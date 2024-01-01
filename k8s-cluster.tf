
data "selectel_mks_kube_versions_v1" "versions" {
  project_id = var.project_id
  region     = var.region
}

resource "selectel_mks_cluster_v1" "main_cluster" {
  name                              = "${var.project_name}-k8s-cluster"
  project_id                        = var.project_id
  region                            = var.region
  kube_version                      = data.selectel_mks_kube_versions_v1.versions.latest_version
  enable_autorepair                 = var.k8s_cluster.enable_autorepair
  private_kube_api                  = var.k8s_cluster.private_kube_api
  zonal                             = var.k8s_cluster.zonal
  enable_patch_version_auto_upgrade = var.k8s_cluster.enable_patch_version_auto_upgrade
  network_id                        = openstack_networking_network_v2.internal_network.id
  subnet_id                         = openstack_networking_subnet_v2.internal_subnet.id
  maintenance_window_start          = var.k8s_cluster.maintenance_window_start
}

resource "selectel_mks_nodegroup_v1" "nodegroup_1" {
  cluster_id        = selectel_mks_cluster_v1.main_cluster.id
  project_id        = selectel_mks_cluster_v1.main_cluster.project_id
  region            = selectel_mks_cluster_v1.main_cluster.region
  availability_zone = var.availability_zone
  nodes_count       = var.k8s_cluster.nodes_count
  keypair_name      = var.k8s_cluster.keypair_name
  affinity_policy   = var.k8s_cluster.affinity_policy
  cpus              = var.k8s_cluster_node.cpus
  ram_mb            = var.k8s_cluster_node.ram_mb
  volume_gb         = var.k8s_cluster_node.volume_gb
  volume_type       = var.k8s_cluster_node.volume_type

  # labels            = var.labels
  # dynamic "taints" {
  #   for_each = var.taints[*]
  #   content {
  #     key = taints.value["key"]
  #     value = taints.value["value"]
  #     effect = taints.value["effect"]
  #   }
  # }
}

data "selectel_mks_kubeconfig_v1" "main_cluster_kubeconfig" {
  cluster_id = selectel_mks_cluster_v1.main_cluster.id
  project_id = selectel_mks_cluster_v1.main_cluster.project_id
  region     = selectel_mks_cluster_v1.main_cluster.region
}
