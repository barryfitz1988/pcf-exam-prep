
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "allow ssh and https access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "${var.username}-jenkins-pcfdev"
  }
}

data "aws_ami" "jenkins_ami" {
  filter {
    name = "name"
    values = ["jenkins-continuous-delivery-lab"]
  }
  owners = ["347546166198"]
}

resource "aws_instance" "jenkins" {
  ami = "${data.aws_ami.jenkins_ami.id}"
  instance_type = "t2.large"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.jenkins_sg.id}"]
  key_name = "${var.key_name}"
  tags {
    Name = "${var.username}-jenkins-pcfdev"
  }
}

output "ip" {
  value = "${aws_instance.jenkins.public_ip}"
}
