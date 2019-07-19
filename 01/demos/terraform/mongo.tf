
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_security_group" "mongo_sg" {
  name        = "mongo_sg_pc"
  description = "allow ssh access and mongo datasource access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.username}-mongo-pcfdev"
  }
}

resource "aws_instance" "mongo" {
  ami = "ami-ee2694f8"
  instance_type = "t2.large"
  associate_public_ip_address = true
  security_groups = ["mongo_sg_pc"]
  key_name = "${var.key_name}"
  tags {
    Name = "${var.username}-mongo-pcfdev"
  }
}

output "ip" {
  value = "${aws_instance.mongo.public_ip}"
}
