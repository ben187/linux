variable "vpc_id" {
  type    = string
  default = "vpc-0b78e3f8d783cae68"
}

variable "availability_zone_1" {
  type    = string
  default = "us-east-1a"
}

variable "availability_zone_2" {
  type    = string
  default = "us-east-1b"
}

variable "redis_node_type" {
  type    = string
  default = "cache.t2.micro"
}

variable "redis_number_cache_clusters" {
  type    = string
  default = "2"
}