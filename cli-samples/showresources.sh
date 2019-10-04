az resource list \
    --query '[].{Name:Name,UMosDisk:storageProfile.osDisk.vhd.uri,MosDisk:storageProfile.osDisk.managedDisk,OS:storageProfile.imageReference.offer}' \