terraform {
  backend "consul" {
    address = "consul.service.consul"
    scheme  = "https"
    path    = "terraform/observability"
  }
  required_providers {
    grafana = {
      source = "grafana/grafana"
    }
  }
}

provider "grafana" {
  url = "https://grafana.service.consul"
}

resource "grafana_folder" "hashistack" {
  title = "HashiStack"
}

resource "grafana_dashboard" "hashistack" {
  for_each = toset(["nomad", "consul"])

  folder      = grafana_folder.hashistack.id
  config_json = file("${path.module}/dashboards/HashiStack/${each.key}.json")
}
