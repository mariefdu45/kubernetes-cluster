# !/bin/bash
# kubernetes-cluster – Main Program
# Version : January 03, 2024
# Author : mariefdu45@gmail.com
#
source variables.env
#source .commons_var.env
ansible_inventory=$working_dir/kubespray/inventory/$k8s_cluster_name/hosts.yaml
cd $working_dir
#rm -rf kubespray
rm -r $ansible_inventory
if [[ $1 == "install" ]]
then
  git clone --branch $k8s_kubespray_branch https://github.com/kubernetes-sigs/kubespray 
  pip3 install -r ./kubespray/requirements.txt
  # There is a problem withansible-core :  TASK [kubernetes/preinstall : Stop if either kube_control_plane or kube_node group is empty]  
  pip3 install ansible-core==2.14.11
  mkdir $working_dir/kubespray/inventory/$k8s_cluster_name
  cp -rfp $working_dir/kubespray/inventory/sample/* $working_dir/kubespray/inventory/$k8s_cluster_name
  
  # Configuring inventory file for kubespray
  echo 'all:' >> $ansible_inventory
  echo  '  hosts:' >> $ansible_inventory
  while read -r line; do
    name=$(echo $line | cut -f 1 -d' ')
    ip=$(echo $line | cut -f 2 -d' ')
    echo '    '$name':' >> $ansible_inventory 
    echo '      ansible_host: '$ip\ >> $ansible_inventory
    echo '      ip: '$ip\ >> $ansible_inventory
    echo '      access_ip: '$ip\ >> $ansible_inventory
  done < $working_dir/.masters_var.env
  while read -r line; do
    name=$(echo $line | cut -f 1 -d' ')
    ip=$(echo $line | cut -f 2 -d' ')
    echo '    '$name':' >> $ansible_inventory 
    echo '      ansible_host: '$ip\ >> $ansible_inventory
    echo '      ip: '$ip\ >> $ansible_inventory
    echo '      access_ip: '$ip\ >> $ansible_inventory
  done < $working_dir/.workers_var.env
  echo  '  children:' >> $ansible_inventory

  echo  '    kube_control_plane:' >> $ansible_inventory
  echo  '      hosts:' >> $ansible_inventory
  while read -r line; do
    name=$(echo $line | cut -f 1 -d' ')
    ip=$(echo $line | cut -f 2 -d' ')
    echo '        '$name':' >> $ansible_inventory 
  done < $working_dir/.masters_var.env

  echo  '    kube_node:' >> $ansible_inventory
  echo  '      hosts:' >> $ansible_inventory
  while read -r line; do
    name=$(echo $line | cut -f 1 -d' ')
    ip=$(echo $line | cut -f 2 -d' ')
    echo '        '$name':' >> $ansible_inventory 
  done < $working_dir/.workers_var.env

  echo  '    etcd:' >> $ansible_inventory
  echo  '      hosts:' >> $ansible_inventory
  while read -r line; do
    name=$(echo $line | cut -f 1 -d' ')
    ip=$(echo $line | cut -f 2 -d' ')
    echo '        '$name':' >> $ansible_inventory 
  done < $working_dir/.masters_var.env

  echo  '    k8s_cluster:' >> $ansible_inventory
  echo  '      children:' >> $ansible_inventory
  echo  '        kube_control_plane:' >> $ansible_inventory
  echo  '        kube_node:' >> $ansible_inventory

  echo  '      calico_rr:' >> $ansible_inventory
  echo  '        hosts: {}' >> $ansible_inventory

  # Configuring CNI
  if [[ k8s_cni==cilium ]]
  then sed -i 's/kube_network_plugin: calico/kube_network_plugin: cilium/g' $working_dir/kubespray/inventory/$k8s_cluster_name/group_vars/k8s_cluster/k8s-cluster.yml
  fi
  
  # Creating cluster
  cd $working_dir/kubespray
  ansible-playbook -i $working_dir/kubespray/inventory/$k8s_cluster_name/hosts.yaml  --become --become-user=root --user=$vsphere_virtual_machine_template_user --private-key /home/$vsphere_virtual_machine_template_user/.ssh/id_rsa $working_dir/kubespray/playbooks/cluster.yml
  # Configuring kubeconfig
  # At this time, there is not LB then use first master
  k8s_lb=10.200.5.81 
  ssh $k8s_lb sudo cat /etc/kubernetes/admin.conf > /home/$vsphere_virtual_machine_template_user/.kube/config
  sed -i 's/127.0.0.1:6443/'$k8s_lb':6443/g' /home/$vsphere_virtual_machine_template_user/.kube/config


elif [[ $1 == "uninstall" ]] 
then
    ansible-playbook -i inventory/$k8s_cluster_name/hosts.yaml  --become --become-user=root --user=vsphere_virtual_machine_template_user --private-key ~mfoucher/.ssh/id_rsa $working_dir/kubespray/playbooks/reset.yml
else
    echo "Error. Usage: main.sh install|uninstall"
fi
