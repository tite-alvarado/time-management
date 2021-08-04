
# Create a CI
resource "openstack_compute_instance_v2" "time-management" {
  name = "time-management"
  image_id = "37b06e50-5375-46df-a08a-862c64093aeb"
  key_pair = "dreamcompute"
  flavor_name = "gp1.supersonic"
  # flavor_name = "gp1.lightspeed"
  security_groups = ["default", "jenkins", "nodeapp", "http", "https"]
  metadata = {
    comment = "CI Server"
  }
}
