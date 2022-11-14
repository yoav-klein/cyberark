
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "instance_count" {
  type        = number
  description = "Number of instances"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets to run the instances in"
}

variable "pub_key_path" {
  type        = string
  description = "Path to a public key"
}

