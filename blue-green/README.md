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
