terraform {
  backend "consul" {
    address = "consul.service.consul:8500"
    scheme  = "http"
    path    = "terraform/observability"
  }
}

resource "consul_keys" "vmagent" {
  key {
    path  = "configs/vmagent/config.yml"
    value = file("vmagent.yml")
  }
}
