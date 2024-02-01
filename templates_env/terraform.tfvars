#!/bin/bash
# kubernetes-cluster – Main Program
# Version : January 30, 2024
# Author : mariefdu45@gmail.com
#
vsphere_user                     = "
vsphere_password                 = "
vsphere_server                   = "
vsphere_datacenter               = "
vsphere_datastore                = "
vsphere_compute_cluster          = "
vsphere_network                  = "
vsphere_virtual_machine_template = "
system_folder                    = "
system_domain                    = "
system_ipv4_netmask              = 
system_dns_server_list           = ["4.4.4.4","8.8.8.8"]
system_ipv4_gateway              = "

masters_nodes   = {
    "master1" = {
      name     = "
      ip = "
    }
    "master2" = {
      name     = "
      ip = "
    }
    "master3" = {
      name     = "
      ip = "
    }
}
workers_nodes   = {
    "worker1" = {
      name     = "
      ip = "1
    }
    "worker2" = {
      name     = "
      ip = "
    }
}


masters_system_cores                     = 2
masters_system_cores_per_socket          = 2
masters_system_memory                    = 4096
#system_disk1_size                = 30
workers_system_cores                     = 2
workers_system_cores_per_socket          = 2
workers_system_memory                    = 4096
#system_disk1_size                = 30
