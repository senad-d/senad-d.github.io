---
title: Azure OpenVPN ARM template
date: 2023-02-02 12:00:00
categories: [Projects, OpenVPN]
tags: [azure, openvpn, arm]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/azure-banner.png?raw=true){: .shadow }

ARM template for creating an automated VPN solution in Azure.
Add Resource group for OpenVPN VM with [***bootstrap***](https://senad-d.github.io/posts/projects-openvpn-azure-boot/) and start connecting to the resources in the account within 10 minutes.


```shell
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "metadata": {},
  "parameters": {
    "vmName": {
      "type": "string",
      "defaultValue": "OpenVPN",
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
      "defaultValue": "openvpn-vNet",
      "metadata": {
        "description": "Name of the VNET"
      }
    },
    "subnetName": {
      "type": "string",
      "defaultValue": "openvpn-Subnet",
      "metadata": {
        "description": "Name of the subnet in the virtual network"
      }
    },
    "networkSecurityGroupName": {
      "type": "string",
      "defaultValue": "openvpn-SGNet",
      "metadata": {
        "description": "Name of the Network Security Group"
      }
    },
    "resourceTags": {
      "type": "object",
      "defaultValue": {
        "Project": "OpenVPN"
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
              "protocol": "Udp",
              "access": "Allow",
              "direction": "Inbound",
              "sourceAddressPrefix": "*",
              "sourcePortRange": "*",
              "destinationAddressPrefix": "*",
              "destinationPortRange": "1194"
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
        "publicIPAllocationMethod": "Static",
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
        "userData": "IyEvYmluL2Jhc2gKCkFETUlOVVNFUj0iRmlyc3RuYW1lLUxhc3RuYW1lIgpFTUFJTD0iZXhhbXBsZUBlbWFpbC5jb20iCk9SRz0iRXhhbXBsZSIKQ09NUEFOWT0iRXhhbXBsZSIKQ0lUWT0iQ2l0eSIKTkVUQURBUFQ9JChpcCByb3V0ZSB8IGdyZXAgZGVmYXVsdCB8IHNlZCAtZSAicy9eLipkZXYuLy8iIC1lICJzLy5wcm90by4qLy8iKQoKIyBJbXBvcnQgdGhlIEdQRyBrZXkKd2dldCAtTyAtIGh0dHBzOi8vc3d1cGRhdGUub3BlbnZwbi5uZXQvcmVwb3MvcmVwby1wdWJsaWMuZ3BnfGFwdC1rZXkgYWRkIC0KCiMgQ3JlYXRlIHRoZSByZXBvc2l0b3J5IGZpbGUKZWNobyBkZWIgaHR0cDovL2J1aWxkLm9wZW52cG4ubmV0L2RlYmlhbi9vcGVudnBuL3N0YWJsZSBiaW9uaWMgbWFpbiB8IHRlZSAvZXRjL2FwdC9zb3VyY2VzLmxpc3QuZC9vcGVudnBuLSBhcHRyZXBvLmxpc3QKCiMgVXBkYXRlIGFwdCBhbmQgaW5zdGFsbCBPcGVuVlBOCmFwdCB1cGRhdGUgJiYgYXB0IGluc3RhbGwgb3BlbnZwbiAteQoKCiMgRG93bmxvYWQgJiBleHRyYWN0IEVhc3lSU0EKbWtkaXIgL2V0Yy9lYXN5LXJzYQp3Z2V0IGh0dHBzOi8vZ2l0aHViLmNvbS9PcGVuVlBOL2Vhc3ktcnNhL3JlbGVhc2VzL2Rvd25sb2FkL3YzLjAuNi9FYXN5UlNBLXVuaXgtdjMuMC42LnRneiAKdGFyIHhmIEVhc3lSU0EtdW5peC12My4wLjYudGd6IC1DIC9ldGMvZWFzeS1yc2EKbXYgL2V0Yy9lYXN5LXJzYS9FYXN5UlNBLXYzLjAuNi8qIC9ldGMvZWFzeS1yc2EKcm0gLXJmIC9ldGMvZWFzeS1yc2EvRWFzeVJTQS12My4wLjYKcm0gRWFzeVJTQS11bml4LXYzLjAuNi50Z3oKCgojIENvbmZpZ3VyZSB5b3VyIEVhc3lSU0EgZW52aXJvbm1lbnQgdmFyaWFibGVzIGZpbGUKY2F0IDw8RU9GID4gL2V0Yy9lYXN5LXJzYS92YXJzCnNldF92YXIgRUFTWVJTQV9SRVFfQ09VTlRSWSAgICAgIiRDSVRZIgpzZXRfdmFyIEVBU1lSU0FfUkVRX1BST1ZJTkNFICAgICIkQ0lUWSIKc2V0X3ZhciBFQVNZUlNBX1JFUV9DSVRZICAgICAgICAiJENJVFkiCnNldF92YXIgRUFTWVJTQV9SRVFfT1JHICAgICAgICAgIiRPUkciCnNldF92YXIgRUFTWVJTQV9SRVFfRU1BSUwgICAgICAgIiRFTUFJTCIKc2V0X3ZhciBFQVNZUlNBX1JFUV9PVSAgICAgICAgICAiUkQiCnNldF92YXIgRUFTWVJTQV9LRVlfU0laRSAgICAgICAgNDA5NgpFT0YKCmNkIC9yb290CiMgSW5pdGlhbGl6ZSB0aGUgUEtJIFN0cnVjdHVyZSBmb3IgRWFzeVJTQQovZXRjL2Vhc3ktcnNhL2Vhc3lyc2EgaW5pdC1wa2kKc2xlZXAgM3MKCnNsZWVwIDJzCiMgQ3JlYXRlIHRoZSBDQSBDZXJ0aWZpY2F0ZQplY2hvIHssfSB8IC9ldGMvZWFzeS1yc2EvZWFzeXJzYSBidWlsZC1jYSBub3Bhc3MKc2xlZXAgMjVzCmVjaG8geyx9IHwgL2V0Yy9lYXN5LXJzYS9lYXN5cnNhIGdlbi1yZXEgIiRDT01QQU5ZIi12cG4gbm9wYXNzCnNsZWVwIDJzCmVjaG8geWVzIHwgL2V0Yy9lYXN5LXJzYS9lYXN5cnNhIHNpZ24tcmVxIHNlcnZlciAiJENPTVBBTlkiLXZwbiBub3Bhc3MKc2xlZXAgMjBzCmNwIC9yb290L3twa2kvaXNzdWVkLyIkQ09NUEFOWSItdnBuLmNydCxwa2kvcHJpdmF0ZS8iJENPTVBBTlkiLXZwbi5rZXkscGtpL2NhLmNydH0gL2V0Yy9vcGVudnBuLwoKL2V0Yy9lYXN5LXJzYS9lYXN5cnNhIGdlbi1kaApzbGVlcCAycwoKL2V0Yy9lYXN5LXJzYS9lYXN5cnNhIGdlbi1jcmwKc2xlZXAgMjBzCgpjcCAvcm9vdC9wa2kvY3JsLnBlbSAvZXRjL29wZW52cG4vCm9wZW52cG4gLS1nZW5rZXkgLS1zZWNyZXQgIi9yb290L3RhLmtleSIKY3AgL3Jvb3QvdGEua2V5IC9ldGMvb3BlbnZwbgpjcCAvcm9vdC9wa2kvZGgucGVtIC9ldGMvb3BlbnZwbgoKIyBDcmVhdGUgeW91ciBPcGVuVlBOIFNlcnZlciBDb25maWd1cmF0aW9uCm1rZGlyIC1wIC9ldGMvb3BlbnZwbi9jbGllbnQtY29uZmlncy97ZmlsZXMsa2V5c30KZ3ppcCAtZCAvdXNyL3NoYXJlL2RvYy9vcGVudnBuL2V4YW1wbGVzL3NhbXBsZS1jb25maWctZmlsZXMvc2VydmVyLmNvbmYuZ3oKY3AgL3Vzci9zaGFyZS9kb2Mvb3BlbnZwbi9leGFtcGxlcy9zYW1wbGUtY29uZmlnLWZpbGVzL3NlcnZlci5jb25mIC9ldGMvb3BlbnZwbi8iJENPTVBBTlkiLXZwbi5jb25mCgpjcCAvcm9vdC97dGEua2V5LHBraS9jYS5jcnR9IC9ldGMvb3BlbnZwbi9jbGllbnQtY29uZmlncy9rZXlzLwpncm91cGFkZCBub2JvZHkKCmNhdCA8PEVPRiA+IC9ldGMvb3BlbnZwbi8iJENPTVBBTlkiLXZwbi5jb25mCjtsb2NhbCBhLmIuYy5kCnBvcnQgMTE5NAo7cHJvdG8gdGNwCnByb3RvIHVkcAo7ZGV2IHRhcApkZXYgdHVuCjtkZXYtbm9kZSBNeVRhcApjYSBjYS5jcnQKY2VydCAkQ09NUEFOWS12cG4uY3J0CmtleSAkQ09NUEFOWS12cG4ua2V5IApkaCBkaC5wZW0KO3RvcG9sb2d5IHN1Ym5ldApzZXJ2ZXIgMTAuOC4wLjAgMjU1LjI1NS4yNTUuMAppZmNvbmZpZy1wb29sLXBlcnNpc3QgL3Zhci9sb2cvb3BlbnZwbi9pcHAudHh0CjtzZXJ2ZXItYnJpZGdlIDEwLjguMC40IDI1NS4yNTUuMjU1LjAgMTAuOC4wLjUwIDEwLjguMC4xMDAKO3NlcnZlci1icmlkZ2UKO3B1c2ggInJvdXRlIDE5Mi4xNjguMTAuMCAyNTUuMjU1LjI1NS4wIgo7cHVzaCAicm91dGUgMTkyLjE2OC4yMC4wIDI1NS4yNTUuMjU1LjAiCjtjbGllbnQtY29uZmlnLWRpciBjY2QKO3JvdXRlIDE5Mi4xNjguNDAuMTI4IDI1NS4yNTUuMjU1LjI0OAo7Y2xpZW50LWNvbmZpZy1kaXIgY2NkCjtyb3V0ZSAxMC45LjAuMCAyNTUuMjU1LjI1NS4yNTIKO2xlYXJuLWFkZHJlc3MgLi9zY3JpcHQKcHVzaCAicmVkaXJlY3QtZ2F0ZXdheSBkZWYxIGJ5cGFzcy1kaGNwIgpwdXNoICJkaGNwLW9wdGlvbiBETlMgMS4xLjEuMSIKcHVzaCAiZGhjcC1vcHRpb24gRE5TIDguOC44LjgiCjtjbGllbnQtdG8tY2xpZW50CjtkdXBsaWNhdGUtY24Ka2VlcGFsaXZlIDEwIDEyMAp0bHMtYXV0aCB0YS5rZXkgMApjaXBoZXIgQUVTLTI1Ni1DQkMKO2NvbXByZXNzIGx6NC12Mgo7cHVzaCAiY29tcHJlc3MgbHo0LXYyIgo7Y29tcC1sem8KO21heC1jbGllbnRzIDEwMAp1c2VyIG5vYm9keQpncm91cCBub2JvZHkKcGVyc2lzdC1rZXkKcGVyc2lzdC10dW4Kc3RhdHVzIC92YXIvbG9nL29wZW52cG4vb3BlbnZwbi1zdGF0dXMubG9nCmxvZyAvdmFyL2xvZy9vcGVudnBuL29wZW52cG4ubG9nCjtsb2ctYXBwZW5kIC92YXIvbG9nL29wZW52cG4vb3BlbnZwbi5sb2cKdmVyYiAzCjttdXRlIDIwCiNleHBsaWNpdC1leGl0LW5vdGlmeSAxCmNybC12ZXJpZnkgL2V0Yy9vcGVudnBuL2NybC5wZW0Ka2V5LWRpcmVjdGlvbiAwCmF1dGggU0hBMjU2CnNuZGJ1ZiAzOTMyMTYKcmN2YnVmIDM5MzIxNgpwdXNoICJzbmRidWYgMzkzMjE2IgpwdXNoICJyY3ZidWYgMzkzMjE2Igp0eHF1ZXVlbGVuIDEwMDAwCkVPRgoKUFVCSVA9JChjdXJsIGlmY29uZmlnLm1lKQojIENyZWF0ZSB0aGUgY2xpZW50IGJhc2UgY29uZmlndXJhdGlvbgpjcCAvdXNyL3NoYXJlL2RvYy9vcGVudnBuL2V4YW1wbGVzL3NhbXBsZS1jb25maWctZmlsZXMvY2xpZW50LmNvbmYgL2V0Yy9vcGVudnBuL2NsaWVudC1jb25maWdzL2Jhc2UuY29uZgpjYXQgPDxFT0YgPiAvZXRjL29wZW52cG4vY2xpZW50LWNvbmZpZ3MvYmFzZS5jb25mCmNsaWVudAo7ZGV2IHRhcApkZXYgdHVuIAo7ZGV2LW5vZGUgTXlUYXAKO3Byb3RvIHRjcApwcm90byB1ZHAKcmVtb3RlICRQVUJJUCAxMTk0CjtyZW1vdGUgbXktc2VydmVyLTIgMTE5NAo7cmVtb3RlLXJhbmRvbQpyZXNvbHYtcmV0cnkgaW5maW5pdGUKbm9iaW5kCnVzZXIgbm9ib2R5Cmdyb3VwIG5vZ3JvdXAKcGVyc2lzdC1rZXkKcGVyc2lzdC10dW4KO2h0dHAtcHJveHktcmV0cnkgIyByZXRyeSBvbiBjb25uZWN0aW9uIGZhaWx1cmVzCjtodHRwLXByb3h5IFtwcm94eSBzZXJ2ZXJdIFtwcm94eSBwb3J0ICNdCjttdXRlLXJlcGxheS13YXJuaW5ncwojY2EgY2EuY3J0CiNjZXJ0IGNsaWVudC5jcnQKI2tleSBjbGllbnQua2V5CnJlbW90ZS1jZXJ0LXRscyBzZXJ2ZXIKY2lwaGVyIEFFUy0yNTYtQ0JDCnZlcmIgMwo7bXV0ZSAyMAo7ZnJhZ21lbnQgMAprZXktZGlyZWN0aW9uIDEKbXNzZml4IDAKYXV0aCBTSEEyNTYKRU9GCgojIFRoZSBDZXJ0aWZpY2F0ZSBDcmVhdGlvbiBTY3JpcHQKY2F0IDw8RU9GID4gL3Jvb3QvY3JlYXRlX3Zwbl91c2VyCiMhL2Jpbi9iYXNoCgpWUE5VU0VSPVwkezEsLH0KZXhwb3J0IEVBU1lSU0FfUkVRX0NOPVwkVlBOVVNFUgpPVVRQVVRfRElSPS9ldGMvb3BlbnZwbi9jbGllbnQtY29uZmlncy9maWxlcwpLRVlfRElSPS9ldGMvb3BlbnZwbi9jbGllbnQtY29uZmlncy9rZXlzCkJBU0VfQ09ORklHPS9ldGMvb3BlbnZwbi9jbGllbnQtY29uZmlncy9iYXNlLmNvbmYKT1BFTlZQTl9ESVI9L2V0Yy9vcGVudnBuCgpFQVNZUlNBX0RJUj0vcm9vdAoKaWYgWyAiXCRWUE5VU0VSIiA9ICcnIF07IHRoZW4KZWNobyAiVXNhZ2U6IC4vY3JlYXRlX3Zwbl91c2VyIGZpcnN0bmFtZS1sYXN0bmFtZSIKZXhpdCAxCgplbHNlCgplY2hvICJDcmVhdGluZyBjZXJ0aWZpY2F0ZSBmb3IgXCRWUE5VU0VSIgoKL2V0Yy9lYXN5LXJzYS9lYXN5cnNhIC0tYmF0Y2ggZ2VuLXJlcSBcJFZQTlVTRVIgbm9wYXNzCi9ldGMvZWFzeS1yc2EvZWFzeXJzYSAtLWJhdGNoIHNpZ24tcmVxIGNsaWVudCBcJFZQTlVTRVIKY3AgXCRFQVNZUlNBX0RJUi9wa2kvcHJpdmF0ZS9cJFZQTlVTRVIua2V5IC9ldGMvb3BlbnZwbi9jbGllbnQtY29uZmlncy9rZXlzLwoKY3AgXCRFQVNZUlNBX0RJUi9wa2kvaXNzdWVkL1wkVlBOVVNFUi5jcnQgL2V0Yy9vcGVudnBuL2NsaWVudC1jb25maWdzL2tleXMvCgpjZCBcJE9QRU5WUE5fRElSL2NsaWVudC1jb25maWdzLwojIEZpcnN0IGFyZ3VtZW50OiBDbGllbnQgaWRlbnRpZmllcgpjYXQgXCR7QkFTRV9DT05GSUd9IDwoZWNobyAtZSAnPGNhPicpIFwke0tFWV9ESVJ9L2NhLmNydCA8KGVjaG8gLWUgJzwvY2E+XG48Y2VydD4nKSBcJHtLRVlfRElSfS9cJHsxfS5jcnQgPChlY2hvIC1lICc8L2NlcnQ+XG48a2V5PicpIFwke0tFWV9ESVJ9L1wkezF9LmtleSA8KGVjaG8gLWUgJzwva2V5PlxuPHRscy1hdXRoPicpIFwke0tFWV9ESVJ9L3RhLmtleSA8KGVjaG8gLWUgJzwvdGxzLWF1dGg+JykgPiBcJHtPVVRQVVRfRElSfS9cJFZQTlVTRVIub3ZwbgoKZ3ppcCBcJE9VVFBVVF9ESVIvXCRWUE5VU0VSLm92cG4KCmN1cmwgLUYgImZpbGU9QFwkT1VUUFVUX0RJUi9cJFZQTlVTRVIub3Zwbi5neiIgaHR0cHM6Ly9maWxlLmlvLz9leHBpcmVzPTFkIHwgc2VkICdzL14uKmh0dHBzL2h0dHBzLycgfCBzZWQgJ3MvXCIsImV4cGlyZXMuKi8vJyA+IC9yb290L3Zwbi1jbGllbnQtbGluawplY2hvICIiCmVjaG8gIiIKZWNobyAtZSAiXGVbOTJtICoqKioqIEhlcmUgaXMgeW91ciBsaW5rIHdoaWNoIGhvbGRzIGNvbmZpZ3VyYXRpb24gZm9yIG9wZW4gdnBuICoqKioqIFxlWzBtIgplY2hvIC1lICJcZVs5Mm0gIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMgXGVbMG0iCmNhdCAvcm9vdC92cG4tY2xpZW50LWxpbmsgfCBzZWQgJ3MvLC9cbi9nJyB8IGhlYWQgLW4gMSB8IHNlZCAncy8uJC8vJwplY2hvIC1lICJcZVs5Mm0gIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMgXGVbMG0iCmVjaG8gIiIKCgpybSBcJE9VVFBVVF9ESVIvXCRWUE5VU0VSLm92cG4uZ3oKCmVjaG8gIkdlbmVyYXRpbmcgbmV3IENlcnRpZmljYXRlIFJldm9jYXRpb24gTGlzdCAoQ1JMKS4iCmNkIFwkRUFTWVJTQV9ESVIKL2V0Yy9lYXN5LXJzYS9lYXN5cnNhIGdlbi1jcmwKY3AgXCRFQVNZUlNBX0RJUi9wa2kvY3JsLnBlbSBcJE9QRU5WUE5fRElSL2NybC5wZW0Kc3lzdGVtY3RsIHJlc3RhcnQgb3BlbnZwbkAkQ09NUEFOWS12cG4KCnNsZWVwIDUKCmVjaG8gIkRpc3BsYXlpbmcgY29ubmVjdGVkIHVzZXJzOiIKY2F0IC92YXIvbG9nL29wZW52cG4vb3BlbnZwbi1zdGF0dXMubG9nIHwgc2VkICcvUk9VVElORy9xJ3wgaGVhZCAtbiAtMQoKZmkKCkVPRgoKY2htb2QgK3ggL3Jvb3QvY3JlYXRlX3Zwbl91c2VyCgojIENlcnRpZmljYXRlIFJldm9jYXRpb24gU2NyaXB0CmNhdCA8PEVPRiA+IC9yb290L3Jldm9rZV92cG5fdXNlcgojIS9iaW4vYmFzaAoKVlBOVVNFUj1cJHsxLCx9CmVjaG8gXCRWUE5VU0VSCmV4cG9ydCBFQVNZUlNBX1JFUV9DTj1cJFZQTlVTRVIKS0VZX0RJUj0vZXRjL29wZW52cG4vY2xpZW50LWNvbmZpZ3Mva2V5cwpPVVRQVVRfRElSPS9ldGMvb3BlbnZwbi9jbGllbnQtY29uZmlncy9maWxlcwpCQVNFX0NPTkZJRz0vZXRjL29wZW52cG4vY2xpZW50LWNvbmZpZ3MvYmFzZS5jb25mCk9QRU5WUE5fRElSPS9ldGMvb3BlbnZwbgoKRUFTWVJTQV9ESVI9L3Jvb3QKCmlmIFsgIlwkVlBOVVNFUiIgPSAnJyBdOyB0aGVuCmVjaG8gIlVzYWdlOiAuL3Jldm9rZV92cG5fdXNlciBmaXJzdG5hbWUtbGFzdG5hbWUiCmV4aXQgMQoKZWxzZQoKL2V0Yy9lYXN5LXJzYS9lYXN5cnNhIC0tYmF0Y2ggcmV2b2tlIFwkVlBOVVNFUgoKZWNobyAiVXBkYXRpbmcgQ1JMIChDZXJ0aWZpY2F0ZSBSZXZvY2F0aW9uIExpc3QpIgovZXRjL2Vhc3ktcnNhL2Vhc3lyc2EgZ2VuLWNybAoKY3AgXCRFQVNZUlNBX0RJUi9wa2kvY3JsLnBlbSBcJE9QRU5WUE5fRElSLwoKZWNobyAiUmVzdGFydGluZyBWUE4gc2VydmljZSB0byB1cGRhdGUgQ1JMIgoKc3lzdGVtY3RsIHJlc3RhcnQgb3BlbnZwbkAkQ09NUEFOWS12cG4KZWNobyAtZSAiXGVbOTJtIE9wZW5WUE4gaXMgXCQoc3lzdGVtY3RsIGlzLWVuYWJsZWQgb3BlbnZwbkAkQ09NUEFOWS12cG4pIGFuZCBcJChzeXN0ZW1jdGwgaXMtYWN0aXZlIG9wZW52cG5AJENPTVBBTlktdnBuKS4gXGVbMG0iCgpzbGVlcCA1CgplY2hvICJQbGVhc2UgZW5zdXJlIHVzZXIgaXMgbm90IGNvbm5lY3RlZCBmcm9tIHRoZSBsb2c6IgoKY2F0IC92YXIvbG9nL29wZW52cG4vb3BlbnZwbi1zdGF0dXMubG9nIHwgc2VkICcvUk9VVElORy9xJyB8IGhlYWQgLW4gLTEKCmZpCgpFT0YKCmNobW9kICt4IC9yb290L3Jldm9rZV92cG5fdXNlcgoKIyBDb25maWd1cmUgdGhlIE5ldHdvcmsgU3RhY2sKY2F0IDw8RU9GID4gL2V0Yy9zeXNjdGwuY29uZgpuZXQuaXB2NC5pcF9mb3J3YXJkPTEKRU9GCgojIFRoaXMgY29uZmlndXJlcyB0aGUgaXAgZm9yd2FyZCBmb3IgcGVyc2lzdGVuY2UsIGJ1dCB3ZSBuZWVkIHRvIHNldCBpdCBpbiB0aGUgcnVubmluZyBzdGFjayB0b28Kc3lzY3RsIG5ldC5pcHY0LmlwX2ZvcndhcmQ9MQojIEZpeCBJUCB0YWJsZXMKIyBpcCByb3V0ZSBsaXN0ICMgdGFpbCAtNTAgL3Zhci9sb2cvb3BlbnZwbi9vcGVudnBuLmxvZyAKaXB0YWJsZXMgLXQgbmF0IC1BIFBPU1RST1VUSU5HIC1zIDEwLjguMC4wLzE2IC1vICIkTkVUQURBUFQiIC1qIE1BU1FVRVJBREUKaXB0YWJsZXMgLXQgbmF0IC1JIFBPU1RST1VUSU5HIC1zIDEwLjguMC4wLzE2IC1kIDEwLjAuMC4wLzE2IC1vICIkTkVUQURBUFQiIC1qIE1BU1FVRVJBREUKaXB0YWJsZXMtc2F2ZQoKIyBTdGFydCBPcGVuVlBOCnN5c3RlbWN0bCBzdGFydCBvcGVudnBuQCIkQ09NUEFOWSItdnBuCnN5c3RlbWN0bCBlbmFibGUgb3BlbnZwbkAiJENPTVBBTlkiLXZwbgoKc2xlZXAgMnMKCiMgQ3JlYXRlIHVzZXIKIy9yb290L2NyZWF0ZV92cG5fdXNlciAiJEFETUlOVVNFUiIKCmVjaG8gLWUgIlxlWzkybSBPcGVuVlBOIGlzICQoc3lzdGVtY3RsIGlzLWVuYWJsZWQgb3BlbnZwbkAkQ09NUEFOWS12cG4pIGFuZCAkKHN5c3RlbWN0bCBpcy1hY3RpdmUgb3BlbnZwbkAkQ09NUEFOWS12cG4pLiBcZVswbSIKc2xlZXAgM3MK",
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