# ----- Группы безопасности -----


# Bastion
resource "yandex_vpc_security_group" "public-bastion-network" {
  name        = "public-bastion-network"
  description = "Public Group Bastion"
  network_id  = yandex_vpc_network.netology-diplom.id

  ingress {
    protocol       = "TCP"
    description    = "external source"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 22
  }


 ingress {
    protocol       = "ICMP"
    description    = "touch host"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    protocol       = "ANY"
    description    = "Rule description"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "private-network" {
  name        = "private-network"
  description = "Private Group"
  network_id  = yandex_vpc_network.netology-diplom.id

  ingress {
    protocol          = "ANY"
    description       = "internal source"
    predefined_target = "self_security_group"
  }

  egress {
    protocol          = "ANY"
    from_port         = 0
    to_port           = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "yandex_vpc_security_group" "external-zabbix" {
  name       = "external-zabbix"
  network_id = yandex_vpc_network.netology-diplom.id

  ingress {
    protocol       = "TCP"
    description    = "zabbix test"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 10051
  }

  ingress {
    protocol       = "TCP"
    description    = "http test"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "ICMP"
    description    = "ping test"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "full access output"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "yandex_vpc_security_group" "external-kibana" {
  name       = "extrenal-kibana"
  network_id = yandex_vpc_network.netology-diplom.id

  ingress {
    protocol       = "TCP"
    description    = "External access"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 5601
  }

  ingress {
    protocol       = "ICMP"
    description    = "Test ping"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "External output"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "external-load-balancer" {
  name       = "external-load-balancer"
  network_id = yandex_vpc_network.netology-diplom.id

  ingress {
    protocol          = "ANY"
    description       = "Health test"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    predefined_target = "loadbalancer_healthcheck"
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP test connection"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "ICMP"
    description    = "Test ping"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "External output"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}