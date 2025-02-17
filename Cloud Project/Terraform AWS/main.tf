provider "aws" {
  access_key = var.CloudInit.aws_access_key
  secret_key = var.CloudInit.aws_secret_key
  region     = var.CloudInit.region
}

module "aws_instance_module" {
  source            = "./modules/aws_instance"
  aws_access_key    = var.aws_access_key
  aws_secret_key    = var.aws_secret_key
  private_key_path  = var.private_key_path
  key_name          = var.key_name
  region            = var.region
}

output "instance_dns" {
  value = module.aws_instance_module.aws_instance_public_dns
}
