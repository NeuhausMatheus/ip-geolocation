
resource "google_container_cluster" "sca-cluster" {
  name = random_pet.service_account.keepers.cluster_name

  location = var.cluster_zone


  initial_node_count       = 1
  remove_default_node_pool = true

  enable_shielded_nodes = true

  ip_allocation_policy {

    cluster_ipv4_cidr_block  = ""
    services_ipv4_cidr_block = ""
  }
  networking_mode = "VPC_NATIVE"

  network    = "default"
  subnetwork = ""

  release_channel {
    channel = "REGULAR"
  } 
  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }
}


resource "google_container_node_pool" "sca-node-pool" {
  name = "${random_pet.service_account.keepers.cluster_name}"

  cluster = random_pet.service_account.keepers.cluster_name

  node_config {

    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = google_service_account.node-pool-service-account.email

    machine_type = var.machine_type
    
    workload_metadata_config {
      mode = "GKE_METADATA"  
  }

  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  initial_node_count = 1
  autoscaling {
    min_node_count = 1 
    max_node_count = 2
  }
}

