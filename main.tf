provider "aws" {
  region = var.region
}

resource "aws_key_pair" "my_key" {
  key_name = "my-key"
  public_key = file(var.my_ssh_key_path)
}

resource "aws_security_group" "cloud_firewall" {
  name = "cloud-firewall"
  description = "Firewall rules"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "servers" {
  count = 2
  ami = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.cloud_firewall.name]
  user_data = <<-EOF
              #!/bin/bash
              echo "${file(var.teacher_ssh_key_path)}" >> /home/ec2-user/.ssh/authorized_keys 
              EOF
  tags = {
    Name = "server-${count.index}"
  }
}

resource "aws_security_group_rule" "db_access" {
  count = 2
  type = "ingress"
  from_port = 5432
  to_port = 5435
  protocol = "tcp"
  cidr_blocks = [
    "${aws_instance.servers[(count.index + 1) % 2].private_ip}/32"  # Access to the other instance's private IP
  ]
  security_group_id = aws_security_group.cloud_firewall.id
}
