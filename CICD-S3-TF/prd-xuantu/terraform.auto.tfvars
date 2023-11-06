#############################################
#                  VPC                      #
#############################################
vpcs = [
  {
    name             = "prd-xuantu-vpc"
    cidr_block       = "10.72.0.0/16"
    azs              = ["ap-southeast-1a", "ap-southeast-1b"]
    public_subnets   = ["10.72.1.0/24", "10.72.2.0/24"]
    private_subnets  = ["10.72.4.0/24", "10.72.5.0/24"]
    database_subnets = ["10.72.7.0/24", "10.72.8.0/24"]
  }
]
#############################################
#                   EKS                     #
############################################# 
cluster_name = "prd-xuantu-eks-cluster"
eks_version  = "1.28"
account_id   = "055475569617"