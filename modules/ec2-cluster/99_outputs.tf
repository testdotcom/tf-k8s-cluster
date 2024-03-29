output "cluster_info" {
  description = "Cluster name, public IP of master node."
  value = {
    name : var.cluster_name,
    ip : aws_eip.master.public_ip
  }
}

output "ssh_private_key" {
  description = "SSH private key of master node."
  value       = tls_private_key.ssh.private_key_pem
}
