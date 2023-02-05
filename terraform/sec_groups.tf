resource "yandex_vpc_security_group" "ssh" {
  name = "ssh rule"
  description = "Security group for remote access only from a jump host"
  network_id = "${yandex_vpc_network.network-1.id}"

  ingress {
    protocol = "TCP"
    description = "rule for ssh"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
    port = 22
  }
  egress {
    protocol = "ANY"
    description = "accept all egress traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 65535
  }
}

resource "yandex_vpc_security_group" "webservers" {
  name = "webservers group"
  description = "Security group for webservers"
  network_id = "${yandex_vpc_network.network-1.id}"

  ingress {
    protocol = "TCP"
    description = "rule for balancer"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
    port = 80
  }

  ingress {
    protocol = "TCP"
    description = "rule for node exporter"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
    port = 9100
  }
  
  ingress {
    protocol = "TCP"
    description = "rule for nginx exporter"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
    port = 9113
  }
}

resource "yandex_vpc_security_group" "prometheus" {
  name = "prometheus rule"
  description = "Access to prometheus server"
  network_id = "${yandex_vpc_network.network-1.id}"

  ingress {
    protocol = "TCP"
    description = "rule for prometheus"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
    port = 9090
  }
}

resource "yandex_vpc_security_group" "grafana" {
  name = "grafana rule"
  description = "Access to grafana server"
  network_id = "${yandex_vpc_network.network-1.id}"

  ingress {
    protocol = "TCP"
    description = "rule for kibana"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 3000
  }
}

resource "yandex_vpc_security_group" "elastic" {
  name = "elastic rule"
  description = "Access to elastic server"
  network_id = "${yandex_vpc_network.network-1.id}"

  ingress {
    protocol = "TCP"
    description = "rule for elastic"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
    port = 9200
  }
  ingress {
    protocol = "TCP"
    description = "rule for elastic"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
    port = 9300
  }
}

resource "yandex_vpc_security_group" "kibana" {
  name = "kibana rule"
  description = "Access to kibana server"
  network_id = "${yandex_vpc_network.network-1.id}"

  ingress {
    protocol = "TCP"
    description = "rule for kibana"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 5601
  }
}

resource "yandex_vpc_security_group" "bastion" {
  name = "bastion rule"
  description = "Access to/from jump host"
  network_id = "${yandex_vpc_network.network-1.id}"

  ingress {
    protocol = "TCP"
    description = "rule for access to jump host"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 22
  }
  egress {
    protocol = "TCP"
    description = "rule for access from jump host"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.11.0/24"]
    port = 22
  }
}

