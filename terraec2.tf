provider "aws" {
  region = "us-east-2"
}
resource "aws_instance" "myec2" {
  depends_on = [aws_db_instance.default]
  ami           = "ami-0629230e074c580f2"
  instance_type = "t2.micro"
  subnet_id   = "subnet-0080182dff1d4159a"
  key_name = "jenkins"
  user_data = templatefile("${path.module}/userdata.tftpl", {endpoint = aws_db_instance.default.endpoint,password = aws_db_instance.default.password})
  iam_instance_profile = "ram-s3-role"
  security_groups = ["sg-0bb5391635b3c304es"]
  tags = {
    Name = "Ec2tf"
  }
}
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "cpms"
  identifier           = "mydb"
  username             = "admin"
  password             = "Nareshkumar"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true
  security_group_names = ["sg-0bb5391635b3c304es"]
}
