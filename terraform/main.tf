terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  zone = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-1" {
  name = "nginx1"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jvcoeij6u9se84dt5"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1-zone-a.id
    nat = true
  }
  
  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "vm-2" {
  name = "nginx2"
  zone = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jvcoeij6u9se84dt5"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1-zone-b.id
    nat = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}
resource "yandex_vpc_network" "network-1" {
  name = "network-1"
}

resource "yandex_vpc_subnet" "subnet1-zone-a" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.network-1.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet1-zone-b" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.network-1.id}"
  v4_cidr_blocks = ["192.168.11.0/24"]
}

resource "yandex_alb_target_group" "nginx-servers" {
  name = "nginx-servers-target-group"

  target {
    subnet_id = "${yandex_vpc_subnet.subnet1-zone-a.id}"
    ip_address   = "${yandex_compute_instance.vm-1.network_interface.0.ip_address}"
  }

  target {
    subnet_id = "${yandex_vpc_subnet.subnet1-zone-b.id}"
    ip_address   = "${yandex_compute_instance.vm-2.network_interface.0.ip_address}"
  }
}

resource "yandex_alb_backend_group" "test-backend-group" {
  name = "nginx-servers-backend-group"

  http_backend {
    name                  = "nginx-servers-backend"
    weight                = 1
    port                  = 80
    target_group_ids      = [ "${yandex_alb_target_group.nginx-servers.id}" ]
    load_balancing_config {
      panic_threshold     = 90
    }
    healthcheck {
      timeout             = "10s"
      interval            = "2s"
      healthy_threshold   = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path              = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "tf-router" {
  name                    = "http-nginx-router"
}

resource "yandex_alb_virtual_host" "nginx-virtual-host" {
  name                    = "nginx-virtual-host"
  http_router_id          = "${yandex_alb_http_router.tf-router.id}"
  route {
    name                  = "my-route"
    http_route {
      http_route_action {
          backend_group_id  = "${yandex_alb_backend_group.test-backend-group.id}"
          timeout           = "3s"
      }
    } 
  }
}

resource "yandex_alb_load_balancer" "nginx-balancer" {
  name                    = "nginx-balancer"
  network_id              = "${yandex_vpc_network.network-1.id}"

  allocation_policy {
    location {
      zone_id             = "ru-central1-a"
      subnet_id           = "${yandex_vpc_subnet.subnet1-zone-a.id}"
    }
    location {
      zone_id             = "ru-central1-b"
      subnet_id           = "${yandex_vpc_subnet.subnet1-zone-b.id}"
    }
  }

  listener {
    name                  = "test-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id    = "${yandex_alb_http_router.tf-router.id}"
      }
    }
  }
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}
output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}
output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}
output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}
output "external_ip_address_lb" {
  value = yandex_alb_load_balancer.nginx-balancer.*
}
