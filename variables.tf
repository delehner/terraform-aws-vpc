variable "application_name" {
  type        = string
  description = "Application name. Used in resource names."
}

variable "environment" {
  type        = string
  description = "Environment where the resource is deployed (e.g. development, staging, production)."
}

variable "cidr_block" {
  type        = string
  default     = "10.20.0.0/16"
  description = "IPv4 CIDR block for the VPC."
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones to spread the private and public subnets across (one of each per AZ)."
}

variable "interface_endpoints" {
  type        = list(string)
  default     = ["sns", "sqs", "sts", "secretsmanager"]
  description = "AWS services reached over interface VPC endpoints from the private subnets (so in-VPC Lambdas reach them without a NAT)."
}

variable "enable_dynamodb_gateway" {
  type        = bool
  default     = true
  description = "Create a (free) DynamoDB gateway VPC endpoint on the private route tables."
}

variable "enable_s3_gateway" {
  type        = bool
  default     = true
  description = "Create a (free) S3 gateway VPC endpoint on the private route tables."
}

variable "enable_nat_gateway" {
  type        = bool
  default     = false
  description = "Create NAT gateway(s) so private subnets have egress to the internet. Off by default — VPC endpoints cover AWS traffic."
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "When enable_nat_gateway is true, use a single shared NAT gateway instead of one per AZ."
}

variable "create_app_security_group" {
  type        = bool
  default     = true
  description = "Create a shared security group for in-VPC application workloads (Lambdas). Downstream data stores allow ingress from it."
}
