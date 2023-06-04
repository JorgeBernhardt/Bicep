targetScope = 'subscription'

@metadata({
  Module : 'Assignment of built-in initiatives'
  version: '0.1'
  deployBy: 'Jorge Bernhardt'
})

@description('Array of policy initiatives. Each object should include an ID and a name.')
param initiatives array = [
  {
    id: '' // Replace with an initiative id
    name: '' // Replace with an initiative name
  }
]

@description('Deployment Location')
@allowed([
  'westeurope'
  'northeurope'
])
param location string = 'westeurope'

resource policyAssignments 'Microsoft.Authorization/policyAssignments@2022-06-01' = [for initiative in initiatives: {
  name: initiative.name 
  properties: {
    displayName: initiative.name
    policyDefinitionId: initiative.id 
  }
  identity: {
    type: 'SystemAssigned' 
  }
  location: location 
  scope: subscription() 
}]

// Output block to return the ids of each created policy assignment
output policyAssignmentIds array = [for initiative in initiatives: reference(initiative.name).policyDefinitionId]
