provider "aws" {
    region = "us-east-2"
}

resource "aws_s3_bucket" "dsa_bucket_flask" {
  bucket = "arthur-926799968519-bucket"

  tags = {
      Name = "DSA Bucket"
      Environment = "Lab4"
  }

    provisioner "local-exec" {
      command = "${path.module}/upload_to_s3.sh"
    }

    provisioner "local-exec" {
      when = destroy
      command = "aws s3 rm s3://arthur-926799968519-bucket --recursive"
    }
}

resource "aws_instance" "ml_api" {

  ami = "ami-0a0d9cf81c479446a"

  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name

  vpc_security_group_ids = [aws_security_group.ml_api_sg.id]
}

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y python3 python3-pip awscli
                sudo pip3 install flask joblib scikit-learn numpy scipy gunicorn
                sudo mkdir /dsa_ml_app
                sudo aws s3 sync s3://arthur-926799968519-bucket /ml_app
                cd /ml_app
                nohup gunicorn -w 4 -b 0.0.0.0:5000 app:app &
              EOF

  tags = {
    Name = "DSAFlaskApp"
  }