@metadata({
  Module : 'StorageAccount'
  version: '0.1'
  deployBy: 'Jorge Bernhardt'
})

@description('Name of the project or solution')
@minLength(3)
@maxLength(18)
param projectName string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param stoSKU string = 'Standard_LRS'


@description('Deployment Location')
@allowed([
  'westeurope'
  'northeurope'
])
param location string

@description('Resource tags')
param resourceTags object = {
  environment: 'jorgebernhardt.com'
}

var storageAccountName = toLower('stoacc${projectName}')

resource sto 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: stoSKU
  }
  kind: 'StorageV2'
  tags: resourceTags
}

output storageAccountId string = sto.id
output storageAccountName string = sto.name

