variable "env" {
  type = string
  default = "Test"
}

variable "rg_name" {
  type =  string 

}

variable "location" {
  type = string
}

variable "kv_name" {
  type = string
}

variable "kv_sku_name" {
  type = string 
}
variable "msi_id" {
  type = string 
  #it is the managed security identiy iud. if this value int null
  default = null
}