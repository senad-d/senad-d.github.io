---
title: Grafana for Azure
date: 2023-02-02 13:00:00
categories: [Projects, Grafana]
tags: [azure, grafana]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/azure-banner.png?raw=true){: .shadow }

ARM template for adding an VM with a fully automated bootstrap script to create monitoring that automatically connects to Azure monitor (data source) for metrics and allows users easy viewing of key metrics for Azure resources.

<details><summary> Video </summary>

<div style="max-width: 100%; max-height: auto;">
  <video controls style="width: 100%; height: auto;">
    <source src="https://github.com/senad-d/senad-d.github.io/raw/main/_media/video/azure_arm_monitoring.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
</div>

</details>

## Creation Proces:
1. Create a Resource groups
2. Create [Azure Grafana ARM template](https://senad-d.github.io/posts/projects-grafana-azure-arm/)
3. Run the ARM template
4. Edit Subscription IAM
		- add Role assignment: Monitor Reade

## Resources creation for monitoring:
- Resource group
- Virtual network
- Network Interface
- Network security group
- Virtual machine [***UserData***](https://senad-d.github.io/posts/projects-grafana-azure-boot/)
- Public IP address
- Disk

***Grafana previsioned Data sources***: 
- Azure Monitor for getting metrics on network resources. Credentials will be with User assigned Managed Identity.
- InfluxDB data source in combination with Telegraf for getting metrics on service UpTime.
 
Custom [***dashboard***](https://senad-d.github.io/posts/projects-grafana-azure-dash/) for Azure resources.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/grafana_azure_env.jpg?raw=true){: .shadow }

## Running ARM temp from Azure CLI

1. Log in to Azure

   ```shell
   az login
   ```

2. Set the right subscription

   ```shell
   az account set --subscription "your subscription id"
   ```

3. Create the Resource group

   ```shell
   az account list-locations
   az group create --name "resource-group" --location "your location"
   ```

4. Deploy the ARM template

   ```shell
   az group deployment create --name "name of your deployment" --resource-group "resource-group" --template-file "./azuredeploy.json"
   ```

5. In Azure CLI fill in "Linux OS Password" parameter

-   At least 12 characters
-   A mixture of both uppercase and lowercase letters
-   A mixture of letters and numbers

6. Go to portal.azure.com and add the role assignment “Monitoring Reader” to the Subscription you want to monitor.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/Azure_IAM_Access_control.jpg?raw=true){: .shadow }

7. Visit GrafanaVM IP address (DNS name) to access the Grafana
  
- User: Admin
-   Password: admin