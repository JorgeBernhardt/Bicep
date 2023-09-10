@description('Name of the Key Vault.')
param keyVaultName string

@description('Azure location where the Key Vault will be deployed.')
param location string

@description('Tags to be associated with the Key Vault.')
param tags object

@description('Properties for configuring the Key Vault.')
param properties object

// Defining default values for specific properties
var defaultSkuFamily = 'A'
var defaultEnableRbacAuthorization = true

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName  
  location: location  
  tags: tags         
  properties: {
    enabledForDeployment: properties.enabledForDeployment
    enabledForDiskEncryption: properties.enabledForDiskEncryption
    enabledForTemplateDeployment: properties.enabledForTemplateDeployment
    enablePurgeProtection: properties.enablePurgeProtection
    enableRbacAuthorization: defaultEnableRbacAuthorization
    enableSoftDelete: properties.enableSoftDelete
    networkAcls: properties.networkAcls
    publicNetworkAccess: properties.publicNetworkAccess
    sku: {
      family: defaultSkuFamily
      name: properties.sku.name
    }
    softDeleteRetentionInDays: properties.softDeleteRetentionInDays
    tenantId: properties.tenantId
  }
}
