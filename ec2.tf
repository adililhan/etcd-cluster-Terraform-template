resource "aws_instance" "etcd" {

  count = var.number_of_instance

  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name

  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.default_sg.id]
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = templatefile("setup/install.tftpl", { index = count.index, etcd_version = var.etcd_version })

  tags = {
    Name = "etcd-${count.index}"
  }

  provisioner "local-exec" {
    command = "echo etcd-${count.index}=http://${self.private_ip}:2380 >> ${var.private_ips_file}"
  }
}


resource "null_resource" "cluster" {

  count = var.number_of_instance

  triggers = {
    cluster_instance_ids = "${join(",", aws_instance.etcd.*.id)}"
  }

  connection {
    host        = element(aws_instance.etcd.*.public_ip, count.index)
    private_key = file("${aws_key_pair.key_pair.key_name}.pem")
    user        = var.ssh_user
  }

  provisioner "file" {
    source      = var.private_ips_file
    destination = "/tmp/${var.private_ips_file}"
  }

  provisioner "file" {
    source      = "setup/etcd.service"
    destination = "/tmp/etcd.service"
  }

  provisioner "file" {
    source      = "setup/etcd_setup"
    destination = "/tmp/etcd_setup"
  }

  provisioner "remote-exec" {
    inline = ["sudo chmod +x /tmp/etcd_setup",
      "sudo /tmp/etcd_setup ${count.index}"
    ]
  }

}

resource "null_resource" "cleaning" {
  provisioner "local-exec" {
    command = "rm -f private_ips.txt"
    when    = destroy
  }
}
