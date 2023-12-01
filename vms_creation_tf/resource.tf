
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "vsphere_datacenter" {}
variable "vsphere_datastore" {}
variable "vsphere_compute_cluster" {}
variable "system_vm_count" {
  type = number
}
variable "vsphere_network" {}
variable "vsphere_virtual_machine_template" {}
variable "system_name_prefix" {}
variable "system_folder" {}
variable "system_domain" {}
variable "system_cores" {}
variable "system_cores_per_socket" {}
variable "system_memory" {}
variable "system_ipv4_start" {}
variable "system_ipv4_netmask" {}
variable "system_dns_server_list" {}
variable "system_ipv4_gateway" {}
variable "system_disk1_size" {}
variable "system_disk2_size" {}

# Virtual Machine Resource
resource "vsphere_virtual_machine" "server-instance" {
  count = var.system_vm_count
  # System
  #firmware  = "efi"
  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  # VM-Name
  name             = "${var.system_name_prefix}-${count.index}"
  folder             = var.system_folder
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  # CPU
  num_cpus               = var.system_cores
  num_cores_per_socket   = var.system_cores_per_socket
  cpu_hot_add_enabled    = true
  cpu_hot_remove_enabled = true

  # Memory
  memory                 = var.system_memory
  memory_hot_add_enabled = true

  # Network
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "e1000e"
  }

  # Storage
  # Drive 0 (C)
  disk {
    label            = "disk0"
    unit_number      = 0
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  # Drive 1 (D)
  #disk {
   # label            = "disk1"
   # unit_number      = 1
   # size             = var.system_disk1_size
   # eagerly_scrub    = data.vsphere_virtual_machine.template.disks.1.eagerly_scrub
   # thin_provisioned = data.vsphere_virtual_machine.template.disks.1.thin_provisioned
  #}

  # Template clone and OS settings
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name         = "${var.system_name_prefix}-${count.index}"
        domain            = var.system_domain
      }

      network_interface {
        ipv4_address    ="${var.system_ipv4_start}${count.index}"
        ipv4_netmask    = var.system_ipv4_netmask
        dns_server_list = var.system_dns_server_list
      }

      ipv4_gateway = var.system_ipv4_gateway
    }
  }
}
