az group create -n vscodedemorg -l eastus
az storage account create -g vscodedemorg -n vscodedemostore -l eastus --sku standard_lrs
az storage share create -n vscodeshare --account-name vscodedemostore
storage_key=$(az storage account keys list -g vscodedemorg --account-name vscodedemostore --query "[0].value" --output tsv)

az container create -g vscodedemorg --name vscodedemo --image codercom/code-server --cpu 1 --memory 1.5 --dns-name-label vscodedemo --ports 8443 --azure-file-volume-account-name vscodedemostore --azure-file-volume-account-key $storage_key --azure-file-volume-share-name vscodeshare --azure-file-volume-mount-path '/root/project'

az container show -g vscodedemorg -n vscodedemo --query "ipAddress.ip" -o tsv
