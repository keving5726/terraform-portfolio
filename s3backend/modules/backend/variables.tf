variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
  default     = "s3backend"
}

variable "principal_arns" {
  type        = list(string)
  description = "A list of principal ARNs allowed to assume the IAM role"
  default     = null
}

variable "force_destroy_state" {
  type        = bool
  description = "Force destroy the S3 bucket containing state files"
  default     = true
}
