resource "google_container_cluster" "ulti" {
  name               = "ulti-cluster"
  zone               = "us-east1-b"
  initial_node_count = 1

  additional_zones = [
    "us-east1-c",
  ]

  master_auth {
    password = "P@ssw0rd1_test_cluster"
    username = "hcmtestuser"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      this-is-for = "dev-cluster"
    }

    tags = [
      "dev",
      "work",
    ]

    machine_type = "n1-standard-2"
  }

  network    = "${google_compute_network.our_development_network.name}"
  subnetwork = "${google_compute_subnetwork.dev-subnet.name}"
}
