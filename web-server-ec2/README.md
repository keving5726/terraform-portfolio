<div align="center">
  <img width="1657" height="433" alt="Terraform_onLight" src="https://github.com/user-attachments/assets/ca0307a8-831c-4a1f-bf48-3460b5552ae2" />
</div>

# Terraform Practice: Web Server using an AWS EC2 Instance

## :dart: Objective

This practice aims to demonstrate the basics of using Terraform to provision infrastructure on AWS by creating a web server using an EC2 instance. It is designed as a starting point for learning Infrastructure as Code (IaC) with Terraform.

## :building_construction: Infrastructure Overview

The infrastructure consists of the following key components:

- 1 EC2 instance:
  - **AMI**: Ubuntu Server 24.04 LTS (HVM), SSD Volume Type.
  - **Instance type**: t4g.micro (eligible for AWS free tier).
  - **Architecture**: 64-bit (Arm).

## :world_map: Architecture Diagram

<div align="center">
  <img width="681" height="373" alt="web-server-ec2 drawio" src="https://github.com/user-attachments/assets/dc037ddf-0c65-4649-93e2-ad2eb48c9e94" />
</div>

## :deciduous_tree: Terraform Dependency Graph

<div align="center">
  <img width="1423" height="539" alt="graphviz" src="https://github.com/user-attachments/assets/d1680de7-e002-4da8-a26d-44b28cfd867b" />
</div>

## :arrow_forward: How to Run

**NOTE**: This example will deploy real resources into your AWS account.
Remember to delete created resources to avoid charges on your AWS account.

### Pre-requisites

- Terraform installed (version v1.14.9 or higher recommended).
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

4. Check the **Outputs** in the terminal, for example:
   ```bash
   Outputs:

   public_ip = "98.92.151.89"
   ```

5. From your browser, enter the Public IP address and port **8080**:
   ```bash
   http://98.92.151.89:8080/
   ```

   You should see the following message:
   ```bash
   Congratulations, the web server is working successfully
   ```

6. Clean up when you're done:
   ```bash
   terraform destroy
   ```

## :rocket: Looking Ahead

This practice is a foundational step to understand Terraform workflow and AWS resource provisioning.\
You can extend this by adding variables, outputs, and more complex resources in future practices.
