resource "google_firestore_database" "default" {
  project     = var.project
  name        = "(default)"
  location_id = "europe-north1"
  type        = "FIRESTORE_NATIVE"
}