# NSX-T Switch

Create a subnet, consisting of a T1 router and a segment, which auto-connects to the corresponding T0. 
- Master branch contains module for terraform 0.12 and later
  ```hcl
  module "nsx-t" {
    source = "git::https://github.com/shawnho1018/terraform-nsxt/"
    nsxt_tz_overlay = "${var.nsxt_tz_overlay}"
    nsxt_edgecluster = "${var.nsxt_edgecluster}"
    nsxt_t0 = "${var.nsxt_t0}"
    subnet = "${var.subnet}"
  }
  ```
## Config options

| Variable | Description | Required | Default |
|:---:|:---:|:---:|:---:|
| `nsxt_tz_overlay` | Name of Transport Zone of the Overlay Network | yes | none
| `nsxt_edgecluster` | Edge Cluster Name which will be used for T1 provisioning | yes | none
| `nsxt_t0` | T0 Router Name | yes | none
| `subnet`  | Settings for the Desired Subnet | yes | none

subnet variable is stored using list of object, including the following 5 items:
* cidr = string (e.g 192.168.0.0/24)
* allocation_ranges = list(string) (e.g. [192.168.0.2-192.168.0.100, 192.168.0.110-192.168.0.250])
* gateway_ip = string (e.g. 192.168.0.1)
* dns_suffix = string (e.g. abc.com)
* dns_nameservers = list(string) (e.g. [168.95.1.1, 8.8.8.8])

