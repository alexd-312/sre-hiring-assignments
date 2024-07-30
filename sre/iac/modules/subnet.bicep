param vnetName string
param name string
param nsgName string
param region string
param addressPrefix string
param nsgSecurityRules array

resource vnet 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  name: vnetName
}

resource thisSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: name
  parent: vnet
  properties: {
    addressPrefix: addressPrefix
    networkSecurityGroup: {
      id: thisNSG.id
    }
  }
}

resource thisNSG 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: nsgName
  location: region
  properties: {
    flushConnection: false
    securityRules: nsgSecurityRules
  }
}
