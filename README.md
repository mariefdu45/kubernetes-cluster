# kubernetes-cluster
This repository is for installing a vanilla K8S cluster on vsphere in an Infrastructure as code way (IaC). It is using Terraform for creating virtual machine and then kubespray to configure the cluster.

> Ce dépot a pour but d'installer un cluster Kubernetes Vanilla sur une infrastructure VMWare de manière automatisée (Infrastructure as code way ou IaC). Il utilise Terraform pour créér les machines virtuelles puis kubespray pour créér le cluster.

## Installing on your cluster
### Prerequisite
- A VSphere cluster
- Linux workstation with kubectl, ansible and terraform

### Get Files and customized them
```bash
cd <projects directory>
# Get repository
git clone https://github.com/mariefdu45/kubernetes-cluster.git
cd kubernetes-cluster # it will be working_dir variable later
cp templates_env/variables.env .
cp templates_env/terraform.tfvars vms_creation_tf/
```

Customizing  variables.env and vms_creation_tf/terraform.tfvars with your own values

```bash
source ./variables.env
```

### using installation script
```bash
./configuration/main.sh install
```

## Uninstalling vms
```bash
./configuration/main.sh uninstall
```
