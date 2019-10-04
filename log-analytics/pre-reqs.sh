#!/bin/bash
az group create -n log-analytics-export -l centralindia
az storage account create -n loganalyticsaccount -g log-analytics-export -l centralindia --sku Standard_LRS
echo 'Enter Storage Account Key'
read accountkey
echo 'Using Account Key '  $accountkey
az storage table create -n loganalyticslog --account-name loganalyticsexport --account-key "$accountkey"