resource "helm_release" "external-dns" {
  name      = "external-dns"
  chart     = "${path.module}/deploy/external-dns"
  namespace = var.namespace
  timeout   = 20 * 60
  wait      = true
  values = [
    file("${path.module}/deploy/external-dns/values.yaml")
  ]
}

resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  chart     = "${path.module}/deploy/cert-manager"
  namespace = "cert-manager"
  timeout   = 20 * 60
  wait      = true
  values = [
    file("${path.module}/deploy/cert-manager/values.yaml")
  ]

  set {
    name  = "installCRDs"
    value = true
  }
  set {
    name  = "prometheus.enabled"
    value = false
  }
  set {
    name  = "webhook.timeoutSeconds"
    value = "4"
  }

}

resource "google_dns_managed_zone" "geolocation" {
  name        = "geolocation"
  description = "geo-location"
  dns_name    = "matheusneuhaus.com."
  visibility  = "public"
  project     = var.project_id
}

resource "google_service_account" "dns_sa" {
  account_id   = var.dns_sa_name
  display_name = var.dns_sa_name
}

resource "google_project_iam_binding" "dns_admin_binding" {
  project = var.project_id
  role    = "roles/dns.admin"

  members = [
    "serviceAccount:${google_service_account.dns_sa.email}",
  ]
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.dns_sa.id
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.dns_namespace}/external-dns]",
  ]
}

resource "kubernetes_namespace" "prod" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "ip-geolocation" {
  name      = "ip-geolocation"
  chart     = "${path.module}/deploy/app"
  namespace = var.namespace
  timeout   = 20 * 60
  wait      = true
  values = [
    file("${path.module}/deploy/app/values.yaml")
  ]
  set {
    name  = "replicas"
    value = var.deployment_replica
  }

  set {
    name  = "namespace"
    value = var.namespace
  }

  set {
    name  = "container.image"
    value = var.container_image
  }

  set {
    name  = "db.user"
    value = "postgres"
  }

  set {
    name  = "db.password"
    value = var.secrets
  }

  set {
    name  = "db.host"
    value = var.db_host
  
  }

  set {
    name  = "db.name"
    value = var.secrets
  }
}


resource "helm_release" "postgresql" {
  name      = "postgresql"
  chart     = "${path.module}/deploy/postgresql"
  namespace = var.namespace
  timeout   = 20 * 60
  wait      = true
  values = [
    file("${path.module}/deploy/postgresql/values.yaml")
  ]

  set {
    name  = "global.postgresql.auth.postgresPassword"
    value = var.secrets
  }

  set {
    name  = "global.postgresql.auth.username"
    value = var.secrets
  }

  set {
    name  = "global.postgresql.auth.password"
    value = var.secrets
  }
  
  set {
    name  = "global.postgresql.auth.database"
    value = var.secrets
  }

}