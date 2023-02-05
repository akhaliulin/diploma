resource "yandex_compute_instance" "vm-1" {
  name = "nginx1"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = "fd8jvcoeij6u9se84dt5"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1-zone-a.id
    nat = true
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.webservers.id]
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-2" {
  name = "nginx2"
  zone = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = "fd8jvcoeij6u9se84dt5"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1-zone-b.id
    nat = true
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.webservers.id]
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "prometheus" {
  name = "prometheus"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      size = 15
      image_id = "fd8emvfmfoaordspe1jr"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1-zone-a.id
    nat = true
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.prometheus.id]
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "grafana" {
  name = "grafana"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = "fd8emvfmfoaordspe1jr"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1-zone-a.id
    nat = true
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.grafana.id]
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
} 

resource "yandex_compute_instance" "elastic" {
  name = "elastic"

  resources {
    cores  = 2
    memory = 4
  }
  boot_disk {
    initialize_params {
      size = 15
      image_id = "fd8emvfmfoaordspe1jr"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1-zone-a.id
    nat = true
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.elastic.id]
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
} 

resource "yandex_compute_instance" "kibana" {
  name = "kibana"

  resources {
    cores  = 2
    memory = 2 
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      size = 10
      image_id = "fd8emvfmfoaordspe1jr"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1-zone-a.id
    nat = true
    security_group_ids = [yandex_vpc_security_group.ssh.id, yandex_vpc_security_group.kibana.id]
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
} 

resource "yandex_compute_instance" "bastion" {
  name = "bastion"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = "fd8emvfmfoaordspe1jr"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1-zone-a.id
    nat = true
    security_group_ids = [yandex_vpc_security_group.bastion.id]
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
} 



