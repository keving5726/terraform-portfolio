variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  type        = string
  default     = "s3backend"
}

variable "principal_arns" {
  description = "A list of principal ARNs allowed to assume the IAM role"
  type        = list(string)
  default     = null
}

variable "force_destroy_state" {
  description = "Force destroy the S3 bucket containing state files"
  type        = bool
  default     = true
}
