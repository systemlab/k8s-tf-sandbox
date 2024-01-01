

resource "selectel_dbaas_user_v1" "user" {
  project_id   = var.project_id
  region       = var.region
  datastore_id = var.datastore_id
  name         = var.username
  password     = var.password
}

resource "selectel_dbaas_database_v1" "database" {
  project_id   = var.project_id
  region       = var.region
  datastore_id = var.datastore_id
  owner_id     = selectel_dbaas_user_v1.user.id
  name         = var.dbname
  lc_ctype     = var.lc_ctype
  lc_collate   = var.lc_collate
}

data "selectel_dbaas_available_extension_v1" "ae" {
  count= length(var.extensions)


  project_id = var.project_id
  region     = var.region
  filter {
    name = var.extensions[count.index]
  }
}

resource "selectel_dbaas_extension_v1" "extension_1" {
  count= length(var.extensions)

  project_id             = var.project_id
  region                 = var.region
  datastore_id           = var.datastore_id
  database_id            = selectel_dbaas_database_v1.database.id
  available_extension_id = data.selectel_dbaas_available_extension_v1.ae[count.index].available_extensions[0].id
}
