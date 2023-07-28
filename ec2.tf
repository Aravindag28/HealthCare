provider "aws" {
  region     = "ap-south-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}


# Create VPC

resource "aws_vpc" "Kubernetes" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Kubernetes"
  }
}

# Create Subnet 

resource "aws_subnet" "Kubernetessubnet" {
  vpc_id     = aws_vpc.Kubernetes.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Kubernetessubnet"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "mygw12" {
  vpc_id = aws_vpc.Kubernetes.id

  tags = {
    Name = "mygw12"
  }
}

# Route Table

resource "aws_route_table" "myrt12" {
  vpc_id = aws_vpc.Kubernetes.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygw12.id
  }

  tags = {
    Name = "myrt12"
  }
}

# Route Table Association

resource "aws_route_table_association" "myrta12" {
  subnet_id      = aws_subnet.Kubernetessubnet.id
  route_table_id = aws_route_table.myrt12.id
}


# Security Groups

resource "aws_security_group" "Kubernetes" {
  name        = "Kubernetes"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.Kubernetes.id

  ingress {
    description      = "Custom TCP"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "mysg8"
  }
}

# Create Instance

resource "aws_instance" "Kubernetes_Master" {
  ami           = "ami-03cb1380eec7cc118"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.Kubernetessubnet.id
  vpc_security_group_ids = [aws_security_group.Kubernetes.id]
  key_name = "Staragile"

  tags = {
    Name = "Kubernetes_Master"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo adduser ansible-admin --disabled-password --gecos ''",
      "sudo usermod -aG sudo ansible-admin",
      "echo 'ansible-admin ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible-admin",
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"  # Replace with the appropriate user for your AMI (e.g., "ec2-user" for Amazon Linux)
      private_key = var.private_key  # Replace with the path to your actual private key file
      host        = aws_instance.Kubernetes_Master.public_ip  # Use the public_ip attribute of the EC2 instance
    }
  }

  provisioner "file" {
    source      = "/home/devopsadmin/.ssh/id_rsa.pub"  # Update this path to your actual public key file path on the Ansible Controller
    destination = "/tmp/id_rsa.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ansible-admin/.ssh",
      "sudo mv /tmp/id_rsa.pub /home/ansible-admin/.ssh/authorized_keys",
      "sudo chown -R ansible-admin:ansible-admin /home/ansible-admin/.ssh",
      "sudo chmod 700 /home/ansible-admin/.ssh",
      "sudo chmod 600 /home/ansible-admin/.ssh/authorized_keys"
    ]
  }
}

# Create Instance 

resource "aws_instance" "Kubernetes_Workernode1" {
  ami           = "ami-03cb1380eec7cc118"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.Kubernetessubnet.id
  vpc_security_group_ids = [aws_security_group.Kubernetes.id]
  key_name = "Staragile"

  tags = {
    Name = "Kubernetes_Workernode1"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo adduser ansible-admin --disabled-password --gecos ''",
      "sudo usermod -aG sudo ansible-admin",
      "echo 'ansible-admin ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible-admin",
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"  # Replace with the appropriate user for your AMI (e.g., "ec2-user" for Amazon Linux)
      private_key = var.private_key  # Replace with the path to your actual private key file
      host        = aws_instance.Kubernetes_Master.public_ip  # Use the public_ip attribute of the EC2 instance
    }
  }

  provisioner "file" {
    source      = "/home/devopsadmin/.ssh/id_rsa.pub"  # Update this path to your actual public key file path on the Ansible Controller
    destination = "/tmp/id_rsa.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ansible-admin/.ssh",
      "sudo mv /tmp/id_rsa.pub /home/ansible-admin/.ssh/authorized_keys",
      "sudo chown -R ansible-admin:ansible-admin /home/ansible-admin/.ssh",
      "sudo chmod 700 /home/ansible-admin/.ssh",
      "sudo chmod 600 /home/ansible-admin/.ssh/authorized_keys"
    ]
  }
}


# Create Instance

resource "aws_instance" "Kubernetes_Workernode2" {
  ami           = "ami-03cb1380eec7cc118"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.Kubernetessubnet.id
  vpc_security_group_ids = [aws_security_group.Kubernetes.id]
  key_name = "Staragile"

  tags = {
    Name = "Kubernetes_Workernode2"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo adduser ansible-admin --disabled-password --gecos ''",
      "sudo usermod -aG sudo ansible-admin",
      "echo 'ansible-admin ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible-admin",
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"  # Replace with the appropriate user for your AMI (e.g., "ec2-user" for Amazon Linux)
      private_key = var.private_key  # Replace with the path to your actual private key file
      host        = aws_instance.Kubernetes_Master.public_ip  # Use the public_ip attribute of the EC2 instance
    }
  }

  provisioner "file" {
    source      = "/home/devopsadmin/.ssh/id_rsa.pub"  # Update this path to your actual public key file path on the Ansible Controller
    destination = "/tmp/id_rsa.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ansible-admin/.ssh",
      "sudo mv /tmp/id_rsa.pub /home/ansible-admin/.ssh/authorized_keys",
      "sudo chown -R ansible-admin:ansible-admin /home/ansible-admin/.ssh",
      "sudo chmod 700 /home/ansible-admin/.ssh",
      "sudo chmod 600 /home/ansible-admin/.ssh/authorized_keys"
    ]
  }
}