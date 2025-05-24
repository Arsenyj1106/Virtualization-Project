resource "yandex_container_registry" "todo-container-registry" {
  name      = "todo-registry"
  folder_id = var.folder_id

  labels = {
    my-label = "todo-label"
  }
}

//Ревизия не проходит, приходится вручную добавить ревизию в Консоли Облака
resource "yandex_serverless_container" "backend" {
  name               = "backend-container"
  memory            = 256
  cores             = 1
  core_fraction     = 100
  service_account_id = yandex_iam_service_account.todo-sa.id

  image {
    url = "cr.yandex/crpm2hqm1q47oehkscbc/backend:latest"
    environment = {
      PG_LINK="postgres://${var.postgresql_user}:${var.postgresql_password}@${yandex_mdb_postgresql_cluster.todo-postgres-cluster.host[0].fqdn}:6432/${var.postgresql_db}"
      PORT="8000"
    }
  }

  connectivity {
    network_id = yandex_vpc_network.network-1.id
  }


}
# Не используем, вместо этого вм
# resource "yandex_serverless_container" "frontend" {
#   name               = "frontend-container"
#   memory            = 256  # MB
#   cores             = 1
#   core_fraction     = 100
#   service_account_id = yandex_iam_service_account.todo-sa.id
#   image {
#     url = "cr.yandex/crpm2hqm1q47oehkscbc/frontend:latest"
#     environment = {
#       PORT="3000"
#     }
#   }
#
#   connectivity {
#     network_id = yandex_vpc_network.network-1.id
#   }
# }

