#!/bin/bash

## Requires az cli installed, authenticated and set to a target subscription
## Used to setup SPN for github actions https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-cli%2Clinux#use-the-azure-login-action-with-a-service-principal-secret
# Harvest the subscription ID here
RANDOM=$(LC_ALL=C tr -dc a-z0-9 </dev/urandom | head -c 4)
read  -p "Please enter your first name in lower case: " USERNAME
az provider register --namespace 'Microsoft.Compute' --wait
az provider register --namespace 'Microsoft.Network' --wait
export SUBSCRIPTION_ID=$(az account show | jq '.id' | sed 's/\"//g')
export TENANT_ID=$(az account show | jq '.tenantId' | sed 's/\"//g')
export STORAGE_ACCOUNT_NAME="pipeline$USERNAME$RANDOM"
export CONTAINER_NAME="terraformstate"
# Default name of the app registration we are creating
export WIZ_PIPELINE_SPN_NAME="wiz-pipeline-spn"
# Create the resource group
export WIZ_DEMO_RG_NAME="wizDemoResourceGroup"
export RESOURCE_GROUP_NAME=$(az group create --name $WIZ_DEMO_RG_NAME --location eastus | jq '.name' | sed 's/\"//g')
# Create storage account
az storage account create --resource-group $WIZ_DEMO_RG_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --auth-mode login
az ad sp create-for-rbac -n $WIZ_PIPELINE_SPN_NAME --role contributor --scopes /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$WIZ_DEMO_RG_NAME
echo "Subscription ID: $SUBSCRIPTION_ID"
echo "Storage Account Name: $STORAGE_ACCOUNT_NAME"
