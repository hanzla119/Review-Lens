resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "reviewlens-vpc"
        Environment = "production"

    }
}
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "reviewlens-public-subnet"
        Environment = "production"
    }
}
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"   
    tags = {    
        Name = "reviewlens-private-subnet"
        Environment = "production"
    } 
}
resource "aws_internet_gateway" "gw"{
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "reviewlens-igw"
        Environment = "production"  
} 
 }

 resource "aws_route_table" "public"{
    vpc_id = aws_vpc.main.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id

    }
    tags = {
        Name = "reviewlens-public-rt"
    
 }
 }
 resource "aws_route_table_association" "public_assoc" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}