# Add a vpc
resource "aws_vpc" "devtest_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "devtest"
  }
}

# Add a public subnet into the vpc
resource "aws_subnet" "devtest_public_subnet" {
  vpc_id                  = aws_vpc.devtest_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1d"

  tags = {
    Name = "devtest-public"
  }
}

# Add an internet gateway for the vpc
resource "aws_internet_gateway" "devtest_internet_gateway" {
  vpc_id = aws_vpc.devtest_vpc.id

  tags = {
    Name = "devtest-igw"
  }
}

# Add a public route table to the vpc
resource "aws_route_table" "devtest_public_rt" {
  vpc_id = aws_vpc.devtest_vpc.id

  tags = {
    Name = "devtest_public_rt"
  }
}

# Add a route to the above route table
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.devtest_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.devtest_internet_gateway.id

}

# Add a route_table_association to bridge gap between the subnet and the route table
resource "aws_route_table_association" "devtest_public_assoc" {
  subnet_id      = aws_subnet.devtest_public_subnet.id
  route_table_id = aws_route_table.devtest_public_rt.id
}

# Add security group to the VPC with ingress/egress rules
resource "aws_security_group" "devtest_sg" {
  name        = "devtest_sg"
  description = "devtest security group"
  vpc_id      = aws_vpc.devtest_vpc.id

  #only allow dev machine IP in (go to whatismyipaddress to determine)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["163.116.144.44/32"] 
  }

  #allow all traffic out
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }

}

# Generate an aws keypair
# *** Run these steps before below "aws_key_pair" resource can be added ***
#
# - 1) Run terminal command to generate on windows: 
#      > ssh-keygen -t ed25519
# - 2) When prompted for file path to save key enter path name like so:
#      > C:\Users\[firstname.lastname]/.ssh/devtestkey
# - 3) Passphrase can be left blank
# - 4) Run to confirm key exists:
#      > ls ~/.ssh
resource "aws_key_pair" "devtest_auth" {
  key_name = "devtestkey"
  public_key = file("~/.ssh/devtestkey.pub")
}

#===
#Finally... Spin up the EC2 Instance with the key pair created above
resource "aws_instance" "devtest_node" {
  instance_type = "t2.micro"
  ami = data.aws_ami.devtest_server_ami.id
  key_name = aws_key_pair.devtest_auth.key_name
  vpc_security_group_ids = [aws_security_group.devtest_sg.id]
  subnet_id = aws_subnet.devtest_public_subnet.id
  
  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "devtest-node"
  }
}
