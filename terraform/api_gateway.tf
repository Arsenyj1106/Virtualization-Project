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
            container_id: "${yandex_serverless_container.tasks_backend.id}"
            service_account_id: "${yandex_iam_service_account.sa.id}"
        post:
          x-yc-apigateway-integration:
            type: "serverless_containers"
            container_id: "${yandex_serverless_container.tasks_backend.id}"
            service_account_id: "${yandex_iam_service_account.sa.id}"
      /api/tasks/{id}:
        put:
          parameters:
            - name: id
              in: path
              required: true
          x-yc-apigateway-integration:
            type: "serverless_containers"
            container_id: "${yandex_serverless_container.tasks_backend.id}"
            service_account_id: "${yandex_iam_service_account.sa.id}"
        delete:
          parameters:
            - name: id
              in: path
              required: true
          x-yc-apigateway-integration:
            type: "serverless_containers"
            container_id: "${yandex_serverless_container.tasks_backend.id}"
            service_account_id: "${yandex_iam_service_account.sa.id}"
  EOT
}