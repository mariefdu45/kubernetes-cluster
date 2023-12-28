# kubernetes-cluster
This repository is for installing a vanilla K8S cluster on vsphere in an Infrastructure as code way (IaC). It is using Terraform for creating virtual machine and then kubespray to configure the cluster.

> Ce dépot a pour but d'installer un cluster Kubernetes Vanilla sur une infrastructure VMWare de manière automatisée (Infrastructure as code way ou IaC). Il utilise Terraform pour créér les machines virtuelles puis kubespray pour créér le cluster .

### Prerequisite
- A VSphere cluster
- Linux workstation with kubectl, ansible and terraform

### Installation
```bash
# Get repository
git clone https://github.com/mariefdu45/vsphere.git
cd kubernetes-cluster
cp templates_env/terraform.tfvars vms_creation_tf/
cd vms_creation_tf
```
Customizing  terraform.tfvars with your own values
  
```bash
# vms deploy
# using installation script
./configuration/main.sh install
```

### Uninstallation
```bash
./configuration/main.sh uninstall
```
