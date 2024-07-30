using '../main.bicep'

var vnetCidrBlocks = ['10.10.25.0/24']

var publicSubnetCidrBlock = '10.10.25.0/25'
var privateSubnetCidrBlock = '10.10.25.128/25'

param deployNetwork = true
param deployApplication = true

param vnetPrefixes = vnetCidrBlocks
param subnetsSetting = [
  {
    suffix: 'Public'
    ip: publicSubnetCidrBlock
    nsgSecurityRules: [
      {
        name: 'AllowHTTPSInboundFromInternet'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowHTTPInboundFromInternet'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
    ]
  }
  {
    suffix: 'Private'
    ip: privateSubnetCidrBlock
    nsgSecurityRules: [
      {
        name: 'AllowInboundFromPublicSubnet'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: publicSubnetCidrBlock
          destinationAddressPrefix: privateSubnetCidrBlock
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
]
