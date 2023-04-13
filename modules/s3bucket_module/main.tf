resource "aws_s3_bucket" "default" {
  bucket = "${var.bucket}"

  tags = {
    Name        = "${var.bucket}"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
    UpdatedBy = "${var.updated_by}"
    AccessToken =  "${var.access_token}"
  }
}