# Changelog

## v1.0.0

### Added
- Initial VPC module: private + public subnets per AZ, internet gateway, optional NAT gateway(s), DynamoDB + S3 gateway endpoints, configurable interface endpoints (private DNS) with a guarding security group, and an optional shared app security group. Outputs `vpc_id`, `cidr_block`, `private_subnet_ids`, `public_subnet_ids`, `app_security_group_id`.
