// System-assigned managed identity
resource vm 'Microsoft.NetworkCloud/virtualMachines@2025-02-01' = {
  name: vmName
  location: location
  extendedLocation: {
    type: 'CustomLocation'
    name: extendedLocation
  }
  tags: tags
  properties: {
    adminUsername: (empty(adminUsername) ? null : adminUsername)
    bootMethod: (empty(bootMethod) ? null : bootMethod)
    cloudServicesNetworkAttachment: {
      attachedNetworkId: cloudServicesNetworkId
      ipAllocationMethod: 'Dynamic'
    }
    identity: {
      type: "SystemAssigned",
      tenantId: "{identity-tenant-id}"
      principalId: "{identity-principal-id}"
    }
    cpuCores: cpuCores
    memorySizeGB: memorySizeGB
    networkData: (empty(networkData) ? null : networkData)
    networkAttachments: (empty(networkAttachments) ? null : networkAttachments)
    placementHints: (empty(placementHints) ? null : placementHints)
    sshPublicKeys: (empty(sshPublicKeys) ? null : sshPublicKeys)
    storageProfile: (empty(storageProfile) ? null : storageProfile)
    userData: (empty(userData) ? null : userData)
    vmDeviceModel: (empty(vmDeviceModel) ? null : vmDeviceModel)
    vmImage: (empty(vmImage) ? null : vmImage)
    vmImageRepositoryCredentials: (empty(vmImageRepositoryCredentials) ? null : vmImageRepositoryCredentials)
  }
}

// User-assigned managed identity
resource vm 'Microsoft.NetworkCloud/virtualMachines@2025-02-01' = {
  name: vmName
  location: location
  extendedLocation: {
    type: 'CustomLocation'
    name: extendedLocation
  }
  tags: tags
  properties: {
    adminUsername: (empty(adminUsername) ? null : adminUsername)
    bootMethod: (empty(bootMethod) ? null : bootMethod)
    cloudServicesNetworkAttachment: {
      attachedNetworkId: cloudServicesNetworkId
      ipAllocationMethod: 'Dynamic'
    }
    identity: {
      type: "UserAssigned"
      userAssignedIdentities: {
        "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identity-name}": {
          clientId: "{identity-client-id}"
          principalId: "{identity-principal-id}"
        }
      }
    }
    cpuCores: cpuCores
    memorySizeGB: memorySizeGB
    networkData: (empty(networkData) ? null : networkData)
    networkAttachments: (empty(networkAttachments) ? null : networkAttachments)
    placementHints: (empty(placementHints) ? null : placementHints)
    sshPublicKeys: (empty(sshPublicKeys) ? null : sshPublicKeys)
    storageProfile: (empty(storageProfile) ? null : storageProfile)
    userData: (empty(userData) ? null : userData)
    vmDeviceModel: (empty(vmDeviceModel) ? null : vmDeviceModel)
    vmImage: (empty(vmImage) ? null : vmImage)
    vmImageRepositoryCredentials: (empty(vmImageRepositoryCredentials) ? null : vmImageRepositoryCredentials)
  }
}