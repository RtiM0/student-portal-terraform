variable "region" {
  default     = "ap-south-1"
  description = "AWS Region"
}

variable "frontend_repo_path" {
  default     = "RtiM0/student-portal"
  description = "Link to the Frontend github repo"
}

variable "frontend_repo_branch" {
  default     = "master"
  description = "Branch of the Frontend github repo"
}
