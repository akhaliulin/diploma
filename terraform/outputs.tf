output "private_ip_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}
output "public_ip_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}
output "private_ip_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}
output "public_ip_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}
output "private_ip_prometheus" {
  value = yandex_compute_instance.prometheus.network_interface.0.ip_address
}
output "public_ip_prometheus" {
  value = yandex_compute_instance.prometheus.network_interface.0.nat_ip_address
}
output "private_ip_grafana" {
  value = yandex_compute_instance.grafana.network_interface.0.ip_address
}
output "public_ip_grafana" {
  value = yandex_compute_instance.grafana.network_interface.0.nat_ip_address
}
output "private_ip_elastic" {
  value = yandex_compute_instance.elastic.network_interface.0.ip_address
}
output "public_ip_elastic" {
  value = yandex_compute_instance.elastic.network_interface.0.nat_ip_address
}
output "private_ip_kibana" {
  value = yandex_compute_instance.kibana.network_interface.0.ip_address
}
output "public_ip_kibana" {
  value = yandex_compute_instance.kibana.network_interface.0.nat_ip_address
}
output "private_ip_bastion" {
  value = yandex_compute_instance.bastion.network_interface.0.ip_address
}
output "public_ip_bastion" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}
output "external_ip_address_lb" {
  value = yandex_alb_load_balancer.nginx-balancer.*
}

