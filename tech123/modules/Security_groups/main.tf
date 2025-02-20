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

#create security group for internal load balancer
#allow inbound traffic from web server security group
resource "aws_security_group" "backend_lb_sg" {
    depends_on = ["var.vpc_id", "aws_security_group.web_server_sg"]
        vpc_id = var.vpc_id
        name   = "${var.project_name}-backend-lb-sg"
        description = "Allow inbound traffic to ports 80 and 443 from web server security group"
        ingress {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            security_groups = [aws_security_group.web_server_sg.id]
            description = "Allow inbound traffic to port 80 from web server security group"
        }
    
        ingress {
            from_port   = 443
            to_port     = 443
            protocol    = "tcp"
            security_groups = [aws_security_group.web_server_sg.id]
            description = "Allow inbound traffic to port 443 from web server security group"
        }
    
        egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Allow all outbound traffic to the internet"
        }
    
        tags = {
            Name = "${var.project_name} backend lb sg"
        }
    }

    #create security group for application server instances that allow inbound traffic only from backend load balancer security group
resource "aws_security_group" "app_server_sg" {
    depends_on = ["var.vpc_id", "aws_security_group.backend_lb_sg"]
        vpc_id = var.vpc_id
        name   = "${var.project_name}-app-server-sg"
        description = "Allow inbound traffic to port 80 from backend load balancer security group"
        ingress {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            security_groups = [aws_security_group.backend_lb_sg.id]
            description = "Allow inbound traffic to port 80 from backend load balancer security group"
        }
    
        egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Allow all outbound traffic to the internet"
        }

        tags = {
            Name = "${var.project_name} app server sg"
        }
    }

    #create security group for database server instances that allow inbound traffic only from application server security group
resource "aws_security_group" "db_server_sg" {
    depends_on = ["var.vpc_id", "aws_security_group.app_server_sg"]
        vpc_id = var.vpc_id
        name   = "${var.project_name}-db-server-sg"
        description = "Allow inbound traffic to port 3306 from application server security group"
        ingress {
            from_port   = 3306
            to_port     = 3306
            protocol    = "tcp"
            security_groups = [aws_security_group.app_server_sg.id]
            description = "Allow inbound traffic to port 3306 from application server security group"
        }
    
        egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Allow all outbound traffic to the internet"
        }

        tags = {
            Name = "${var.project_name} db server sg"
        }
    }
    
    #create security group for bastion host that allow inbound traffic from my ip address
resource "aws_security_group" "bastion_sg" {
    depends_on = [var.vpc_id]
        vpc_id = var.vpc_id
        name   = "${var.project_name}-bastion-sg"
        description = "Allow inbound traffic to port 22 from my ip address"
        ingress {
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = var.my_ip
            description = "Allow inbound traffic to port 22 from my ip address"
        }
    
        egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Allow all outbound traffic to the internet"
        }

        tags = {
            Name = "${var.project_name} bastion sg"
        }
    }

 