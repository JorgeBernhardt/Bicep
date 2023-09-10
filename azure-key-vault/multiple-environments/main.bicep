targetScope= 'subscription'

@metadata({
  Module : 'Azure KeyVault - Multiple Environments'
  version: '0.1'
  author: 'Jorge Bernhardt'
})

@description('Array de Key Vaults para crear.')
param keyVaultArray array = []

@description('The tags to be associated with the resources.')
param tags object = {
  bicep: 'true'
}

// This module iterates over the keyVaultArray to create multiple Key Vaults
module keyVaultDeployments './modules/kv.bicep' = [for (keyVault, index) in keyVaultArray: {
  name: 'deployment${index}'
  params: {
    keyVaultName: '${keyVault.name}-${keyVault.environment}'
    location: keyVault.location
    tags: tags
    properties: {
      enabledForDeployment: keyVault.properties.enabledForDeployment
      enabledForDiskEncryption: keyVault.properties.enabledForDiskEncryption
      enabledForTemplateDeployment: keyVault.properties.enabledForTemplateDeployment
      enablePurgeProtection: keyVault.properties.enablePurgeProtection == false ? null : keyVault.properties.enablePurgeProtection
      enableSoftDelete: keyVault.properties.enableSoftDelete
      networkAcls: keyVault.properties.networkAcls
      publicNetworkAccess: keyVault.properties.publicNetworkAccess
      sku: keyVault.properties.sku
      softDeleteRetentionInDays: keyVault.properties.softDeleteRetentionInDays
      tenantId: keyVault.properties.tenantId
    }
  }
  scope: resourceGroup(keyVault.resourceGroupName)
}]

// Outputs to return the names and URIs of the deployed Key Vaults
output keyVaultInfo array = [for keyVault in keyVaultArray: {
  name: '${keyVault.name}-${keyVault.environment}'
  uri: 'https://${keyVault.name}-${keyVault.environment}${environment().suffixes.keyvaultDns}'
}]
