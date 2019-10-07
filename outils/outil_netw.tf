provider "google" {
    credentials = "${file(var.credentials)}"
    project     = "mattermost-245316"
    
}
resource "google_compute_network" "networkoutil" {
  name                    = "networkoutil"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "suboutil" {
  name          = "suboutil"
  ip_cidr_range = "10.3.0.0/16"
  region        = "${var.regionsubnet}"
  network       = "${google_compute_network.networkoutil.self_link}"
}

resource "google_compute_firewall" "firewall" {
  name    = "tesfirewall"
  network = "${google_compute_network.networkoutil.name}"

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
}