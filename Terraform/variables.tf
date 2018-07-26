variable "network_name" {
  default     = "devnetwork"
  type        = "string"
  description = "Just the GCP network name"
}

variable "gcp_ip_cidr_range" {
  default     = "10.0.1.0/24"
  type        = "string"
  description = "IP CIDR range for google vpc"
}

variable "subnet_names" {
  type = "map"

  default = {
    subnet1 = "subnet1default"
    subnet2 = "subnet2"
  }
}

//output variables
output "first_output" {
  value = "This is the caloue through execution."
}

output "opendj_config_store_ip" {
  value = "${google_compute_instance.opendj_config_store.instance_id}"
}

output "opendj_cts_store_ip" {
  value = "${google_compute_instance.opendj_cts_store.network_interface.0.access_config.0.assigned_nat_ip}"
}

variable "new_var" {

}

variable "new_map" {
  type = "map"

}
