@metadata({
  Module : 'Azure Application Insights'
  version: '0.1'
  author: 'Jorge Bernhardt'
})

@description('Common tags for all resources.')
param commonTags object = {
  project: 'jorgebernhardt.com'
  bicep: 'true'
}

@description('Configuration parameters for the Log Analytics Workspace with default values.')
param logAnalyticsWorkspaceConfig object = {
  name: 'defaultLogAnalyticsWorkspace'
  location: resourceGroup().location
  retentionInDays: 30
  skuName: 'PerGB2018'
  enableDataExport: 'false'
  publicNetworkAccessForIngestion: 'Enabled'
  publicNetworkAccessForQuery: 'Enabled'
  dailyQuotaGb: -1
}

@description('Configuration parameters for the Application Insights component with default values.')
param applicationInsightsConfig object = {
  name: 'defaultApplicationInsights'
  kind: 'web'
  applicationType: 'web'
  samplingPercentage: 100
  disableLocalAuth: false
}

// Resource: Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceConfig.name
  location: logAnalyticsWorkspaceConfig.location
  tags: commonTags 
  properties: {
    sku: {
      name: logAnalyticsWorkspaceConfig.skuName
    }
    features:{
      enableDataExport: logAnalyticsWorkspaceConfig.enableDataExport
    }
    retentionInDays: logAnalyticsWorkspaceConfig.retentionInDays
    publicNetworkAccessForIngestion: logAnalyticsWorkspaceConfig.publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: logAnalyticsWorkspaceConfig.publicNetworkAccessForQuery
    workspaceCapping: {
      dailyQuotaGb: logAnalyticsWorkspaceConfig.dailyQuotaGb
    }
  }
}

// Resource: Application Insights
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsConfig.name
  location: logAnalyticsWorkspaceConfig.location
  kind: applicationInsightsConfig.kind
  tags: commonTags 
  properties: {
    Application_Type: applicationInsightsConfig.applicationType
    WorkspaceResourceId: logAnalyticsWorkspace.id
    SamplingPercentage: applicationInsightsConfig.samplingPercentage
    DisableLocalAuth: applicationInsightsConfig.disableLocalAuth
  }
}

// Output: Log Analytics Workspace Resource ID
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id

// Output: Application Insights Resource ID
output applicationInsightsId string = applicationInsights.id
