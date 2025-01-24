resource "aws_security_group" "jenkins-sg" {
  name   = "jenkins-sg"
  vpc_id = aws_vpc.MyVPC2.id
  tags = {
    Name = "jenkins-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.jenkins-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22      # for ssh
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_8080" {
  security_group_id = aws_security_group.jenkins-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080    # Jenkins default port
  to_port           = 8080
  ip_protocol       = "tcp"
}