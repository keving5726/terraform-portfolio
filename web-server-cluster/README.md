<div align="center">
  <img width="1657" height="433" alt="Terraform_onLight" src="https://github.com/user-attachments/assets/ca0307a8-831c-4a1f-bf48-3460b5552ae2" />
</div>

# Terraform Practice: Web Server Cluster using AWS

## :dart: Objective

Automate the provisioning and management of a scalable and highly available infrastructure on AWS to host a web server cluster.
Using Terraform, the project deploys EC2 instances managed by Auto Scaling Groups (ASG) to ensure dynamic scalability, alongside an Application Load Balancer (ALB) that efficiently distributes traffic and enhances service availability.

This practice aims to enable Infrastructure as Code (IaC) using Terraform, allowing reproducible deployments, version control, and simplified maintenance of the web architecture on AWS.

## :building_construction: Infrastructure Overview

The infrastructure consists of the following key components:

- 3 EC2 instances:
  - **AMI**: Ubuntu Server 24.04 LTS (HVM), SSD Volume Type.
  - **Instance type**: t4g.micro (eligible for AWS free tier).
  - **Architecture**: 64-bit (Arm).
- 1 Application Load Balancing (ALB).
- 1 Auto Scaling Group (ASG).

## :world_map: Architecture Diagram

<div align="center">
  <img width="711" height="721" alt="web-server-cluster drawio" src="https://github.com/user-attachments/assets/a525efcb-95fc-458f-8617-a4ac45943ac2" />
</div>

## :deciduous_tree: Terraform Dependency Graph

<div align="center">
  <img width="2265" height="1019" alt="graphviz" src="https://github.com/user-attachments/assets/d0df6496-7fc8-4dbe-b0d9-0c0e46d22571" />
</div>

## :arrow_forward: How to Run

**NOTE**: This example will deploy real resources into your AWS account.
Remember to delete created resources to avoid charges on your AWS account.

### Pre-requisites

- Terraform installed (version v1.15.3 or higher recommended).
- AWS CLI configured with your credentials and default region.
- An AWS account with permissions to create EC2 instances, Auto Scaling Group and Application Load Balancing.

### Steps

1. Initialize Terraform (downloads provider plugins):
   ```bash
   terraform init
   ```
2. Configure environment variables:
   - First, copy the example template:
     ```bash
     cp terraform.tfvars.example terraform.tfvars
     ```
   - Next, open the newly created **terraform.tfvars** file in your editor and customize the values for your environment
3. Preview the infrastructure changes Terraform will apply:
   ```bash
   terraform plan
   ```
4. Apply the configuration to create the EC2 instance:
   ```bash
   terraform apply
   ```
5. Check the **Outputs** in the terminal, for example:
   ```bash
   Outputs:

   alb_dns_name = "web-server-lb-908363196.us-east-1.elb.amazonaws.com"
   ```
6. From your browser, enter the DNS name:
   ```bash
   http://web-server-lb-908363196.us-east-1.elb.amazonaws.com
   ```
   You should see the following message:
   ```bash
   Congratulations, the web server is working successfully
   ```
   You can take a look at all the resources created using the **AWS Management Console**.
7. Clean up when you're done:
   ```bash
   terraform destroy
   ```

## :rocket: Looking Ahead

This practice is a foundational step to understand Terraform workflow and AWS resource provisioning.\
You can extend this by adding variables, outputs, and more complex resources in future practices.
