// Создает гейтвей, который обрабатывает запросы к апи
#
resource "yandex_api_gateway" "tasks_gateway" {
  name        = "tasks-gateway"
  description = "Gateway for Tasks API"
  spec = <<-EOT
  openapi: "3.0.0"
  info:
    title: "Tasks API Gateway"
    version: "1.0.0"
  paths:
    /api/tasks:
      x-yc-apigateway-any-method:
        x-yc-apigateway-integration:
          type: "serverless_containers"
          container_id: "${yandex_serverless_container.backend.id}"
          service_account_id: "${yandex_iam_service_account.todo-sa.id}"

    /api/tasks/{path}:
      x-yc-apigateway-any-method:
        x-yc-apigateway-integration:
          type: "serverless_containers"
          container_id: "${yandex_serverless_container.backend.id}"
          service_account_id: "${yandex_iam_service_account.todo-sa.id}"
  EOT
}

output "api_gateway_url" {
  value = "https://${yandex_api_gateway.tasks_gateway.domain}"
}