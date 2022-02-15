resource "aws_iam_service_linked_role" "ipam" {
  aws_service_name = "ipam.amazonaws.com"
  description      = "AWS VPC IP Address Manager"
}

locals {
  deduplicated_region_list = toset(concat([var.region], var.ipam_operating_regions))
}

#IPAM Create
resource "aws_vpc_ipam" "ipam" {
  description = "IPAM Teste"
  dynamic "operating_regions" {               
    for_each = local.deduplicated_region_list 
    content {
      region_name = operating_regions.value
    }
  }
  depends_on = [
    aws_iam_service_linked_role.ipam 
  ]
}

resource "aws_vpc_ipam_pool" "top_level" {
  description    = "top-level-pool"
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.ipam.private_default_scope_id
}

#CIDR Pool
resource "aws_vpc_ipam_pool_cidr" "top_level" {
  ipam_pool_id = aws_vpc_ipam_pool.top_level.id
  cidr         = var.top_level_pool_cidr 
}

# create sub-level pools
resource "aws_vpc_ipam_pool" "regional" {
  for_each            = local.deduplicated_region_list
  description         = "${each.key}-pool"
  address_family      = "ipv4"
  ipam_scope_id       = aws_vpc_ipam.ipam.private_default_scope_id
  locale              = each.key
  source_ipam_pool_id = aws_vpc_ipam_pool.top_level.id
}

resource "aws_vpc_ipam_pool_cidr" "regional" {
  for_each     = { for index, region in tolist(local.deduplicated_region_list) : region => index }
  ipam_pool_id = aws_vpc_ipam_pool.regional[each.key].id
  cidr         = cidrsubnet(var.top_level_pool_cidr, 8, each.value)
}

resource "aws_vpc" "infraprojects-dev" {
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool.regional[var.region].id
  ipv4_netmask_length = 24
  depends_on = [
    aws_vpc_ipam_pool_cidr.regional
  ]
}
