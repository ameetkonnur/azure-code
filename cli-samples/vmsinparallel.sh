#!/bin/bash

# set parameters
group_name="<resource group>"
vm_prefix="<vm prefix>"
dc_location="<dc name>"
image_name="Canonical:UbuntuServer:16.04-LTS:latest"
vm_size="Standard_A2"
vnet_name="<vnet name>"
subnet_name="<subnet name>"
vm_username="<username>"
vm_passsword="<password>"
# optional random 12 character password
# vm_passsword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
public_ip=""
declare -i no_of_vm
declare -i batch_size
declare -i no_of_runs
declare -i vms_created
no_of_vm=3
batch_size=2
val=`expr $no_of_vm % $batch_size`
if [ $val == 0 ] ; then
    no_of_runs=$no_of_vm/$batch_size
else
    no_of_runs=$no_of_vm/$batch_size+1
fi
echo "no of runs $no_of_runs"

vms_created=0

# create resource group
echo "creating resource group"
az group create --name $group_name --location $dc_location

# create vm's in parallel

for ((i=1; i<=$no_of_runs;i++))
do
    val=$(($no_of_vm-$vms_created))

    if [ $batch_size -gt $val ]; then
        batch_size=$(($val))
    fi

    for ((j=1;j<=$batch_size;j++))
    do
        vms_created=$(($vms_created+1))
        echo "creating $vm_prefix-$vms_created..password : $vm_passsword"
        az vm create \
            --resource-group $group_name \
            --name "$vm_prefix-$vms_created" \
            --image $image_name \
            --size $vm_size \
            --authentication-type password \
            --admin-username $vm_username \
            --admin-password $vm_passsword \
            --vnet-name $vnet_name \
            --subnet $subnet_name &
    done
    wait
done
wait
echo "$vms_created vm's created"