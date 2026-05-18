provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA2ZA73453LXYUTNFJ"
  secret_key = "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"
}

resource "aws_instance" "my_first_ec2" {
    ami = "ami-0236922087fa98b6e"
    instance_type = "t3.micro"

    tags = {
    Name = "my_first_ec2"
  }
}