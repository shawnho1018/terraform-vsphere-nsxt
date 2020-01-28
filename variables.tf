variable "nsxt_tz_overlay" {
  description = "name of overlay zone"
}
variable "nsxt_edgecluster" {
  description = "name of the edge cluster for tier1 router"
}
variable "nsxt_t0" {
  description = "name of the constructed T0"
}
variable "subnet" {
  type = object({
    cidr = string
    allocation_ranges = list(string)
    gateway_ip = string
    dns_suffix = string
    dns_nameservers = list(string)
  })
}

