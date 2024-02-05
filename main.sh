#!/bin/bash
# kubernetes-cluster – Main Program
# Version : January 03, 2024
# Author : mariefdu45@gmail.com
#
if [[ $1 == install ]]
then
  ./vms_creation_tf/main.sh install
  sleep 60
  ./cluster_creation_kubespray/main.sh install
elif [[ $1 == uninstall ]]
then
  ./vms_creation_tf/main.sh uninstall
  #./cluster_creation_kubespray/main.sh uninstall
else
  echo "Error. Usage: main.sh install|uninstall"
fi


