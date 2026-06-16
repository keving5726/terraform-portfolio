variable "namespace" {
  type        = string
  description = "A project name to use for resource mapping"
}

variable "terraform_version" {
  type        = string
  description = "The version of Terraform to use for this workspace. Defaults to the latest available version"
  default     = "latest"
}

variable "working_directory" {
  type        = string
  description = "A relative path that Terraform will execute within. Defaults to the root of your repository"
  default     = "."
}

variable "auto_apply" {
  type        = bool
  description = "Automatically apply changes when a Terraform plan runs successfully. Defaults to false"
  default     = false
}

variable "environment" {
  type        = map(string)
  description = "A map of environment variables to pass into pipeline"
  default = {
    TF_IN_AUTOMATION = "1"
    TF_INPUT         = "0"
    CONFIRM_DESTROY  = "0"
  }
}

variable "deployment_policy" {
  type        = string
  description = "An optional IAM deployment policy. Defaults to null"
  default     = null
}

variable "s3backend_config" {
  type = object({
    bucket   = string
    region   = string
    role_arn = string
  })
  description = "Settings for configuring the S3 remote backend"
}
