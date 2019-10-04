#!/bin/bash
# set parameters
avsetname="testavcentralindia"
group_name="testrgcentralindia"
vm_prefix="testvm"
dc_location="centralindia"
image_name="Canonical:UbuntuServer:16.04-LTS:latest"
vm_size="Standard_D2_v3"
vnet_name="/subscriptions/<subscriptionid>/resourceGroups/<rgname>/providers/Microsoft.Network/virtualNetworks/<vnetname>" # full subnet resourcename if existing else just name
subnet_name="/subscriptions/<subscriptionid>/resourceGroups/<rgname>/providers/Microsoft.Network/virtualNetworks/<vnetname>/subnets/<subnetname>" # full subnet resourcename if existing else just name
vm_username="linuxadmin"
vm_passsword="s0mep@sswordwith123"
# optional random 12 character password
# vm_passsword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
# create resourcegroup
az group create -n $group_name -l $dc_location
# create av set name
az vm availability-set create -n $avsetname -g $group_name --platform-fault-domain-count 2 --platform-update-domain-count 2
set -i no_of_vm
set -i batch_size
set -i no_of_runs
set -i vms_created
no_of_vm=1
batch_size=1
val=`expr $no_of_vm % $batch_size`
if [ $val == 0 ] ; then
    no_of_runs=$no_of_vm/$batch_size
else
    no_of_runs=$no_of_vm/$batch_size+1
fi
echo "no of runs $no_of_runs"
vms_created=0
# create vms in parallel
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
            --subnet $subnet_name \
            --availability-set $avsetname
    done
    wait
done
wait
echo "$vms_created vm's created"
