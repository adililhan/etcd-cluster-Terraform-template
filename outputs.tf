output "etcd_servers_ip_addresses" {
  value = ["${aws_instance.etcd[*].public_ip}"]
}