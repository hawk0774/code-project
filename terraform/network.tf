# ----- Облачная сеть и NAT-table -----
resource "yandex_vpc_network" "netology-diplom" {
  name = var.vpc_name
}
resource "yandex_vpc_route_table" "nat-table" {
  network_id = yandex_vpc_network.netology-diplom.id

 static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.bastion.network_interface.0.ip_address
  }
}

# ----- Подсети -----

resource "yandex_vpc_subnet" "inner-web-1" {
  name           = var.name_three
  zone           = var.default_zone
  network_id     = yandex_vpc_network.netology-diplom.id
  v4_cidr_blocks = var.cidr_inner-web1
  route_table_id = yandex_vpc_route_table.nat-table.id
}

resource "yandex_vpc_subnet" "inner-web-2" {
  name           = var.name_four
  zone           = var.new_zone
  network_id     = yandex_vpc_network.netology-diplom.id
  v4_cidr_blocks = var.cidr_inner-web2
  route_table_id = yandex_vpc_route_table.nat-table.id
}


resource "yandex_vpc_subnet" "external-network" {
  name           = var.name_one
  zone           = var.new_zone
  network_id     = yandex_vpc_network.netology-diplom.id
  v4_cidr_blocks = var.cidr_external
}

resource "yandex_vpc_subnet" "internal-network" {
  name           = var.name_two
  zone           = var.new_zone
  network_id     = yandex_vpc_network.netology-diplom.id
  v4_cidr_blocks = var.cidr_internal
  route_table_id = yandex_vpc_route_table.nat-table.id
}

# ----- Target Group -----
resource "yandex_alb_target_group" "target-group" {
  name = "target-group"

  target {
    subnet_id = yandex_vpc_subnet.inner-web-1.id
    ip_address = yandex_compute_instance.webserv-1.network_interface.0.ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.inner-web-2.id
    ip_address   = yandex_compute_instance.webserv-2.network_interface.0.ip_address
  }
}

# ---- Backend -----
resource "yandex_alb_backend_group" "backend-group" {
  name                     = "backend-group"

  http_backend {
    name                   = "backend"
    weight                 = 1
    port                   = 80
    target_group_ids       = [yandex_alb_target_group.target-group.id]
    load_balancing_config {
      panic_threshold      = 90
    }
    healthcheck {
      timeout              = "7s"
      interval             = "1s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15
      http_healthcheck {
        path               = "/"
      }
    }
  }
}

#----------------- HTTP router -----------------
resource "yandex_alb_http_router" "http_router" {
  name = "http-router"
}

resource "yandex_alb_virtual_host" "rootless" {
  name           = "virtual-host"
  http_router_id = yandex_alb_http_router.http_router.id
  route {
    name = "root-path"
    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
        timeout          = "3s"
      }
    }
  }
}
#----------------- L7 balancer -----------------

resource "yandex_alb_load_balancer" "lb" {
  name               = "load-balancer"
  network_id         = yandex_vpc_network.netology-diplom.id
  security_group_ids = [yandex_vpc_security_group.external-load-balancer.id, yandex_vpc_security_group.private-network.id] 

  allocation_policy {
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.internal-network.id
    }
  }

  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http_router.id
      }
    }
  }
}
