
resource "random_pet" "service_account" {
  keepers = {
    cluster_name = var.cluster_name
  }
  length = 1
}

resource "google_service_account" "node-pool-service-account" {
  account_id   = "np-${random_pet.service_account.id}"
  display_name = "${random_pet.service_account.keepers.cluster_name}-service-account"
  description  = "default service account for nodes in 'sca node pool'"
}


resource "google_project_iam_member" "roles" {

  for_each = toset(var.roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.node-pool-service-account.email}"
}
