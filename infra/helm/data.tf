data "google_client_config" "default" {}

data "google_storage_bucket_object_content" "cluster_endpoint" {
  name   = "cluster-endpoint"
  bucket = "connection-name"
}

data "google_storage_bucket_object_content" "cluster_cert" {
  name   = "cluster-cert"
  bucket = "connection-name"
}