# kubernetes-cluster
This repository is for installing a vanilla K8S cluster on vsphere in an Infrastructure as code way (IaC). It is using Terraform for creating virtual machine and then kubespray to configure the cluster.

> Ce dépot a pour but d'installer un cluster Kubernetes Vanilla sur une infrastructure VMWare de manière automatisée (Infrastructure as code way ou IaC). Il utilise Terraform pour créér les machines virtuelles puis kubespray pour créér le cluster.

## Installing on your cluster
### Prerequisite
- A VSphere cluster
- Linux workstation with kubectl, ansible and terraform

### Get Files
```bash
cd <projects directory>
# Get repository
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

```bash
source ./variables.env
```

### Using installation script
```bash
./main.sh install
```

## Uninstalling vms
```bash
./configuration/main.sh uninstall
```
