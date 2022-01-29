provider "aws" {
  region = "us-east-2"
}
resource "aws_instance" "myec2" {
  depends_on = [aws_db_instance.default]
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  subnet_id   = "subnet-04bb8948"
  key_name = "terra"
  user_data = templatefile("${path.module}/userdata.tftpl", {endpoint = aws_db_instance.default.endpoint},{username = aws_db_instance.default.username},{password = aws_db_instance.default.password})
  iam_instance_profile = "demo_full_access"
  security_groups = ["sg-0244e3f85210cc582"]
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
  security_group_names = ["sg-0244e3f85210cc582"]
}
