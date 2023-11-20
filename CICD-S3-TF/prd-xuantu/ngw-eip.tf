resource "aws_eip" "nat" {
  count = 1

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "prd-xuantu-ngw-eip"
  })
}