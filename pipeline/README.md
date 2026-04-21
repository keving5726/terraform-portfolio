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
