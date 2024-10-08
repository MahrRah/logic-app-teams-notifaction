variable "name" {
  description = "Name of the workflow resources"
  type        = string
  default     = "wf-webhook-rg"
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

variable "webhook_url" {
  description = "Webhook URL"
  type        = string
 }