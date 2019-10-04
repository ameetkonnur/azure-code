#start VM's
az vm start --ids $(az vm list --query "[].id" -o tsv)

#stop VM's
az vm stop --ids $(az vm list --query "[].id" -o tsv)