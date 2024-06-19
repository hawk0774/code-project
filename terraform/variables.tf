#-----------Base-------------

variable "yc_iam_token" {
  description = ""
}

variable "cloud_id" {
  description = ""
} 

variable "folder_id" {
  description = ""
} 

#------- VPC and Subnet ----------


variable "vpc_name" {
  type        = string
  default     = "netology-diplom"
  description = "VPC network"
}


variable "cidr_inner-web1" {
  type        = list(string)
  default     = ["10.10.1.0/28"]
}


variable "cidr_inner-web2" {
  type        = list(string)
  default     = ["10.10.2.0/28"]
}


variable "cidr_external" {
  type        = list(string)
  default     = ["10.10.4.0/27"]
}


variable "cidr_internal" {
  type        = list(string)
  default     = ["10.10.3.0/27"]
}

variable "name_one" {
  type        = string
  default     = "external-network"
  description = "Subnet external"
}

variable "name_two" {
  type        = string
  default     = "internal-network"
  description = "Subnet internal"
}

variable "name_three" {
  type        = string
  default     = "inner-web-1-subnet"
  description = "Subnet nginx1 internal"
}

variable "name_four" {
  type        = string
  default     = "inner-web-2-subnet"
  description = "Subnet nginx2 internal"
}


#-------share variables--------

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}

variable "new_zone" {
  type        = string
  default     = "ru-central1-b"
}

variable "platform" {
  type        = string
  default     = "standard-v1"
}

#-----Bastion-----

variable "hostname" {
  type        = string
  default     = "bastion"
}


#-------Web-serv1--------
variable "web1-name" {
  type        = string
  default     = "webserv-1"
}

#------Web-serv2-------
variable "web2-name" {
  type        = string
  default     = "webserv-2"
}
#--------Zabbix---------
variable "zab-name" {
  type        = string
  default     = "zabbix"
}
#--------Elastic---------
variable "el-name" {
  type        = string
  default     = "elastic"
}

