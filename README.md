# kubernetes-cluster
This repository is for installing a vanilla K8S cluster on vsphere in an Infrastructure as code way (IaC). It is using Terraform for creating virtual machine and then kubespray to configure the cluster.

> Ce dépot a pour but d'installer un cluster Kubernetes Vanilla sur une infrastructure VMWare de manière automatisée (Infrastructure as code way ou IaC). Il utilise Terraform pour créér les machines virtuelles puis kubespray pour créér le cluster.

## Installing a cluster from scratch
### Prerequisite
- A VSphere cluster
- Linux workstation with kubectl, ansible and terraform

Go to your favorite projects directory
```bash
cd <projects directory>
```

### Get Files
```bash
# Get kubernetes-cluster repository
git clone https://github.com/mariefdu45/kubernetes-cluster.git
cd kubernetes-cluster # it will be working_dir variable later
cp templates_env/variables.env .
cp templates_env/terraform.tfvars vms_creation_tf/
```

### Customizing  vms_creation_tf/terraform.tfvars for creating virtual machines with your own values
- vcenter, admin user and password
- datacenter, datastore, cluster, network
- vm template, vm folder, network parameters for nodes
- masters and workers  properties

### Customizing  variables.env for creating kubernetes cluster with your own values
- kubespray branch
- sudo user name and password configured in the template
- cluster name
- cni of your choice

### get variables and execute bash script 
```bash
source ./variables.env
./main.sh install
```

## Installing vritual machines without configuring kubernetes cluster
Go to your favorite projects directory
```bash
cd <projects directory>
```
### Get Files. In this case, you don't need variables.env
```bash

# Get kubernetes-cluster repository
git clone https://github.com/mariefdu45/kubernetes-cluster.git
cd kubernetes-cluster # it will be working_dir variable later
cp templates_env/terraform.tfvars vms_creation_tf/
```

### Customizing  vms_creation_tf/terraform.tfvars for creating virtual machines with your own values
- vcenter, admin user and password
- datacenter, datastore, cluster, network
- vm template, vm folder, network parameters for nodes
- masters and workers  properties

### execute bash script 
```bash
./vms_creation_tf/main.sh install
```

## Configuring kubernetes cluster on existing virtual machines
Go to your favorite projects directory
```bash
cd <projects directory>
```

### Get Files. In this case, you don't need terraform.tfvars but you need extra files describing your infrastructure

```bash
# Get kubernetes-cluster repository
git clone https://github.com/mariefdu45/kubernetes-cluster.git
cd kubernetes-cluster # it will be working_dir variable later
cp templates_env/variables.env .
cp templates_env/.masters_list_var.env .
cp templates_env/.workers_list_var.env .
cp templates_env/.masters_var.env .
cp templates_env/.workers_var.env .

### Customizing  variables.env for creating kubernetes cluster with your own values
- kubespray branch
- sudo user name and password configured in the template
- cluster name
- cni of your choice

### Customizing  files  describing your existing infrastructure (names and ips)
- .masters_list_var.env
- .workers_list_var.env
- .masters_var.env
- .workers_var.env

### execute bash script 
```bash
./cluster_creation_kubespray/main.sh install
```


## Uninstalling vms and cluster if configured
```bash
./main.sh uninstall
```

## Uninstalling cluster only
```bash
./cluster_creation_kubespray/main.sh uninstall uninstall
```
