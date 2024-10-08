variable "name" {
  description = "Name of the workflow resources"
  type        = string
  default     = "wf-connector-rg"
}

variable "location" {
  description = "Location for the resources"
  type        = string
  default     = "West Europe"
}

variable "suffix" {
  description = "Suffix for the resources"
  type        = string
  default     = "wf"
}
