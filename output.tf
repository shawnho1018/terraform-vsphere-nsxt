output "edgecluster-id" {
  value = data.nsxt_edge_cluster.edge_cluster
}
output "transportzone-id" {
  value = data.nsxt_transport_zone.overlay_transport_zone
}
output "t0-id" {
  value = data.nsxt_logical_tier0_router.tier0_router
}
