@metadata({
  Module : 'StorageAccount'
  version: '0.1'
  deployBy: 'Jorge Bernhardt'
})

@description('Name of the project or solution')
@minLength(3)
@maxLength(22)
param projectName string

@description('Deployment Location')
@allowed([
  'westeurope'
  'northeurope'
])
param location string

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
param stSKU string = 'Standard_LRS'

@description('Resource tags')
param resourceTags object = {
  environment: 'jorgebernhardt.com'
}
// This function ensures that the name is stored in lowercase.
var storageAccountName = toLower('st${projectName}')

resource st 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: stSKU
  }
  kind: 'StorageV2'
   properties: {
     accessTier: 'Hot'
   }
  tags: resourceTags
}

output storageAccountId string = st.id
output storageAccountName string = st.name

