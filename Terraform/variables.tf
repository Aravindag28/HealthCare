#This Terraform code defines two variables, "aws_access_key" and "aws_secret_key," to store AWS access and secret keys, respectively. 
#These variables are intended for secure storage and retrieval of AWS credentials when configuring infrastructure resources.
variable "aws_access_key" {
  description = "AWS Access Key ID"
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
}
# variable "private_key" {
#   description = "SSH private key for EC2 instance access"
  
# }
