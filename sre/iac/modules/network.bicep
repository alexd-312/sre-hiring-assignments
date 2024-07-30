param region string

param virtualNetworkName string
param virtualNetworkAddressPrefixes array

param subnets array


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: region
  properties: {
    addressSpace: {
      addressPrefixes: virtualNetworkAddressPrefixes
    }
  }
}

@batchSize(1)
module thisSubnets 'subnet.bicep' = [for subnet in subnets: {
  name: subnet.name
  params: {
    addressPrefix: subnet.addressPrefix
    name: subnet.name
    nsgName: replace(subnet.name, 'sn', 'nsg')
    nsgSecurityRules: subnet.nsgSecurityRules
    region: region
    vnetName: virtualNetwork.name
  }
}]
