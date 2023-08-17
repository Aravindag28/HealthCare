#This code block configures an AWS provider using Terraform. It specifies the AWS region as "ap-south-1" and sets the access key and secret key using variables var.aws_access_key and var.aws_secret_key, respectively. 
#This setup allows Terraform to interact with AWS services in the specified region using the provided credentials.
provider "aws" {
  region     = "ap-south-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}
# Security Groups
#This Terraform code defines an AWS security group named "Kubernetes" that permits inbound traffic on any port from any source IP and allows SSH traffic on port 22. 
#Outbound traffic is unrestricted, and the security group is tagged as "mysg8" for identification purposes.

resource "aws_security_group" "Kubernetes" {
  name        = "Kubernetes"
  description = "Allow inbound traffic"

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
#This Terraform script creates three AWS instances using the "t2.micro" instance type and a common Amazon Machine Image ("ami-03cb1380eec7cc118"). 
#Each instance is associated with the previously defined "Kubernetes" security group, utilizing the "Staragile" SSH key pair. 
#The instances are tagged respectively as "Kubernetes_Master," "Kubernetes_Workernode1," and "Kubernetes_Workernode2," paving the way for a multi-node Kubernetes setup.

resource "aws_instance" "Kubernetes_Master" {
  ami           = "ami-03cb1380eec7cc118"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.Kubernetes.id]
  key_name = "Staragile"

  tags = {
    Name = "Kubernetes_Master"
  }
  
}

# Create Instance 

resource "aws_instance" "Kubernetes_Workernode1" {
  ami           = "ami-03cb1380eec7cc118"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.Kubernetes.id]
  key_name = "Staragile"

  tags = {
    Name = "Kubernetes_Workernode1"
  }
 
}


# Create Instance

resource "aws_instance" "Kubernetes_Workernode2" {
  ami           = "ami-03cb1380eec7cc118"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.Kubernetes.id]
  key_name = "Staragile"

  tags = {
    Name = "Kubernetes_Workernode2"
  }
  
}