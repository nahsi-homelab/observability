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

resource "grafana_folder" "observability" {
  title = "Observability"
}

resource "grafana_folder" "infra" {
  title = "Infra"
}

resource "grafana_dashboard" "hashistack" {
  for_each = fileset("${path.module}/dashboards/HashiStack", "*.json")

  folder      = grafana_folder.hashistack.id
  overwrite   = true
  config_json = file("${path.module}/dashboards/HashiStack/${each.key}")
}

resource "grafana_dashboard" "general" {
  for_each = fileset("${path.module}/dashboards", "*.json")

  overwrite   = true
  config_json = file("${path.module}/dashboards/${each.key}")
}

resource "grafana_dashboard" "observability" {
  for_each = fileset("${path.module}/dashboards/Observability", "*.json")

  folder      = grafana_folder.observability.id
  overwrite   = true
  config_json = file("${path.module}/dashboards/Observability/${each.key}")
}

resource "grafana_dashboard" "infra" {
  for_each = fileset("${path.module}/dashboards/Infra", "*.json")

  folder      = grafana_folder.infra.id
  overwrite   = true
  config_json = file("${path.module}/dashboards/Infra/${each.key}")
}
