variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster to create. This name will be used in the names and tags of the created AWS resources and for the local kubeconfig file."
}

variable "tags" {
  type        = map(string)
  description = "A set of tags to assign to the created resources."
}

variable "master_instance_type" {
  type        = string
  description = "EC2 instance type for the master node (must have at least 2 CPUs and 2 GB RAM)."
}

variable "worker_instance_type" {
  type        = string
  description = "EC2 instance type for the worker nodes."
}

variable "num_workers" {
  type        = number
  description = "Number of worker nodes."
}

variable "master_storage_size" {
  type        = number
  description = "Storage size for the master's Root Block Device, in gibibytes (GiB)"
}

variable "worker_storage_size" {
  type        = number
  description = "Storage size for the worker's Root Block Device, in gibibytes (GiB)"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC and subnet. This value will determine the private IP addresses of the Kubernetes cluster nodes."
}

variable "allowed_ssh_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which it is allowed to make SSH connections to the EC2 instances that form the cluster nodes."
}

variable "allowed_k8s_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which it is allowed to make Kubernetes API request to the API server of the cluster. Note that Kubernetes API requests from Pods and nodes inside the cluster are always allowed, regardless of the value of this variable."
}

variable "pod_network_cidr_block" {
  type        = string
  description = "CIDR block for the Pod network of the cluster."
}
