data "nsxt_edge_cluster" "edge_cluster" {
  display_name = var.nsxt_edgecluster
}
data "nsxt_logical_tier0_router" "tier0_router" {
  display_name = var.nsxt_t0
}
data "nsxt_transport_zone" "overlay_transport_zone" {
  display_name = var.nsxt_tz_overlay
}
resource "random_uuid" "logical_port" {}
resource "random_uuid" "router" {}
resource "random_uuid" "switch" {}
resource "random_uuid" "ip_pool" {}

resource "nsxt_ip_pool" "ip_pool" {
  description = "IP Pool Prepared by Terraform"
  display_name = "pool-${random_uuid.ip_pool.result}"
  subnet {
    cidr              = var.subnet.cidr
    allocation_ranges = var.subnet.allocation_ranges
    gateway_ip        = var.subnet.gateway_ip
    dns_suffix        = var.subnet.dns_suffix
    dns_nameservers   = var.subnet.dns_nameservers
  }
}

resource "nsxt_logical_switch" "switch1" {
  admin_state       = "UP"
  description       = "Logical Switch Provisioned by Terraform"
  display_name      = "switch-${random_uuid.switch.result}"
  transport_zone_id = data.nsxt_transport_zone.overlay_transport_zone.id
  replication_mode  = "MTEP"

  # Get Subnet from IP-Pool
  ip_pool_id = nsxt_ip_pool.ip_pool.id
}

resource "nsxt_logical_tier1_router" "tier1_router" {
  description                 = "Logical Router provisioned by Terraform"
  display_name                = "router-${random_uuid.router.result}"
  failover_mode               = "NON_PREEMPTIVE"
  edge_cluster_id             = data.nsxt_edge_cluster.edge_cluster.id
  enable_router_advertisement = true
  advertise_connected_routes  = true
  advertise_static_routes     = true
  advertise_nat_routes        = true
  advertise_lb_vip_routes     = true
  advertise_lb_snat_ip_routes = false

}
resource "nsxt_logical_router_link_port_on_tier0" "link_port_T0" {
  description       = "Logical Port provisioned by Terraform"
  display_name      = "T0_port-${random_uuid.logical_port.result}"
  logical_router_id = data.nsxt_logical_tier0_router.tier0_router.id

}
resource "nsxt_logical_router_link_port_on_tier1" "link_port_T1" {
  description                   = "Logical Port provisioned by Terraform"
  display_name                  = "T1_port-${random_uuid.logical_port.result}"
  logical_router_id             = nsxt_logical_tier1_router.tier1_router.id
  linked_logical_router_port_id = nsxt_logical_router_link_port_on_tier0.link_port_T0.id

}
resource "nsxt_logical_port" "logical_port" {
  admin_state       = "UP"
  description       = "Logical Port provisioned by Terraform"
  display_name      = "segment_port-${random_uuid.logical_port.result}"
  logical_switch_id = nsxt_logical_switch.switch1.id

}
resource "nsxt_logical_router_downlink_port" "downlink_port" {
  description                   = "Logical Port provisioned by Terraform"
  display_name                  = "T1_downlink-${random_uuid.logical_port.result}"
  logical_router_id             = nsxt_logical_tier1_router.tier1_router.id
  linked_logical_switch_port_id = nsxt_logical_port.logical_port.id
  ip_address                    = format("${var.subnet.gateway_ip}/%s", split("/",var.subnet.cidr)[1])
}
