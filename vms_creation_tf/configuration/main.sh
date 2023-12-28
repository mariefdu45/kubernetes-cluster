# !/bin/bash
# kubernetes-cluster – Main Program
# Version : December 28, 2023
# Author : mariefdu45@gmail.com
#

if [[ $1 == "install" ]]
then
    terraform init
    terraform apply -auto-approve
elif [[ $1 == "uninstall" ]] 
then
    terraform init
    terraform destroy -auto-approve
else
    echo "Error. Usage: main.sh install|uninstall"
fi
