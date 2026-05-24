resource "aws_security_group" "frontend" {
    name = "reviewlens-frontend-sg"
    description = "Security group for frontend servers"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "reviewlens-frontend-sg"
        Environment = "production"
    }
}
resource "aws_security_group" "backend" {
    name = "reviewlens-backend-sg"
    description = "Security group for backend servers"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        security_groups = [aws_security_group.frontend.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "reviewlens-backend-sg"
        Environment = "production"
    }
}
    resource "aws_security_group" "database" {
    name = "reviewlens-database-sg"
    description = "Security group for database servers"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 27017
        to_port = 27017
        protocol = "tcp"
        security_groups = [aws_security_group.backend.id]
    }   
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "reviewlens-database-sg"
        Environment = "production"
    }
}