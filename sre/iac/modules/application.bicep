param region string

param containersSettings array

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: 'SRE-Assignment-Containers'
  location: region
  properties: {
    containers: containersSettings
    osType: 'Linux'
    restartPolicy: 'Always'
    ipAddress: {
      type: 'Public'
      ports: [
        {
          port: 8080
          protocol: 'TCP'
        }
      ]
    }
  }
}
