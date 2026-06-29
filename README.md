<div align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./images/Terraform_onDark.svg">
    <source media="(prefers-color-scheme: light)" srcset="./images/Terraform_onLight.svg">
    <img alt="Logo de mi proyecto" src="./images/Terraform_onLight.svg">
  </picture>
</div>

# Terraform Portfolio

Welcome to my Terraform Portfolio!

This repository is a curated collection of Infrastructure as Code (IaC) projects, demonstrating a journey from cloud infrastructure fundamentals to complex AWS architectures. The goal of this repository is to showcase scalable, modular, and secure cloud deployments using Terraform best practices.

## :file_folder: Portfolio Structure

Every directory inside this repository represents an independent, self-contained project.

- [basic-ec2](basic-ec2): Deploy a simple AWS EC2 instance. Perfect for beginners to get familiar with Terraform basics and AWS resource provisioning.
- [web-server-ec2](web-server-ec2): Deploy a web server on a single EC2 instance with custom configuration. Great for understanding server provisioning and configuration management.
- [web-server-cluster](web-server-cluster): Set up a scalable web server cluster. Learn about load balancing and managing multiple instances for high availability.
- [multi-tier-webapp](multi-tier-webapp): Build a multi-tier web application architecture. Demonstrates how to organize infrastructure with separate layers like presentation, application, and data.
- [s3backend-dynamodb](s3backend-dynamodb): Configure a Terraform backend using Amazon S3 with DynamoDB for state locking. This project demonstrates how to manage remote state with locking to prevent conflicts in team environments and how to use workspaces. However, this setup is no longer recommended since Amazon S3 now provides a native state locking feature that simplifies and improves backend management.
- [s3backend](s3backend): Learn how to use Terraform’s remote backend with Amazon S3 to store infrastructure state. This project also introduces the use of workspaces to manage multiple environments or configurations within the same project, helping organize and control state versions effectively.
- [blue-green](blue-green): Implement a blue-green deployment strategy using Terraform. This project demonstrates how to deploy two identical environments (blue and green) to enable zero-downtime updates, safe rollbacks, and high availability during production deployments. It covers managing infrastructure versions, switching traffic between environments, and minimizing risks during updates.
- [pipeline](pipeline): Configure a continuous integration and continuous deployment (CI/CD) pipeline to automate the provisioning and updating of infrastructure with Terraform. Ideal for learning how to integrate Terraform with AWS CodeCommit, AWS CodeBuild, and AWS CodePipeline.

## :gear: Operational Guidelines & Best Practices

- :package: **Isolated Environments**: Every project is fully self-contained. You can experiment, modify, and deploy within any specific directory without risking cross-project interference.
- :shield: **Execution Safety**: Always run `terraform plan` prior to `terraform apply`. Reviewing the execution graph is non-negotiable to prevent unintended infrastructure drift.
- :notebook: **Granular Documentation**: Each project folder contains its own local **README.md**. Refer to it for specific architecture diagrams, variables, and deployment steps.
- :money_with_wings: **Cost Optimization**: Avoid unnecessary cloud expenditures. Always execute `terraform destroy` immediately after testing to ensure proper resource cleanup.

## :scroll: License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.\
:free: Feel free to use, modify, and distribute this Terraform code for personal or commercial projects!

## :mailbox_with_mail: Contact

Questions, suggestions, or feedback? Open an issue or reach out! Happy Terraforming! :earth_americas::sparkles:
