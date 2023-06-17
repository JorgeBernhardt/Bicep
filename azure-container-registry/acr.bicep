@metadata({
  Module : 'Azure Container Registry'
  version: '0.1'
  deployBy: 'Jorge Bernhardt'
})

@description('Name of the project or solution. Must be between 3 and 18 characters.')
@minLength(3)
@maxLength(18)
param projectName string

@description('The location where the ACR should be created')
@allowed([
  'westeurope'
  'northeurope'
])
param location string

@allowed([
  'Basic'
  'Standard'
  'Premium'
])
@description('The SKU for the ACR')
param sku string = 'Premium'

@description('Flag indicating whether admin user should be enabled for the ACR')
param adminEnabled bool = false

@description('Flag indicating whether anonymous pull should be enabled')
param anonymousPullEnabled bool = false

@description('Flag indicating whether data endpoint should be enabled')
param dataEndpointEnabled bool = false

@allowed([
  'Allow'
  'Deny'
])
@description('The default action of network rule')
param defaultAction string = 'Allow'

@description('The IP address or range for network rule')
param ipAddress string

@description('Resource tags')
param resourceTags object = {
  environment: 'jorgebernhardt.com'
}

var uniqueStringForAcr = uniqueString(resourceGroup().id)
var acrName = toLower('acr${projectName}${uniqueStringForAcr}')

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  tags: resourceTags
  sku: {
    name: sku
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    adminUserEnabled: adminEnabled
    anonymousPullEnabled: anonymousPullEnabled
    dataEndpointEnabled: dataEndpointEnabled
    networkRuleSet: {
      defaultAction: defaultAction
      ipRules: [
        {
          action: 'Allow'
          value: ipAddress
        }
      ]
    }
  }
}
@description('The entire ACR resource object')
output acrObject object = acr


