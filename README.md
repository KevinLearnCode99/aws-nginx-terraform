# Terraform AWS Nginx Demo

This project uses Terraform to provision a small AWS environment for a public web server, intended for an Nginx demo deployment.

## What It Creates

The Terraform configuration creates the following AWS resources in `us-east-1`:

- A VPC with CIDR block `10.0.0.0/16`
- A public subnet with CIDR block `10.0.0.0/24`
- An internet gateway attached to the VPC
- A public route table with a default route to the internet gateway
- A route table association for the public subnet
- An EC2 instance in the public subnet
- A security group for the web server
- Ingress rules allowing public HTTP and HTTPS traffic:
  - TCP port `80`
  - TCP port `443`

The EC2 instance is configured with:

- AMI: `ami-003bce5ba6a96a706`
- Instance type: `t2.micro`
- Public IP address enabled
- 10 GB `gp3` root volume

## Project Structure

```text
.
|-- compute.tf      # EC2 instance and web security group
|-- locals.tf       # Shared project names and tags
|-- moved.tf        # Terraform moved blocks for renamed resources
|-- networking.tf   # VPC, subnet, internet gateway, and routing
`-- provider.tf     # AWS provider configuration
```

## Naming and Tags

Resources use the local project name `nginx` and environment `demo`, producing names such as:

- `nginx-demo-vpc`
- `nginx-demo-public-subnet`
- `nginx-demo-web`
- `nginx-demo-web-sg`

Common tags are applied to supported resources:

- `Project = nginx`
- `Environment = demo`
- `ManagedBy = Terraform`

## Usage

Initialize Terraform:

```bash
terraform init
```

Preview the infrastructure changes:

```bash
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

Destroy the infrastructure when finished:

```bash
terraform destroy
```

## Important Notes

This configuration creates the AWS infrastructure for a public web server, but it does not currently install or configure Nginx on the EC2 instance. To make the instance serve Nginx automatically, add a `user_data` script or configuration management step.

Do not commit Terraform state or provider cache files to GitHub. Add a `.gitignore` before pushing this project.

Recommended ignored files:

```gitignore
.terraform/
terraform.tfstate
terraform.tfstate.backup
*.tfvars
```

## Requirements

- Terraform installed locally
- AWS credentials configured for the target AWS account
- Permission to create VPC, subnet, route table, internet gateway, security group, and EC2 resources
