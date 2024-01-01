variable "username" {}

variable "password" {}

variable "domain_name" {}

variable "project_id" {}

variable "region" {}

variable "auth_url" {
  default = "https://api.selvpc.ru/identity/v3"
}

variable "availability_zone" {
  default = "ru-2c"
}

variable "project_name" {
  default = "learn"
}

variable "internal_subnet_cidr" {
  default = "10.31.86.0/24"
}

variable "dns_nameservers" {
  default = [
    "188.93.16.19",
    "188.93.17.19",
  ]
}

variable "ssh_keypairs" {
  type = list(object({
    name = string
    key = string
  }))
}

variable "k8s_cluster" {
  type = object({
    private_kube_api = bool
    zonal = bool
    enable_patch_version_auto_upgrade = bool
    enable_autorepair = bool
    maintenance_window_start = string
    nodes_count       = number
    keypair_name      = string
    affinity_policy   = string
  })

  default = {
    private_kube_api = true
    zonal = true
    enable_patch_version_auto_upgrade = false
    enable_autorepair = true
    maintenance_window_start = ""
    nodes_count = 3
    keypair_name = ""
    affinity_policy = ""
  }
}

variable "k8s_cluster_node" {
  type = object({
   cpus = number
   ram_mb = number
   volume_gb = number
   volume_type = string
  })

  default = {
    cpus = 2
    ram_mb = 4096
    volume_gb = 16
    volume_type = "fast.ru-2c"
  }
}

variable "postgres_resources" {
  sensitive = true

  type = list(object({
    username = string
    password = string
    dbname = string
  }))

  default = []
}

variable "redis_password" {
  sensitive = true

  type = string
}
