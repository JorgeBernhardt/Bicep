// Define the parameters for the Elastic SAN configuration
// with default values and descriptions
@description('Basic configuration for the Elastic SAN resource.')
param elasticSan object = {
  name: ''
  location: ''
  baseSizeTiB: 0
  extendedCapacitySizeTiB: 0
  skuName: ''
  volumeGroupName: ''
  volumes: []
  subnetIds: []
}

// Define tags to be associated with the resources
@description('The tags to be associated with the resources.')
param tags object = {
  bicep: 'true'
  environment: 'jorgebernhardt.com'
}

// Create an Elastic SAN resource with the specified properties
resource elasticSanResource 'Microsoft.ElasticSan/elasticSans@2023-01-01' = {
  name: elasticSan.name
  location: elasticSan.location
  properties: {
    baseSizeTiB: elasticSan.baseSizeTiB
    extendedCapacitySizeTiB: elasticSan.extendedCapacitySizeTiB
    sku: {
      name: elasticSan.skuName
    }
  }
  tags: tags

  // Nested resource for volume groups within the Elastic SAN
  resource volumeGroup 'volumeGroups@2023-01-01' = {
    name: elasticSan.volumeGroupName
    properties: {
      protocolType: 'Iscsi'
      networkAcls: {
        virtualNetworkRules: [for subnetId in elasticSan.subnetIds: {
          id: subnetId
        }]
      }
    }

    // Nested resource for volumes within the volume group
    resource volumes 'volumes@2023-01-01' = [for volume in elasticSan.volumes: {
      name: volume.name
      properties: {
        sizeGiB: volume.sizeGiB
      }
    }]
  }
}

// Output the primary resource ID
output primaryResourceId string = elasticSanResource.id
