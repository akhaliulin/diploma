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

