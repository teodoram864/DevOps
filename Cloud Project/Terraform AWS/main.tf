#VARIABLES
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "private_key_path" {}

variable "key_name" {}

variable "region" {
    default = "us-east-2"
}

#PROVIDERS
provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.region
}

#DATA
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

# RESOURCES

# Default VPC, it won't delete on destroy

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "allow_ssh_http_80" {
    name = "allow_ssh_http_t"
    description = "Allow ssh on 22 & http on port 80"
    vpc_id = aws_default_vpc.default.id
 
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

 
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "nginx-t" {
    ami = data.aws_ami.aws_linux.id
    instance_type = "t2.micro"
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.allow_ssh_http_80.id]
    subnet_id = tolist(data.aws_subnets.default.ids)[0] 
    
    connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(var.private_key_path)
    }

    provisioner "remote-exec" {
        inline = [
            "sudo amazon-linux-extras install nginx1 -y", # Install nginx via Amazon Linux Extras
            "sudo systemctl start nginx.service" # Start nginx service
        ]
    }
}


# OUTPUT
output "aws_instance_public_dns" {
    value = aws_instance.nginx-t.public_dns
}

