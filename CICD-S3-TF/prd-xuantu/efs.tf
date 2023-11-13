module "efs" {
  source = "terraform-aws-modules/efs/aws"

  # File system
  name      = "xuantu-efs"
  encrypted = false

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  attach_policy = false

  # Mount targets / security group
  mount_targets = {
    element(module.vpc.azs, 0) = {
      subnet_id = element(module.vpc.private_subnets, 0)
    }
    element(module.vpc.azs, 1) = {
      subnet_id = element(module.vpc.private_subnets, 1)
    }
  }
  security_group_description = "EFS xuantu security group"
  security_group_vpc_id      = module.vpc.vpc_id
  security_group_rules = {
    vpc_private_subnet = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
    vpc_public_subnet = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC public subnets"
      cidr_blocks = module.vpc.public_subnets_cidr_blocks
    }
  }

  # Backup policy
#   enable_backup_policy = true

#   tags = merge(
#     var.tags,
#     {
#       Name = "appthien-efs"
#     }
#   )
}