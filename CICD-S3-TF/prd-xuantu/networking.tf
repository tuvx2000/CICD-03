data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name             = var.vpcs[0].name
  cidr             = var.vpcs[0].cidr_block
  azs              = var.vpcs[0].azs
  public_subnets   = var.vpcs[0].public_subnets
  private_subnets  = var.vpcs[0].private_subnets
  database_subnets = var.vpcs[0].database_subnets

  enable_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  reuse_nat_ips       = true
  external_nat_ip_ids = aws_eip.nat.*.id

  create_database_subnet_group = false

  tags = var.tags

  igw_tags = merge(
    var.tags,
    {
      "Name" = "prd-xuantu-igw"
    }
  )

  nat_gateway_tags = merge(
    var.tags,
    {
      "Name" = "prd-xuantu-ngw"
    }
  )

  nat_eip_tags = merge(
    var.tags,
    {
      "Name" = "prd-xuantu-ngw-eip"
    }
  )

  public_subnet_tags = merge(
    var.tags,
    {
      "Name"                                      = "prd-xuantu-public-subnet"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/elb"                    = 1
    }
  )

  private_subnet_tags = merge(
    var.tags,
    {
      "Name"                                      = "prd-xuantu-private-subnet"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb"           = 1
    }
  )

  database_subnet_tags = merge(
    var.tags,
    {
      "Name" = "prd-xuantu-database-subnet"
    }
  )

  public_route_table_tags = merge(
    var.tags,
    {
      "Name" = "prd-xuantu-public-subnet-rtable"
    }
  )
  private_route_table_tags = merge(
    var.tags,
    {
      "Name" = "prd-xuantu-private-subnet-rtable"
    }
  )
}