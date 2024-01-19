resource "aws_db_instance" "finance-cluster" {
    engine = "mysql"
    engine_version = "8.0.35"
    instance_class = "db.t2.micro"
    manage_master_user_password = true
    skip_final_snapshot = true
    allocated_storage = "20"
    username = "admin"
}

