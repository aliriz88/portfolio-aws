# Uncomment each output in the phase that creates it.

# Phase 2
output "site_url" {
  value = module.static_site.site_url
}

output "site_bucket" {
  value = module.static_site.bucket_name
}

output "distribution_id" {
  value = module.static_site.distribution_id
}

# Phase 3
output "api_url" {
  value = module.counter_api.api_url
}

output "table_name" {
  value = module.counter_api.table_name
}
