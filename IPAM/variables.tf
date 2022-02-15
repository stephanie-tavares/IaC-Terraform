variable "region" {
  default     = "us-east-1" #Your region
}

variable "ipam_operating_regions" {
 default     = ["us-east-1"] #Your region
}

variable "top_level_pool_cidr" {
  default     = "1.1.1.1/1"
}
