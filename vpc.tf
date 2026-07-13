locals {
  name     = "${var.application_name}-${var.environment}"
  az_count = length(var.availability_zones)
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = local.name }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_subnet" "private" {
  count = local.az_count

  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(var.cidr_block, 4, count.index)

  tags = { Name = "${local.name}-private-${var.availability_zones[count.index]}" }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_subnet" "public" {
  count = local.az_count

  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = cidrsubnet(var.cidr_block, 4, count.index + local.az_count)
  map_public_ip_on_launch = true

  tags = { Name = "${local.name}-public-${var.availability_zones[count.index]}" }

  lifecycle {
    ignore_changes = [tags]
  }
}
