# kubernetes-cluster
This repository is for installing a vanilla K8S cluster on vsphere in an Infrastructure as code way (IaC)

> Ce dépot a pour but d'installer un cluster Kubernetes Vanilla sur une infrastructure VMWare de manière automatisée (Infrastructure as code way ou IaC).


## Some theory about components
> Un peu de théorie à propos des composants

In the f
> Dans 


<img src="https://github.com/mariefdu45/csi-vsphere/assets/96368239/cd1af133-08fd-4b21-affa-a512dd9c1f2a"  width="350"/>
<img align="right" src="https://github.com/mariefdu45/csi-vsphere/assets/96368239/1e5fdd77-e92a-4cb3-bc48-8a09d2588a8a"  width="600"/>


## Installating on your cluster
### Prerequisite
- A VSphere cluster
- Linux workstation with kubectl, ansible and terraform

### CPI and CSI Installation
```bash
# Get repository
git clone https://github.com/mariefdu45/vsphere.git
cd kubernetes-cluster
cp templates_env/terraform.tfvars vms_creation_tf/
cd vms_creation_tf
```
- Customizing  terraform.tfvars
  
```bash
# vms deploy
# using installation script
./configuration/main.sh install
```
