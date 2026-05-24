data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}
resource "aws_instance" "mongodb" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t3.micro" 
    subnet_id = aws_subnet.private.id 
    vpc_security_group_ids = [aws_security_group.database.id]
     user_data = <<-EOF
              #!/bin/bash
              # Update packages and install Docker
              dnf update -y
              dnf install -y docker
              systemctl enable --now docker
              # Launch MongoDB as a Docker container inside the server
              # Binds MongoDB database storage to /data/db inside the instance
              docker run -d \
                --name mongodb \
                --restart always \
                -p 27017:27017 \
                -v /data/db:/data/db \
                mongo:7.0
              EOF
  tags = {
    Name        = "reviewlens-mongodb-server"
    Environment = "Production"
  }
}

resource "aws_ebs_volume" "mongo_data" {
availability_zone = "us-east-1b" 
  size              = 10 
  type              = "gp3" 
  tags = {
    Name = "reviewlens-mongodb-storage"
  }
}

resource "aws_volume_attachment" "mongo_attach" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.mongo_data.id
  instance_id = aws_instance.mongodb.id
}
    
