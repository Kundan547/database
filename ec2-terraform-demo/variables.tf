variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "us-west-2" # Update with the appropriate AWS region
}

variable "ami_id" {
  description = "The Amazon Machine Image (AMI) ID for the instance"
  default     = "ami-id" # Update with the appropriate AMI ID
}

variable "instance_type" {
  description = "The instance type for the React app server"
  default     = "t2.micro"
}

variable "react_app_repo_url" {
  description = "The GitHub repository URL of the React application"
  default     = "https://github.com/julien-muke/brainwave.git" # Update with the appropriate repository URL
}
variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  default     = "key-pair" # Update with the appropriate key pair name
}