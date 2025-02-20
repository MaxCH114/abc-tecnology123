#Create security group for the face client tier
#create security group for frontend load balancer
resource "aws_security_group" "face_client_sg" {
  depends_on = [var.vpc_id]
    vpc_id = var.vpc_id
    name   = "${var.project_name}-face-client-sg"
    description = "Allow inbound traffic to ports 80 and 443 from public internet"
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow inbound traffic to port 80 from public internet"
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow inbound traffic to port 443 from public internet"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic to the internet"
    }

    tags = {
        Name = "${var.project_name} face client sg"
    }
}

#create security group for web server instances that allow inbound traffic only from face client security group
resource "aws_security_group" "web_server_sg" {
  depends_on = ["var.vpc_id", "aws_security_group.face_client_sg"]
    vpc_id = var.vpc_id
    name   = "${var.project_name}-web-server-sg"
    description = "Allow inbound traffic to ports 80 and 443 from face client security group"
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [aws_security_group.face_client_sg.id]
        description = "Allow inbound traffic to port 80 from face client security group"
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        security_groups = [aws_security_group.face_client_sg.id]
        description = "Allow inbound traffic to port 443 from face client security group"
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound "
    }

    tags = {
        Name = "${var.project_name} web server sg"
    }
}



