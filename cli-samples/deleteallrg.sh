 #!/bin/bash
az group list --query "[].name" -o tsv >> group.txt
for i in `cat group.txt`
do
az group delete -g $i -y
done