locals {
  # Used to determine correct partition (i.e. - `aws`, `aws-gov`, `aws-cn`, etc.)
  partition = data.aws_partition.current.partition
  node_tags = {
    "Name" = "prd-xuantu-eks-nodegroup"
  }

  desired_size = 2
}

################################################################################
# Desired Size Hack
################################################################################

resource "null_resource" "update_desired_size" {
  triggers = {
    desired_size = local.desired_size
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    # Note: this requires the awscli to be installed locally where Terraform is executed
    command = <<-EOT
      aws eks update-nodegroup-config \
        --cluster-name ${module.eks.cluster_name} \
        --nodegroup-name ${element(split(":", module.eks.eks_managed_node_groups["nodegroup"].node_group_id), 1)} \
        --scaling-config desiredSize=${local.desired_size}
    EOT
  }
}
#############################################
#                   EKS                     #
#############################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"

  # EKS CLUSTER
  cluster_name    = var.cluster_name
  cluster_version = var.eks_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = slice(tolist(module.vpc.private_subnets), 0, 2)

  cluster_endpoint_public_access = true

  cluster_addons = {
    # coredns = {
    #   preserve    = true
    #   most_recent = true

    #   timeouts = {
    #     create = "25m"
    #     delete = "10m"
    #   }
    # }
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }
  }

  iam_role_name            = "prd-xuantu-eks-cluster-role"
  iam_role_use_name_prefix = false

  enable_irsa = true

  ##EKS MANAGED NODE GROUPS

  eks_managed_node_groups = {
    nodegroup = {
      instance_types  = ["t3.medium"]
      min_size        = 2
      max_size        = 3
      desired_size    = local.desired_size # https://github.com/bryantbiggs/eks-desired-size-hack/blob/main/main.tf
      capacity_type   = "ON_DEMAND"
      create_iam_role = false
      iam_role_arn    = aws_iam_role.managed_ng.arn

      create_launch_template = true
      enable_monitoring      = false

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 50
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = false
            delete_on_termination = true
          }
        }
      }
      labels = {
        Which = "prd-xuantu-eks-nodegroup"
      }
      additional_tags = merge(
        var.tags,
        local.node_tags
      )

      launch_template_tags = merge(
        var.tags,
        local.node_tags
      )
    }
  }

  node_security_group_additional_rules = {
    # Extend node-to-node security group rules. Recommended and required for the Add-ons
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    # Recommended outbound traffic for Node groups
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    # Allows Control Plane Nodes to talk to Worker nodes on all ports. Added this to avoid issues with Add-ons communication with Control plane.
    # This can be restricted further to specific port based on the requirement for each Add-on e.g., metrics-server 4443, spark-operator 8080, karpenter 8443 etc.
    # Change this according to your security requirements if needed

    ingress_cluster_to_node_all_traffic = {
      description                   = "Cluster API to Nodegroup all traffic"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
  manage_aws_auth_configmap = true

  # # External encryption key
  # create_kms_key = false
  # cluster_encryption_config = {
  #   resources        = ["secrets"]
  #   provider_key_arn = module.kms.key_arn
  # }

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::055475569617:user/sub.tu.vo"
      username = "subtuvo"
      groups   = ["system:masters"]
    },
  ]

  tags = merge(
    var.tags,
    {
      Name = "prd-xuantu-eks-cluster"
    }
  )
}

#############################################
#     Custom IAM roles for Node Groups      #
#############################################
data "aws_iam_policy_document" "managed_ng_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "managed_ng" {
  name                  = "prd-xuantu-managed-node-role"
  description           = "prd-xuantu-eks-cluster Managed Node group IAM Role"
  assume_role_policy    = data.aws_iam_policy_document.managed_ng_assume_role_policy.json
  path                  = "/"
  force_detach_policies = true
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser", # require for pull image cross account
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]

  tags = var.tags
}

resource "aws_iam_instance_profile" "managed_ng" {
  name = "prd-xuantu-managed-node-instance-profile"
  role = aws_iam_role.managed_ng.name
  path = "/"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

#############################################
#             Kubernetes Add-ons            #
#############################################
module "eks_kubernetes_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.8"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    name                 = "aws-load-balancer-controller"
    chart                = "aws-load-balancer-controller"
    repository           = "https://aws.github.io/eks-charts"
    chart_version        = "1.6.1"
    namespace            = "platform"
    timeout              = "1200"
    create_namespace     = true
    role_name            = "prd-xuantu-eks-cluster-aws-load-balancer-controller-sa-irsa"
    role_name_use_prefix = false
    values = [templatefile("${path.module}/bootstrap/aws-alb-controller.tftpl", {
      ACCOUNT_ID = var.account_id
    })]
  }
}
#############################################
#              Storage Classes              #
#############################################
resource "kubernetes_annotations" "gp2" {
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  force       = "true"

  metadata {
    name = "gp2"
  }

  annotations = {
    # Modify annotations to remove gp2 as default storage class still reatain the class
    "storageclass.kubernetes.io/is-default-class" = "false"
  }

  depends_on = [
    module.eks_kubernetes_addons
  ]
}

resource "kubernetes_storage_class_v1" "gp3" {
  metadata {
    name = "gp3"

    annotations = {
      # Annotation to set gp3 as default storage class
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  allow_volume_expansion = true
  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"

  parameters = {
    encrypted = true
    fsType    = "ext4"
    type      = "gp3"
  }

  depends_on = [
    kubernetes_annotations.gp2
  ]
}

#######################################################
#                         KMS                         #
#######################################################

# module "kms" {
#   source  = "terraform-aws-modules/kms/aws"
#   version = "~> 1.5"

#   aliases               = ["eks/${var.cluster_name}"]
#   description           = "${var.cluster_name} cluster encryption key"
#   enable_default_policy = true

#   tags = var.tags
# }
 