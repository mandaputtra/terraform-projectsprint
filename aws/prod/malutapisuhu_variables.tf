variable "malutapisuhu_services" {
  default = ["ms-upp-svc", "ms-product-svc"]
}

variable "malutapisuhu_service_configs" {
  default = {
    "ms-upp-svc"     = { container_port = 8080, cpu = 256, memory = 512, instance_count = 2 }
    "ms-product-svc" = { container_port = 8080, cpu = 256, memory = 512, instance_count = 2 }
  }
}

variable "malutapisuhu_databases" {
  default = "malutapisuhu-db"
}

variable "malutapisuhu_database_configs" {
  default = {
    name          = "malutapisuhu-db",
    instance_type = "db.t4g.large",
    db_name       = "malutapisuhu-tutuplapak"
  }
}
