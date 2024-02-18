variable "project_id" {
  type        = string
}

variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "dns_sa_name" {
  description = "The name of the DNS service account."
  default     = "external-dns"
}
variable "dns_namespace" {
  description = "The name of the DNS service account."
  default     = "external-dns"
}


variable "region" {
    default = "us-east1"
  type = string
}

variable "namespace" {
  type        = string
  default = "prod"
  description = "namespace where the kubernetes objects will be created"
}

variable "db_host" {
  type        = string
  default     = "postgresql.prod.svc.cluster.local"
  description = "database host"
}

variable "db_user" {
  type        = string
  description = "database host"
}

variable "secrets"{
         type        = string
}

variable "deployment_replica" {
  default = 1
  type        = number
  description = "number of pods in the deployment"
}

variable "container_image" {
  default = "neuhausmatheus/api-geolocation:v0.0.15"
  type        = string
  description = "container image to run in the pod"
}