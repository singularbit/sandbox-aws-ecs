# output "cdn_oai_iam_arn" {
#   value = aws_cloudfront_origin_access_identity.cdn_oai.iam_arn
# }
output "cdn_id" {
  value = aws_cloudfront_distribution.cloudfront_distribution.id
}
output "cdn_arn" {
  value = aws_cloudfront_distribution.cloudfront_distribution.arn
}