variable "subnet_names" {
  type = list(string)
  default = ["subnet1", "subnet2"]
}

variable "subnet_prefixes" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_id" {
  type = string
}

resource "aws_vpc" "net" {
cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "subnet" {
  count                = length(var.subnet_names)
#  name                 = var.subnet_names[count.index]
  cidr_block           = var.subnet_prefixes[count.index]
  vpc_id               = var.vpc_id
  availability_zone    = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))
}

data "aws_availability_zones" "available" {}

locals {
  aws_subnets = {
    for index, subnet in aws_subnet.subnet :
    subnet.id => subnet.cidr_block
  }
}

output "subnet_ids" {
  value = aws_subnet.subnet[*].id
}