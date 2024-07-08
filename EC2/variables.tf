variable "aws_access_key" {
  description = "AWS_ACCESS_KEY_ID"
  type        = string
  default     = "Paste you access key here"
}

variable "aws_secret_key" {
  description = "AWS_SECRET_ACCESS_KEY"
  type        = string
  default     = "Paste you secret access key here"
}

variable "aws_region" {
  description = "AWS Region"
}

variable "instance_name" {
  description = "Name of the EC2 instance"
}

variable "project_name" {
  description = "Name of the project"
}

variable "security_group_name" {
  description = "Name of the Security Group"
}

variable "key_pair_name" {
  description = "Name of the key pair"
}

variable "instance_type" {
  description = "Name of the Instance type"
}

variable "volume_size" {
  description = "Name of the Instance type"
}

variable "iam_role" {
  description = "Name of the Instance type"
}

variable "ami_id" {
  description = "Name of the Instance type"
}

variable "elastic_ip" {
  description = "Whether to attach an Elastic IP (yes or no)"
}
variable "aws_access_key" {
  description = "AWS_ACCESS_KEY_ID"
  type        = string
  default     = "KEY"
}

variable "aws_secret_key" {
  description = "AWS_SECRET_ACCESS_KEY"
  type        = string
  default     = "KEY"
}

variable "aws_region" {
  description = "AWS Region"
}

variable "instance_name" {
  description = "Name of the EC2 instance"
}

variable "project_name" {
  description = "Name of the project"
}

variable "security_group_name" {
  description = "Name of the Security Group"
}

variable "key_pair_name" {
  description = "Name of the key pair"
}

variable "instance_type" {
  description = "Name of the Instance type"
}

variable "volume_size" {
  description = "Name of the Instance type"
}

variable "iam_role" {
  description = "Name of the Instance type"
}

variable "ami_id" {
  description = "Name of the Instance type"
}

variable "elastic_ip" {
  description = "Whether to attach an Elastic IP (yes or no)"
}

variable "create_key_pair" {
  description = "Set to 'yes' if you want to create a new key pair, otherwise set to 'no'"
}


variable "create_iam_role" {
  description = "Set to 'yes' if you want to create a new IAM role, otherwise set to 'no'"
}
