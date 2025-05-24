// Неудача с использование container-solution, вместо - вручную созданная Виртуальная машина, с docker

# data "yandex_compute_image" "container-optimized-image" {
#   family = "container-optimized-image"
# }
#
# resource "yandex_compute_instance" "frontend_vm" {
#   name        = "frontend-vm"
#   platform_id = "standard-v2"
#   zone        = "ru-central1-a"
#
#   resources {
#     cores  = 2
#     memory = 2
#   }
#
#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.container-optimized-image.id
#       size     = 20
#     }
#   }
#
#   network_interface {
#     subnet_id = yandex_vpc_subnet.subnet-1.id
#     nat       = true
#   }
#
#   metadata = {
#     docker-container-declaration = file("${path.module}/docker-declaration.yaml")
#   }
# }
#
