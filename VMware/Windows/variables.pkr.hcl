variable "vsphere-server" {
  type = string
}
variable "vsphere-user" {
  type = string
}
variable "vsphere-password" {
  type = string
  sensitive = true
}
variable "vm-cpu-num" {
  type = number
}
variable "vm-mem-size" {
  type = number
}
variable "vsphere-cluster" {
  type = string
}
variable "vsphere-datacenter" {
  type = string
}
variable "vsphere-folder" {
  type = string
}
variable "vsphere-datastore" {
  type = string
}
variable "vm-disk-size" {
  type = number
}
variable "vsphere-network" {
  type = string
}
variable "winadmin-password" {
  type = string
  sensitive = true
}
variable "winrm_username" {
  type = string
}
variable "os_iso_path_2022" {
  type = string
}
variable "vm-name-2022" {
  type = string
}
variable "vmtools_iso_path" {
  type = string
}
variable "content_library" {
  type = string
}