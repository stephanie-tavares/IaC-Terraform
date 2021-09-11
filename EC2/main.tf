resource "aws_instance" "ec2" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  subnet_id = "subnet-<ID>"
  security_groups = [ aws_security_group.ec2-rules.id]
  user_data = file("${path.module}/instalador.sh") #Pra já subir a EC2 com alguns programas instalados, arquivo externo.

  tags = {
	Name = "Teste-EC2"
	}
}

#Create VPC
resource "aws_vpc" "terraform-vpc" {
  cidr_block = "1.1.1.1/1"
  enable_dns_hostnames = true 
  
  tags = {
    Name = "VPC"
  }
}

output "aws_vpc_id" {
  value = "${aws_vpc.terraform-vpc.id}"
  
}

#Security Group
resource "aws_security_group" "ec2-rules" {
  name        = "regras-de-acesso-Entrada"
  description = "regras-de-acesso-Entrada"
  vpc_id      = var.vpc_id


  ingress = [ 
        {
        description = "Acesso-SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false
        }
     ]

  egress = [ 
        {
        description = "Allow-Access"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false
        }
     ]
}
