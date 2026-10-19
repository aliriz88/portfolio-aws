# Module: waf (Phase 4)

AWS WAF web ACL for CloudFront. CloudFront-scoped web ACLs must be created in **us-east-1**,
so the root module passes this module the `aws.us_east_1` provider.

Build in this module:

- [ ] Web ACL with scope `CLOUDFRONT`, default action allow
- [ ] Rate-based rule: block an IP over N requests per 5 minutes
- [ ] AWS managed rule groups: Amazon IP reputation list, Core rule set, Known bad inputs
- [ ] CloudWatch metrics and sampled requests on every rule
- [ ] WAF logging to a CloudWatch log group named `aws-waf-logs-...`

Inputs: `project`, `rate_limit`, `log_retention_days`
Outputs: `web_acl_arn`, `web_acl_name`

Cost: about $5/month for the web ACL plus $1/month per rule, charged hourly. Turn it off with
`enable_waf = false` when you're not using it.

The full code is in the build guide, Phase 4.
