variable "token" {
  description = "OAuth токен вашего аккаунта"
  type        = string
}
variable "cloud_id" {
  description = "Айди облака, в котором будут создаваться ресурсы"
  type        = string
}
variable "folder_id" {
  description = "Айди папки, в которой будут создаваться ресурсы"
  type        = string
}

variable "postgresql_user" {
  description = "Имя пользователя БД"
  type        = string
}

variable "postgresql_password" {
  description = "Пароль БД"
  type        = string
}

variable "postgresql_db" {
  description = "Название БД"
  type        = string
}

