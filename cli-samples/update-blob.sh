#!/bin/bash
rm blobs.txt
account='<storage account name>'
container='<container name>'
key='<storage account key>'
pattern='<pattern> for eg .log .jpg'
mime_type='<MIME Type>'
az storage blob list --query "[?contains(name,'$pattern')].name" --num-results "*" --container-name $container --account-name $account --account-key $key -o tsv >> blobs.txt
for i in `cat blobs.txt`
do
az storage blob update --container-name $container --account-name $account --account-key $key --name $i --content-type $mime_type
done
