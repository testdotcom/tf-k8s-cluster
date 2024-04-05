terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.1"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
  }

  required_version = "~> 1.7.0"
}

#resource "null_resource" "post-install" {
#  depends_on = [aws_instance.master]

#  provisioner "remote-exec" {
#    connection {
#      type = "ssh"

#      host        = aws_eip.master.public_ip
#      user        = "ec2-user"
#      private_key = tls_private_key.ssh.private_key_pem
#    }

#    inline = [
#      "while [ ! -f /home/ec2-user/done ]; do sleep 2; done",

#      "zypper in -y chrony jq open-iscsi nfs-client",
#      "start iscsid.socket && enable iscsid.socket",
#    ]
#  }
#}
