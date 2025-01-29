resource "aws_db_instance" "malutapisuhu_db" {
  allocated_storage    = 5
  engine               = "postgres"
  engine_version       = "17.2"
  instance_class       = var.malutapisuhu_database_configs.instance_type
  identifier           = var.malutapisuhu_database_configs.name
  storage_type         = "standard"
  db_name              = var.malutapisuhu_databases
  username             = "postgres"
  password             = random_string.malutapisuhu_db_pass.result
  parameter_group_name = aws_db_parameter_group.malutapisuhu_db_parameter_group.name
  skip_final_snapshot  = true

  storage_encrypted   = false
  deletion_protection = false

  vpc_security_group_ids = [aws_security_group.projectsprint_db.id]
  db_subnet_group_name   = aws_db_subnet_group.projectsprint_db.name


  tags = {
    project     = "projectsprint"
    environment = "development"
    team_name   = "malutapisuhu"
  }
}

resource "aws_db_parameter_group" "malutapisuhu_db_parameter_group" {
  name        = "malutapisuhu-db-parameter-group"
  family      = "postgres17"
  description = "Custom parameter group for malutapisuhu database"

  parameter {
    name  = "huge_pages"
    value = "10475"
  }

  parameter {
    name  = "work_mem"
    value = "8MB"
  }

  parameter {
    name  = "maintenance_work_mem"
    value = "128MB"
  }

  tags = {
    project     = "projectsprint"
    environment = "development"
    team_name   = "malutapisuhu"
  }
}

resource "aws_db_subnet_group" "malutapisuhu_db_subnet" {
  name       = "malutapisuhu-db-subnet"
  subnet_ids = [aws_subnet.private_b.id, aws_subnet.private_a.id]
  tags = {
    project = "projectsprint",
    Name    = "malutapisuhu-db"
  }
}

resource "random_string" "malutapisuhu_db_pass" {
  length  = 32
  special = false
  upper   = true
  lower   = true
  numeric = true
}
