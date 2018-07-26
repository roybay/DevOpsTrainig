resource "google_compute_network" "our_development_network" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dev-subnet" {
  ip_cidr_range = "${var.gcp_ip_cidr_range}"
  name          = "${var.subnet_names["subnet1"]}"
  network       = "${google_compute_network.our_development_network.self_link}"
  region        = "us-east1"
}
