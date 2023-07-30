@metadata({
  Module : 'Microsoft Sentinel'
  version: '0.1'
  deployBy: 'Jorge Bernhardt'
})

// Parameters

@description('Specifies the Tenant ID for Azure Active Directory.')
param tenantId string 

@description('Name of the project or solution')
@minLength(3)
@maxLength(37)
param projectName string

@description('Specifies the location for all resources.')
@allowed([
  'westeurope'
  'northeurope'
])
param location string

@description('Specifies the SKU name for the workspace.')
@allowed([
  'PerGB2018'
  'Standard'
])
param skuName string = 'PerGB2018'

@description('Specifies the retention in days.')
@minValue(30)
@maxValue(730)
param retentionInDays int = 90

@description('Specifies the state of the AzureActiveDirectory connector.')
@allowed([
  'Enabled'
  'Disabled'
])
param dataState string = 'Enabled'

@description('The tags to be associated with the resources.')
param tags object = {
  bicep: 'true'
  environment: 'jorgebernhatdt.com'
}

// Variables

@description('Generated the workspace name.')
var workspaceName = 'law-${projectName}-${tags.environment}'

// Resources

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: skuName
    }
    retentionInDays: retentionInDays
  }
  tags: tags
}

resource sentinel 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'SecurityInsights(${workspaceName})'
  location: location
  properties: {
    workspaceResourceId: workspace.id
  }
  plan: {
    name: 'SecurityInsights(${workspaceName})'
    product: 'OMSGallery/SecurityInsights'
    promotionCode: ''
    publisher: 'Microsoft'
  }
  tags: tags
}

resource azureADDataConnector 'Microsoft.SecurityInsights/dataConnectors@2023-02-01-preview' = {
  name: '${workspaceName}-AzureActiveDirectory'
  kind: 'AzureActiveDirectory'
  scope: workspace
  dependsOn: [
    sentinel
  ]
  properties: {
    dataTypes: {
      alerts: {
        state: dataState
      }
    }
    tenantId: tenantId
  }
}

// Outputs

output workspaceId string = workspace.id
output workspaceName string = workspace.name
output solutionId string = sentinel.id
output solutionName string = sentinel.name
output dataConnectorId string = azureADDataConnector.id
