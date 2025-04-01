resource "random_password" "token_secret" {
  length  = 32
  special = false
  upper   = false
}

locals {
  tags       = merge(var.tags, { "tf-rke2:cluster" = var.cluster_name })
  public_key = chomp(tls_private_key.ssh.public_key_openssh)

  token = random_password.token_secret.result

  install_rke2 = file("./assets/scripts/install-rke2.sh")
  install_helm = file("./assets/scripts/install-helm.sh")
}
