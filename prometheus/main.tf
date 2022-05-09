resource "aws_instance" "grafana-prometheus" {
  ami           = "ami-11111111"
  instance_type = "t2.small"
  security_groups = [aws_security_group.grafana-prometheus.id]
  iam_instance_profile = var.iam_instance_profile
  #key_name = ""
  user_data = "${file("instalador.sh")}" #Using external doc to install prometheus
  vpc_security_group_ids = [aws_security_group.grafana-prometheus.id]
  subnet_id = var.subnet_id

  tags = {
    Name = "grafana-prometheus"
  }
}

resource "aws_network_interface" "ec2" {
  subnet_id = var.subnet_id
}

#Security Group
resource "aws_security_group" "grafana-prometheus" {
  name        = "sg_grafana-prometheus"
  description = "sg_grafana-prometheus"
  vpc_id      = var.vpc_id
 
  tags = {
    "Name" = "sg_grafana-prometheus"
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
