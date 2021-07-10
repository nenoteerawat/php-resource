name   = "php-service"
region = "ap-southeast-1"

login_user_ec2        = "ec2-user"
key_name_ec2_frontend = "key-php-service-frontend"

db_instance_class    = "db.t2.micro"
db_allocated_storage = "5"
db_username          = "admin"
db_password          = "password"
# DBName must begin with a letter and contain only alphanumeric characters.
db_database_name = "botman"
