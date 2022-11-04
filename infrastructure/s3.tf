/******************************
S3 bucket with encryption and public access block configurations 
******************************/

# The S3 bucket
# resource "aws_s3_bucket" "demo_bucket" {
#   bucket_prefix = "${var.aws_region}-${var.environment}-demo-bucket"
# }

# # Let's make the bucket private
# resource "aws_s3_bucket_acl" "demo_bucket_acl" {
#   bucket = aws_s3_bucket.demo_bucket.id
#   acl    = "private"
# }

/******************************
More configurations in the actual file, please check the Github repo.
******************************/
