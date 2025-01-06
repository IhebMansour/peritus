


---

# AWS Static Website Deployment with Terraform and Docker

This project demonstrates how to deploy a static website on AWS using S3 and CloudFront, with infrastructure managed through Terraform and local execution configured with Docker. 

## Objective

Create a fully functional environment to host a static website, leveraging:

- **AWS S3** for static hosting
- **AWS CloudFront** for content delivery
- **Terraform** for infrastructure-as-code management
- **Docker** for a reproducible local environment
- **Makefile** to simplify command execution

---

## Prerequisites

1. **AWS Configuration:**
   - Install and configure the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
   - Ensure AWS credentials (`~/.aws/credentials`) are properly set up with required permissions.

2. **Docker Installation:**
   - Install Docker and Docker Compose ([Guide](https://docs.docker.com/get-docker/)).

3. **Terraform Installation:**
   - Ensure Terraform is installed (version >= 0.12) if not running within Docker.

---

## Project Structure

```
test-peritus/
├── modules/
│   └── s3-static-website/
│       ├── main.tf         # S3 and CloudFront configuration
│       ├── variables.tf    # Input variables for the module
│       └── outputs.tf      # Outputs from the module
├── envs/
│   └── dev/
│       ├── main.tf         # Environment-specific Terraform configurations
│       ├── variables.tf    # Variables for the development environment
│       └── terraform.tfvars # Development environment variable values
├── website/
│   ├── index.html          # Welcome page
│   └── error.html          # Error page
├── backend.tf              # Backend configuration for state management
├── provider.tf             # AWS provider configuration
├── variables.tf            # Global variables
├── docker-compose.yml      # Docker Compose configuration
├── Dockerfile              # Docker container configuration
├── Makefile                # Automation commands
└── README.md               # Documentation
```

---

## Setup Instructions

### 1. Backend Infrastructure

First, set up the S3 bucket and DynamoDB table for Terraform state management:

```bash
# Create S3 bucket for Terraform state
aws s3 mb s3://peritus-bucket

# Create DynamoDB table for state locking
aws dynamodb create-table \
    --table-name terraform-state-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

Update the `backend.tf` file with the following configuration:

```hcl
terraform {
  backend "s3" {
    bucket         = "peritus-bucket"
    key            = "static-website/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

### 2. Initialize Environment

Navigate to the development environment directory:

```bash
cd envs/dev
```

Run the following commands:

```bash
# Build the Docker image
make build

# Initialize Terraform
make init

# Review planned changes
make plan

# Apply the Terraform plan
make apply
```

### 3. Deploy Website Content

Upload website files to the S3 bucket:

```bash
make deploy-index
make deploy-error
```

---

## Accessing Your Website

1. Retrieve the CloudFront URL:

   ```bash
   terraform output cloudfront_domain_name
   ```

2. Open the URL in your browser: `https://[CLOUDFRONT_DOMAIN]`.

---

## Cleanup

To destroy all created resources:

```bash
make destroy
```

---

## Makefile Commands

| Command        | Description                            |
|----------------|----------------------------------------|
| `make build`   | Build the Docker image                |
| `make init`    | Initialize Terraform                  |
| `make plan`    | Generate a Terraform execution plan   |
| `make apply`   | Apply the Terraform plan              |
| `make deploy-index` | Upload the `index.html` file to S3 |
| `make deploy-error` | Upload the `error.html` file to S3 |
| `make destroy` | Destroy the Terraform-managed resources |

---

## Security Considerations

- **S3 Bucket:** Public read access is configured for website hosting.
- **HTTPS Enforcement:** CloudFront ensures HTTPS for secure content delivery.
- **State Management:** Terraform state is stored securely in an encrypted S3 bucket, with state locking enabled using DynamoDB.

---
