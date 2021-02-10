provider "google" {
  project     = "nordcloud-304401"
  region      = "us-central1"
  credentials = "nordcloud.json"
}

#locals {
#  create_vpc = "${var.vpc_id == "" ? 1 : 0}"
#}

resource "google_sourcerepo_repository" "notejam" {
  name = "notejam"
}

resource "google_cloud_run_service" "notejam" {
  name     = "notejam"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/notejam"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
