<div align="center">
  <img width="1657" height="433" alt="Terraform_onLight" src="https://github.com/user-attachments/assets/ca0307a8-831c-4a1f-bf48-3460b5552ae2" />
</div>

# Terraform Practice: Blue-Green Deployment in AWS

## :dart: Objective

The objective of this practice is to implement and understand the Blue-Green Deployment strategy, a release methodology designed to minimize downtime and reduce deployment risks.

This approach involves maintaining two identical production environments: Blue (current live environment) and Green (idle environment for the new version).

The deployment process includes:
- Deploying the new version of the application to the **Green** environment.
- Testing and validating the **Green** environment to ensure stability and functionality.
- Switching traffic from the **Blue** environment to the **Green** environment using a router, ensuring a seamless transition with zero downtime.
- Retaining the **Blue** environment as a fallback for quick rollbacks in case of issues with the new version.

<div align="center">
  <img width="711" height="392" alt="blue-green-deployment drawio" src="https://github.com/user-attachments/assets/161fe077-cbcd-4c2a-ab4a-af31f74d1ee3" />
</div>

This practice demonstrates how to achieve safe, efficient, and reversible deployments while maintaining high availability and minimizing risks during production updates.

## :building_construction: Infrastructure Overview

The infrastructure consists of the following key components:

- Base Module:
  - 1 VPC.
  - 1 route table.
  - 1 Internet gateway.
  - 1 NAT gateway.
  - 2 public subnets for the Application Load Balancer.
  - 2 private subnets for the EC2 instances.
  - 2 security groups (ALB and Blue-Green app).
  - 1 IAM role instance profile.
  - 1 Application Load Balancer (ALB):
    - 1 listener.
    - 2 target groups.
  - 1 resource group.

- Autoscaling Module:
  - 2 Launch template (Blue and Green):
    - **AMI**: Ubuntu Server 24.04 LTS (HVM), SSD Volume Type.
    - **Instance type**: t4g.micro (eligible for AWS free tier).
    - **Architecture**: 64-bit (Arm).
    - **User data**: startup.sh.
  - 2 Auto Scaling Group (ASG):
    - Blue:
      - Desired capacity: 1.
      - Min size: 1.
      - Max size: 2.
    - Green:
      - Desired capacity: 1.
      - Min size: 1.
      - Max size: 2.

## :world_map: Architecture Diagrams

### Deployment Strategy

The **Base** infrastructure is deployed first. \
Initially, **Blue** will be the live server, while **Green** is idle. \
Then a manual cutover will take place so that **Green** becomes the new live server.

<div align="center">
  <img width="601" height="141" alt="blue-green-deployment-strategy drawio" src="https://github.com/user-attachments/assets/40f7f3d5-708f-40e5-ac41-e7d20de3fc4e" />
</div>

The end result is that the customer experiences an instantaneous software update from version **1.0** to **2.0**.

### Blue

<div align="center">
  <img width="811" height="631" alt="blue-green-deployment-a drawio" src="https://github.com/user-attachments/assets/17d09a94-9b1d-4dc0-afa7-1276d0a04916" />
</div>

### Green

<div align="center">
  <img width="811" height="631" alt="blue-green-deployment-b drawio" src="https://github.com/user-attachments/assets/304d1959-82a2-404c-989c-ec84ffa8aa82" />
</div>
