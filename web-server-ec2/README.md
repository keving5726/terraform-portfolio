<div align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../images/Terraform_onDark.svg">
    <source media="(prefers-color-scheme: light)" srcset="../images/Terraform_onLight.svg">
    <img alt="Terraform logo" src="../images/Terraform_onLight.svg" width="850">
  </picture>
</div>

# Web Server using an AWS EC2 Instance

## :dart: Objective

This project aims to demonstrate the basics of using Terraform to provision infrastructure on AWS by creating a web server using an EC2 instance. It is designed as a starting point for learning Infrastructure as Code (IaC) with Terraform.

## :building_construction: Infrastructure Overview

The infrastructure consists of the following key components:

- 1 EC2 instance:
  - **AMI**: Ubuntu Server 24.04 LTS (HVM), SSD Volume Type.
  - **Instance type**: t4g.micro.
  - **Free Tier Eligible**: true.
  - **Architecture**: arm64.
  - **vCPUs**: 2.
  - **Memory (GiB)**: 1.

## :world_map: Architecture Diagram

<div align="center">
  <img width="681" height="373" alt="web-server-ec2 drawio" src="https://github.com/user-attachments/assets/dc037ddf-0c65-4649-93e2-ad2eb48c9e94" />
</div>

## :deciduous_tree: Terraform Dependency Graph

```mermaid
graph TD
    data.aws_ami.ubuntu["data.aws_ami.ubuntu"]
    data.aws_ec2_instance_types.free_tier["data.aws_ec2_instance_types.free_tier"]
    aws_instance.web_server_ec2["aws_instance.web_server_ec2"]
    aws_security_group.web_server_ec2["aws_security_group.web_server_ec2"]
    aws_vpc_security_group_ingress_rule.allow_ipv4["aws_vpc_security_group_ingress_rule.allow_ipv4"]

    aws_instance.web_server_ec2 --> data.aws_ami.ubuntu
    aws_instance.web_server_ec2 --> data.aws_ec2_instance_types.free_tier
    aws_instance.web_server_ec2 --> aws_security_group.web_server_ec2
    aws_vpc_security_group_ingress_rule.allow_ipv4 --> aws_security_group.web_server_ec2
```

## :arrow_forward: How to Run

**NOTE**: This project will deploy real resources into your AWS account.
Remember to delete created resources to avoid charges on your AWS account.

### Pre-requisites

- Terraform installed (version v1.15.3 or higher recommended).
- AWS CLI configured with your credentials and default region.
- An AWS account with permissions to create EC2 instances.

### Steps

1. Initialize Terraform (downloads provider plugins):
   ```bash
   terraform init
   ```
2. Copy the example template to configure your input variables:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   Open `terraform.tfvars` and customize the values for your setup.
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

   public_ip = "98.92.151.89"
   ```
6. From your browser, enter the Public IP address and port `8080`:
   ```bash
   http://98.92.151.89:8080/
   ```
   You should see the following message:
   ```bash
   Congratulations, the web server is working successfully
   ```
7. Clean up when you're done:
   ```bash
   terraform destroy
   ```

## :rocket: Looking Ahead

This project is a foundational step to understand Terraform workflow and AWS resource provisioning.\
You can extend this by adding variables, outputs, and more complex resources in future practices.
