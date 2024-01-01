locals {
  redis_version = "6"
  redis_node_count = 1
}

data "selectel_dbaas_datastore_type_v1" "redis_datastore_type" {
  project_id = var.project_id
  region     = var.region
  filter {
    engine  = "redis"
    version = local.redis_version
  }
}

###############################
# Поиск flavor
###############################

data "selectel_dbaas_flavor_v1" "flavor" {
    project_id = var.project_id
    region     = var.region
    filter {
      datastore_type_id = data.selectel_dbaas_datastore_type_v1.redis_datastore_type.datastore_types[0].id
    }
}

###############################
# Создание Кластера БД
###############################

resource "selectel_dbaas_datastore_v1" "redis_datastore_1" {
  name       = "${var.project_name}-redis-datastore-1"
  project_id = var.project_id
  region     = var.region
  type_id    = data.selectel_dbaas_datastore_type_v1.redis_datastore_type.datastore_types[0].id
  subnet_id  = openstack_networking_subnet_v2.internal_subnet.id
  node_count = local.redis_node_count

  redis_password = var.redis_password
  flavor_id = data.selectel_dbaas_flavor_v1.flavor.flavors[0].id

  config = {
    maxmemory-policy = "noeviction"
  }
}
