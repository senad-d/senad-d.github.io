---
title: Azure Grafana ARM
date: 2023-02-02 13:00:00
categories: [Projects, Grafana]
tags: [azure, grafana, arm]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/azure-banner.png?raw=true){: .shadow }

ARM template for creating an automated monitoring solution for Azure resources.
Add a Resource group for monitoring VM with [bootstrap](https://senad-d.github.io/posts/projects-grafana-azure-boot/) and start monitoring resources in the account within 10 minutes.


```shell
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "metadata": {},
  "parameters": {
    "vmName": {
      "type": "string",
      "defaultValue": "GrafanaVM",
      "metadata": {
        "description": "The name of you Virtual Machine."
      }
    },
    "adminUsername": {
      "type": "string",
      "defaultValue": "azureuser",
      "metadata": {
        "description": "Username for the Virtual Machine."
      }
    },
    "authenticationType": {
      "type": "string",
      "defaultValue": "password",
      "allowedValues": [
        "sshPublicKey",
        "password"
      ],
      "metadata": {
        "description": "Type of authentication to use on the Virtual Machine. SSH key is recommended."
      }
    },
    "adminPasswordOrKey": {
      "type": "secureString",
      "metadata": {
        "description": "SSH Key or password for the Virtual Machine. SSH key is recommended."
      }
    },
    "dnsLabelPrefix": {
      "type": "string",
      "defaultValue": "[toLower(format('{0}-{1}', parameters('vmName'), uniqueString(resourceGroup().id)))]",
      "metadata": {
        "description": "Unique DNS Name for the Public IP used to access the Virtual Machine."
      }
    },
    "ubuntuOSVersion": {
      "type": "string",
      "defaultValue": "18.04-LTS",
      "metadata": {
        "description": "The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version."
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "metadata": {
        "description": "Location for all resources."
      }
    },
    "vmSize": {
      "type": "string",
      "defaultValue": "Standard_B2s",
      "metadata": {
        "description": "The size of the VM"
      }
    },
    "virtualNetworkName": {
      "type": "string",
      "defaultValue": "grafana-vNet",
      "metadata": {
        "description": "Name of the VNET"
      }
    },
    "subnetName": {
      "type": "string",
      "defaultValue": "grafana-Subnet",
      "metadata": {
        "description": "Name of the subnet in the virtual network"
      }
    },
    "networkSecurityGroupName": {
      "type": "string",
      "defaultValue": "grafana-SGNet",
      "metadata": {
        "description": "Name of the Network Security Group"
      }
    },
    "resourceTags": {
      "type": "object",
      "defaultValue": {
        "Project": "Monitoring"
      }
    }
  },
  "variables": {
    "publicIPAddressName": "[format('{0}PublicIP', parameters('vmName'))]",
    "networkInterfaceName": "[format('{0}NetInt', parameters('vmName'))]",
    "osDiskType": "Standard_LRS",
    "subnetAddressPrefix": "10.1.0.0/24",
    "addressPrefix": "10.1.0.0/16",
    "linuxConfiguration": {
      "disablePasswordAuthentication": true,
      "ssh": {
        "publicKeys": [
          {
            "path": "[format('/home/{0}/.ssh/authorized_keys', parameters('adminUsername'))]",
            "keyData": "[parameters('adminPasswordOrKey')]"
          }
        ]
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2020-11-01",
      "name": "[variables('networkInterfaceName')]",
      "location": "[parameters('location')]",
      "tags": "[parameters('resourceTags')]",
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', parameters('virtualNetworkName'), parameters('subnetName'))]"
              },
              "privateIPAllocationMethod": "Dynamic",
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPAddressName'))]"
              }
            }
          }
        ],
        "networkSecurityGroup": {
          "id": "[resourceId('Microsoft.Network/networkSecurityGroups', parameters('networkSecurityGroupName'))]"
        }
      },
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkSecurityGroups', parameters('networkSecurityGroupName'))]",
        "[resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPAddressName'))]",
        "[resourceId('Microsoft.Network/virtualNetworks/subnets', parameters('virtualNetworkName'), parameters('subnetName'))]"
      ]
    },
    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2020-11-01",
      "name": "[parameters('networkSecurityGroupName')]",
      "location": "[parameters('location')]",
      "tags": "[parameters('resourceTags')]",
      "properties": {
        "securityRules": [
          {
            "name": "HTTP",
            "properties": {
              "priority": 1000,
              "protocol": "Tcp",
              "access": "Allow",
              "direction": "Inbound",
              "sourceAddressPrefix": "*",
              "sourcePortRange": "*",
              "destinationAddressPrefix": "*",
              "destinationPortRange": "80"
            }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2020-11-01",
      "name": "[parameters('virtualNetworkName')]",
      "location": "[parameters('location')]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "[variables('addressPrefix')]"
          ]
        }
      }
    },
    {
      "type": "Microsoft.Network/virtualNetworks/subnets",
      "apiVersion": "2020-11-01",
      "name": "[format('{0}/{1}', parameters('virtualNetworkName'), parameters('subnetName'))]",
      "properties": {
        "addressPrefix": "[variables('subnetAddressPrefix')]",
        "privateEndpointNetworkPolicies": "Enabled",
        "privateLinkServiceNetworkPolicies": "Enabled"
      },
      "dependsOn": [
        "[resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworkName'))]"
      ]
    },
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "apiVersion": "2020-11-01",
      "name": "[variables('publicIPAddressName')]",
      "tags": "[parameters('resourceTags')]",
      "location": "[parameters('location')]",
      "sku": {
        "name": "Basic"
      },
      "properties": {
        "publicIPAllocationMethod": "Dynamic",
        "publicIPAddressVersion": "IPv4",
        "dnsSettings": {
          "domainNameLabel": "[parameters('dnsLabelPrefix')]"
        },
        "idleTimeoutInMinutes": 4
      }
    },
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2021-11-01",
      "name": "[parameters('vmName')]",
      "tags": "[parameters('resourceTags')]",
      "location": "[parameters('location')]",
      "identity": {
        "type": "SystemAssigned"
      },
      "properties": {
        "userData": "IyEvYmluL2Jhc2gKCiMjIyBJZiB5b3UgYXJlIHJ1bmluZyBqdXN0IGEgYmFzaCBzY3JpcHQgbWFrZSBzaHVyZSB0byBjaGFuZ2UgRE5TIG5hbWVzCkROUzE9InR5cGVxYXN0LmNvbSIKRE5TMj0iZXhhbXBsZTEuY29tIiAjIG9wdGlvbmFsCkROUzM9ImV4YW1wbGUyLmNvbSIgIyBvcHRpb25hbAojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCgphcHQgdXBkYXRlIC15CmFwdCBpbnN0YWxsIHdnZXQgY3VybCBnaXQgZG9ja2VyLmlvIC15CmN1cmwgLUwgaHR0cHM6Ly9naXRodWIuY29tL2RvY2tlci9jb21wb3NlL3JlbGVhc2VzL2xhdGVzdC9kb3dubG9hZC9kb2NrZXItY29tcG9zZS0kKHVuYW1lIC1zKS0kKHVuYW1lIC1tKSAtbyAvdXNyL2xvY2FsL2Jpbi9kb2NrZXItY29tcG9zZQpjaG1vZCAreCAvdXNyL2xvY2FsL2Jpbi9kb2NrZXItY29tcG9zZQpsbiAtcyAvdXNyL2xvY2FsL2Jpbi9kb2NrZXItY29tcG9zZSAvdXNyL2Jpbi9kb2NrZXItY29tcG9zZQpuZXdncnAgZG9ja2VyCnVzZXJhZGQgLWcgZG9ja2VyIC1zIC91c3IvYmluL2Jhc2ggLW0gZG9ja2VyCnVzZXJtb2QgLWEgLUcgZG9ja2VyIGF6dXJldXNlcgpzeXN0ZW1jdGwgZW5hYmxlIGRvY2tlci5zZXJ2aWNlCnN5c3RlbWN0bCBzdGFydCBkb2NrZXIuc2VydmljZQpta2RpciAtcCAvaG9tZS9henVyZXVzZXIvZG9ja2VyL2dyYWZhbmEve3Byb3Zpc2lvbmluZyxkYXNoYm9hcmRzfQpta2RpciAtcCAvaG9tZS9henVyZXVzZXIvZG9ja2VyL2dyYWZhbmEvcHJvdmlzaW9uaW5nL3tkYXRhc291cmNlcyxkYXNoYm9hcmRzfQpta2RpciAtcCAvaG9tZS9henVyZXVzZXIvZG9ja2VyL3RlbGVncmFmL2V0YwpjaG93biAtUiBhenVyZXVzZXI6ZG9ja2VyIC9ob21lL2F6dXJldXNlci9kb2NrZXIKY2F0IDw8RU9GID4gL2hvbWUvYXp1cmV1c2VyL2RvY2tlci9jb25maWd1cmF0aW9uLmVudgojIEdyYWZhbmEgb3B0aW9ucwpHRl9TRUNVUklUWV9BRE1JTl9VU0VSPWFkbWluCkdGX1NFQ1VSSVRZX0FETUlOX1BBU1NXT1JEPWFkbWluCkdGX0lOU1RBTExfUExVR0lOUz0KCiMgSW5mbHV4REIgb3B0aW9ucwpJTkZMVVhEQl9EQj1pbmZsdXgKSU5GTFVYREJfQURNSU5fVVNFUj0kKGRhdGUgKyVzIHwgc2hhMjU2c3VtIHwgYmFzZTY0IHwgaGVhZCAtYyA4IDsgZWNobykKSU5GTFVYREJfQURNSU5fUEFTU1dPUkQ9JChkYXRlICslcyB8IHNoYTI1NnN1bSB8IGJhc2U2NCB8IGhlYWQgLWMgMTIgOyBlY2hvKQpFT0YKCmNhdCA8PEVPRiA+IC9ob21lL2F6dXJldXNlci9kb2NrZXIvdGVsZWdyYWYvZXRjL3RlbGVncmFmLmNvbmYKW2dsb2JhbF90YWdzXQoKW2FnZW50XQogIGludGVydmFsID0gIjMwcyIKICByb3VuZF9pbnRlcnZhbCA9IHRydWUKICBtZXRyaWNfYnVmZmVyX2xpbWl0ID0gMTAwMDAKICBmbHVzaF9idWZmZXJfd2hlbl9mdWxsID0gdHJ1ZQogIGNvbGxlY3Rpb25faml0dGVyID0gIjBzIgogIGZsdXNoX2ludGVydmFsID0gIjEwcyIKICBmbHVzaF9qaXR0ZXIgPSAiMHMiCiAgZGVidWcgPSBmYWxzZQogIHF1aWV0ID0gZmFsc2UKICBob3N0bmFtZSA9ICIiCgpbW291dHB1dHMuaW5mbHV4ZGJdXQogIHVybHMgPSBbImh0dHA6Ly9pbmZsdXhkYjo4MDg2Il0gIyByZXF1aXJlZAogIGRhdGFiYXNlID0gImluZmx1eCIgIyByZXF1aXJlZAogIHByZWNpc2lvbiA9ICJzIgogIHRpbWVvdXQgPSAiNXMiCgpbW2lucHV0cy5zdGF0c2RdXQogIHByb3RvY29sID0gInVkcCIKICBtYXhfdGNwX2Nvbm5lY3Rpb25zID0gMjUwCiAgdGNwX2tlZXBfYWxpdmUgPSBmYWxzZQogIHNlcnZpY2VfYWRkcmVzcyA9ICI6ODEyNSIKICBkZWxldGVfZ2F1Z2VzID0gdHJ1ZQogIGRlbGV0ZV9jb3VudGVycyA9IHRydWUKICBkZWxldGVfc2V0cyA9IHRydWUKICBkZWxldGVfdGltaW5ncyA9IHRydWUKICBwZXJjZW50aWxlcyA9IFs5MF0KICBtZXRyaWNfc2VwYXJhdG9yID0gIl8iCiAgcGFyc2VfZGF0YV9kb2dfdGFncyA9IGZhbHNlCiAgYWxsb3dlZF9wZW5kaW5nX21lc3NhZ2VzID0gMTAwMDAKICBwZXJjZW50aWxlX2xpbWl0ID0gMTAwMAoKW1tpbnB1dHMuY3B1XV0KICBwZXJjcHUgPSB0cnVlCiAgdG90YWxjcHUgPSB0cnVlCiAgZmllbGRkcm9wID0gWyJ0aW1lXyoiXQogIGNvbGxlY3RfY3B1X3RpbWUgPSBmYWxzZQogIHJlcG9ydF9hY3RpdmUgPSBmYWxzZQoKW1tpbnB1dHMuZGlza11dCiAgaWdub3JlX2ZzID0gWyJ0bXBmcyIsICJkZXZ0bXBmcyIsICJkZXZmcyIsICJpc285NjYwIiwgIm92ZXJsYXkiLCAiYXVmcyIsICJzcXVhc2hmcyJdCgpbW2lucHV0cy5kaXNraW9dXQoKW1tpbnB1dHMua2VybmVsXV0KCltbaW5wdXRzLm1lbV1dCgpbW2lucHV0cy5wcm9jZXNzZXNdXQoKW1tpbnB1dHMuc3dhcF1dCgpbW2lucHV0cy5zeXN0ZW1dXQoKW1tpbnB1dHMubmV0XV0KCltbaW5wdXRzLm5ldHN0YXRdXQoKW1tpbnB1dHMuaW50ZXJydXB0c11dCgpbW2lucHV0cy5saW51eF9zeXNjdGxfZnNdXQoKW1tpbnB1dHMucGluZ11dCiAgdXJscyA9IFsiJEROUzEiLCAiJEROUzIiLCAiJEROUzMiXQogIGludGVydmFsID0gIjMwcyIKICBjb3VudCA9IDQKICBwaW5nX2ludGVydmFsID0gMS4wCiAgdGltZW91dCA9IDIuMApFT0YKCmNhdCA8PEVPRiA+IC9ob21lL2F6dXJldXNlci9kb2NrZXIvZ3JhZmFuYS9wcm92aXNpb25pbmcvZGF0YXNvdXJjZXMvZGF0YXNvdXJjZS55bWwKYXBpVmVyc2lvbjogMQoKZGVsZXRlRGF0YXNvdXJjZXM6CiAgLSBuYW1lOiBJbmZsdXhkYgogICAgb3JnSWQ6IDEKZGF0YXNvdXJjZXM6CiAgLSBuYW1lOiBJbmZsdXhEQgogICAgdHlwZTogaW5mbHV4ZGIKICAgIGFjY2VzczogcHJveHkKICAgIG9yZ0lkOiAxCiAgICB1cmw6IGh0dHA6Ly9pbmZsdXhkYjo4MDg2CiAgICBwYXNzd29yZDogImFkbWluIgogICAgdXNlcjogImFkbWluIgogICAgZGF0YWJhc2U6ICJpbmZsdXgiCiAgICBiYXNpY0F1dGg6IGZhbHNlCiAgICBpc0RlZmF1bHQ6IHRydWUKICAgIGpzb25EYXRhOgogICAgICB0aW1lSW50ZXJ2YWw6ICIzMHMiCiAgICB2ZXJzaW9uOiAxCiAgICBlZGl0YWJsZTogZmFsc2UKICAtIG5hbWU6IEF6dXJlIE1vbml0b3IKICAgIHR5cGU6IGdyYWZhbmEtYXp1cmUtbW9uaXRvci1kYXRhc291cmNlCiAgICBhY2Nlc3M6IHByb3h5CiAgICBqc29uRGF0YToKICAgICAgYXp1cmVBdXRoVHlwZTogbXNpCiAgICB2ZXJzaW9uOiAxCkVPRgoKY2F0IDw8RU9GID4gL2hvbWUvYXp1cmV1c2VyL2RvY2tlci9ncmFmYW5hL3Byb3Zpc2lvbmluZy9kYXNoYm9hcmRzL2Rhc2hib2FyZC55bWwKYXBpVmVyc2lvbjogMQoKcHJvdmlkZXJzOgotIG5hbWU6ICdkYXNoJwogIG9yZ0lkOiAxCiAgZm9sZGVyOiAnJwogIHR5cGU6IGZpbGUKICBkaXNhYmxlRGVsZXRpb246IGZhbHNlCiAgdXBkYXRlSW50ZXJ2YWxTZWNvbmRzOiAzMAogIG9wdGlvbnM6CiAgICBwYXRoOiAvdmFyL2xpYi9ncmFmYW5hL2Rhc2hib2FyZHMvCiAgICBmb2xkZXJzRnJvbUZpbGVzU3RydWN0dXJlOiB0cnVlCkVPRgoKZ2l0IGNsb25lIGh0dHBzOi8vZ2hwX3hWNldFTndFQ0dHMWNXT01KOU11Ylg4akVoeWh6ODJieWtmSkBnaXRodWIuY29tL3NlbmFkLWRpemRhcmV2aWMvZ3JhZmFuYS1kYXNoLmdpdCAvaG9tZS9henVyZXVzZXIvZG9ja2VyL3RlbXAKbXYgL2hvbWUvYXp1cmV1c2VyL2RvY2tlci90ZW1wL0F6dXJlL0F6dXJlLWRhc2guanNvbiAvaG9tZS9henVyZXVzZXIvZG9ja2VyL2dyYWZhbmEvZGFzaGJvYXJkcy9kYXNoLmpzb24KbXYgL2hvbWUvYXp1cmV1c2VyL2RvY2tlci90ZW1wL0F6dXJlL2dyYWZhbmEtY29uZiAvaG9tZS9henVyZXVzZXIvZG9ja2VyL2dyYWZhbmEvZGVmYXVsdHMuaW5pCnJtIC1yZiAvaG9tZS9henVyZXVzZXIvZG9ja2VyL3RlbXAKCmNhdCA8PEVPRiA+IC9ob21lL2F6dXJldXNlci9kb2NrZXIvZG9ja2VyLWNvbXBvc2UueW1sCnZlcnNpb246ICczLjYnCnNlcnZpY2VzOgogIHRlbGVncmFmOgogICAgaW1hZ2U6IHRlbGVncmFmOjEuMTgtYWxwaW5lCiAgICB2b2x1bWVzOgogICAgICAtIC4vdGVsZWdyYWYvZXRjL3RlbGVncmFmLmNvbmY6L2V0Yy90ZWxlZ3JhZi90ZWxlZ3JhZi5jb25mOnJvCiAgICBkZXBlbmRzX29uOgogICAgICAtIGluZmx1eGRiCiAgICBsaW5rczoKICAgICAgLSBpbmZsdXhkYgogICAgcG9ydHM6CiAgICAgIC0gJzgxMjU6ODEyNS91ZHAnCgogIGluZmx1eGRiOgogICAgaW1hZ2U6IGluZmx1eGRiOjEuOC1hbHBpbmUKICAgIGVudl9maWxlOiBjb25maWd1cmF0aW9uLmVudgogICAgcG9ydHM6CiAgICAgIC0gJzgwODY6ODA4NicKICAgIHZvbHVtZXM6CiAgICAgIC0gLi86L2ltcG9ydHMKICAgICAgLSBpbmZsdXhkYl9kYXRhOi92YXIvbGliL2luZmx1eGRiCgogIGdyYWZhbmE6CiAgICBpbWFnZTogZ3JhZmFuYS9ncmFmYW5hOjkuMS44CiAgICBkZXBlbmRzX29uOgogICAgICAtIGluZmx1eGRiCiAgICBlbnZfZmlsZTogY29uZmlndXJhdGlvbi5lbnYKICAgIGxpbmtzOgogICAgICAtIGluZmx1eGRiCiAgICBwb3J0czoKICAgICAgLSAnODA6MzAwMCcKICAgIHZvbHVtZXM6CiAgICAgIC0gZ3JhZmFuYV9kYXRhOi92YXIvbGliL2dyYWZhbmEKICAgICAgLSAuL2dyYWZhbmEvcHJvdmlzaW9uaW5nLzovZXRjL2dyYWZhbmEvcHJvdmlzaW9uaW5nLwogICAgICAtIC4vZ3JhZmFuYS9kYXNoYm9hcmRzLzovdmFyL2xpYi9ncmFmYW5hL2Rhc2hib2FyZHMvCiAgICAgIC0gLi9ncmFmYW5hL2RlZmF1bHRzLmluaTovdXNyL3NoYXJlL2dyYWZhbmEvY29uZi9kZWZhdWx0cy5pbmkKCnZvbHVtZXM6CiAgZ3JhZmFuYV9kYXRhOiB7fQogIGluZmx1eGRiX2RhdGE6IHt9CkVPRgoKZG9ja2VyLWNvbXBvc2UgLWYgL2hvbWUvYXp1cmV1c2VyL2RvY2tlci9kb2NrZXItY29tcG9zZS55bWwgdXAgLWQ=",
        "hardwareProfile": {
          "vmSize": "[parameters('vmSize')]"
        },
        "storageProfile": {
          "osDisk": {
            "createOption": "FromImage",
            "managedDisk": {
              "storageAccountType": "[variables('osDiskType')]"
            }
          },
          "imageReference": {
            "publisher": "Canonical",
            "offer": "UbuntuServer",
            "sku": "[parameters('ubuntuOSVersion')]",
            "version": "latest"
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('networkInterfaceName'))]"
            }
          ]
        },
        "osProfile": {
          "computerName": "[parameters('vmName')]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPasswordOrKey')]",
          "linuxConfiguration": "[if(equals(parameters('authenticationType'), 'password'), null(), variables('linuxConfiguration'))]"
        }
      },
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkInterfaces', variables('networkInterfaceName'))]"
      ]
    }
  ],
  "outputs": {
    "adminUsername": {
      "type": "string",
      "value": "[parameters('adminUsername')]"
    },
    "hostname": {
      "type": "string",
      "value": "[reference(resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPAddressName'))).dnsSettings.fqdn]"
    },
    "sshCommand": {
      "type": "string",
      "value": "[format('ssh {0}@{1}', parameters('adminUsername'), reference(resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPAddressName'))).dnsSettings.fqdn)]"
    }
  }
}
```