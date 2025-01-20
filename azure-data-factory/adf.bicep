@metadata({
  Module : 'Azure Data Factory'
  version: '1.0'
  deployBy: 'Jorge Bernhardt'
})

@description('The name of the Azure Data Factory.')
param factoryName string

@description('The location where the Azure Data Factory will be deployed.')
param location string = resourceGroup().location

@description('The type of identity to be used for the Azure Data Factory.')
@allowed([
  'SystemAssigned'
  'UserAssigned'
  'None'
])
param identityType string = 'SystemAssigned'

@description('The user assigned identities for the Azure Data Factory.')
param userAssignedIdentities object = {}

@description('The encryption settings for the Azure Data Factory.')
param encryption object = {
  identity: {
    userAssignedIdentity: ''
  }
  keyName: ''
  keyVersion: ''
  vaultBaseUrl: ''
}

@description('The global parameters for the Azure Data Factory.')
param globalParameters object = {}

@description('The public network access setting for the Azure Data Factory.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('The Purview configuration for the Azure Data Factory.')
param purviewConfiguration object = {
  purviewResourceId: ''
}

@description('The repository configuration for the Azure Data Factory.')
param repoConfiguration object = {
  accountName: 'AccountName'
  collaborationBranch: 'main'
  disablePublish: false
  lastCommitId: ''
  repositoryName: 'RepositoryName'
  rootFolder: '/'
  type: 'FactoryVSTSConfiguration'
  projectName: 'ProjectName'
}

@description('The tags to be associated with the Azure Data Factory.')
param tags object = {
  environment: 'dev'
  project: 'ProjectName'
}

@description('The resource ID of the Log Analytics workspace.')
param logAnalyticsWorkspaceId string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  location: location
  identity: {
    type: identityType
    userAssignedIdentities: identityType == 'UserAssigned' ? userAssignedIdentities : null
  }
  properties: {
    encryption: encryption
    globalParameters: globalParameters
    publicNetworkAccess: publicNetworkAccess
    purviewConfiguration: empty(purviewConfiguration.purviewResourceId) ? null : purviewConfiguration
    repoConfiguration: repoConfiguration
  }
  tags: tags
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'adf-diagnostic-settings'
  scope: dataFactory
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'PipelineRuns'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'ActivityRuns'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'TriggerRuns'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'SandboxPipelineRuns'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'SandboxActivityRuns'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'SSISPackageEventMessages'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'SSISPackageExecutableStatistics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'SSISPackageEventMessageContext'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'SSISPackageExecutionComponentPhases'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'SSISPackageExecutionDataStatistics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'SSISIntegrationRuntimeLogs'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
  }
}
resource dataFactoryDeleteLock 'Microsoft.Authorization/locks@2016-09-01' = {
  name: 'dataFactoryDeleteLock'
  properties: {
    level: 'CanNotDelete'
    notes: 'Lock to prevent accidental deletion of the Data Factory'
  }
  scope: dataFactory
}

output dataFactoryId string = dataFactory.id
output dataFactoryName string = dataFactory.name
output dataFactoryLocation string = dataFactory.location
output dataFactoryIdentityType string = dataFactory.identity.type
output dataFactoryPublicNetworkAccess string = dataFactory.properties.publicNetworkAccess
