resource "aws_instance" "react_app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.react_sg.name]

  user_data = <<-EOF
    #!/bin/bash

    # Update packages
    sudo yum update -y

    # Install and enable Nginx
    sudo amazon-linux-extras enable nginx1
    sudo yum install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx

    # Install Node.js and npm
    curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
    sudo yum install -y nodejs

    # Install Git
    sudo yum install -y git

    # Clone React App from GitHub
    git clone ${var.react_app_repo_url} /home/ec2-user/react-app

    # Build React App
    cd /home/ec2-user/react-app
    npm install
    npm run build

    # Set permissions for React app folder
    sudo chmod -R 755 /home/ec2-user/react-app

    # Remove default Nginx welcome page
    sudo rm -rf /usr/share/nginx/html/*

    # Copy React build files (dist) to Nginx
    sudo cp -r /home/ec2-user/react-app/dist/* /usr/share/nginx/html/

    # Set permissions for Nginx HTML directory
    sudo chmod -R 755 /usr/share/nginx/html
    sudo chown -R nginx:nginx /usr/share/nginx/html

    # Configure Nginx for React app
    cat << 'EOCONF' | sudo tee /etc/nginx/conf.d/react_app.conf
    server {
        listen 80;
        server_name public_ip;

        root /usr/share/nginx/html;
        index index.html;

        location / {
            try_files $uri /index.html;
        }

        location = /favicon.ico {
            log_not_found off;
            access_log off;
        }
    }
    EOCONF

    # Restart Nginx to apply the configuration
    sudo systemctl restart nginx

    # Log completion
    echo "User data script completed at $(date)" | sudo tee -a /var/log/user_data.log
  EOF

  tags = {
    Name = "ReactAppServer"
  }
}

resource "aws_security_group" "react_sg" {
  name        = "react_app_sg"
  description = "Security group for React app server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ReactAppSG"
  }
}
