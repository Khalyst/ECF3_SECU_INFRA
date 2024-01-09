resource "aws_instance" "Dev" {
  count         = var.ec2_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

   tags = {
    Name = "dev"
    Secret = data.vault_kv_secret_v2.dev.data["username"]
  }

    
}