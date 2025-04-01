terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.93.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.1"
    }
  }

  required_version = "~> 1.9.0"
}

provider "aws" {
  region = var.region
}

resource "random_pet" "cluster_name" {
  count = var.cluster_sum

  prefix = "cluster"
}

module "cluster" {
  count  = var.cluster_sum
  source = "./modules/ec2-cluster"

  cluster_name = random_pet.cluster_name[count.index].id

  master_instance_type = var.master_instance_type
  worker_instance_type = var.worker_instance_type
  num_workers          = var.num_workers

  master_storage_size = var.master_storage_size
  worker_storage_size = var.worker_storage_size

  cidr_block = var.cidr_block

  allowed_k8s_cidr_blocks = var.allowed_k8s_cidr_blocks
  allowed_ssh_cidr_blocks = var.allowed_ssh_cidr_blocks
  pod_network_cidr_block  = var.pod_network_cidr_block

  tags = { "terraform-kubeadm:cluster" = random_pet.cluster_name[count.index].id }
}
