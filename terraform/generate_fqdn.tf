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