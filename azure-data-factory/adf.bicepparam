using './adf.bicep'

param factoryName = 'ADF-DEMO-WE'
param location = 'westeurope'
param identityType = 'UserAssigned'
param userAssignedIdentities = {
  '/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<managed-identity-name>': {}
}
param encryption = {
  identity: {
    userAssignedIdentity: '/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<managed-identity-name>'
  }
  keyName: '<key-name>'
  keyVersion: '0000000000000000000000000000000'
  vaultBaseUrl: '<key-vault-uri>'
}
param globalParameters = {
  restServiceUrl: {
    type: 'string'
    value: 'https://api.ProjectName.com'
  }
  maxRetryAttempts: {
    type: 'int'
    value: 5
  }
  enableLogging: {
    type: 'bool'
    value: true
  }
  allowedIPs: {
    type: 'array'
    value: [
      '192.168.1.1'
      '192.168.1.2'
    ]
  }
}
param publicNetworkAccess = 'Enabled'
param purviewConfiguration = {
  purviewResourceId: '/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Purview/accounts/<pureview-account-name>'
}
param repoConfiguration = {
  accountName: '<azure-devops-account-name>'
  collaborationBranch: 'main'
  disablePublish: false
  lastCommitId: '0000000000000000000000000000000'
  repositoryName: '<repo-name>'
  rootFolder: '/'
  type: 'FactoryVSTSConfiguration'
  projectName: '<projetc-name>'
}
param tags = {
  bicep: 'true'
  project: 'jorgebernhardt.com'
}
param logAnalyticsWorkspaceId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<log-analytics-wokspace-name>'
