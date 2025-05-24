// Сеть
resource "yandex_vpc_network" "network-1" {
  name = "terraform-net-gnushev"
}

// Подсесть, в которой будет сервис
resource "yandex_vpc_subnet" "subnet-1" {
  name           = "terraform-subnet-gneushev"
  zone = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.2.0.0/16"]
}
