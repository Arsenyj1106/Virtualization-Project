resource "yandex_iam_service_account" "todo-sa" {
  name = "todo-sa"
}
// Все нужные роли для создания ресурсов
resource "yandex_resourcemanager_folder_iam_member" "todo-roles" {
  for_each = toset([
    "container-registry.images.puller",
    "mdb.viewer",
    "serverless.containers.invoker",
    "serverless.containers.editor",
    "vpc.publicAdmin",
    "compute.editor",
    "storage.viewer",
    "api-gateway.editor",
  ])
  folder_id = var.folder_id
  member    = "serviceAccount:${yandex_iam_service_account.todo-sa.id}"
  role      = each.key
}

