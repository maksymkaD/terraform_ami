variable "region" { default = "eu-north-1" }
variable "ami" { default = "ami-0cac9699e508258b1" }  # Replace with actual ami id
variable "instance_type" { default = "t3.micro" }
variable "my_ssh_key_path" {
  default = "keys/my_key.pub"
}
variable "teacher_ssh_key_path" {
  default = "keys/teacher_key.pub"
}
