<div align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="../images/Terraform_onDark.svg">
    <source media="(prefers-color-scheme: light)" srcset="../images/Terraform_onLight.svg">
    <img alt="Terraform logo" src="../images/Terraform_onLight.svg" width="850">
  </picture>
</div>

# Microsoft Azure Projects

This directory contains a curated collection of Microsoft Azure Infrastructure as Code projects, ranging from core resource management and virtual networking to scalable, enterprise-grade cloud architectures built with Terraform.

Each project is designed to showcase modular design, security best practices, and efficient resource organization following the Azure Cloud Adoption Framework.

## :file_folder: Portfolio Structure

Every directory inside this repository represents an independent, self-contained project.

- [basic-vm](basic-vm): Deploy a simple Azure Virtual Machine. Perfect for beginners to get familiar with Terraform basics and Azure resource provisioning.

## :gear: Operational Guidelines & Best Practices

- :package: **Isolated Environments**: Every project is fully self-contained. You can experiment, modify, and deploy within any specific directory without risking cross-project interference.
- :shield: **Execution Safety**: Always run `terraform plan` prior to `terraform apply`. Reviewing the execution graph is non-negotiable to prevent unintended infrastructure drift.
- :notebook: **Granular Documentation**: Each project folder contains its own local `README.md`. Refer to it for specific architecture diagrams, variables, and deployment steps.
- :money_with_wings: **Cost Optimization**: Avoid unnecessary cloud expenditures. Always execute `terraform destroy` immediately after testing to ensure proper resource cleanup.
