// Вроде удобно делать так, после запуска terraform apply, я пушу вручную образы с уже записанными .env(Но в любом случае плохо, что приходится вручную пушить образы)

resource "local_file" "env_file" {
  content = <<-EOF
    PG_LINK=postgres://${var.postgresql_user}:${var.postgresql_password}@${yandex_mdb_postgresql_cluster.todo-postgres-cluster.host[0].fqdn}:6432/${var.postgresql_db}
  EOF
  filename = "../.env"
}

resource "local_file" "env_file_backend" {
  content = <<-EOF
    PG_LINK=postgres://${var.postgresql_user}:${var.postgresql_password}@${yandex_mdb_postgresql_cluster.todo-postgres-cluster.host[0].fqdn}:6432/${var.postgresql_db}

  EOF
  filename = "../backend/.env"
}


resource "local_file" "env_frontend" {
  content = <<-EOF
    VITE_API_URL=https://${yandex_api_gateway.tasks_gateway.domain}/api/tasks
  EOF
  filename = "../frontend/.env"
}