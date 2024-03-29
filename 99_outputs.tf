output "bucket_name" {
  description = "Public S3 bucket name."
  value       = aws_s3_bucket.this.id
}
