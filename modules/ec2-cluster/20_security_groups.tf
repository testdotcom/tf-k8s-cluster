# The AWS provider removes the default "allow all "egress rule from all security
# groups, so it has to be defined explicitly.
resource "aws_security_group" "egress" {
  name        = "${var.cluster_name}-egress"
  description = "Allow all outgoing traffic to everywhere"
  vpc_id      = aws_vpc.this.id
  tags        = local.tags
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress_internal" {
  name        = "${var.cluster_name}-ingress-internal"
  description = "Allow all incoming traffic from nodes and Pods in the cluster"
  vpc_id      = aws_vpc.this.id
  tags        = local.tags
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    self        = true
    description = "Allow incoming traffic from cluster nodes"

  }
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = var.pod_network_cidr_block != null ? [var.pod_network_cidr_block] : null
    description = "Allow incoming traffic from the Pods of the cluster"
  }
}

resource "aws_security_group" "ingress_k8s" {
  name        = "${var.cluster_name}-ingress-k8s"
  description = "Allow incoming Kubernetes API requests (TCP/6443) from outside the cluster"
  vpc_id      = aws_vpc.this.id
  tags        = local.tags
  ingress {
    protocol    = "tcp"
    from_port   = 6443
    to_port     = 6443
    cidr_blocks = var.allowed_k8s_cidr_blocks
  }
}

resource "aws_security_group" "ingress_rke2" {
  name        = "${var.cluster_name}-ingress-k8s"
  description = "Allow incoming RKE2 API requests (TCP/9345) from outside the cluster"
  vpc_id      = aws_vpc.this.id
  tags        = local.tags
  ingress {
    protocol    = "tcp"
    from_port   = 9345
    to_port     = 9345
    cidr_blocks = var.allowed_k8s_cidr_blocks
  }
}

resource "aws_security_group" "ingress_ssh" {
  name        = "${var.cluster_name}-ingress-ssh"
  description = "Allow incoming SSH traffic (TCP/22) from outside the cluster"
  vpc_id      = aws_vpc.this.id
  tags        = local.tags
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }
}

#resource "aws_security_group" "exercises_ingress" {
#  name        = "${var.cluster_name}-exercises-ingress"
#  description = "Allow incoming TCP traffic on ports behind which services for exercises should be configured"
#  vpc_id      = aws_vpc.this.id
#  tags        = local.tags
#  ingress {
#    description = "Used by Ingress Controller scanarios"
#    protocol    = "tcp"
#    from_port   = 30800
#    to_port     = 30800
#    cidr_blocks = var.allowed_ssh_cidr_blocks
#  }
#  ingress {
#    description = "Used by NodePort scenarios"
#    protocol    = "tcp"
#    from_port   = 30007
#    to_port     = 30007
#    cidr_blocks = var.allowed_ssh_cidr_blocks
#  }
#}
