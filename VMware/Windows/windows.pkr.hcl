packer{
  required_version = ">=1.8.0"
  required_plugins {
    vsphere = {
      version = ">=1.0.7"
        source = "github.com/hashicorp/vsphere"
    }
  }
  required_plugins {
    windows-update = {
      version = ">=0.14.1"
        source = "github.com/rgl/windows-update"
    }
  }
}

source "vsphere-iso" "EMEA-DC-2022" {

  vcenter_server = var.vsphere-server
  username       = var.vsphere-user
  password     = var.vsphere-password
  insecure_connection  = "true"

  vm_name         = "${var.vm-name-2022}-${formatdate("YY.MM.DD", timestamp())}"
  guest_os_type        = "windows2019srvNext_64Guest"

  CPUs                 = var.vm-cpu-num
  RAM                  = var.vm-mem-size
  RAM_reserve_all      = false
  firmware             = "efi"
  cdrom_type           = "sata"
  video_ram            = "8192"

  cluster              = var.vsphere-cluster
  datacenter           = var.vsphere-datacenter
  folder               = var.vsphere-folder
  datastore            = var.vsphere-datastore

  disk_controller_type = ["pvscsi"]
  storage {
    disk_size             = var.vm-disk-size
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.vsphere-network
    network_card = "vmxnet3"
  }

  boot_command         = ["<spacebar>"]
  boot_wait            = "2s"
  
  
  communicator         = "winrm"
  winrm_insecure = "true"
  winrm_use_ssl  = "true"
  winrm_password = var.winadmin-password
  winrm_username = var.winrm_username
  
  
  floppy_files         = ["../../vmware/windows/2022/autounattend.xml", "../../scripts/"]
  iso_paths            = [var.os_iso_path_2022, var.vmtools_iso_path]
  
  notes        = "Packer build generated on ${legacy_isotime("02-01-2006")}"
  remove_cdrom = true
  convert_to_template  = "true" 
}

source "vsphere-iso" "EMEA-DC-2022-CORE" {

  vcenter_server = var.vsphere-server
  username       = var.vsphere-user
  password     = var.vsphere-password
  insecure_connection  = "true"

  vm_name         = "${var.vm-name-2022}-core-${formatdate("YY.MM.DD", timestamp())}"
  guest_os_type        = "windows2019srvNext_64Guest"

  CPUs                 = var.vm-cpu-num
  RAM                  = var.vm-mem-size
  RAM_reserve_all      = false
  firmware             = "efi"
  cdrom_type           = "sata"
  video_ram            = "8192"

  cluster              = var.vsphere-cluster
  datacenter           = var.vsphere-datacenter
  folder               = var.vsphere-folder
  datastore            = var.vsphere-datastore

  disk_controller_type = ["pvscsi"]
  storage {
    disk_size             = var.vm-disk-size
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.vsphere-network
    network_card = "vmxnet3"
  }

  boot_command         = ["<spacebar>"]
  boot_wait            = "2s"
  
  
  communicator         = "winrm"
  winrm_insecure = "true"
  winrm_use_ssl  = "true"
  winrm_password = var.winadmin-password
  winrm_username = var.winrm_username
  
  
  floppy_files         = ["../../vmware/windows/2022-core/autounattend.xml", "../../scripts/"]
  iso_paths            = [var.os_iso_path_2022, var.vmtools_iso_path]
  
  notes        = "Packer build generated on ${legacy_isotime("02-01-2006")}"
  remove_cdrom = true
  convert_to_template  = "true" 
}

build {
  sources = ["source.vsphere-iso.EMEA-DC-2022","source.vsphere-iso.EMEA-DC-2022-CORE"]

  provisioner "powershell" {
    elevated_password = var.winadmin-password
    elevated_user     = var.winrm_username
    scripts           = ["../../scripts/windows/disable-firewallprofiles.ps1", "../../scripts/windows/7zip.ps1", "../../scripts/windows/powershell7.ps1"]
  }

  provisioner "windows-update" {
    filters         = ["exclude:$_.Title -like '*Preview*'", "include:$true"]
    search_criteria = "IsInstalled=0"
    update_limit    = 25
  }

  provisioner "windows-update" {
  }

  provisioner "windows-restart" {
  }

  provisioner "powershell" {
    elevated_password = var.winadmin-password
    elevated_user     = var.winrm_username
    scripts           = ["../../scripts/windows/Cleanup.ps1"]
  }

}
