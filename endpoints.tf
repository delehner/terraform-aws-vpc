# Gateway endpoints (free) — attached to the private route tables so DynamoDB
# and S3 traffic never leaves the AWS network and needs no NAT.
resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_gateway ? 1 : 0

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id

  tags = { Name = "${local.name}-dynamodb" }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_gateway ? 1 : 0

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id

  tags = { Name = "${local.name}-s3" }

  lifecycle {
    ignore_changes = [tags]
  }
}

# Interface endpoints — private DNS, one ENI per private subnet, guarded by a
# security group that allows HTTPS from within the VPC.
resource "aws_security_group" "endpoints" {
  name        = "${local.name}-vpce"
  description = "Allow HTTPS from within the VPC to interface endpoints."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS from the VPC CIDR."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name}-vpce" }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_vpc_endpoint" "interface" {
  for_each = toset(var.interface_endpoints)

  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = { Name = "${local.name}-${each.value}" }

  lifecycle {
    ignore_changes = [tags]
  }
}
