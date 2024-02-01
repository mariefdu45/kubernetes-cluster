#!/bin/bash
# kubernetes-cluster – Main Program
# Version : January 11, 2024
# Author : mariefdu45@gmail.com
#
source variables.env
cd $working_dir/vms_creation_tf || echo "working_dir must be defined"; exit 1
if [[ $1 == "install" ]]
then
    # Create virtual machines
    terraform init 
    terraform apply  -auto-approve
    wait 120
   
    # get masters_list from terraform.tfvars and add public key of the managing worstation to masters's .ssh/authorized_keys file
    # initialize parameters
    i=1
    masters_list=()
    rm $working_dir/.masters_var.env $working_dir/.masters_list_var.env
    while [[ true ]]
    do
      master_ip=$(cat terraform.tfvars |  hclq get "masters_nodes.master$i.ip")
      master_ip="${master_ip//\"/}" # The 2 " characters are removed from the IP
      master_name=$(cat terraform.tfvars |  hclq get "masters_nodes.master$i.name")
      master_name="${master_name//\"/}" # The 2 " characters are removed from the name
      # declare one list for each master containing name and ip
      declare -n listname="$(echo master$i)" # this is a dynamic list name
      declare -a listname=("$master_name" "$master_ip")
      if [[ $master_name == "[]" ]]
      then
       break
      fi
      masters_list+=("$master_name") # Creating a master list with the name of each node list
      # Append informations in a file for sourcing later
      # echo master$i'=("'${listname[0]}'" "'${listname[1]}'")' >> $working_dir/.masters_var.env
      echo ${listname[@]} >> $working_dir/.masters_var.env\
      # add public key of the managing worstation to masters's .ssh/authorized_keys file
      until ssh   -oBatchMode=yes $(whoami)@$master_ip ls
      do
        sshpass -p "$vsphere_virtual_machine_template_user_password" ssh-copy-id -o StrictHostKeyChecking=no $(whoami)@$master_ip
      sleep 5
      done
      ((i++))
    done
    echo ${masters_list[@]} > $working_dir/.masters_list_var.env

    # get workers_list from terraform.tfvars and add public key of the managing worstation to workers's .ssh/authorized_keys file
    # initialize parameters
    i=1
    workers_list=()
    rm $working_dir/.workers_var.env $working_dir/.workers_list_var.env
    while [[ true ]]
    do
      worker_ip=$(cat terraform.tfvars |  hclq get "workers_nodes.worker$i.ip")
      worker_ip="${worker_ip//\"/}" # The 2 " characters are removed from the IP
      worker_name=$(cat terraform.tfvars |  hclq get "workers_nodes.worker$i.name")
      worker_name="${worker_name//\"/}" # The 2 " characters are removed from the name
      # declare one list for each worker containing name and ip
      declare -n listname="$(echo worker$i)"
      declare -a listname=("$worker_name" "$worker_ip")
      if [[ $worker_name == "[]" ]]
      then
       break
      fi
       workers_list+=("$worker_name") # Creating a worker list with the name of each node list
       # Append informations in a file for sourcing later
       # echo worker$i'=("'${listname[0]}'" "'${listname[1]}'")'\ >> $working_dir/.workers_var.env
       echo ${listname[@]} >> $working_dir/.workers_var.env
       # add public key of the managing worstation to masters's .ssh/authorized_keys file
       until ssh   -oBatchMode=yes $(whoami)@$master_ip ls
       do
         sshpass -p "$vsphere_virtual_machine_template_user_password" ssh-copy-id -o StrictHostKeyChecking=no $(whoami)@$worker_ip
         sleep 5
       done

       ((i++))
    done
    echo ${workers_list[@]} > $working_dir/.workers_list_var.env
   
elif [[ $1 == "uninstall" ]] 
then
    # Destroy virtual machines
    terraform init
    terraform destroy -auto-approve
else
    echo "Error. Usage: main.sh install|uninstall"
fi
cd $working_dir
