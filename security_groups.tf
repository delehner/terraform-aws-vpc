# Shared security group for in-VPC application workloads (e.g. the service
# Lambda). Egress-only: the workloads are clients of the VPC endpoints and of
# data stores (which allow ingress from this group). No ingress is opened here.
resource "aws_security_group" "app" {
  count = var.create_app_security_group ? 1 : 0

  name        = "${local.name}-app"
  description = "Shared security group for in-VPC application workloads (Lambdas)."
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name}-app" }

  lifecycle {
    ignore_changes = [tags]
  }
}
