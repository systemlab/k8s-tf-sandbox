locals {
  postgres_version = "16"
  postgres_node_count = 1
}

###############################
# Поиск datastore_type
###############################

data "selectel_dbaas_datastore_type_v1" "postgres_datastore_type" {
  project_id = var.project_id
  region     = var.region
  filter {
    engine  = "postgresql"
    version = local.postgres_version
  }
}

###############################
# Создание Кластера БД
###############################

resource "selectel_dbaas_datastore_v1" "postgres_datastore_1" {
  name       = "${var.project_name}-pg-datastore-1"
  project_id = var.project_id
  region     = var.region
  type_id    = data.selectel_dbaas_datastore_type_v1.postgres_datastore_type.datastore_types[0].id
  subnet_id = openstack_networking_subnet_v2.internal_subnet.id

  node_count = local.postgres_node_count

  flavor {
    vcpus = 2
    ram   = 4096
    disk  = 32
  }
  pooler {
    mode = "transaction"
    size = 50
  }
}

module "kubernetes_cluster"  {
  source = "./modules/postgres_resource"

  count = length(var.postgres_resources)

  project_id = var.project_id
  region     = var.region
  datastore_id =  selectel_dbaas_datastore_v1.postgres_datastore_1.id

  username = var.postgres_resources[count.index].username
  password = var.postgres_resources[count.index].password
  dbname = var.postgres_resources[count.index].dbname
}
