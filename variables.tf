variable "route53_zone_name" {
  description = "Existing public Route 53 hosted zone name, for example example.com."
  type        = string
}

variable "route53_record_prefix" {
  description = "DNS record prefix inside the hosted zone. Use an empty string for the zone apex."
  type        = string
  default     = "test"
}
