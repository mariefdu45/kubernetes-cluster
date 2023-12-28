
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "vsphere_datacenter" {}
variable "vsphere_datastore" {}
variable "vsphere_compute_cluster" {}
variable "vsphere_network" {}
variable "vsphere_virtual_machine_template" {}
variable "system_folder" {}
variable "system_domain" {}
#variable "system_ipv4_start" {}
variable "system_ipv4_netmask" {}
variable "system_dns_server_list" {}
variable "system_ipv4_gateway" {}


variable "masters_system_cores" {}
variable "masters_system_cores_per_socket" {}
variable "masters_system_memory" {}
#variable "masters_system_disk1_size" {}
variable "master-nodes" {
  type = map(object({
    name     = string
    ip = string
  }))
}



variable "workers_system_cores" {}
variable "workers_system_cores_per_socket" {}
variable "workers_system_memory" {}
#variable "workers_system_disk1_size" {}
variable "worker-nodes" {
  type = map(object({
    name     = string
    ip = string
  }))
}




# Virtual Machine Resource for Masters
resource "vsphere_virtual_machine" "master-instance" {
  for_each = var.worker-nodes
  # System
  #firmware  = "efi"
  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  # VM-Name
  name             = each.value["name"]
  folder             = var.system_folder
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  # CPU
  num_cpus               = var.masters_system_cores
  num_cores_per_socket   = var.masters_system_cores_per_socket
  cpu_hot_add_enabled    = true
  cpu_hot_remove_enabled = true

  # Memory
  memory                 = var.masters_system_memory
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


  # Template clone and OS settings
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name         = each.value["name"]
        domain            = var.system_domain
      }

      network_interface {
        ipv4_address    = each.value["ip"]
        ipv4_netmask    = var.system_ipv4_netmask
        dns_server_list = var.system_dns_server_list
      }

      ipv4_gateway = var.system_ipv4_gateway
    }
  }
}



# Virtual Machine Resource for Workers
resource "vsphere_virtual_machine" "worker-instance" {
  for_each = var.master-nodes
  # System
  #firmware  = "efi"
  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  # VM-Name
  name             = each.value["name"]
  folder             = var.system_folder
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  # CPU
  num_cpus               = var.masters_system_cores
  num_cores_per_socket   = var.masters_system_cores_per_socket
  cpu_hot_add_enabled    = true
  cpu_hot_remove_enabled = true

  # Memory
  memory                 = var.masters_system_memory
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


  # Template clone and OS settings
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name         = each.value["name"]
        domain            = var.system_domain
      }

      network_interface {
        ipv4_address    = each.value["ip"]
        ipv4_netmask    = var.system_ipv4_netmask
        dns_server_list = var.system_dns_server_list
      }

      ipv4_gateway = var.system_ipv4_gateway
    }
  }
}

