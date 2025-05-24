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
        get:
          x-yc-apigateway-integration:
            type: "serverless_containers"
            container_id: "${yandex_serverless_container.backend.id}"
            service_account_id: "${yandex_iam_service_account.todo-sa.id}"
        post:
          x-yc-apigateway-integration:
            type: "serverless_containers"
            container_id: "${yandex_serverless_container.backend.id}"
            service_account_id: "${yandex_iam_service_account.todo-sa.id}"
      /api/tasks/{id}:
        put:
          parameters:
            - name: id
              in: path
              required: true
          x-yc-apigateway-integration:
            type: "serverless_containers"
            container_id: "${yandex_serverless_container.backend.id}"
            service_account_id: "${yandex_iam_service_account.todo-sa.id}"
        delete:
          parameters:
            - name: id
              in: path
              required: true
          x-yc-apigateway-integration:
            type: "serverless_containers"
            container_id: "${yandex_serverless_container.backend.id}"
            service_account_id: "${yandex_iam_service_account.todo-sa.id}"
      /:
        get:
          x-yc-apigateway-integration:
            type: "serverless_containers"
            container_id: "${yandex_serverless_container.frontend.id}"
            service_account_id: "${yandex_iam_service_account.todo-sa.id}"
  EOT
}

output "api_gateway_url" {
  value = "https://${yandex_api_gateway.tasks_gateway.domain}"
}