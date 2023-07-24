variable "cloudflare_token" {
  sensitive = true
  description = "Your Cloudflare API token"
}
resource "kubernetes_secret" "cloudflare_api_token_secret" {
  metadata {
    namespace = "cert-manager"
    name = "cloudflare-api-token-secret"
  }
  type = "Opaque"
  data = {
    "api-token" = var.cloudflare_token
  }
}

variable "cloudflare_email" {
  description = "Your Cloudflare Email Address"
}