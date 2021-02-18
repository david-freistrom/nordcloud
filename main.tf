resource "google_sourcerepo_repository" "notejam" {
  provider = google
  name     = "notejam"
}

resource "google_artifact_registry_repository" "notejam" {
  provider      = google-beta
  repository_id = "notejam"
  description   = "Noordcloud's Notejam Docker Repo"
  format        = "DOCKER"
  location      = var.region
}

resource "google_cloudbuild_trigger" "prod_trigger" {
  name = "Production-Trigger" 
  description = "Run Build and Tests when master branch is tagged with semver tagging"

  trigger_template {
    tag_name   = "^v\\d+\\.\\d+\\.\\d+-?.*$"
  }

  filename = "cloudbuild_prod.yaml"
}

resource "google_cloudbuild_trigger" "test_trigger" {
  name        = "Testing-Trigger"
  description = "Run Build and Tests and deploy to internal testing environment when pushed to testing branch"

  trigger_template {
    branch_name = "^testing$"
    repo_name   = "notejam"
  }

  filename = "cloudbuild_test.yaml"
}

resource "google_cloudbuild_trigger" "dev_trigger" {
  name        = "Development-Trigger"
  description = "Run Build and Tests but do not Deploy when pushed to any feature_X branch"

  trigger_template {
    branch_name = "^feature_.*$"
    repo_name   = "notejam"
  }

  filename = "cloudbuild_dev.yaml"
}

resource "google_compute_network" "private_network" {
  provider = google-beta
  name = "private-network"
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_vpc_access_connector" "connector" {
  name          = "notejam-db-connector"
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.private_network.name
  project       = var.project
  region        = var.region
}

resource "google_sql_database_instance" "master" {
  provider         = google-beta
  name             = "notejam-dbms"
  database_version = "POSTGRES_11"
  region           = var.region

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
    }
  }
}

resource "google_sql_database" "database" {
  name      = "notejam-db"
  instance  = google_sql_database_instance.master.name
}

resource "google_sql_user" "users" {
  name     = var.db_username
  instance = google_sql_database_instance.master.name
  host     = ""
  password = var.db_password
}

# resource "google_cloud_run_service" "notejam" {
#   name     = "notejam"
#   location = "us-central1"

#   template {
#     spec {
#       containers {
#         image = "us-docker.pkg.dev/cloudrun/container/notejam"
#       }
#     }
#   }

#   traffic {
#     percent         = 100
#     latest_revision = true
#   }
# }
