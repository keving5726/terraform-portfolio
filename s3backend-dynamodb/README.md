<div align="center">
  <img width="1657" height="433" alt="Terraform_onLight" src="https://github.com/user-attachments/assets/ca0307a8-831c-4a1f-bf48-3460b5552ae2" />
</div>

# Terraform Practice: S3 Backend with DynamoDB

**NOTE**: This practice using DynamoDB for state locking is intended **only for testing or legacy purposes**. The DynamoDB locking mechanism is now **deprecated** in favor of the **native S3 locking feature**, which provides a simpler and more efficient way to manage Terraform state locks directly within S3. It is recommended to migrate to native S3 locking for production environments to benefit from improved reliability and reduced operational overhead. If you want to check out a practice that uses the native S3 locking feature, click on the following link: [s3backend](../s3backend).

## :dart: Objective

The objective of this practice is to:

- Understand how to configure and test a remote backend using S3 and DynamoDB in Terraform.
- Validate state locking functionality to prevent concurrent state modifications.
- Explore workspace management for environment separation.

How the S3 backend with DynamoDB works:

1. Access is controlled by a least-privileged IAM role that authorized users or services assume to gain temporary permissions for reading/writing state files and using the encryption keys.
2. DynamoDB provides a locking mechanism to coordinate access and prevent simultaneous state changes, maintaining integrity and avoiding conflicts.
3. Your Terraform state files are securely stored in an S3 bucket with server-side encryption using AWS KMS, ensuring data confidentiality at rest.

<div align="center">
  <img width="669" height="319" alt="s3backend-dynamodb-module drawio" src="https://github.com/user-attachments/assets/97b65821-6ddb-43c6-ae44-264147f096b7" />
</div>

This practice is focused on testing the S3 backend configuration with DynamoDB for state locking, in order to help you begin testing Terraform S3 backends effectively.

## :building_construction: Infrastructure Overview

The infrastructure consists of the following key components:

- 1 KMS key.
- 1 S3 bucket.
- 1 DynamoDB table.
- 1 IAM role.
- 1 IAM policy.
- 1 resource group.
- 2 EC2 instances: **t4g.micro** (eligible for AWS free tier).

## :world_map: Architecture Diagrams

### Deploy

<div align="center">
  <img width="751" height="451" alt="s3backend-dynamodb-deploy drawio" src="https://github.com/user-attachments/assets/07b432a5-0a81-4c3e-8dd1-b72eca122d83" />
</div>

### Workspaces

<div align="center">
  <img width="641" height="551" alt="s3backend-workspaces drawio" src="https://github.com/user-attachments/assets/4b0748bb-27a8-447b-b6e9-1530093eb355" />
</div>

## :deciduous_tree: Terraform Dependency Graph

<div align="center">
  <img width="411" height="381" alt="s3backend-dependencies drawio" src="https://github.com/user-attachments/assets/90214943-8c4f-4eac-9638-7bdf0a2d78a2" />
</div>

## :arrow_forward: How to Run

**NOTE**: This practice will deploy real resources into your AWS account. Remember to delete created resources to avoid charges on your AWS account.

### Pre-requisites

- Terraform installed (version v1.14.7 or higher recommended).
- AWS CLI configured with your credentials and default region.
- An AWS account with permissions to create KMS keys, S3 buckets, DynamoDB tables, IAM roles, IAM policies and EC2 instances.

### Steps

1. The first step is to deploy the S3 backend:

   - Navigate to the **deploy** folder to run Terraform commands:
     ```bash
     cd deploy
     ```
   - Initialize Terraform (downloads provider plugins):
     ```bash
     terraform init
     ```
   - Preview the infrastructure changes Terraform will apply:
     ```bash
     terraform plan
     ```
   - Apply the configuration to deploy the S3 backend with DynamoDB:
     ```bash
     terraform apply
     ```
   - Check the **Outputs** in the terminal, for example:
     ```bash
     Outputs:

     s3backend_config = {
       "bucket" = "s3backend-dynamodb-ge5af-tf-backend"
       "dynamodb_table" = "s3backend-dynamodb-ge5af-tf-lock"
       "region" = "us-east-1"
       "role_arn" = "arn:aws:iam::081276790814:role/s3backend-dynamodb-ge5af-tf-backend"
     }
     ```

2. The second step is to run tests to confirm that the S3 backend with DynamoDB is working correctly:

   - Navigate to the **test** folder to run Terraform commands:
     ```bash
     cd test
     ```
   - Create the **backend.config** file to configure the backend using the **output** from step **1**, for example:
     ```bash
     bucket = "s3backend-dynamodb-ge5af-tf-backend"
     key = "test"
     encrypt = true
     use_lockfile = false

     region = "us-east-1"

     dynamodb_table = "s3backend-dynamodb-ge5af-tf-lock"

     assume_role = {
       role_arn = "arn:aws:iam::081276790814:role/s3backend-dynamodb-nr1ye-tf-backend"
     }
     ```
   - Initialize Terraform (downloads provider plugins):
     ```bash
     terraform init -backend-config="./backend.config"
     ```
   - Preview the infrastructure changes Terraform will apply:
     ```bash
     terraform plan
     ```
   - Apply the configuration to deploy the S3 backend with DynamoDB:
     ```bash
     terraform apply
     ```
   - You can now check from the **AWS Management Console** that Terraform states are being saved in the S3 bucket and that DynamoDB is performing locks correctly.

3. The third step involves using Terraform workspaces to manage multiple environments (dev and prod):

   - Navigate to the **workspaces** folder to run Terraform commands:
     ```bash
     cd workspaces
     ```
   - Create the **backend.config** file to configure the backend using the **output** from step **1**, for example:
     ```bash
     bucket = "s3backend-dynamodb-ge5af-tf-backend"
     key = "test"
     encrypt = true
     use_lockfile = false

     region = "us-east-1"

     dynamodb_table = "s3backend-dynamodb-ge5af-tf-lock"

     assume_role = {
       role_arn = "arn:aws:iam::081276790814:role/s3backend-dynamodb-nr1ye-tf-backend"
     }
     ```
   - Initialize Terraform (downloads provider plugins):
     ```bash
     terraform init -backend-config="./backend.config"
     ```
   - Create and switch to a new workspace called **prod**:
     ```bash
     terraform workspace new prod
     ```
   - Preview the infrastructure changes Terraform will apply:
     ```bash
     terraform plan -var-file="./environments/prod.tfvars"
     ```
   - Apply the configuration to deploy the S3 backend with DynamoDB:
     ```bash
     terraform apply -var-file="./environments/prod.tfvars"
     ```
   - Create and switch to a new workspace called **dev**:
     ```bash
     terraform workspace new dev
     ```
   - Preview the infrastructure changes Terraform will apply:
     ```bash
     terraform plan -var-file="./environments/dev.tfvars"
     ```
   - Apply the configuration to deploy the S3 backend with DynamoDB:
     ```bash
     terraform apply -var-file="./environments/dev.tfvars"
     ```
   - You can now check from the **AWS Management Console** that Terraform states are being saved in the S3 bucket and that DynamoDB is performing locks correctly.

4. The fourth step is to clean up:

   - Delete the **prod** deployment:
     ```bash
     terraform select prod
     terraform destroy -var-file="./environments/prod.tfvars"
     ```
   - Delete the **dev** deployment:
     ```bash
     terraform select dev
     terraform destroy -var-file="./environments/dev.tfvars"
     ```
   - Finally, switch back into the **deploy** directory from which you deployed the S3 backend, and run terraform destroy:
     ```bash
     cd deploy
     terraform destroy
     ```

## :rocket: Looking Ahead

This practice is a foundational step to understand Terraform workflow and AWS resource provisioning.\
You can extend this by adding variables, outputs, and more complex resources in future practices.
