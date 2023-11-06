resource "aws_eip" "nat" {
  count = 2

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "Staging-Module-ngw-eip"
  })
}