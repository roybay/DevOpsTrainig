resource "google_compute_instance" "opendj_config_store" {
  "boot_disk" {
    initialize_params {
      image = "debian-cloud/debian-8"
    }
  }

  machine_type = "n1-standard-1"
  name         = "opendj-config-store-az1"

  "network_interface" {
    subnetwork    = "${google_compute_subnetwork.dev-subnet.name}"
    access_config = {}
  }

  zone = "us-east1-b"

  metadata {
    dev = "config-store"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}




resource "google_compute_instance" "opendj_cts_store" {
  "boot_disk" {
    initialize_params {
      image = "debian-cloud/debian-8"
    }
  }

  machine_type = "n1-standard-1"
  name         = "opendj-cts-store-az1"

  "network_interface" {
    subnetwork    = "${google_compute_subnetwork.dev-subnet.name}"
    access_config = {}
  }

  zone = "us-east1-b"

  metadata {
    dev = "cts-store"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}


