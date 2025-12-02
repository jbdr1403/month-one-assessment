variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-west-2"
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]

}
variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "web_instance_type" {
  description = "Instance type for web servers"
  type        = string
  default     = "t3.micro"

}

variable "db_instance_type" {
  description = "Instance type for database servers"
  type        = string
  default     = "t3.small"
}

variable "key_pair_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "my_ip" {
  description = "Your IP address for SSH access"
  type        = string
}
