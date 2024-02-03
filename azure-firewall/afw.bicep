@metadata({
  Module : 'Azure Firewall'
  version: '0.1'
  author: 'Jorge Bernhardt'
})

@description('Name of the project or solution. Must be between 3 and 18 characters.')
@minLength(3)
@maxLength(18)
param projectName string

@description('The prefix for the Azure Firewall name.')
param firewallPrefix string = 'afw'

@description('The prefix for the Public IP name.')
param publicIPPrefix string = 'pip'

@description('Deployment Location')
@allowed([
  'westeurope'
  'northeurope'
  'uksouth'
])
param location string

@description('The SKU name of the Azure Firewall.')
@allowed([
  'AZFW_VNet'
  'AZFW_Hub'
])
param skuName string = 'AZFW_VNet'

@description('The SKU tier of the Azure Firewall.')
@allowed([
  'Standard'
  'Premium'
])
param skuTier string = 'Standard'

@description('The zones of the Azure Firewall.')
param zones array = ['1']

@description('The allocation method of the public IP address for the Azure Firewall.')
@allowed([
  'Static'
  'Dynamic'
])
param publicIPAllocationMethod string = 'Static'

@description('The IP version of the public IP address for the Azure Firewall.')
@allowed([
  'IPv4'
  'IPv6'
])
param publicIPAddressVersion string = 'IPv4'

@description('The name of the virtual network for the Azure Firewall.')
param vnetName string

@description('The name of the subnet for the Azure Firewall. This must be named "AzureFirewallSubnet".')
param subnetName string = 'AzureFirewallSubnet'

@description('The prefix for the subnet to be created. This must have a size of at least /26')
param subnetPrefix string

@description('List of service endpoints to be associated with the subnet.')
param serviceEndpoints array = []

@description('The tags to be associated with the resources.')
param tags object = {
  bicep: 'true'
  environment: 'jorgebernhatdt.com'
}

// Use string interpolation to combine the prefix and name
var firewallName = '${firewallPrefix}-${projectName}'
var publicIPName = '${publicIPPrefix}-${projectName}'

// Public IP address resource for Azure Firewall
resource publicIP 'Microsoft.Network/publicIPAddresses@2023-06-01' = {
  name: publicIPName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  zones: zones
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    publicIPAddressVersion: publicIPAddressVersion
  }
}
// Subnet resource to configure the subnet address range and associated service endpoints.
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-06-01' = {
  name: '${vnetName}/${subnetName}'
  properties: {
    addressPrefix: subnetPrefix
    serviceEndpoints: serviceEndpoints
    delegations: []
  }
}

// Azure Firewall resource
resource firewall 'Microsoft.Network/azureFirewalls@2023-06-01' = {
  name: firewallName
  location: location
  tags: tags
  properties: {
    sku: {
      name: skuName
      tier: skuTier
    }
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddress: {
            id: publicIP.id
          }
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
  zones: zones
}

// Output the name and public IP address of the firewall
@description('The resource ID of the Azure Firewall.')
output firewallResourceId string = firewall.id

@description('The public IP address of the Azure Firewall.')
output publicIPAddress string = publicIP.properties.ipAddress

