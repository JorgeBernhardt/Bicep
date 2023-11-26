@metadata({
  Module : 'Azure Virtual Machine Scale Sets'
  version: '0.1'
  author: 'Jorge Bernhardt'
})

@description('The location for all resources.')
@allowed([
  'westeurope'
  'northeurope'
])
param location string

@description('The SKU of the VM.')
param vmSku string

@description('The number of VM instances.')
param instanceCount int

@description('The prefix for the VMSS name.')
param nameSubfix string

@description('The ID of the subnet where the VMSS will be located.')
param subnetId string

@allowed([
  'Windows'
  'Ubuntu'
])
@description('The operating system type.')
param osType string

@description('The admin username for the VM.')
param adminUsername string

@secure()
@description('The admin password for the VM.')
param adminPassword string

@description('The tags to be associated with the VMSS.')
param tags object = {
  bicep: 'true'
  environment: 'jorgebernhatdt.com'
}

var osProfile = {
  computerNamePrefix: nameSubfix
  adminUsername: adminUsername
  adminPassword: adminPassword
  windowsConfiguration: osType == 'Windows' ? {
    enableAutomaticUpdates: true
  } : null
  linuxConfiguration: osType != 'Windows' ? {
    disablePasswordAuthentication: false
  } : null
}

var imageReference = {
  publisher: osType == 'Windows' ? 'MicrosoftWindowsServer' : 'Canonical'
  offer: osType == 'Windows' ? 'WindowsServer' : 'UbuntuServer'
  sku: osType == 'Windows' ? '2022-Datacenter' : '18_04-LTS-GEN2'
  version: 'latest'
}

var networkConfig = {
  networkInterfaceConfigurations: [
    {
      name: 'nic'
      properties: {
        primary: true
        ipConfigurations: [
          {
            name: 'ipconfig'
            properties: {
              subnet: {
                id: subnetId
              }
            }
          }
        ]
      }
    }
  ]
}

var osDiskConfig = {
  caching: 'ReadWrite'
  managedDisk: {
    storageAccountType: 'Standard_LRS'
  }
  createOption: 'FromImage'
}

var storageProfile = {
  imageReference: imageReference
  osDisk: osDiskConfig
}

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2023-07-01' = {
  name: 'vmss-${nameSubfix}'
  location: location
  tags: tags
  sku: {
    name: vmSku
    tier: 'Standard'
    capacity: instanceCount
  }
  properties: {
    overprovision: true
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      osProfile: osProfile
      storageProfile: storageProfile
      networkProfile: networkConfig
    }
  }
}

output vmssId string = vmss.id
output vmssName string = vmss.name
output vmssLocation string = vmss.location
