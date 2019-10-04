# output to screen as table
az disk list --query '[].{Name:name,RG:resourceGroup,SKU:sku.name,Size:diskSizeGb,ManagedBy:managedBy,OS:osType}' -o table
# output to csv file
az disk list --query '[].{Name:name,RG:resourceGroup,SKU:sku.name,Size:diskSizeGb,ManagedBy:managedBy,OS:osType}' -o csv >> Disks.csv