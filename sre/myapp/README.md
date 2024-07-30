*Resources

# Application

The application code is all in one file, main.py. It exposes the default page and 2 endpoints, one specific for healthcheck and one for the functionality.
The functionality endpoint has validation for the path param. 

To run the "myapp" application alone, build the docker image and run the container on port 8080:

```bash
docker build -t dummy-pdf-or-png .
docker run --rm -it -p 3000:3000 dummy-pdf-or-png
```

# Tests
Tests are located in tests/test_main.py. To run the tests you must install the requirements using pip. For safety, use a custom venv. 
```bash
python -m venv .venv #you can use any location instead of ".venv"
pip install -r requirements.txt
python3 -m pytest tests/test_main.py
```

The 3rd test is designed to test the integration with the dummyPDF service. To pass you need to also start dummy-pdf-or-png app.

For development purposes, both applications can be started using the compose configuration for Docker:
```bash
docker compose up
```
# Infrastructure
The infrastructure is a quick solution for deploying 2 containers in a Azure Container Instance resource. For IaC I chose bicep, a domain specific language by Microsoft.

The source code is aimed to show my approach on starting a new IaC repository. The network resources are not linked with the Container Instances. 

Prerequisites: 
Azure Account and Subscription
Existing Resource Group

To run the infrastructure, you can create a deployment using az cli. It is recommended to check the plan first, using the --what-if flag
```bash
az group deployment create --resource-group $YOUR_RG_NAME --name myAwsomeDeployment --parameters parameters/dev.bicepparam #--what-if
```

# Future improvements
* Create CI/CD pipelines
* Move the containers in a private network 
* Expose the app via an Azure AppGateway/LB 
* Use KV to refference the environment variables and handle secrets
* Adjust myapp logger to log relevant information
* Add Prometheus metrics
* Create managed identity and use it for the containers 


