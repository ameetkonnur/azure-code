 #!/bin/bash
az account list --query '[].{SubscriptionId:id}' | grep Sub | awk -F ":" '{print $2}' | tr -d ' " ' >> subsc.txt
for i in `cat subsc.txt`
do
az vm list -d --query '[].{Name:name,Size:hardwareProfile.vmSize,Location:location,Offer:storageProfile.imageReference.offer,ResourceGroup:resourceGroup,OS:storageProfile.osDisk.osType,status:powerState}' --subscription $i -o table
done
