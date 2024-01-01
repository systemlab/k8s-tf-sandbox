locals {
  base_name = "vpn_gate"
  server_image_name = "Ubuntu 22.04 LTS 64-bit"
  flavor_id = "9011" # 1vCPU (10% cpu), 512Mb RAM
  volume_size_in_gb = 8
}

resource "openstack_networking_port_v2" "vpn_gate_port" {
  network_id = openstack_networking_network_v2.internal_network.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.internal_subnet.id
  }
}

# Поиск ID образа (из которого будет создан сервер) по его имени
data "openstack_images_image_v2" "vpn_gate_image" {
  most_recent = true
  visibility  = "public"
  name        = local.server_image_name
}

# Создание сетевого загрузочного диска из образа
resource "openstack_blockstorage_volume_v3" "vpn_gate_root_volume" {
  name                 = "${local.base_name}_volume"
  size                 = local.volume_size_in_gb
  image_id             = data.openstack_images_image_v2.vpn_gate_image.id
  volume_type          = "fast.ru-2c"
  availability_zone    = var.availability_zone
  enable_online_resize = true
  lifecycle {
    ignore_changes = [image_id]
  }
}

# Создание сервера
resource "openstack_compute_instance_v2" "vpn_gate_server" {
  name              = "${local.base_name}_server"
  flavor_id         = local.flavor_id
  key_pair          = openstack_compute_keypair_v2.admin_ssh_pubkey[0].id
  availability_zone = var.availability_zone

  network {
    port = openstack_networking_port_v2.vpn_gate_port.id
  }

  block_device {
    uuid             = openstack_blockstorage_volume_v3.vpn_gate_root_volume.id
    source_type      = "volume"
    destination_type = "volume"
    boot_index       = 0
  }

  vendor_options {
    ignore_resize_confirmation = true
  }
  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "openstack_networking_floatingip_v2" "floatingip_vpn_gate" {
  pool = "external-network"
}

resource "openstack_networking_floatingip_associate_v2" "association_vpn_gate" {
  port_id     = openstack_networking_port_v2.vpn_gate_port.id
  floating_ip = openstack_networking_floatingip_v2.floatingip_vpn_gate.address
}
