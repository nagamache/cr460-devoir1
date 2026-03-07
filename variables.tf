variable "location" {
  description = "Région Azure où déployer les ressources"
  type        = string
  default     = "canadacentral"
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources Azure"
  type        = string
  default     = "rg-cr460-devoir1"
}

variable "ssh_public_key" {
  description = "Clé publique SSH pour accéder à la VM"
  type        = string
}