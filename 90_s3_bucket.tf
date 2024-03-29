resource "aws_s3_bucket" "this" {
  bucket_prefix = var.bucket_prefix
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_access" {
  depends_on = [aws_s3_bucket_public_access_block.this]

  bucket = aws_s3_bucket.this.id

  policy = templatefile("${path.module}/assets/custom_policies/s3_public_access.json.tftpl", {
    bucket_name = aws_s3_bucket.this.bucket
  })
}

resource "aws_s3_object" "cluster_info" {
  depends_on = [module.cluster.id]

  bucket = aws_s3_bucket.this.bucket

  key          = "cluster_info.json"
  content_type = "application/json"

  content = jsonencode({
    "cluster_info" : [
      for cluster in module.cluster[*].cluster_info :
      cluster
    ]
  })
}

resource "aws_s3_object" "ssh_private_key" {
  depends_on = [module.cluster.id]
  count      = var.cluster_sum

  bucket = aws_s3_bucket.this.bucket

  key     = "${random_pet.cluster_name[count.index].id}/id_rsa.pem"
  content = module.cluster[count.index].ssh_private_key

  content_type = "text/*"
}
