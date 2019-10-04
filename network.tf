
resource "google_compute_instance_group" "Pic" {
  name         = "${var.namegroupe}"
  description  = "${var.descriptiongroupe}"
  zone         = "${var.zonegroupe}"
  network      = "${google_compute_network.network.self_link}"
}

resource "google_compute_network" "network" {
  name                    = "${var.namenetwork}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subjenkins" {
  name          = "${var.subjenkins}"
  ip_cidr_range = "10.1.0.0/16"
  region        = "${var.regionsubnet}"
  network       = "${google_compute_network.network.self_link}"
}

resource "google_compute_firewall" "firewall" {
  name    = "test-firewall"
  network = "${google_compute_network.network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "firewaljenkins" {
  name    = "firewaljenkins"
  network = "${google_compute_network.network.name}"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

 target_tags = ["jenkins-fir"]
  
}

resource "google_compute_instance" "jenkins" {
  name         = "${var.jenkins}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zonevm}"
  tags = ["jenkins-fir"]

  boot_disk {
    initialize_params {
      image = "${var.imagevm}"
    }
    auto_delete = true
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    network = "${google_compute_network.network.self_link}"
    subnetwork = "${google_compute_subnetwork.subjenkins.self_link}"
  }

  metadata {
    sshKeys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

