# Terraform - VPC Module

A VPC with private and public subnets across availability zones, VPC endpoints
so in-VPC workloads reach AWS without a NAT gateway, and a shared security group
for application workloads (e.g. an in-VPC Lambda).

## Usage

```hcl
module "network" {
  source  = "app.terraform.io/<org>/vpc/aws"
  version = "~> 1.0"

  application_name   = "prummo"
  environment        = "development"
  cidr_block         = "10.20.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]

  # Interface endpoints so the private subnets reach these services without a NAT.
  interface_endpoints = ["sns", "sqs", "sts", "secretsmanager"]

  # Free gateway endpoints on the private route tables.
  enable_dynamodb_gateway = true
  enable_s3_gateway       = true

  # No NAT by default — the endpoints cover AWS traffic.
  enable_nat_gateway = false

  # A shared SG the in-VPC app workloads attach to; data stores allow ingress from it.
  create_app_security_group = true
}
```

## What it creates

- One `aws_vpc` and, per AZ, one **private** and one **public** subnet (carved from `cidr_block` with `cidrsubnet`).
- An internet gateway + public route table; per-AZ private route tables (with a default route only when NAT is enabled).
- Optional NAT gateway(s) — off by default (`enable_nat_gateway`, `single_nat_gateway`).
- Gateway VPC endpoints for **DynamoDB** and **S3** on the private route tables.
- Interface VPC endpoints (private DNS) for each of `interface_endpoints`, guarded by an SG allowing 443 from the VPC.
- An optional shared, egress-only **app security group**.

## Outputs

`vpc_id`, `cidr_block`, `private_subnet_ids`, `public_subnet_ids`, `app_security_group_id`.
