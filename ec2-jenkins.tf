data "aws_key_pair" "MyKeyPair" {
  # import the keypair from AWS
  key_name           = "MyKeyPair"
  include_public_key = true
}

resource "aws_instance" "jenkins-controller" {
  ami           = var.AMI
  instance_type = var.instance_type
  subnet_id     = aws_subnet.PublicSubnet.id

  # User data to update packages, install JDK and Jenkins
  user_data = <<-EOF
            #!/bin/bash
            sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
            echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

            # Update packages
            sudo apt-get update

            # Install Jenkins
            sudo apt-get install jenkins -y

            # Start jenkins service
            sudo systemctl start jenkins
            sudo systemctl enable jenkins

            sudo apt update
            sudo apt install fontconfig openjdk-17-jre -y
            java -version
            openjdk version "17.0.13" 2024-10-15
            OpenJDK Runtime Environment (build 17.0.13+11-Debian-2)
            OpenJDK 64-Bit Server VM (build 17.0.13+11-Debian-2, mixed mode, sharing)
            EOF
  
  # leveraging the depends_on argument to created the after the below has been created
  depends_on = [
    aws_security_group.jenkins-sg,
    aws_vpc.MyVPC2,
    aws_subnet.PublicSubnet
  ]
  security_groups   = [aws_security_group.jenkins-sg.id]
  key_name          = data.aws_key_pair.MyKeyPair.key_name
  availability_zone = var.az

  # Added this meta-arg as part of testing through multiple terraform applies. Can be omitted
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Jenkins-Controller"
  }

}

# Output the public IP of the Jenkins controller
output "public_ip" {
  value = aws_instance.jenkins-controller.public_ip
}