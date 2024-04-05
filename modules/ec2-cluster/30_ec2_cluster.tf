data "aws_ami" "ubuntu" {
  owners      = ["013907871322"]
  most_recent = true

  filter {
    name   = "name"
    values = ["suse-sles-15-*-hvm-ssd-x86_64"]
  }
}

#------------------------------------------------------------------------------#
# Master node configuration
#------------------------------------------------------------------------------#

resource "aws_instance" "master" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = var.master_instance_type
  subnet_id     = aws_subnet.this.id
  key_name      = aws_key_pair.this.key_name

  root_block_device {
    volume_size = var.master_storage_size
    volume_type = "gp3"
  }

  vpc_security_group_ids = [
    aws_security_group.egress.id,
    aws_security_group.ingress_internal.id,
    aws_security_group.ingress_ssh.id,
    aws_security_group.ingress_https.id,
  ]

  # Saved in: /var/lib/cloud/instances/<instance-id>/user-data.txt
  # Logs in:  /var/log/cloud-init-output.log
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-shell-scripts
  user_data = templatefile(
    "./assets/config/user-data.sh.tftpl",
    {
      node             = "master",
      cidr             = var.pod_network_cidr_block
      master_public_ip = aws_eip.master.public_ip,
      worker_index     = null,
      token            = local.token
    }
  )

  tags = merge(local.tags, { "tf-rke2:node" = "master" })
}

resource "aws_eip" "master" {
  domain = "vpc"
  tags   = merge(local.tags, { "tf-rke2:node" = "master" })
}

resource "aws_eip_association" "master" {
  allocation_id = aws_eip.master.id
  instance_id   = aws_instance.master.id
}

#------------------------------------------------------------------------------#
# Worker node configuration
#------------------------------------------------------------------------------#

resource "aws_instance" "workers" {
  count = var.num_workers

  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = var.worker_instance_type
  subnet_id                   = aws_subnet.this.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.this.key_name

  root_block_device {
    volume_size = var.worker_storage_size
    volume_type = "gp3"
  }

  vpc_security_group_ids = [
    aws_security_group.egress.id,
    aws_security_group.ingress_internal.id,
    aws_security_group.ingress_ssh.id
  ]

  user_data = templatefile(
    "./assets/config/user-data.sh.tftpl",
    {
      node             = "worker",
      cidr             = null,
      master_public_ip = aws_eip.master.public_ip,
      worker_index     = count.index,
      token            = local.token
    }
  )

  tags = merge(local.tags, { "tf-rke2:node" = "worker-${count.index}" })
}
