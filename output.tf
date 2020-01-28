output "edgecluster-id" {
  value = data.nsxt_edge_cluster.edge_cluster
}
output "transportzone-id" {
  value = data.nsxt_transport_zone.overlay_transport_zone
}
output "t0-id" {
  value = data.nsxt_logical_tier0_router.tier0_router
}
output "t1-name" {
  value = nsxt_logical_tier1_router.tier1_router.display_name
}
output "segment-name" {
  value = nsxt_logical_switch.switch1.display_name 
}
