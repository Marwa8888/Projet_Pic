resource "google_compute_firewall" "firewallkube" {
  name    = "firewallkube"
  network = "${google_compute_network.networkoutil.name}"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}


resource "google_container_cluster" "cluster" {
  name     = "cluster"
  location = "europe-west2-a"
  network  = "${google_compute_network.networkoutil.self_link}"
  subnetwork = "${google_compute_subnetwork.subk8s.self_link}"


  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1

  ip_allocation_policy {
      node_ipv4_cidr_block = "10.6.0.0/24"
  }

  private_cluster_config {
      master_ipv4_cidr_block = "10.7.0.0/28"
      enable_private_nodes = false
      enable_private_endpoint = false
  }
  
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "10.2.0.0/16"
      display_name = "net3"
    }
    cidr_blocks {
      cidr_block = "10.6.0.0/16"
      display_name = "net4"
    }
  }
  master_auth {
    username = ""
    password = ""
  }
}

resource "google_container_node_pool" "prod_preemptible_nodes1" {
  name       = "node1"
  location   = "europe-west2-a"
  cluster    = "${google_container_cluster.cluster.name}"
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}


