resource "yandex_mdb_postgresql_cluster" "todo-postgres-cluster" {
  name        = "todo-postgres-cluster"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.network-1.id

  config {
    version = 15
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }
    postgresql_config = {
      max_connections                   = 395
      enable_parallel_hash              = true
      vacuum_cleanup_index_scale_factor = 0.2
      autovacuum_vacuum_scale_factor    = 0.34
      default_transaction_isolation     = "TRANSACTION_ISOLATION_READ_COMMITTED"
      shared_preload_libraries          = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
    }
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet-1.id
  }
}

resource "yandex_mdb_postgresql_database" "todo-postgresql" {
  cluster_id = yandex_mdb_postgresql_cluster.todo-postgres-cluster.id
  name       = var.postgresql_db
  owner      = yandex_mdb_postgresql_user.todo-user.name
}

resource "yandex_mdb_postgresql_user" "todo-user" {
  cluster_id = yandex_mdb_postgresql_cluster.todo-postgres-cluster.id
  name       = var.postgresql_user
  password   = var.postgresql_password
  conn_limit = 50

  settings = {
    default_transaction_isolation = "read committed"
    log_min_duration_statement    = 5000
  }
}