<div align="center">
  <img width="1657" height="433" alt="Terraform_onLight" src="https://github.com/user-attachments/assets/ca0307a8-831c-4a1f-bf48-3460b5552ae2" />
</div>

# Terraform Practice: AWS EC2 Instance

## :dart: Objective

This practice aims to demonstrate the basics of using Terraform to provision infrastructure on AWS by creating a simple EC2 instance.\
It is designed as a starting point for learning Infrastructure as Code (IaC) with Terraform.

## :building_construction: Infrastructure Overview

The infrastructure consists of the following key components:

- 1 EC2 instance:
  - **AMI**: Amazon Linux 2023 kernel-6.1 AMI.
  - **Instance type**: t4g.micro (eligible for AWS free tier).
  - **Architecture**: 64-bit (Arm).

## :world_map: Architecture Diagram

<div align="center">
  <img width="891" height="321" alt="basic-ec2 drawio" src="https://github.com/user-attachments/assets/b4291472-bb00-4ab9-90a0-e947d6b993ea" />
</div>

## :twisted_rightwards_arrows: Flowchart

<div align="center">
  <img width="549" height="181" alt="basic-ec2-flow drawio" src="https://github.com/user-attachments/assets/08576754-0291-42e7-a9ef-73c23dac7a2d" />
</div>

1. Write Terraform configuration files.
2. Initialize Terraform with `terraform init`.
3. Deploy the EC2 instance with `terraform apply`.
4. Clean up with `terraform destroy`.

## :deciduous_tree: Terraform Dependency Graph

<div align="center">
  <img width="815" height="539" alt="graphviz" src="https://github.com/user-attachments/assets/1b685485-a6de-4049-bd05-d3d12d18a7f8" />  
</div>

## :arrow_forward: How to Run

**NOTE**: This example will deploy real resources into your AWS account.
Remember to delete created resources to avoid charges on your AWS account.

### Pre-requisites

- Terraform installed (version v1.14.4 or higher recommended).
- AWS CLI configured with your credentials and default region.
- An AWS account with permissions to create EC2 instances.

### Steps

1. Initialize Terraform (downloads provider plugins):
   ```bash
   terraform init
   ```

2. Preview the infrastructure changes Terraform will apply:
   ```bash
   terraform plan
   ```

3. Apply the configuration to create the EC2 instance:
   ```bash
   terraform apply
   ```

4. Clean up when you're done:
   ```bash
   terraform destroy
   ```

## :rocket: Looking Ahead

This practice is a foundational step to understand Terraform workflow and AWS resource provisioning.\
You can extend this by adding variables, outputs, and more complex resources in future practices.
