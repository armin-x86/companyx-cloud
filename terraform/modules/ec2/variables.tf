## Instance Configuration
variable "create_instance" {
  description = "Whether to create the EC2 instance"
  default     = true
  type        = bool
}

variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  default     = "t3a.nano"
  type        = string
}

variable "ami" {
  description = "The AMI to use for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The name of the EC2 key pair to use"
  type        = string
  default     = null
}

## Instance Networking
variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with the EC2 instance"
  type        = list(string)
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the EC2 instance into"
  type        = string
}

variable "eip" {
  description = "Whether to create an Elastic IP and associate it with the EC2 instance"
  default     = false
  type        = bool
}

## Instance Storage
variable "root_block_device" {
  description = "The root block device configuration"
  default = [{
    volume_size = 15
    volume_type = "gp3"
    encrypted   = true
  }]
  type = any
}

variable "ebs_block_device" {
  description = "The EBS block device configuration"
  default     = []
  type        = any
}

## Instance User Data
variable "user_data" {
  description = "The user data to provide when launching the EC2 instance"
  type        = string
  default     = ""
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with the EC2 instance"
  type        = string
  default     = ""
}

variable "create_iam_instance_profile" {
  description = "Whether to create an IAM instance profile for the EC2 instance"
  default     = true
  type        = bool
}

variable "iam_role_name_suffix" {
  description = "The IAM instance name suffix"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to assign to the EC2 instance"
  type        = any
}

## AMI Configuration
variable "ignore_ami_changes" {
  description = "Whether to ignore the AMI configuration changes" #Prevent the AMI from being replaced when the configuration changes from the previous AMI
  default     = true
  type        = bool
}

## Instance Metadata
variable "metadata_options" {
  description = "The metadata options for the EC2 instance"
  default = {
    http_tokens = "required"
  }
  type = any
}
