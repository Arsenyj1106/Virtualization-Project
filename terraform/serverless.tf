resource "yandex_container_registry" "todo-container-registry" {
  name      = "todo-registry"
  folder_id = var.folder_id

  labels = {
    my-label = "todo-label"
  }
}

resource "yandex_serverless_container" "test-container" {
  name               = "test"
  memory             = 2
  service_account_id = yandex_iam_service_account.todo-sa.id
  image {
    url = "https://bba78u7b4lrdl7s6hrgg.containers.yandexcloud.net/"

  }
}