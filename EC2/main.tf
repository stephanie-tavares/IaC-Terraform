resource "aws_instance" "EC2-Stephanie" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = "t2.small"
  security_groups = [aws_security_group.ec2-rules.id]
  iam_instance_profile = var.iam_instance_profile
  key_name = ""
  user_data = "${file("instalador.sh")}" #Usando arquivo externo para execução em shell quando a máquina ficar up.
  vpc_security_group_ids = [aws_security_group.ec2-rules.id]
  subnet_id = var.subnet_id

  tags = {
    Name = "ec2-stephanie"
  }
}

output "DNS" {
  value = aws_instance.EC2-Stephanie.public_dns
}

resource "aws_network_interface" "ec2" {
  subnet_id = var.subnet_id
}

#Security Group
resource "aws_security_group" "ec2-rules" {
  name        = "sg_stephanie"
  description = "sg_stephanie"
  vpc_id      = var.vpc_id
 
  tags = {
    "Name" = "sg_stephanie"
  }

 ingress = [ 
        {
        description = "Entrada"
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

  egress {
    description = "Saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
