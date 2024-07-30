param deployNetwork bool
param deployApplication bool

param subnetsSetting array
param vnetPrefixes array

var tenant = 'alex'
var region = 'uksouth'

var namingConvention = '${tenant}-${region}-myapp'

var virtualNetwork = {
  name: 'vnet-${namingConvention}'
  vnetPrefixes: vnetPrefixes
}

var subnets = [
  for subnet in subnetsSetting: {
    name: 'sn-${namingConvention}-${subnet.suffix}'
    addressPrefix: subnet.ip
    nsgSecurityRules: subnet.nsgSecurityRules
  }
]

var acrName = replace('${namingConvention}sreAssignmentRegistry', '-', '')

var myAppImage = '${acrName}.azurecr.io/myApp:latest'
var dummyAppImage = '${acrName}.azurecr.io/dummyApp:latest'

var containersSettings = [
  {
    name: 'MyApp'
    properties: {
      image: myAppImage
      environmentVariables: [
        {
          name: 'GO_APP_ADDRESS'
          value: 'localhost:3000'
        }
        {
          name: 'MYAPP_TMP_FOLDER'
          value: '/tmp'
        }
      ]
      ports: [
        {
          port: 8080
          protocol: 'TCP'
        }
      ]
      resources: {
        requests: {
          cpu: 1
          memoryInGB: 1
        }
      }
    }
  }
  {
    name: dummyAppImage
    properties: {
      image: dummyAppImage
      ports: [
        {
          port: 3000
          protocol: 'TCP'
        }
      ]
      resources: {
        requests: {
          cpu: 1
          memoryInGB: 1
        }
      }
    }
  }
]

module network 'modules/network.bicep' = if (deployNetwork) {
  name: 'MyApp-Network'
  params: {
    region: region
    subnets: subnets
    virtualNetworkName: virtualNetwork.name
    virtualNetworkAddressPrefixes: virtualNetwork.vnetPrefixes
  }
}

resource acrResource 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: region
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

module application 'modules/application.bicep' = if (deployApplication) {
  name: 'MyApp-Containers'
  params: {
    region: region
    containersSettings: containersSettings
  }
}
