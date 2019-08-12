# RDS Mysql DATABASE

resource "aws_db_instance" "db" {
  identifier             = "${var.identifier}"
  allocated_storage      = "${var.storage}"
  engine                 = "${var.engine}"
  engine_version         = "${lookup(var.engine_version, var.engine)}"
  instance_class         = "${var.instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.username}"
  password               = "${var.password}"
  publicly_accessible    = "true"
  vpc_security_group_ids = ["${module.db_sg.security_group_id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.db_sb.id}"
  skip_final_snapshot    = "true"
}

resource "aws_db_subnet_group" "db_sb" {
  name        = "main_subnet_group"
  description = "Group of public subnets"
  subnet_ids  = ["${module.vpc.private_subnets_id}"]
}
