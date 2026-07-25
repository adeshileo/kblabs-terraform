provider "aws" {
  region     = "us-east-1"
}

data "aws_availability_zones" "available" {}

resource "aws_launch_configuration" "my-first-asg" {

  count           = 3
  image_id           = "ami-06067086cf86c58e6"
  instance_type = "t3.micro"
  security_groups  = [ aws_security_group.instance.id ]

 user_data = <<-EOF
              #!/bin/bash
              cd /home/ec2-user
              echo "Hello, world" > index.html
              nohup python3 -m http.server 8080 &
EOF

lifecycle {
  create_before_destroy = true
}
  # user_data_replace_on_change = true


  # tags = {
  #   Name = "my_first_ec2"
  # }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress{
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "my-first-asg"{
  count                 = 3
  launch_configuration  = aws_launch_configuration.my-first-asg[count.index].name
  availability_zones    = data.aws_availability_zones.available.names

  min_size = 2
  max_size = 10

  tag{
    key   = "Name"
    value = "terraform-asg-my-first-asg-${count.index}"
    propagate_at_launch = true
  }
}