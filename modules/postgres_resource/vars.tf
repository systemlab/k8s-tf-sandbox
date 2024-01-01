variable "project_id" {}
variable "region" {}
variable "datastore_id" {}
variable "username" {}
variable "password" {}
variable "dbname" {}

variable "extensions" {
  type = list
  default = []
}

variable "lc_ctype" {
  type = string
  default = "ru_RU.utf8"
}
variable "lc_collate" {
  type = string
  default = "ru_RU.utf8"
}
