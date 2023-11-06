#############################################
#                  Common                   #
#############################################
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    ENV         = "prd-xuantu"
    ProjectName = "MA"
  }
}
#############################################
#                   VPC                     #
#############################################
variable "vpcs" {
  type = list(any)
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = []
}

#############################################
#                   EKS                     #
#############################################
variable "cluster_name" {
  type    = string
  default = ""
}

variable "eks_version" {
  type    = string
  default = ""
}

variable "account_id" {
  type    = string
  default = ""
}
