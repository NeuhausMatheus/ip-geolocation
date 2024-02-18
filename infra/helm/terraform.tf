terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
    random = {
      source = "hashicorp/random"
    }
    google = {
      source = "hashicorp/google"
      version = ">=3.89.0"
    }
  }
}

terraform {
}

provider "google" {
  project = var.project_id
  region = var.region
}

provider "kubernetes" {
  host  = "https://${data.google_storage_bucket_object_content.cluster_endpoint.content}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_storage_bucket_object_content.cluster_cert.content,
  )
}

provider "helm" {
  kubernetes {
  host  = "https://${data.google_storage_bucket_object_content.cluster_endpoint.content}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_storage_bucket_object_content.cluster_cert.content,
  )
  }
}
