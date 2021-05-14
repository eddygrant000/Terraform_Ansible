
resource "aws_instance" "appserver" {
  ami                         = "ami-0cda377a1b884a1bc"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.ct-subnet-public.id
  vpc_security_group_ids      = [aws_security_group.app-group.id]
  key_name                    = aws_key_pair.ct-keypair.id
  associate_public_ip_address = true

  provisioner "local-exec" {
    command = "echo remote_address: ${aws_instance.appserver.private_ip} > ./vars.yml"
  }

  tags = {
    "Name" = "AppServer"
  }
}


resource "aws_instance" "webserver" {
  ami                         = "ami-0cda377a1b884a1bc"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.ct-subnet-public.id
  vpc_security_group_ids      = [aws_security_group.ct-group.id]
  key_name                    = aws_key_pair.ct-keypair.id
  associate_public_ip_address = true
  tags = {
    "Name" = "WebServer"
  }
  }

# resource "aws_db_instance" "db2" {
#   identifier             = "db2"
#   instance_class         = "db.t2.micro"
#   allocated_storage      = 10
#   engine                 = "mysql"
#   name                   = "appdb"
#   password               = var.db_password
#   username               = var.db_username
#   engine_version         = "8.0.23"
#   skip_final_snapshot    = true
#   db_subnet_group_name   = aws_db_subnet_group.default.name
#   multi_az               = false
#   vpc_security_group_ids = [aws_security_group.ct-db.id]
#   tags = {
#     "Name" = "TomcatDB"
#   }
# }