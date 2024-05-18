// Set the target scope to 'subscription' level.
targetScope = 'subscription'

@description('Name of the initiative.')
param initiativeName string

@description('Description of the initiative.')
param initiativeDescription string

@description('Category of the initiative.')
param initiativeCategory string

@description('Version of the initiative.')
param initiativeVersion string

@description('List of policies in the initiative.')
param policies array

resource storageGovernanceInitiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: initiativeName
  properties: {
    policyType: 'Custom' 
    displayName: initiativeName 
    description: initiativeDescription 
    metadata: {
      category: initiativeCategory
      version: initiativeVersion 
    }
    // Define the policy definitions included in this initiative.
    policyDefinitions: [
      for policy in policies: { // Iterate over each policy in the 'policies' parameter.
        policyDefinitionId: policy.policyId
        parameters: policy.parameters
      }
    ]
  }
}

// Output the resource ID of the created Initiative
output initiativeId string = storageGovernanceInitiative.id
