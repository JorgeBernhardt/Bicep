@metadata({
  Module : 'Azure Log Analytics Workspace'
  version: '0.1'
  author: 'Jorge Bernhardt'
})

@description('An array of objects, each representing the configuration for a Log Analytics workspace to be deployed.')
param workspaces array = []

@description('The tags to be associated with the resources.')
param tags object = {
  bicep: 'true'
  environment: 'jorgebernhardt.com'
}

var workspaceIds = [for workspace in workspaces: {
  id: resourceId('Microsoft.OperationalInsights/workspaces', workspace.name)
}]

resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' = [for workspace in workspaces: {
  name: workspace.name
  location: workspace.location
  tags: tags
  identity: {
    type: workspace.identityType
    userAssignedIdentities: workspace.identityType == 'UserAssigned' ? workspace.userAssignedIdentities : null
  }
  properties: {
    defaultDataCollectionRuleResourceId: workspace.defaultDataCollectionRuleResourceId
    features: {
      clusterResourceId: workspace.clusterResourceId
      disableLocalAuth: workspace.disableLocalAuth
      enableDataExport: workspace.enableDataExport
      enableLogAccessUsingOnlyResourcePermissions: workspace.enableLogAccessUsingOnlyResourcePermissions
      immediatePurgeDataOn30Days: workspace.immediatePurgeDataOn30Days
    }
    forceCmkForQuery: workspace.forceCmkForQuery
    publicNetworkAccessForIngestion: workspace.publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: workspace.publicNetworkAccessForQuery
    retentionInDays: workspace.retentionDays
    sku: {
      capacityReservationLevel: workspace.capacityReservationLevel
      name: workspace.skuName
    }
    workspaceCapping: {
      dailyQuotaGb: workspace.dailyQuotaGb
    }
  }
}]

output workspaceIds array = workspaceIds

