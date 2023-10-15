targetScope= 'subscription'
@metadata({
  Module : 'Azure Custom Roles'
  version: '0.1'
  deployBy: 'Jorge Bernhardt'
})

// Input parameter
param roles array

// Define the role resources based on the input
resource roleDefinitions 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' = [for role in roles: {
  name: guid(role.roleName)
  properties: {
    roleName: role.roleName
    description: role.description
    type: 'CustomRole'
    assignableScopes: [
      subscription().id
    ]
    permissions: role.permissions
  }
}]


// Output the names and IDs of the deployed roles
output deployedRoleNames array = [for i in range(0, length(roles) - 1): roleDefinitions[i].properties.roleName]
output deployedRoleIds array = [for i in range(0, length(roles) - 1): roleDefinitions[i].id]


