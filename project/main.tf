provider "aws" {
  region                  = "us-east-1"
}

resource "aws_subnet" "main" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.0.100.0/24"
  availability_zone = "${var.availability_zone_1}"

}

resource "aws_subnet" "main1" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "10.0.101.0/24"
  availability_zone = "${var.availability_zone_2}"

}

resource "aws_elasticache_subnet_group" "testsubnet" {
  name       = "testsubnet"
  subnet_ids = ["${aws_subnet.main.id}", "${aws_subnet.main1.id}"]
}

resource "aws_security_group" "testsg" {
  name        = "testsg"
  description = "Allow 6379"
  vpc_id      = "vpc-0b78e3f8d783cae68"

  ingress {
    description = "Allow 6379"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

}

resource "aws_elasticache_replication_group" "example" {

  replication_group_id          = "tf-rep-group-2"
  replication_group_description = "test description"
  engine_version       		      = "5.0.6"
  node_type                     = "${var.redis_node_type}"

 automatic_failover_enabled     = true
 # availability_zones            = ["us-east-1a", "us-east-1b"]
availability_zones            = ["${var.availability_zone_1}", "${var.availability_zone_2}"] 
number_cache_clusters         = "${var.redis_number_cache_clusters}"
  port                          = 6379
  subnet_group_name    		      = "testsubnet"

  parameter_group_name          = "pgtest"
  security_group_ids   		      = ["${aws_security_group.testsg.id}"]  
  
  lifecycle {
    ignore_changes 		= ["number_cache_clusters"]
  }
}



