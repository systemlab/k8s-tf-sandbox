output "vpn_gate_ip" {
  value = openstack_networking_floatingip_v2.floatingip_vpn_gate.address
}

output "k8s_cluster_internal_ip" {
  value = selectel_mks_cluster_v1.main_cluster.kube_api_ip
}

output "k8s_cluster_kubeconfig" {
  sensitive = true
  value = data.selectel_mks_kubeconfig_v1.main_cluster_kubeconfig.raw_config
}

output "postgres_dsn" {
  value = selectel_dbaas_datastore_v1.postgres_datastore_1.connections
}

output "redis_dsn" {
  value = selectel_dbaas_datastore_v1.postgres_datastore_1.connections
}
