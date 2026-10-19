# Root module: wires the reusable modules together.
# Each block below is uncommented in its phase of the build guide.

# ---------- Phase 2: static site (S3 + CloudFront + KMS) ----------
# module "static_site" {
#   source   = "../modules/static-site"
#   project  = var.project
#   site_dir = "${path.root}/../website"
#
#   # Phase 3: add the generated config.js
#   # generated_files = {
#   #   "config.js" = "window.API_URL = \"${module.counter_api.api_url}\";"
#   # }
#
#   # Phase 4: attach the WAF web ACL
#   # web_acl_arn = var.enable_waf ? module.waf[0].web_acl_arn : null
# }

# ---------- Phase 3: visitor counter API ----------
# module "counter_api" {
#   source             = "../modules/counter-api"
#   project            = var.project
#   allowed_origin     = module.static_site.site_url
#   lambda_source_file = "${path.root}/../lambda/counter.py"
# }

# ---------- Phase 4: WAF (us-east-1, required for CloudFront) ----------
# module "waf" {
#   source    = "../modules/waf"
#   count     = var.enable_waf ? 1 : 0
#   providers = { aws = aws.us_east_1 }
#   project   = var.project
# }

# ---------- Phase 5: continuous compliance (Config + Security Hub) ----------
# module "compliance" {
#   source              = "../modules/compliance"
#   count               = var.enable_compliance ? 1 : 0
#   project             = var.project
#   enable_security_hub = var.enable_security_hub
# }
