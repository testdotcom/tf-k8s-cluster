resource "random_password" "token_secret" {
  length  = 32
  special = false
  upper   = false
}

locals {
  tags = merge(var.tags, { "tf-rke2:cluster" = var.cluster_name })

  public_key = chomp(tls_private_key.ssh.public_key_openssh)

  token = random_password.token_secret.result
}
