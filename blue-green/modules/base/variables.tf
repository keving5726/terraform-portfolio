variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  type        = string
}

variable "deployment" {
  description = "The current deployment version or environment"
  type        = string
}
