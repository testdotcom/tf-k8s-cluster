# Provisioning of K8s clusters over AWS

The following Terraform script allows users to provision a K8s cluster over AWS. This can be useful if you don't want a managed K8s service, i.e. Amazon Elastic Kubernetes Service (**EKS**).

The Terraform AWS provider must be configured with the proper credentials before you can use it. Furthermore, a *public key* / *private key* pair is created to access the EC2 instances.

The Terraform script creates several resources:

- A set of clusters of `N+1` EC2 instances (`1` _master_, `N` _workers_), each one running the latest **SLES 15**
- AWS *security groups* are configured as declared in the Terraform variables, while allowing communications between each node on default K8s port (`6443`).
- An Elastic IP (**EIP**) address is associated with the *master* node, in order to be reacheable from the local machine.
- The K8s cluster is deployed through RKE2.

At the end of the Terraform script, the SSH private key is uploaded over a shared S3 bucket.

## Usage

```bash
terraform init -upgrade

terraform apply -auto-approve -var="region=<REGION>" -var="bucket_prefix=<PREFIX>"

terraform destroy -auto-approve -var="region=<REGION>" -var="bucket_prefix=lab-<N>-k8s-"
```

A JSON file describing each cluser (EIP, SSH key) will be available in a public bucket `<PREFIX>-<AUTO_GENERATED>`.

## Elastic IP address quota

All AWS accounts have a quota of **five** Elastic IP (EIP) addresses per Region. If you need more than five clusters, switch between [Terraform Workspaces](https://developer.hashicorp.com/terraform/cli/workspaces).

```bash
terraform workspace list

terraform workspace new

terraform workspace select

terraform workspace delete
```

## Using pre-commit-terraform

The pre-commit-terraform repository is a collection of git hooks for Terraform. Run the following command to format, lint, and generate docs:

```bash
docker run --rm \ 
  --volume=$(pwd):/lint:Z \ 
  --workdir=/lint \ 
  ghcr.io/antonbabenko/pre-commit-terraform:latest run -a
```

## Terraform docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
