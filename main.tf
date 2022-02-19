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

resource "grafana_dashboard" "home" {
  config_json = file("${path.module}/dashboards/home.json")
}

resource "grafana_folder" "hashistack" {
  title = "HashiStack"
}

resource "grafana_dashboard" "hashistack" {
  for_each = toset(["nomad", "consul"])

  folder      = grafana_folder.hashistack.id
  config_json = file("${path.module}/dashboards/HashiStack/${each.key}.json")
}

resource "grafana_dashboard" "zfs" {
  config_json = file("${path.module}/dashboards/zfs.json")
}

resource "grafana_dashboard" "system" {
  config_json = file("${path.module}/dashboards/system.json")
}
