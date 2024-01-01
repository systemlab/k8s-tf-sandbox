data "openstack_networking_network_v2" "external_net" {
  external = true
}

# Создание роутера
resource "openstack_networking_router_v2" "main_router" {
  name                = "${var.project_name}_router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external_net.id
}

# Создание сети
resource "openstack_networking_network_v2" "internal_network" {
  name = "${var.project_name}_network" #
  admin_state_up = "true"
}

# Создание подсети
resource "openstack_networking_subnet_v2" "internal_subnet" {
  network_id = openstack_networking_network_v2.internal_network.id
  name       = "${var.project_name}_subnet"
  dns_nameservers = var.dns_nameservers
  cidr       = var.internal_subnet_cidr
}

# Подключение роутера к подсети
resource "openstack_networking_router_interface_v2" "main_router_interface_internal" {
  router_id = openstack_networking_router_v2.main_router.id
  subnet_id = openstack_networking_subnet_v2.internal_subnet.id
}
