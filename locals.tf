locals {
  project     = "nginx"
  environment = "demo"

  name_prefix = "${local.project}-${local.environment}"

  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
  }

  resource_names = {
    vpc              = "${local.name_prefix}-vpc"
    public_subnet    = "${local.name_prefix}-public-subnet"
    internet_gateway = "${local.name_prefix}-igw"
    public_route     = "${local.name_prefix}-public-rt"
    web_instance     = "${local.name_prefix}-web"
    web_security     = "${local.name_prefix}-web-sg"
  }
}
