# Module: counter-api (Phase 3)

Visitor counter: API Gateway HTTP API -> Lambda -> DynamoDB, with a customer-managed KMS key.

Build in this module:

- [ ] KMS key (rotation on) whose key policy also lets CloudWatch Logs use it
- [ ] DynamoDB table, on-demand, SSE with the KMS key, point-in-time recovery
- [ ] Lambda function (Python 3.13) and a least-privilege role: one DynamoDB action, KMS via DynamoDB only, its own logs
- [ ] KMS-encrypted log groups for Lambda and API access logs, 14-day retention
- [ ] HTTP API with `POST /count`, CORS limited to the site origin, stage throttling, access logging
- [ ] Lambda permission scoped to this API's route

Inputs: `project`, `allowed_origin`, `lambda_source_file`, `throttle_rate_limit`, `throttle_burst_limit`, `log_retention_days`
Outputs: `api_url`, `api_id`, `table_name`, `function_name`, `kms_key_arn`

The full code is in the build guide, Phase 3.
