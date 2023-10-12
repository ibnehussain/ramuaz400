#!/bin/bash

# Define variables
resource_group_name="newramuclidsc"
location="eastus"
vm_name="ramuvm001"
admin_username="myadminusr"
admin_password="qWerTy@swrd1019"
vm_size="Standard_B2s"
os_disk_name="myOsDisk"
nsg_name="myNSG"
http_port=80

# Create a resource group
az group create --name $resource_group_name --location $location

# Create a Windows Virtual Machine
az vm create \
  --resource-group $resource_group_name \
  --name $vm_name \
  --image win2019datacenter \
  --admin-username $admin_username \
  --admin-password $admin_password \
  --size $vm_size \
  --os-disk-size-gb 128 \
  --os-disk-name $os_disk_name \
  --public-ip-sku Standard \
  --nsg $nsg_name \
  --authentication-type password

# Open RDP Port (3389) in the Network Security Group (NSG)
az network nsg rule create --resource-group $resource_group_name --nsg-name $nsg_name --name RDP --priority 1000 --protocol Tcp --destination-port-range 3389 --access Allow

# Create an inbound rule to open port 80 (HTTP)
az network nsg rule create --resource-group $resource_group_name --nsg-name $nsg_name --name HTTP --priority 1100 --protocol Tcp --destination-port-range $http_port --access Allow
