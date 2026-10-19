# Secure Serverless Portfolio on AWS

A personal portfolio site with a live visitor counter, built on AWS with modular Terraform and deployed
only through a GitHub Actions pipeline. Based on the Cloud Resume Challenge, extended with a security layer.

> Built and deployed a serverless application on AWS using modular Terraform, with a GitHub Actions
> pipeline using OIDC, automated IaC security scanning, encryption with customer-managed KMS keys, WAF,
> and continuous compliance monitoring with Security Hub and Config.

## Architecture

```
Browser ──HTTPS──> AWS WAF ──> CloudFront ──OAC (SigV4)──> S3 (private, SSE-KMS)
   │
   └──POST /count──> API Gateway (HTTP API, CORS, throttling) ──> Lambda ──> DynamoDB (SSE-KMS)

AWS Config + Security Hub CSPM continuously check all of the above.
GitHub Actions deploys everything with Terraform, using OIDC (no stored AWS keys).
```

- Region: `us-east-2` for everything, except the WAF web ACL (CloudFront requires `us-east-1`).
- State: S3 bucket encrypted with a customer-managed KMS key, S3-native locking.

## Repository layout

```
bootstrap/              One-time setup, local state: state bucket + KMS key, budget, GitHub OIDC roles
infra/                  Root module (remote state): wires the modules together
modules/static-site/    Phase 2: S3 + CloudFront + OAC + KMS
modules/counter-api/    Phase 3: API Gateway + Lambda + DynamoDB + KMS
modules/waf/            Phase 4: WAF web ACL for CloudFront (us-east-1)
modules/compliance/     Phase 5: AWS Config + Security Hub CSPM
lambda/counter.py       Visitor counter function
website/                index.html, style.css, app.js (config.js is generated)
.github/workflows/      plan.yml (PRs), apply.yml (merge to main), destroy.yml (manual)
```

## Build phases

- [ ] **Phase 0:** local tools and the `raadmin` CLI profile
- [ ] **Phase 1:** bootstrap + pipeline (state, budget, OIDC roles, GitHub settings)
- [ ] **Phase 2:** static site module
- [ ] **Phase 3:** visitor counter API module
- [ ] **Phase 4:** WAF module
- [ ] **Phase 5:** compliance module (Config + Security Hub)
- [ ] **Phase 6:** make the security scan a hard gate
- [ ] **Phase 7:** verify, document, tear down

## Quick start (Phase 1)

```bash
export AWS_PROFILE=raadmin

# 1. Bootstrap (run once, from your laptop)
cd bootstrap
cp terraform.tfvars.example terraform.tfvars   # fill in your email and owner/repo
terraform init
terraform apply
terraform output github_actions_variables     # copy these into GitHub repo variables

# 2. Connect infra/ to the remote state
cd ../infra
cp backend.hcl.example backend.hcl             # fill in bucket and kms_key_id
terraform init -backend-config=backend.hcl
terraform plan                                 # "No changes" in Phase 1
```

Then configure GitHub (repository variables, a `production` environment with required reviewers,
and a ruleset on `main`), and from here on every change goes through a pull request.

## Security controls

| Control | Where |
| --- | --- |
| No long-lived AWS keys in CI (OIDC, two scoped roles) | `bootstrap/github-oidc.tf` |
| Manual approval before any apply | GitHub `production` environment |
| Customer-managed KMS keys with rotation | state, site bucket, DynamoDB, CloudWatch Logs |
| Private S3, CloudFront Origin Access Control, TLS-only bucket policies | `modules/static-site` |
| AWS WAF: rate limiting + AWS managed rules | `modules/waf` |
| Least-privilege Lambda role, scoped Lambda invoke permission | `modules/counter-api` |
| CORS restricted to the site, API throttling, access logs | `modules/counter-api` |
| IaC scanning on every pull request | Checkov in `plan.yml` |
| Continuous compliance | AWS Config rules + Security Hub CSPM (FSBP) |
| Cost guardrail | AWS Budgets alert in `bootstrap/budget.tf` |

## Cost

Close to $0 for the core app. WAF (about $9/month while on), Security Hub CSPM (after its 30-day
trial) and KMS keys ($1/month each) cost money. Turn features off with `enable_waf`,
`enable_compliance` and `enable_security_hub` in `infra/variables.tf`, or run the **Terraform Destroy**
workflow between study sessions.
