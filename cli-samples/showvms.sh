az vm list \
  -d --query '[].{Name:name,Size:hardwareProfile.vmSize,Location:location,Offer:storageProfile.imageReference.offer,ResourceGroup:resourceGroup,OS:storageProfile.osDisk.osType,status:powerState}' \
  -o table

az vm list \
  --query '[].{name:name,UMosDisk:storageProfile.osDisk.vhd.uri,MosDisk:storageProfile.osDisk.managedDisk,OS:storageProfile.imageReference.offer}' \
  -o jsonc

az vm list -d --query "[?powerState == 'VM running'].{Name:name,Size:hardwareProfile.vmSize,Location:location,Offer:storageProfile.imageReference.offer,ResourceGroup:resourceGroup,OS:storageProfile.osDisk.osType,status:powerState}" -o table
