<div align="center">
  <img width="1657" height="433" alt="Terraform_onLight" src="https://github.com/user-attachments/assets/ca0307a8-831c-4a1f-bf48-3460b5552ae2" />
</div>

# Terraform Practice: CI/CD Pipeline in AWS

## :dart: Objective

The objective of this practice is to create and deploy a four-stage CI/CD pipeline for Terraform deployments:
1. **Source**: Changes to the Terraform configuration code stored in a version-controlled source (VCS) repository are detected. This triggers the pipeline to start running.
2. **Plan**: The pipeline runs `terraform plan` to create an execution plan, showing what changes will be made to the infrastructure based on the new code.
3. **Approve**: If the `terraform plan` succeeds without errors, the pipeline pauses and requires manual approval before proceeding. This step ensures that changes are reviewed before applying.
4. **Apply**: Once approved, the pipeline runs `terraform apply` to apply the planned changes to the production environment, updating the infrastructure accordingly.

<div align="center">
  <img width="736" height="100" alt="pipeline-stages drawio" src="https://github.com/user-attachments/assets/15b06f53-3a79-4fe4-bd24-900a2176e924" />
</div>

How the CI/CD pipeline works:

* The pipeline integrates AWS CodeCommit as the source repository.
* When a user pushes changes to the CodeCommit repository, the system registers these changes and creates an event reflecting the new state of the repository.
* This event is then captured by Amazon EventBridge, which acts as a trigger to start the execution of the CodePipeline.
* From there, CodePipeline takes control, coordinating and managing the progression through each stage of the pipeline automatically.

<div align="center">
  <img width="795" height="147" alt="pipeline-implementation drawio" src="https://github.com/user-attachments/assets/ff77cbd4-ca72-42e5-a8d8-eb603d775c60" />
</div>

This automation ensures consistent, repeatable infrastructure deployments and streamlines the management of Terraform code changes.

## :building_construction: Infrastructure Overview

The infrastructure consists of the following key components:

- S3 Backend Module:
  - 1 KMS key.
  - 1 S3 bucket.
  - 1 IAM role.
  - 1 IAM policy.
  - 1 resource group.

- CodePipeline Module:
  - 1 KMS key.
  - 1 S3 bucket.
  - 2 IAM role.
  - 2 IAM policy.
  - 1 CodeCommit repository.
  - 2 CodeBuild projects.
  - 1 CodePipeline pipeline.
  - 1 EC2 instance: **t4g.micro** (eligible for AWS free tier).

## :twisted_rightwards_arrows: Flowchart

<div align="center">
  <img width="689" height="473" alt="pipeline-workflow drawio" src="https://github.com/user-attachments/assets/253b983b-5eec-44b0-b21f-1cf49f99ce34" />
</div>

1. Download source code from AWS CodeCommit repository.
2. AWS CodePipeline sends a signal to AWS CodeBuild and AWS CodeBuild runs `terraform plan`.
3. The status is read from the S3 backend.
4. AWS SNS notifies the relevant stakeholders. The stakeholders manually approve or reject the changes.
5. AWS CodePipeline sends a signal to AWS CodeBuild and AWS CodeBuild runs `terraform apply`.
6. The state is written in the S3 backend.

## :deciduous_tree: Terraform Dependency Graph

<div align="center">
  <img width="401" height="181" alt="pipeline-dependencies drawio" src="https://github.com/user-attachments/assets/35a58fc7-53d5-4f6c-8414-09530087fef3" />
</div>

## :arrow_forward: How to Run

**NOTE**: This practice will deploy real resources into your AWS account.
Remember to delete created resources to avoid charges on your AWS account.

### Pre-requisites

- Terraform installed (version v1.14.8 or higher recommended).
- AWS CLI configured with your credentials and default region.
- An AWS account with permissions to create IAM roles, IAM policies, S3 buckets, KMS keys.

### Steps

1. Initialize Terraform (downloads provider plugins):
   ```bash
   terraform init
   ```

2. Preview the infrastructure changes Terraform will apply:
   ```bash
   terraform plan
   ```

3. Apply the configuration to create the CI/CD pipeline:
   ```bash
   terraform apply
   ```

4. Create a file in the **AWS CodeCommit** repository, for example:
   ```bash
   provider "aws" {
     region = "us-east-1"
   }

   data "aws_ami" "amazon_linux" {
     most_recent = true
     owners      = ["amazon"]

     filter {
       name   = "name"
       values = ["al2023-ami-2023.10.20260120.4-kernel-6.12*"]
     }

     filter {
       name   = "architecture"
       values = ["arm64"]
     }
   }

   resource "aws_instance" "basic_ec2" {
     ami           = data.aws_ami.amazon_linux.id
     instance_type = "t4g.micro"

     tags = {
       Name = "Basic EC2"
     }
   }
   ```

   You can use the **AWS Management Console** to create the file:
   
   <div align="center">
     <img width="1543" height="665" alt="Screenshot_2026-04-14_14-22-09" src="https://github.com/user-attachments/assets/9e849260-d84d-47d5-aee8-3bc57b5d2fd1" />
   </div>

   Click on the **Commit changes** button:

   <div align="center">
     <img width="1538" height="565" alt="Screenshot_2026-04-14_14-22-22" src="https://github.com/user-attachments/assets/496eb790-6326-4454-af81-b5e46e8f8c4d" />
   </div>

5. Check the pipeline progress from **AWS CodePipeline**:

   <div align="center">
     <img width="1917" height="444" alt="Screenshot_2026-04-14_12-52-57" src="https://github.com/user-attachments/assets/d959f9d9-29b7-41de-8980-8efcfd67aa9d" />
   </div>

6. Once the pipeline has successfully completed, you can verify that the resources were created correctly.
   
7. Clean up when you're done:
   - Update the **CONFIRM_DESTROY** environment variable in the **main.tf** file:
     ```bash
     environment = {
       CONFIRM_DESTROY = "1"
     }
     ```
     
   - Apply the configuration to delete the created resources:
     ```bash
     terraform apply
     ```
     
   - Now you can now delete the pipeline:
     ```bash
     terraform destroy
     ```

## :rocket: Looking Ahead

This practice is a foundational step to understand Terraform workflow and AWS resource provisioning.\
You can extend this by adding variables, outputs, and more complex resources in future practices.
