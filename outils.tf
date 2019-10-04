resource "google_compute_firewall" "firewalnexus" {
  name    = "firewalnexus"
  network = "${google_compute_network.network.name}"

  allow {
    protocol = "tcp"
    ports    = ["8081"]
  }

 target_tags = ["nexus-fir"]
  
}

resource "google_compute_instance" "nexus" {
  name         = "nexus"
  machine_type = "${var.machine_type}"
  zone         = "${var.zonevm}"
  tags = ["nexus-fir"]

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

resource "google_compute_instance" "maven" {
  name         = "maven"
  machine_type = "${var.machine_type}"
  zone         = "${var.zonevm}"
  

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

resource "google_compute_instance" "nginx" {
  name         = "nginx"
  machine_type = "${var.machine_type}"
  zone         = "${var.zonevm}"
  

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

      access_config {
      // Ephemeral IP
}
  }

  metadata {
    sshKeys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}