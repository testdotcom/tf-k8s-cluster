variable "region" {
  type        = string
  description = "AWS region in which to create the clusters."
  default     = "eu-central-1"
}

variable "bucket_prefix" {
  type        = string
  description = "Name of the bucket storing lab resources."
  default     = "lab-rke2-"
}

variable "cluster_sum" {
  type        = number
  description = "Total number of clusters to provision."
  default     = 1
}

variable "master_instance_type" {
  type        = string
  description = "EC2 instance type for the master node (must have at least 2 CPUs and 2 GB RAM)."
  default     = "t3a.medium"
}

variable "worker_instance_type" {
  type        = string
  description = "EC2 instance type for the worker nodes."
  default     = "t3a.micro"
}

variable "num_workers" {
  type        = number
  description = "Number of worker nodes."
  default     = 2
}

variable "master_storage_size" {
  type        = number
  description = "Storage size for the master's Root Block Device, in gibibytes (GiB)"
  default     = 20
}

variable "worker_storage_size" {
  type        = number
  description = "Storage size for the worker's Root Block Device, in gibibytes (GiB)"
  default     = 20
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC and subnet. This value will determine the private IP addresses of the Kubernetes cluster nodes."
  default     = "10.0.0.0/16"
}

variable "allowed_ssh_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which it is allowed to make SSH connections to the EC2 instances that form the cluster nodes. By default, SSH connections are allowed from everywhere."
  default     = ["0.0.0.0/0"]
}

variable "allowed_k8s_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which it is allowed to make Kubernetes API request to the API server of the cluster. By default, Kubernetes API requests are allowed from everywhere. Note that Kubernetes API requests from Pods and nodes inside the cluster are always allowed, regardless of the value of this variable."
  default     = ["0.0.0.0/0"]
}

variable "pod_network_cidr_block" {
  type        = string
  description = "CIDR block for the Pod network of the cluster. If set, Kubernetes automatically allocates Pod subnet IP address ranges to the nodes (i.e. sets the \".spec.podCIDR\" field of the node objects). Defaults to Flannel network CIDR."
  default     = "10.244.0.0/16"
}

variable "rke2_version" {
  type = string
  description = "Pin the RKE2 version."
}
