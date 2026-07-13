resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = { Name = local.name }

  lifecycle {
    ignore_changes = [tags]
  }
}

locals {
  nat_count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : local.az_count) : 0
}

resource "aws_eip" "nat" {
  count = local.nat_count

  domain = "vpc"

  tags = { Name = "${local.name}-nat-${count.index}" }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_nat_gateway" "main" {
  count = local.nat_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = { Name = "${local.name}-${count.index}" }

  depends_on = [aws_internet_gateway.main]

  lifecycle {
    ignore_changes = [tags]
  }
}
