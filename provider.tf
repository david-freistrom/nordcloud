provider "google" {
  project     = var.project
  region      = var.region
  credentials = file("key.json")
}

provider "google-beta" {
  project     = var.project
  region      = var.region
  credentials = file("key.json")
}
