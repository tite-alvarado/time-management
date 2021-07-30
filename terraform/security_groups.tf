
resource "openstack_compute_secgroup_v2" "jenkins" {
  name = "jenkins"
  description = "Security group for the Jenkins CI"
  rule {
    from_port = 8080
    to_port = 8080
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "nodeapp" {
  name = "nodeapp"
  description = "Security group for the nodeapp"
  rule {
    from_port = 3000
    to_port = 3000
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}
