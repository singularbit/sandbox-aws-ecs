# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
# GLOBAL VARIABLES
# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
custom_tags    = {}
project_name   = "project_name"
aws_account_id = "XXXXXXXXXXXX"
aws_region     = "xx-xxxx-x"
branch_name    = "main" # Variable to distinguish between installs - Perhaps need to review this approach


# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
# VARIABLES - CLOUDFORMATION - IMPORTS
# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
cloudformation_stack_name = "project_name-tfpipeline-main" #TODO: (2024-01-12) We need to Import this value!


## ---------------------------------------------------------------------------------------------------------------------
## VARIABLES - ROUTE53
## --------------------------------------------------------------------------------------------------------------------
route53_zone_name = "subdomain.domain.tld"

# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
# VARIABLES - VPC - CIDRs - GRAFANA
# ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
vpc_cidr_4_ecs         = "10.112"
public_subnets_4_ecs   = ["11", "12", "13"]
private_subnets_4_ecs  = ["21", "22", "23"]
database_subnets_4_ecs = ["31", "32", "33"]

# # ---------------------------------------------------------------------------------------------------------------------
# # VARIABLES - STATIC WEBSITE(S)
# # ---------------------------------------------------------------------------------------------------------------------
# # The key values can be anything and must be unique. They are used to name resources.
# static_websites_variables = {
#   "site1" = {
#     static_website_route53_zone_name       = "subdomain.domain.tld"
#     static_website_subdomain               = "main" # This is the subdomain for the static website
#     static_website_repository_branch       = "main" # This is the branch of the static website repository
#     static_website_index_document          = "index.html"
#     static_website_error_document          = "error.html"
#     static_website_cdn_default_root_object = "index.html"
#
#     static_website_account_id                            = "XXXXXXXXXXXX"
#     static_website_region                                = "xx-xxxx-x"
#     static_website_repository_name                       = "user/repo"
#     static_website_pipeline_codestar_connection_name     = "codestarconnection1"
#     static_website_pipeline_codestar_connection_provider = "GitHub"
#     static_website_pipeline_build_stages                 = {
#       "build"  = "buildspecs/cicd_pipeline/buildspec_build.yaml"
#       "deploy" = "buildspecs/cicd_pipeline/buildspec_deploy.yaml"
#       "cdn"    = "buildspecs/cicd_pipeline/buildspec_cdn.yaml"
#     }
#   },
#   "site2" = {
#     static_website_route53_zone_name       = "subdomain.domain.tld"
#     static_website_subdomain               = "staging" # This is the subdomain for the static website
#     static_website_repository_branch       = "staging" # This is the branch of the static website repository
#     static_website_index_document          = "index.html"
#     static_website_error_document          = "error.html"
#     static_website_cdn_default_root_object = "index.html"
#
#     static_website_account_id                            = "XXXXXXXXXXXX"
#     static_website_region                                = "xx-xxxx-x"
#     static_website_repository_name                       = "user/repo"
#     static_website_pipeline_codestar_connection_name     = "codestarconnection2"
#     static_website_pipeline_codestar_connection_provider = "GitHub"
#     static_website_pipeline_build_stages                 = {
#       "build"  = "buildspecs/cicd_pipeline/buildspec_build.yaml"
#       "deploy" = "buildspecs/cicd_pipeline/buildspec_deploy.yaml"
#       "cdn"    = "buildspecs/cicd_pipeline/buildspec_cdn.yaml"
#     }
#   },
# }