locals {

#   buckets_to_lock = {
#     alb_bucket = aws_s3_bucket.alb_ecs_bucket.id,
#   }
  alb_bucket = "${var.project_name}-${local.account_id_last4}-alb_access_logs"
  account_id = var.aws_account_id != "" ? var.aws_account_id : data.aws_caller_identity.current.account_id
  account_id_last4 = substr(var.aws_account_id, -4, 4)

}

locals {

  # ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
  # VPC (for EKS / RDS Clusters)
  # ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------

  vpc_suffix = "ecs"


  tags = []
}