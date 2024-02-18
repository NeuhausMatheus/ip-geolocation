

resource "google_storage_bucket" "example_bucket" {
  name     = "connection-name"
  location = "US" 
}

resource "google_storage_bucket_object" "cluster_cert" {
  name   = "cluster-cert"
  content = "${google_container_cluster.sca-cluster.master_auth[0].cluster_ca_certificate}"
  bucket =  "connection-name"
}

resource "google_storage_bucket_object" "cluster_endpoint" {
  name   = "cluster-endpoint"
  content = "${google_container_cluster.sca-cluster.endpoint}"
  bucket =  "connection-name"
}