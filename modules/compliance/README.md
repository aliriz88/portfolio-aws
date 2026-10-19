# Module: compliance (Phase 5)

Continuous compliance monitoring with AWS Config and Security Hub CSPM.

Build in this module:

- [ ] Private, TLS-only S3 bucket for Config snapshots, with the bucket policy Config needs
- [ ] Config service-linked role, configuration recorder (all supported + global resources), delivery channel, recorder status
- [ ] AWS managed Config rules: S3 TLS-only, DynamoDB KMS encryption, log group encryption, KMS key rotation, no root access keys
- [ ] Security Hub CSPM with the AWS Foundational Security Best Practices standard (behind `enable_security_hub`)

Inputs: `project`, `enable_security_hub`
Outputs: `config_bucket`, `config_rule_names`, `security_hub_enabled`

Cost: Config charges per configuration item recorded and per rule evaluation (cents at this size).
Security Hub CSPM has a 30-day free trial, then charges per security check.

The full code is in the build guide, Phase 5.
