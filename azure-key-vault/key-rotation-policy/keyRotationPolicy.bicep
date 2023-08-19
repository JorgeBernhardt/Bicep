@metadata({
  Module : 'Azure Key Vault - Rotation Policy'
  version: '0.1'
  author: 'Jorge Bernhardt'
})

@description('Specifies the name of the key vault to be created.')
param vaultName string

@description('Specifies the name of the key to be created within the vault.')
param keyName string

@description('Specifies the size of the RSA key.')
@allowed([
  2048
  3072
  4096
])
param rsaKeySize int = 2048

@description('Indicates if the key is active or not.')
param isKeyEnabled bool = true

@description('Specifies the duration after which the key should be rotated.')
@allowed([
  'P6M'
  'P1Y'
  'P2Y'
])
param rotationTimeAfterCreate string = 'P1Y'

@description('Specifies the expiration duration for the new key version.')
@allowed([
  'P7M'
  'P13M'
  'P25M'
])
param expiryTime string = 'P13M'

@description('Duration before key expiration to trigger a notification.')
@allowed([
  'P15D'
  'P30D'
  'P45D'
])
param notifyTimeBeforeExpiry string = 'P30D'

@description('The tags to be associated with the resources.')
param tags object = {
  bicep: 'true'
  environment: 'jorgebernhardt.com'
}

resource keyVaultKey 'Microsoft.KeyVault/vaults/keys@2023-02-01' = {
  name: '${vaultName}/${keyName}'
  tags: tags
  properties: {
    kty: 'RSA'
    keySize: rsaKeySize
    rotationPolicy: {
      lifetimeActions: [
        {
          trigger: {
            timeAfterCreate: rotationTimeAfterCreate
          }
          action: {
            type: 'rotate'
          }
        }
        {
          trigger: {
            timeBeforeExpiry: notifyTimeBeforeExpiry
          }
          action: {
            type: 'notify'
          }
        }
      ]
      attributes: {
        expiryTime: expiryTime
      }
    }
    attributes:{
      enabled: isKeyEnabled
    }
  }
}

output keyVaultKeyID string = keyVaultKey.id
output keyVaultKeyRotationPolicy object = keyVaultKey.properties.rotationPolicy
output keyVaultKeyExpirationTime string = keyVaultKey.properties.rotationPolicy.attributes.expiryTime
