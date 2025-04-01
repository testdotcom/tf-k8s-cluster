resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "this" {
  key_name_prefix = "${var.cluster_name}-"
  public_key      = local.public_key
  tags            = local.tags
}
