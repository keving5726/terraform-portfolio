<div align="center">
  <img width="1657" height="433" alt="Terraform_onLight" src="https://github.com/user-attachments/assets/ca0307a8-831c-4a1f-bf48-3460b5552ae2" />
</div>

# Terraform Practice: Multi Tier Web Application in AWS

## :dart: Objective

To design and deploy a highly available, scalable multi-tiered web application in AWS using Terraform.
Multi-tier simply refers to a software system that is divided into logical layers, like a cake, for example:

<div align="center">
  <img width="400" height="246" alt="multi-tiered-web-app-flow drawio" src="https://github.com/user-attachments/assets/6983c425-3524-4725-90ca-172431ad068d" />
</div>

This practice aims to demonstrate proficiency in Infrastructure as Code (IaC) by automating the provisioning of network components, load balancers, auto scaling groups, and backend services to ensure fault tolerance, scalability, and efficient resource management in a cloud environment.

The practice will incorporate the use of official AWS Terraform modules as well as external community modules to learn how to effectively integrate and manage reusable modules. Additionally, it will include the use of nested modules to enhance code modularity, promote better organization, and improve maintainability across complex infrastructure deployments.

## :building_construction: Infrastructure Overview

The infrastructure consists of the following key components:

- Networking Module:
  - 1 VPC.
  - 1 route table.
  - 1 Internet gateway.
  - 1 NAT gateway.
  - 3 public subnets for the Application Load Balancer.
  - 3 private subnets for the EC2 instances.
  - 3 private subnets for the RDS instances.
  - 3 security groups (ALB, Web Server and Database).

- Database Module:
  - 1 RDS instance:
    - **Instance type**: db.t4g.micro (eligible for AWS free tier).
    - **Engine version**: MySQL 8.4.7.
    - Single-AZ DB instance deployment (1 instance).

- Autoscaling Module:
  - 1 Launch template:
    - **AMI**: Ubuntu Server 24.04 LTS (HVM), SSD Volume Type.
    - **Instance type**: t3.micro (eligible for AWS free tier).
    - **Architecture**: 64-bit (x86).
    - **User data**: Cloud-init configuration.
  - 1 Application Load Balancer (ALB).
  - 1 Auto Scaling Group (ASG).

## :world_map: Architecture Diagram

<div align="center">
  <img width="1052" height="821" alt="Multi-tiered-web-app drawio" src="https://github.com/user-attachments/assets/f81fb293-5506-476c-b01e-7031d5710cdf" />
</div>

## :deciduous_tree: Terraform Dependency Graph

<div align="center">
  <img width="711" height="241" alt="multi-tiered-web-app-dependencies drawio" src="https://github.com/user-attachments/assets/861e0dd7-0a4a-4fe4-bba7-bed3c4a1d3c0" />
</div>

## :arrow_forward: How to Run

**NOTE**: This practice will deploy real resources into your AWS account.
Remember to delete created resources to avoid charges on your AWS account.

### Pre-requisites

- Terraform installed (version v1.14.9 or higher recommended).
- AWS CLI configured with your credentials and default region.
- An AWS account with permissions to create EC2 instances, RDS instances, Auto Scaling group and Application Load Balancing.

### Steps

1. Initialize Terraform (downloads provider plugins):
   ```bash
   terraform init
   ```

2. Preview the infrastructure changes Terraform will apply:
   ```bash
   terraform plan
   ```

3. Apply the configuration to create the multi-tiered web application:
   ```bash
   terraform apply
   ```

4. Check the **Outputs** in the terminal, for example:
   ```bash
   Outputs:

   alb_dns_name = "http://webapp-alb-792144198.us-east-1.elb.amazonaws.com"
   ```

5. From your browser, enter the DNS name:
   ```bash
   http://webapp-alb-792144198.us-east-1.elb.amazonaws.com
   ```

   You should see the multi-tiered web application for a social media site geared toward pet owners:

   <div align="center">
     <img width="1914" height="1007" alt="pets" src="https://github.com/user-attachments/assets/b22a46f9-4649-4602-a913-8bb0ef46956b" />
   </div>

   You can take a look at all the resources created using the **AWS Management Console**.

6. Clean up when you're done:
   ```bash
   terraform destroy
   ```

## :rocket: Looking Ahead

This practice is a foundational step to understand Terraform workflow and AWS resource provisioning.\
You can extend this by adding variables, outputs, and more complex resources in future practices.
