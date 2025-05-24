resource "yandex_container_registry" "todo-container-registry" {
  name      = "todo-registry"
  folder_id = var.folder_id

  labels = {
    my-label = "todo-label"
  }
}

resource "yandex_serverless_container" "backend" {
  name               = "backend-container"
  memory            = 256
  cores             = 1
  core_fraction     = 100
  service_account_id = yandex_iam_service_account.todo-sa.id
  image {
    url = "cr.yandex/crpm2hqm1q47oehkscbc/backend:v1"
  }
}

resource "yandex_serverless_container" "frontend" {
  name               = "frontend-container"
  memory            = 256  # MB
  cores             = 1
  core_fraction     = 100
  service_account_id = yandex_iam_service_account.todo-sa.id
  image {
    url = "cr.yandex/crpm2hqm1q47oehkscbc/frontend:v1"
  }
}

