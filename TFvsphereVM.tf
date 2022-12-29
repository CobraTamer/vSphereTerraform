provider "vsphere" {
    user           = "root"
    password       = "#Tame2011"
    vsphere_server = "172.16.20.2"


    # If you have a self-signed cert
    allow_unverified_ssl = true
  }
  
  data "vsphere_datacenter" "dc" {
    name = "dc1"
  }
  
  data "vsphere_datastore" "datastore" {
    name          = "2TB"
    datacenter_id = data.vsphere_datacenter.dc.id
  }
  
  data "vsphere_resource_pool" "pool" {
    name          = "cluster1/Resources"
    datacenter_id = data.vsphere_datacenter.dc.id
  }
  
  data "vsphere_network" "network" {
    name          = "WindowsServers"
    datacenter_id = data.vsphere_datacenter.dc.id
  }
  
  resource "vsphere_virtual_machine" "vm" {
    name             = "terraform-test"
    resource_pool_id = data.vsphere_resource_pool.pool.id
    datastore_id     = data.vsphere_datastore.datastore.id
  
    num_cpus = 1
    memory   = 2048
    guest_id = "Windows9Server64Guest"
    scsi_type="lsilogic-sas"
  
    network_interface {
      network_id = data.vsphere_network.network.id
    }
  
    disk {
      label = "disk0"
      size  = 40
    }

    cdrom {
      datastore_id = data.vsphere_datastore.datastore.id
      path ="ISO-IMAGES/17763.737.190906-2324.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us_1.iso"
    }
  }
  
