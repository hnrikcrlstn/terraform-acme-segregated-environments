terraform { 
  cloud { 
    
    organization = "Terraform-ACME-case" 

    workspaces { 
      name = "terraform-acme-dev" 
    } 
  } 
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

module "ec2-instance" {
  source            = "./modules/ec2"
  ec2_instance_name = "acme-demo-${random_id.suffix.hex}-ec2"
  ec2_instance_type = var.default_ec2_instance_type
}

module "bucket" {
  source      = "./modules/bucket"
  bucket_name = "acme-demo-${random_id.suffix.hex}-bucket"
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "gcloud-db" {
  source = "./modules/gcloud-db"
  project = var.google_project_id
}