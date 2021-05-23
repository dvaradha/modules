variable "port" {
    type = list
    
}

resource "google_compute_network" "myvpc" {
    name = "myvpc"
}

resource "google_compute_subnetwork" "mysubnet" {
    name = "mysubnet"
    ip_cidr_range = "10.1.0.0/16"
    network = google_compute_network.myvpc.id
}

resource "google_compute_firewall" "myfw" {
    name = "myfw"
    network = google_compute_network.myvpc.id
    dynamic "allow" {
       for_each = var.port
    content {
   
        protocol = "tcp"
        ports = [allow.value]
    
    }
    }
    target_tags = [ "web" ]
    source_ranges = ["0.0.0.0/0"]

}
resource "google_compute_firewall" "allowssh" {
    name = "allowssh"
    network = google_compute_network.myvpc.id
    allow {
        protocol = "tcp"
        ports = ["22"]
     }
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["allowssh"]
}

output "mynet" {
    value = google_compute_network.myvpc.id
}
