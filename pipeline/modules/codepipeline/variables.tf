variable "namespace" {
  description = "A project name to use for resource mapping"
  type        = string
  default     = "terraform"
}

variable "terraform_version" {
  description = "The version of Terraform to use for this workspace. Defaults to the latest available version"
  type        = string
  default     = "latest"
}

variable "working_directory" {
  description = "A relative path that Terraform will execute within. Defaults to the root of your repository"
  type        = string
  default     = "."
}

variable "auto_apply" {
  description = "Whether to automatically apply changes when a Terraform plan is successful. Defaults to false"
  type        = bool
  default     = false
}
