@metadata({
  Module : 'Azure AD B2C'
  version: '0.1'
  deployBy: 'Jorge Bernhardt'
})

@description('Name of the project or solution')
@minLength(3)
@maxLength(37)
param projectName string

@description('The location where the AAD B2C Directory will be deployed.')
@allowed([
  'global'
  'unitedstates'
  'europe'
  'asiapacific'
  'australia'
  'japan'
])
param location string

@description('The name of the SKU for the AAD B2C Directory.')
@allowed([
  'PremiumP1'
  'PremiumP2'
  'Standard'
])
param skuName string = 'PremiumP1'

@description('The tier of the SKU for the AAD B2C Directory.')
@allowed([
  'A0'
])
param skuTier string = 'A0'

@description('The country code for the tenant.')
param countryCode string

@description('The display name for the AAD B2C Directory.')
param displayName string

@description('Resource tags')
param resourceTags object = {
  environment: 'jorgebernhardt.com'
}
var directoryName = toLower('${projectName}.onmicrosoft.com')

resource AzAdB2c 'Microsoft.AzureActiveDirectory/b2cDirectories@2021-04-01' = {
  name: directoryName
  location: location
  tags: resourceTags
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    createTenantProperties: {
      countryCode: countryCode
      displayName: displayName
    }
  }
}

output directoryId string = AzAdB2c.id
output directoryLocation string = AzAdB2c.location
output tenantId string = AzAdB2c.properties.tenantId
