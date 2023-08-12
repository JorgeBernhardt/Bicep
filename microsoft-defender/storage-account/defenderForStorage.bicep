targetScope = 'subscription'

@metadata({
  Module : 'Microsoft Defender for Storage Accounts'
  version: '0.1'
  deployBy: 'Jorge Bernhardt'
})

@description('Pricing tier for Microsoft Defender for Cloud. Standard offers advanced security capabilities, while Free offers basic security features.')
@allowed([
  'Free'
  'Standard'
])
param pricingTier string = 'Standard'

@description('Optional sub-plan selected for a Standard pricing configuration. Leave empty if the full plan is to be applied.')
param subPlan string = 'DefenderForStorageV2'

@description('Enable or disable the On-upload malware scanning feature.')
@allowed([
  true
  false
])
param onUploadMalwareScanningEnabled bool = true

@description('Monthly cap in GB for malware scanning per storage account. Set to -1 for unlimited scanning.')
param malwareScanningCapGB int

@description('Enable or disable the Sensitive data discovery feature.')
@allowed([
  true
  false
])
param sensitiveDataDiscoveryEnabled bool = true

resource defenderForStorageSettings 'Microsoft.Security/pricings@2023-01-01' = {
  name: 'StorageAccounts'
  properties: {
    pricingTier: pricingTier
    subPlan: (pricingTier == 'Free') ? null : subPlan
    extensions: (pricingTier == 'Standard') ? [
      {
        name: 'OnUploadMalwareScanning'
        isEnabled: string(onUploadMalwareScanningEnabled)
        additionalExtensionProperties: {
          CapGBPerMonthPerStorageAccount: malwareScanningCapGB
        }
      }
      {
        name: 'SensitiveDataDiscovery'
        isEnabled: string(sensitiveDataDiscoveryEnabled)
      }
    ] : []
  }
}

output pricingTierApplied string = defenderForStorageSettings.properties.pricingTier
output subPlanApplied string = (pricingTier == 'Standard') ? defenderForStorageSettings.properties.subPlan : 'N/A'
output onUploadMalwareScanningEnabledApplied string = (pricingTier == 'Standard') ? defenderForStorageSettings.properties.extensions[0].isEnabled : 'N/A'
output malwareScanningCapGBApplied string = (pricingTier == 'Standard') ? defenderForStorageSettings.properties.extensions[0].additionalExtensionProperties.CapGBPerMonthPerStorageAccount : 'N/A'
output sensitiveDataDiscoveryEnabledApplied string = (pricingTier == 'Standard') ? defenderForStorageSettings.properties.extensions[1].isEnabled : 'N/A'
