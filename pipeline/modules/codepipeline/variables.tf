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
