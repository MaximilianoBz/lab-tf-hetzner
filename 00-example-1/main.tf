# Create network
resource "hcloud_network" "mynet" {
  name       = "example-network"
  ip_range   = "10.0.0.0/8"
    labels     = {
        "env" = "dev"
    }
}
# Create network route
resource "hcloud_network_route" "privNet" {
  network_id  = hcloud_network.mynet.id
  destination = "10.100.1.0/24"
  gateway     = "10.0.1.1"
}
# Create network subnet
resource "hcloud_network_subnet" "foonet" {
  network_id   = hcloud_network.mynet.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}
# Create server
resource "hcloud_server" "server" {
  name        = "example-server"
  image       = "docker"
  server_type = "cpx21"
  location    = "nbg1"
  public_net {
    ipv4_enabled = false
    ipv6_enabled = true
  }
  ## Add SSH
  ssh_keys = [hcloud_ssh_key.my_ssh_key.id]
  labels      = {
    "env" = "dev"
  }
}
# Create server network
resource "hcloud_server_network" "srvnetwork" {
  server_id  = hcloud_server.server.id
  network_id = hcloud_network.mynet.id
  ip         = "10.0.1.5"
}
