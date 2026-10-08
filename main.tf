resource "aws_key_pair" "my_key" {
  key_name   = "khan"
  public_key = file("khan.pub")
}

resource "aws_default_vpc" "default" {

}


resource "aws_security_group" "my_sg" {
  name = "aws_fsa"
  vpc_id = aws_default_vpc.default.id #interpoation
  

  ingress{
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"
  }

  ingress{
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS open"
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "mysecurity"
  }
}

resource "aws_instance" "testinstance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_sg.name]
  tags = {
    Name = "Automate"
  }
  root_block_device {
    volume_size = 30 
    volume_type = "gp3"
  }
}