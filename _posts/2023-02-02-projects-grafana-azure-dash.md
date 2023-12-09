---
title: Azure Grafana bootstrap script
date: 2023-02-02 13:00:00
categories: [Projects, Grafana]
tags: [azure, grafana, dashboard]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/azure-banner.png?raw=true){: .shadow }

The Dashboard provides a comprehensive visualization of essential metrics derived from Azure services, enabling users to monitor and analyze the performance and health of their Azure resources. Built using Grafana, this dashboard offers a streamlined and intuitive interface that simplifies the interpretation of data and empowers users to make informed decisions.

```shell
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "datasource",
          "uid": "grafana"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "target": {
          "limit": 100,
          "matchAny": false,
          "tags": [],
          "type": "dashboard"
        },
        "type": "dashboard"
      }
    ]
  },
  "description": "Track metrics for services running on AWS using CloudWatch metrics",
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 18,
  "links": [],
  "liveNow": false,
  "panels": [
    {
      "datasource": {
        "type": "influxdb",
        "uid": "P951FEA4DE68E13C5"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "decimals": 4,
          "displayName": "Daily/Uptime",
          "mappings": [
            {
              "options": {
                "0": {
                  "index": 0,
                  "text": "Service down"
                }
              },
              "type": "value"
            }
          ],
          "noValue": "Service down",
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "rgba(245, 54, 54, 0.9)",
                "value": null
              },
              {
                "color": "rgba(237, 129, 40, 0.89)",
                "value": 95
              },
              {
                "color": "rgba(50, 172, 45, 0.97)",
                "value": 99.9
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 5,
        "x": 0,
        "y": 0
      },
      "id": 86,
      "interval": "",
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "mean"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "9.1.8",
      "targets": [
        {
          "datasource": {
            "type": "influxdb",
            "uid": "P951FEA4DE68E13C5"
          },
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1m"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "ping",
          "orderByTime": "ASC",
          "policy": "default",
          "query": "SELECT 100 - mean(\"percent_packet_loss\") FROM \"ping\" WHERE \"url\" =~ /^$PingURL$/ AND $timeFilter GROUP BY time(1m) fill(null)",
          "rawQuery": true,
          "refId": "A",
          "resultFormat": "table",
          "select": [
            [
              {
                "params": [
                  "percent_packet_loss"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "max"
              },
              {
                "params": [
                  " / 3600"
                ],
                "type": "math"
              }
            ]
          ],
          "tags": [
            {
              "key": "url",
              "operator": "=",
              "value": "208.67.222.222"
            }
          ]
        }
      ],
      "timeFrom": "24h",
      "transparent": true,
      "type": "stat"
    },
    {
      "datasource": {
        "type": "grafana-azure-monitor-datasource",
        "uid": "${ds}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 20,
            "gradientMode": "opacity",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "displayName": "${__field.displayName}",
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "decbytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "BytesUploaded_Sum"
            },
            "properties": [
              {
                "id": "unit",
                "value": "bytes"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 7,
        "w": 13,
        "x": 5,
        "y": 0
      },
      "id": 16,
      "links": [],
      "options": {
        "legend": {
          "calcs": [
            "mean",
            "lastNotNull",
            "max",
            "min"
          ],
          "displayMode": "table",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "9.1.8",
      "targets": [
        {
          "azureMonitor": {
            "aggregation": "Total",
            "allowedTimeGrainsMs": [
              60000,
              300000,
              900000,
              1800000,
              3600000,
              21600000,
              43200000,
              86400000
            ],
            "dimensionFilters": [],
            "metricName": "RequestSize",
            "metricNamespace": "microsoft.cdn/profiles",
            "resourceGroup": "$cdn_rg",
            "resourceName": "$cdn",
            "timeGrain": "auto"
          },
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "${ds}"
          },
          "queryType": "Azure Monitor",
          "refId": "A",
          "subscription": "$sub"
        }
      ],
      "title": "Site traffic",
      "transparent": true,
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "influxdb",
        "uid": "P951FEA4DE68E13C5"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "displayName": "Ping",
          "mappings": [],
          "noValue": "Service down",
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "rgba(50, 172, 45, 0.97)",
                "value": null
              },
              {
                "color": "rgba(237, 129, 40, 0.89)",
                "value": 50
              },
              {
                "color": "rgba(245, 54, 54, 0.9)",
                "value": 100
              }
            ]
          },
          "unit": "ms"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 6,
        "x": 18,
        "y": 0
      },
      "id": 87,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "last"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "value_and_name"
      },
      "pluginVersion": "9.1.8",
      "targets": [
        {
          "datasource": {
            "type": "influxdb",
            "uid": "P951FEA4DE68E13C5"
          },
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "$__interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "ping",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "A",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "average_response_ms"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              }
            ]
          ],
          "tags": [
            {
              "key": "url",
              "operator": "=~",
              "value": "/^$PingURL$/"
            }
          ]
        }
      ],
      "transparent": true,
      "type": "stat"
    },
    {
      "datasource": {
        "type": "influxdb",
        "uid": "P951FEA4DE68E13C5"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "decimals": 4,
          "displayName": "Weekly/Uptime",
          "mappings": [
            {
              "options": {
                "0": {
                  "index": 0,
                  "text": "Service down"
                }
              },
              "type": "value"
            }
          ],
          "noValue": "Service down",
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "rgba(245, 54, 54, 0.9)",
                "value": null
              },
              {
                "color": "rgba(237, 129, 40, 0.89)",
                "value": 95
              },
              {
                "color": "rgba(50, 172, 45, 0.97)",
                "value": 99.9
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 5,
        "x": 0,
        "y": 5
      },
      "id": 84,
      "interval": "",
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "mean"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "9.1.8",
      "targets": [
        {
          "datasource": {
            "type": "influxdb",
            "uid": "P951FEA4DE68E13C5"
          },
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1m"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "ping",
          "orderByTime": "ASC",
          "policy": "default",
          "query": "SELECT 100 - mean(\"percent_packet_loss\") FROM \"ping\" WHERE \"url\" =~ /^$PingURL$/ AND $timeFilter GROUP BY time(1m) fill(null)",
          "rawQuery": true,
          "refId": "A",
          "resultFormat": "table",
          "select": [
            [
              {
                "params": [
                  "percent_packet_loss"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "max"
              },
              {
                "params": [
                  " / 3600"
                ],
                "type": "math"
              }
            ]
          ],
          "tags": [
            {
              "key": "url",
              "operator": "=",
              "value": "208.67.222.222"
            }
          ]
        }
      ],
      "timeFrom": "168h",
      "transparent": true,
      "type": "stat"
    },
    {
      "datasource": {
        "type": "influxdb",
        "uid": "P951FEA4DE68E13C5"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 100,
            "gradientMode": "opacity",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "ms"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 6,
        "x": 18,
        "y": 5
      },
      "id": 44,
      "links": [],
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": false
        },
        "tooltip": {
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "9.1.8",
      "targets": [
        {
          "alias": "$tag_url",
          "datasource": {
            "type": "influxdb",
            "uid": "P951FEA4DE68E13C5"
          },
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "$__interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "url"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "ping",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "A",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "average_response_ms"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "max"
              }
            ]
          ],
          "tags": [
            {
              "key": "url",
              "operator": "=~",
              "value": "/^$PingURL$/"
            }
          ]
        }
      ],
      "title": "Ping Response Time",
      "transparent": true,
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "grafana-azure-monitor-datasource",
        "uid": "${ds}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 20,
            "gradientMode": "opacity",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "displayName": "${__field.displayName}",
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "short"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "VolumeIdleTime_Average"
            },
            "properties": [
              {
                "id": "unit",
                "value": "percent"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "TotalErrorRate_Sum"
            },
            "properties": [
              {
                "id": "unit",
                "value": "percent"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "TotalErrorRate_Average"
            },
            "properties": [
              {
                "id": "unit",
                "value": "percent"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 6,
        "w": 13,
        "x": 5,
        "y": 7
      },
      "id": 12,
      "links": [],
      "options": {
        "legend": {
          "calcs": [
            "mean",
            "lastNotNull",
            "max",
            "min",
            "sum"
          ],
          "displayMode": "table",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "9.1.8",
      "targets": [
        {
          "azureMonitor": {
            "aggregation": "Count",
            "allowedTimeGrainsMs": [
              60000,
              300000,
              900000,
              1800000,
              3600000,
              21600000,
              43200000,
              86400000
            ],
            "dimensionFilters": [],
            "metricName": "OriginRequestCount",
            "metricNamespace": "microsoft.cdn/profiles",
            "resourceGroup": "$cdn_rg",
            "resourceName": "$cdn",
            "timeGrain": "auto"
          },
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "${ds}"
          },
          "queryType": "Azure Monitor",
          "refId": "A",
          "subscription": "$sub"
        }
      ],
      "title": "API Requests",
      "transparent": true,
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "influxdb",
        "uid": "P951FEA4DE68E13C5"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "decimals": 4,
          "displayName": "Monthly/Uptime",
          "mappings": [
            {
              "options": {
                "0": {
                  "index": 0,
                  "text": "Service down"
                }
              },
              "type": "value"
            }
          ],
          "noValue": "Service down",
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "rgba(245, 54, 54, 0.9)",
                "value": null
              },
              {
                "color": "rgba(237, 129, 40, 0.89)",
                "value": 95
              },
              {
                "color": "rgba(50, 172, 45, 0.97)",
                "value": 99.9
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 5,
        "x": 0,
        "y": 10
      },
      "id": 85,
      "interval": "",
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "mean"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "9.1.8",
      "targets": [
        {
          "datasource": {
            "type": "influxdb",
            "uid": "P951FEA4DE68E13C5"
          },
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1m"
              ],
              "type": "time"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "ping",
          "orderByTime": "ASC",
          "policy": "default",
          "query": "SELECT 100 - mean(\"percent_packet_loss\") FROM \"ping\" WHERE \"url\" =~ /^$PingURL$/ AND $timeFilter GROUP BY time(1m) fill(null)",
          "rawQuery": true,
          "refId": "A",
          "resultFormat": "table",
          "select": [
            [
              {
                "params": [
                  "percent_packet_loss"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "max"
              },
              {
                "params": [
                  " / 3600"
                ],
                "type": "math"
              }
            ]
          ],
          "tags": [
            {
              "key": "url",
              "operator": "=",
              "value": "208.67.222.222"
            }
          ]
        }
      ],
      "timeFrom": "720h",
      "transparent": true,
      "type": "stat"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "influxdb",
        "uid": "P951FEA4DE68E13C5"
      },
      "fill": 1,
      "fillGradient": 2,
      "gridPos": {
        "h": 5,
        "w": 6,
        "x": 18,
        "y": 10
      },
      "hiddenSeries": false,
      "id": 46,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": false,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "9.1.8",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "alias": "$tag_url",
          "datasource": {
            "type": "influxdb",
            "uid": "P951FEA4DE68E13C5"
          },
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "$__interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "url"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "ping",
          "orderByTime": "ASC",
          "policy": "default",
          "query": "SELECT max(\"percent_packet_loss\") FROM \"ping\" WHERE \"url\" = '208.67.222.222' AND $timeFilter GROUP BY time(1m) fill(null)",
          "rawQuery": false,
          "refId": "A",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "percent_packet_loss"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "max"
              }
            ]
          ],
          "tags": [
            {
              "key": "url",
              "operator": "=~",
              "value": "/^$PingURL$/"
            }
          ]
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Packet Loss Percentage",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "transparent": true,
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:132",
          "format": "percent",
          "logBase": 1,
          "max": "100",
          "min": "0",
          "show": true
        },
        {
          "$$hashKey": "object:133",
          "format": "short",
          "logBase": 1,
          "show": true
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "datasource": {
        "type": "grafana-azure-monitor-datasource",
        "uid": "${ds}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 20,
            "gradientMode": "opacity",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "displayName": "${__field.displayName}",
          "mappings": [],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 9,
        "w": 13,
        "x": 5,
        "y": 13
      },
      "id": 90,
      "links": [],
      "options": {
        "legend": {
          "calcs": [
            "max",
            "min"
          ],
          "displayMode": "table",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "9.1.8",
      "targets": [
        {
          "azureMonitor": {
            "aggregation": "Average",
            "allowedTimeGrainsMs": [
              60000,
              300000,
              900000,
              1800000,
              3600000,
              21600000,
              43200000,
              86400000
            ],
            "dimensionFilters": [],
            "metricName": "Percentage4XX",
            "metricNamespace": "microsoft.cdn/profiles",
            "resourceGroup": "$cdn_rg",
            "resourceName": "$cdn",
            "timeGrain": "auto"
          },
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "${ds}"
          },
          "queryType": "Azure Monitor",
          "refId": "A",
          "subscription": "$sub"
        },
        {
          "azureMonitor": {
            "aggregation": "Average",
            "allowedTimeGrainsMs": [
              60000,
              300000,
              900000,
              1800000,
              3600000,
              21600000,
              43200000,
              86400000
            ],
            "dimensionFilters": [],
            "metricName": "Percentage5XX",
            "metricNamespace": "microsoft.cdn/profiles",
            "resourceGroup": "$cdn_rg",
            "resourceName": "$cdn",
            "timeGrain": "auto"
          },
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "${ds}"
          },
          "hide": false,
          "queryType": "Azure Monitor",
          "refId": "B",
          "subscription": "$sub"
        }
      ],
      "title": "TotalErrorRate",
      "transparent": true,
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "grafana-azure-monitor-datasource",
        "uid": "${ds}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 20,
            "gradientMode": "opacity",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "normal"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "displayName": "${__field.displayName}",
          "mappings": [],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 5,
        "x": 0,
        "y": 15
      },
      "id": 89,
      "links": [],
      "options": {
        "legend": {
          "calcs": [
            "max",
            "min"
          ],
          "displayMode": "table",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "9.1.8",
      "targets": [
        {
          "azureMonitor": {
            "aggregation": "Average",
            "allowedTimeGrainsMs": [
              60000,
              300000,
              900000,
              1800000,
              3600000,
              21600000,
              43200000,
              86400000
            ],
            "dimensionFilters": [],
            "metricName": "Percentage5XX",
            "metricNamespace": "microsoft.cdn/profiles",
            "resourceGroup": "$cdn_rg",
            "resourceName": "$cdn",
            "timeGrain": "auto"
          },
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "${ds}"
          },
          "queryType": "Azure Monitor",
          "refId": "A",
          "subscription": "$sub"
        }
      ],
      "title": "CDN 5xx Issues",
      "transparent": true,
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "grafana-azure-monitor-datasource",
        "uid": "${ds}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 20,
            "gradientMode": "opacity",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "normal"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "displayName": "${__field.displayName}",
          "mappings": [],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 6,
        "x": 18,
        "y": 15
      },
      "id": 18,
      "links": [],
      "options": {
        "legend": {
          "calcs": [
            "max",
            "min"
          ],
          "displayMode": "table",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "9.1.8",
      "targets": [
        {
          "azureMonitor": {
            "aggregation": "Average",
            "allowedTimeGrainsMs": [
              60000,
              300000,
              900000,
              1800000,
              3600000,
              21600000,
              43200000,
              86400000
            ],
            "dimensionFilters": [],
            "metricName": "Percentage4XX",
            "metricNamespace": "microsoft.cdn/profiles",
            "resourceGroup": "$cdn_rg",
            "resourceName": "$cdn",
            "timeGrain": "auto"
          },
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "${ds}"
          },
          "queryType": "Azure Monitor",
          "refId": "A",
          "subscription": "$sub"
        }
      ],
      "title": "CDN 4xx Issues",
      "transparent": true,
      "type": "timeseries"
    },
    {
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 22
      },
      "id": 94,
      "panels": [
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "${ds}"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 10,
                "gradientMode": "opacity",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 2,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "auto",
                "spanNulls": false,
                "stacking": {
                  "group": "A",
                  "mode": "percent"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "mappings": [],
              "max": 100,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "percent"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 7,
            "w": 11,
            "x": 0,
            "y": 23
          },
          "id": 92,
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "single",
              "sort": "none"
            }
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "azureMonitor": {
                "aggregation": "Minimum",
                "allowedTimeGrainsMs": [
                  60000,
                  300000,
                  900000,
                  1800000,
                  3600000,
                  21600000,
                  43200000,
                  86400000
                ],
                "dimensionFilters": [],
                "metricName": "DipAvailability",
                "metricNamespace": "microsoft.network/loadbalancers",
                "resourceGroup": "$cdn_rg",
                "resourceName": "$lb",
                "timeGrain": "auto"
              },
              "datasource": {
                "type": "grafana-azure-monitor-datasource",
                "uid": "${ds}"
              },
              "queryType": "Azure Monitor",
              "refId": "A",
              "subscription": "$sub"
            }
          ],
          "title": "Load Balancer - Healthy Count",
          "transparent": true,
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "${ds}"
          },
          "description": "",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "auto",
                "spanNulls": false,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "bytes"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 7,
            "w": 13,
            "x": 11,
            "y": 23
          },
          "id": 96,
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "single",
              "sort": "none"
            }
          },
          "targets": [
            {
              "azureMonitor": {
                "aggregation": "Total",
                "allowedTimeGrainsMs": [
                  60000,
                  300000,
                  900000,
                  1800000,
                  3600000,
                  21600000,
                  43200000,
                  86400000
                ],
                "dimensionFilters": [],
                "metricName": "ByteCount",
                "metricNamespace": "microsoft.network/loadbalancers",
                "resourceGroup": "Grafana-testing",
                "resourceName": "grafana-LB",
                "timeGrain": "auto"
              },
              "datasource": {
                "type": "grafana-azure-monitor-datasource",
                "uid": "${ds}"
              },
              "queryType": "Azure Monitor",
              "refId": "A",
              "subscription": "0e221a1b-69be-4f9f-8cd0-2122054bf7f1"
            }
          ],
          "title": "Load balancer -Traffic",
          "transparent": true,
          "type": "timeseries"
        }
      ],
      "title": "Load Balancer",
      "type": "row"
    },
    {
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 23
      },
      "id": 124,
      "panels": [
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "$ds"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "mappings": [],
              "thresholds": {
                "mode": "percentage",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 99
                  },
                  {
                    "color": "green",
                    "value": 100
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 4,
            "x": 0,
            "y": 31
          },
          "id": 130,
          "options": {
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "/^Availability$/",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": false,
            "text": {}
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": "00000000-0000-0000-0000-000000000000"
              },
              "azureMonitor": {
                "aggOptions": [
                  "Average",
                  "Minimum",
                  "Maximum"
                ],
                "aggregation": "Average",
                "alias": "Availability",
                "allowedTimeGrainsMs": [
                  60000,
                  300000,
                  900000,
                  1800000,
                  3600000,
                  21600000,
                  43200000,
                  86400000
                ],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "dimensions": [
                  {
                    "text": "Geo type",
                    "value": "GeoType"
                  },
                  {
                    "text": "API name",
                    "value": "ApiName"
                  },
                  {
                    "text": "Authentication",
                    "value": "Authentication"
                  }
                ],
                "metricDefinition": "$ns",
                "metricName": "Availability",
                "metricNamespace": "microsoft.storage/storageaccounts",
                "resourceGroup": "$storage_rg",
                "resourceName": "$stor",
                "timeGrain": "auto",
                "timeGrains": [
                  {
                    "text": "auto",
                    "value": "auto"
                  },
                  {
                    "text": "1 minute",
                    "value": "PT1M"
                  },
                  {
                    "text": "5 minutes",
                    "value": "PT5M"
                  },
                  {
                    "text": "15 minutes",
                    "value": "PT15M"
                  },
                  {
                    "text": "30 minutes",
                    "value": "PT30M"
                  },
                  {
                    "text": "1 hour",
                    "value": "PT1H"
                  },
                  {
                    "text": "6 hours",
                    "value": "PT6H"
                  },
                  {
                    "text": "12 hours",
                    "value": "PT12H"
                  },
                  {
                    "text": "1 day",
                    "value": "P1D"
                  }
                ],
                "top": "10"
              },
              "datasource": {
                "uid": "$ds"
              },
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "queryType": "Azure Monitor",
              "refId": "A",
              "subscription": "$sub"
            }
          ],
          "title": "Availability",
          "transparent": true,
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "$ds"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "fixedColor": "blue",
                "mode": "fixed"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 5,
            "x": 5,
            "y": 31
          },
          "id": 140,
          "options": {
            "colorMode": "none",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "sum"
              ],
              "fields": "",
              "values": false
            },
            "text": {},
            "textMode": "value_and_name"
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": "00000000-0000-0000-0000-000000000000"
              },
              "azureMonitor": {
                "aggOptions": [
                  "Total",
                  "Average",
                  "Minimum",
                  "Maximum"
                ],
                "aggregation": "Total",
                "allowedTimeGrainsMs": [
                  60000,
                  300000,
                  900000,
                  1800000,
                  3600000,
                  21600000,
                  43200000,
                  86400000
                ],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "dimensions": [
                  {
                    "text": "Geo type",
                    "value": "GeoType"
                  },
                  {
                    "text": "API name",
                    "value": "ApiName"
                  },
                  {
                    "text": "Authentication",
                    "value": "Authentication"
                  }
                ],
                "metricDefinition": "$ns",
                "metricName": "Egress",
                "metricNamespace": "microsoft.storage/storageaccounts",
                "resourceGroup": "$storage_rg",
                "resourceName": "$stor",
                "timeGrain": "auto",
                "timeGrains": [
                  {
                    "text": "auto",
                    "value": "auto"
                  },
                  {
                    "text": "1 minute",
                    "value": "PT1M"
                  },
                  {
                    "text": "5 minutes",
                    "value": "PT5M"
                  },
                  {
                    "text": "15 minutes",
                    "value": "PT15M"
                  },
                  {
                    "text": "30 minutes",
                    "value": "PT30M"
                  },
                  {
                    "text": "1 hour",
                    "value": "PT1H"
                  },
                  {
                    "text": "6 hours",
                    "value": "PT6H"
                  },
                  {
                    "text": "12 hours",
                    "value": "PT12H"
                  },
                  {
                    "text": "1 day",
                    "value": "P1D"
                  }
                ],
                "top": "10"
              },
              "datasource": {
                "uid": "$ds"
              },
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "queryType": "Azure Monitor",
              "refId": "A",
              "subscription": "$sub"
            }
          ],
          "transparent": true,
          "type": "stat"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "$ds"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "fixedColor": "blue",
                "mode": "fixed"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 5,
            "x": 11,
            "y": 31
          },
          "id": 138,
          "options": {
            "colorMode": "none",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "sum"
              ],
              "fields": "",
              "values": false
            },
            "text": {},
            "textMode": "value_and_name"
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": "00000000-0000-0000-0000-000000000000"
              },
              "azureMonitor": {
                "aggOptions": [
                  "Total",
                  "Average",
                  "Minimum",
                  "Maximum"
                ],
                "aggregation": "Total",
                "allowedTimeGrainsMs": [
                  60000,
                  300000,
                  900000,
                  1800000,
                  3600000,
                  21600000,
                  43200000,
                  86400000
                ],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "dimensions": [
                  {
                    "text": "Geo type",
                    "value": "GeoType"
                  },
                  {
                    "text": "API name",
                    "value": "ApiName"
                  },
                  {
                    "text": "Authentication",
                    "value": "Authentication"
                  }
                ],
                "metricDefinition": "$ns",
                "metricName": "Ingress",
                "metricNamespace": "microsoft.storage/storageaccounts",
                "resourceGroup": "$storage_rg",
                "resourceName": "$stor",
                "timeGrain": "auto",
                "timeGrains": [
                  {
                    "text": "auto",
                    "value": "auto"
                  },
                  {
                    "text": "1 minute",
                    "value": "PT1M"
                  },
                  {
                    "text": "5 minutes",
                    "value": "PT5M"
                  },
                  {
                    "text": "15 minutes",
                    "value": "PT15M"
                  },
                  {
                    "text": "30 minutes",
                    "value": "PT30M"
                  },
                  {
                    "text": "1 hour",
                    "value": "PT1H"
                  },
                  {
                    "text": "6 hours",
                    "value": "PT6H"
                  },
                  {
                    "text": "12 hours",
                    "value": "PT12H"
                  },
                  {
                    "text": "1 day",
                    "value": "P1D"
                  }
                ],
                "top": "10"
              },
              "datasource": {
                "uid": "$ds"
              },
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "queryType": "Azure Monitor",
              "refId": "A",
              "subscription": "$sub"
            }
          ],
          "transparent": true,
          "type": "stat"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "$ds"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "fixedColor": "blue",
                "mode": "fixed"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 6,
            "x": 17,
            "y": 31
          },
          "id": 132,
          "options": {
            "colorMode": "none",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "sum"
              ],
              "fields": "",
              "values": false
            },
            "text": {},
            "textMode": "value_and_name"
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": "00000000-0000-0000-0000-000000000000"
              },
              "azureMonitor": {
                "aggOptions": [
                  "Total"
                ],
                "aggregation": "Total",
                "allowedTimeGrainsMs": [
                  60000,
                  300000,
                  900000,
                  1800000,
                  3600000,
                  21600000,
                  43200000,
                  86400000
                ],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "dimensions": [
                  {
                    "text": "Response type",
                    "value": "ResponseType"
                  },
                  {
                    "text": "Geo type",
                    "value": "GeoType"
                  },
                  {
                    "text": "API name",
                    "value": "ApiName"
                  },
                  {
                    "text": "Authentication",
                    "value": "Authentication"
                  }
                ],
                "metricDefinition": "$ns",
                "metricName": "Transactions",
                "metricNamespace": "microsoft.storage/storageaccounts",
                "resourceGroup": "$storage_rg",
                "resourceName": "$stor",
                "timeGrain": "PT5M",
                "timeGrains": [
                  {
                    "text": "auto",
                    "value": "auto"
                  },
                  {
                    "text": "1 minute",
                    "value": "PT1M"
                  },
                  {
                    "text": "5 minutes",
                    "value": "PT5M"
                  },
                  {
                    "text": "15 minutes",
                    "value": "PT15M"
                  },
                  {
                    "text": "30 minutes",
                    "value": "PT30M"
                  },
                  {
                    "text": "1 hour",
                    "value": "PT1H"
                  },
                  {
                    "text": "6 hours",
                    "value": "PT6H"
                  },
                  {
                    "text": "12 hours",
                    "value": "PT12H"
                  },
                  {
                    "text": "1 day",
                    "value": "P1D"
                  }
                ],
                "top": "10"
              },
              "datasource": {
                "uid": "$ds"
              },
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "queryType": "Azure Monitor",
              "refId": "A",
              "subscription": "$sub"
            }
          ],
          "transparent": true,
          "type": "stat"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "$ds"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "fixedColor": "red",
                "mode": "fixed"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 10,
                "gradientMode": "none",
                "hideFrom": {
                  "graph": false,
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "red",
                    "value": null
                  }
                ]
              },
              "unit": "short"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byName",
                  "options": "Transactions Success"
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "green",
                      "mode": "fixed"
                    }
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 8,
            "w": 19,
            "x": 0,
            "y": 36
          },
          "id": 128,
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "single",
              "sort": "none"
            }
          },
          "pluginVersion": "7.4.3",
          "targets": [
            {
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": "00000000-0000-0000-0000-000000000000"
              },
              "azureMonitor": {
                "aggOptions": [
                  "Total"
                ],
                "aggregation": "Total",
                "alias": "",
                "allowedTimeGrainsMs": [
                  60000,
                  300000,
                  900000,
                  1800000,
                  3600000,
                  21600000,
                  43200000,
                  86400000
                ],
                "dimensionFilter": "*",
                "dimensionFilters": [
                  {
                    "dimension": "ResponseType",
                    "filters": [],
                    "operator": "eq"
                  }
                ],
                "dimensions": [
                  {
                    "text": "Response type",
                    "value": "ResponseType"
                  },
                  {
                    "text": "Geo type",
                    "value": "GeoType"
                  },
                  {
                    "text": "API name",
                    "value": "ApiName"
                  },
                  {
                    "text": "Authentication",
                    "value": "Authentication"
                  }
                ],
                "metricDefinition": "$ns",
                "metricName": "Transactions",
                "metricNamespace": "microsoft.storage/storageaccounts",
                "resourceGroup": "$storage_rg",
                "resourceName": "$stor",
                "timeGrain": "auto",
                "timeGrains": [
                  {
                    "text": "auto",
                    "value": "auto"
                  },
                  {
                    "text": "1 minute",
                    "value": "PT1M"
                  },
                  {
                    "text": "5 minutes",
                    "value": "PT5M"
                  },
                  {
                    "text": "15 minutes",
                    "value": "PT15M"
                  },
                  {
                    "text": "30 minutes",
                    "value": "PT30M"
                  },
                  {
                    "text": "1 hour",
                    "value": "PT1H"
                  },
                  {
                    "text": "6 hours",
                    "value": "PT6H"
                  },
                  {
                    "text": "12 hours",
                    "value": "PT12H"
                  },
                  {
                    "text": "1 day",
                    "value": "P1D"
                  }
                ],
                "top": "10"
              },
              "datasource": {
                "uid": "$ds"
              },
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "queryType": "Azure Monitor",
              "refId": "A",
              "subscription": "$sub"
            }
          ],
          "transparent": true,
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "$ds"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "fixedColor": "purple",
                "mode": "fixed"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 4,
            "w": 5,
            "x": 19,
            "y": 36
          },
          "id": 136,
          "options": {
            "colorMode": "none",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "mean"
              ],
              "fields": "",
              "values": false
            },
            "text": {},
            "textMode": "value_and_name"
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": "00000000-0000-0000-0000-000000000000"
              },
              "azureMonitor": {
                "aggOptions": [
                  "Average",
                  "Minimum",
                  "Maximum"
                ],
                "aggregation": "Average",
                "allowedTimeGrainsMs": [
                  60000,
                  300000,
                  900000,
                  1800000,
                  3600000,
                  21600000,
                  43200000,
                  86400000
                ],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "dimensions": [
                  {
                    "text": "Geo type",
                    "value": "GeoType"
                  },
                  {
                    "text": "API name",
                    "value": "ApiName"
                  },
                  {
                    "text": "Authentication",
                    "value": "Authentication"
                  }
                ],
                "metricDefinition": "$ns",
                "metricName": "SuccessServerLatency",
                "metricNamespace": "microsoft.storage/storageaccounts",
                "resourceGroup": "$storage_rg",
                "resourceName": "$stor",
                "timeGrain": "auto",
                "timeGrains": [
                  {
                    "text": "auto",
                    "value": "auto"
                  },
                  {
                    "text": "1 minute",
                    "value": "PT1M"
                  },
                  {
                    "text": "5 minutes",
                    "value": "PT5M"
                  },
                  {
                    "text": "15 minutes",
                    "value": "PT15M"
                  },
                  {
                    "text": "30 minutes",
                    "value": "PT30M"
                  },
                  {
                    "text": "1 hour",
                    "value": "PT1H"
                  },
                  {
                    "text": "6 hours",
                    "value": "PT6H"
                  },
                  {
                    "text": "12 hours",
                    "value": "PT12H"
                  },
                  {
                    "text": "1 day",
                    "value": "P1D"
                  }
                ],
                "top": "10"
              },
              "datasource": {
                "uid": "$ds"
              },
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "queryType": "Azure Monitor",
              "refId": "A",
              "subscription": "$sub"
            }
          ],
          "transparent": true,
          "type": "stat"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "$ds"
          },
          "description": "",
          "fieldConfig": {
            "defaults": {
              "color": {
                "fixedColor": "purple",
                "mode": "fixed"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 4,
            "w": 5,
            "x": 19,
            "y": 40
          },
          "id": 134,
          "options": {
            "colorMode": "none",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "mean"
              ],
              "fields": "",
              "values": false
            },
            "text": {},
            "textMode": "value_and_name"
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": "00000000-0000-0000-0000-000000000000"
              },
              "azureMonitor": {
                "aggOptions": [
                  "Average",
                  "Minimum",
                  "Maximum"
                ],
                "aggregation": "Average",
                "allowedTimeGrainsMs": [
                  60000,
                  300000,
                  900000,
                  1800000,
                  3600000,
                  21600000,
                  43200000,
                  86400000
                ],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "dimensions": [
                  {
                    "text": "Geo type",
                    "value": "GeoType"
                  },
                  {
                    "text": "API name",
                    "value": "ApiName"
                  },
                  {
                    "text": "Authentication",
                    "value": "Authentication"
                  }
                ],
                "metricDefinition": "$ns",
                "metricName": "SuccessE2ELatency",
                "metricNamespace": "microsoft.storage/storageaccounts",
                "resourceGroup": "$storage_rg",
                "resourceName": "$stor",
                "timeGrain": "auto",
                "timeGrains": [
                  {
                    "text": "auto",
                    "value": "auto"
                  },
                  {
                    "text": "1 minute",
                    "value": "PT1M"
                  },
                  {
                    "text": "5 minutes",
                    "value": "PT5M"
                  },
                  {
                    "text": "15 minutes",
                    "value": "PT15M"
                  },
                  {
                    "text": "30 minutes",
                    "value": "PT30M"
                  },
                  {
                    "text": "1 hour",
                    "value": "PT1H"
                  },
                  {
                    "text": "6 hours",
                    "value": "PT6H"
                  },
                  {
                    "text": "12 hours",
                    "value": "PT12H"
                  },
                  {
                    "text": "1 day",
                    "value": "P1D"
                  }
                ],
                "top": "10"
              },
              "datasource": {
                "uid": "$ds"
              },
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "queryType": "Azure Monitor",
              "refId": "A",
              "subscription": "$sub"
            }
          ],
          "transparent": true,
          "type": "stat"
        }
      ],
      "title": "Storage",
      "type": "row"
    },
    {
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 24
      },
      "id": 104,
      "panels": [
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "P1EB995EACC6832D3"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green"
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 11,
            "x": 1,
            "y": 25
          },
          "id": 106,
          "options": {
            "colorMode": "none",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "limit": 40,
              "values": true
            },
            "text": {
              "titleSize": 18,
              "valueSize": 18
            },
            "textMode": "value_and_name"
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "account": "",
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": ""
              },
              "azureMonitor": {
                "aggOptions": [],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "timeGrain": "auto",
                "timeGrains": [],
                "top": "10"
              },
              "azureResourceGraph": {
                "query": "Resources \r\n| extend type = case(\r\ntype contains 'microsoft.netapp/netappaccounts', 'NetApp Accounts',\r\ntype contains \"microsoft.compute\", \"Azure Compute\",\r\ntype contains \"microsoft.logic\", \"LogicApps\",\r\ntype contains 'microsoft.keyvault/vaults', \"Key Vaults\",\r\ntype contains 'microsoft.storage/storageaccounts', \"Storage Accounts\",\r\ntype contains 'microsoft.compute/availabilitysets', 'Availability Sets',\r\ntype contains 'microsoft.operationalinsights/workspaces', 'Azure Monitor Resources',\r\ntype contains 'microsoft.operationsmanagement', 'Operations Management Resources',\r\ntype contains 'microsoft.insights', 'Azure Monitor Resources',\r\ntype contains 'microsoft.desktopvirtualization/applicationgroups', 'WVD Application Groups',\r\ntype contains 'microsoft.desktopvirtualization/workspaces', 'WVD Workspaces',\r\ntype contains 'microsoft.desktopvirtualization/hostpools', 'WVD Hostpools',\r\ntype contains 'microsoft.recoveryservices/vaults', 'Backup Vaults',\r\ntype contains 'microsoft.web', 'App Services',\r\ntype contains 'microsoft.managedidentity/userassignedidentities','Managed Identities',\r\ntype contains 'microsoft.storagesync/storagesyncservices', 'Azure File Sync',\r\ntype contains 'microsoft.hybridcompute/machines', 'ARC Machines',\r\ntype contains 'Microsoft.EventHub', 'Event Hub',\r\ntype contains 'Microsoft.EventGrid', 'Event Grid',\r\ntype contains 'Microsoft.Sql', 'SQL Resources',\r\ntype contains 'Microsoft.HDInsight/clusters', 'HDInsight Clusters',\r\ntype contains 'microsoft.devtestlab', 'DevTest Labs Resources',\r\ntype contains 'microsoft.containerinstance', 'Container Instances Resources',\r\ntype contains 'microsoft.portal/dashboards', 'Azure Dashboards',\r\ntype contains 'microsoft.containerregistry/registries', 'Container Registry',\r\ntype contains 'microsoft.automation', 'Automation Resources',\r\ntype contains 'sendgrid.email/accounts', 'SendGrid Accounts',\r\ntype contains 'microsoft.datafactory/factories', 'Data Factory',\r\ntype contains 'microsoft.databricks/workspaces', 'Databricks Workspaces',\r\ntype contains 'microsoft.machinelearningservices/workspaces', 'Machine Learnings Workspaces',\r\ntype contains 'microsoft.alertsmanagement/smartdetectoralertrules', 'Azure Monitor Resources',\r\ntype contains 'microsoft.apimanagement/service', 'API Management Services',\r\ntype contains 'microsoft.dbforpostgresql', 'PostgreSQL Resources',\r\ntype contains 'microsoft.scheduler/jobcollections', 'Scheduler Job Collections',\r\ntype contains 'microsoft.visualstudio/account', 'Azure DevOps Organization',\r\ntype contains 'microsoft.network/', 'Network Resources',\r\ntype contains 'microsoft.migrate/' or type contains 'microsoft.offazure', 'Azure Migrate Resources',\r\ntype contains 'microsoft.servicebus/namespaces', 'Service Bus Namespaces',\r\ntype contains 'microsoft.classic', 'ASM Obsolete Resources',\r\ntype contains 'microsoft.resources/templatespecs', 'Template Spec Resources',\r\ntype contains 'microsoft.virtualmachineimages', 'VM Image Templates',\r\ntype contains 'microsoft.documentdb', 'CosmosDB DB Resources',\r\ntype contains 'microsoft.alertsmanagement/actionrules', 'Azure Monitor Resources',\r\ntype contains 'microsoft.kubernetes/connectedclusters', 'ARC Kubernetes Clusters',\r\ntype contains 'microsoft.purview', 'Purview Resources',\r\ntype contains 'microsoft.security', 'Security Resources',\r\ntype contains 'microsoft.cdn', 'CDN Resources',\r\ntype contains 'microsoft.devices','IoT Resources',\r\ntype contains 'microsoft.datamigration', 'Data Migraiton Services',\r\ntype contains 'microsoft.cognitiveservices', 'Congitive Services',\r\ntype contains 'microsoft.customproviders', 'Custom Providers',\r\ntype contains 'microsoft.appconfiguration', 'App Services',\r\ntype contains 'microsoft.search', 'Search Services',\r\ntype contains 'microsoft.maps', 'Maps',\r\ntype contains 'microsoft.containerservice/managedclusters', 'AKS',\r\ntype contains 'microsoft.signalrservice', 'SignalR',\r\ntype contains 'microsoft.resourcegraph/queries', 'Resource Graph Queries',\r\ntype contains 'microsoft.batch', 'MS Batch',\r\ntype contains 'microsoft.analysisservices', 'Analysis Services',\r\ntype contains 'microsoft.synapse/workspaces', 'Synapse Workspaces',\r\ntype contains 'microsoft.synapse/workspaces/sqlpools', 'Synapse SQL Pools',\r\ntype contains 'microsoft.kusto/clusters', 'ADX Clusters',\r\ntype contains 'microsoft.resources/deploymentscripts', 'Deployment Scripts',\r\ntype contains 'microsoft.aad/domainservices', 'AD Domain Services',\r\ntype contains 'microsoft.labservices/labaccounts', 'Lab Accounts',\r\ntype contains 'microsoft.automanage/accounts', 'Automanage Accounts',\r\nstrcat(\"Not Translated: \", type))\r\n| summarize count() by type",
                "resultFormat": "table"
              },
              "backends": [],
              "datasource": {
                "type": "grafana-azure-monitor-datasource",
                "uid": "P1EB995EACC6832D3"
              },
              "dimension": "",
              "environment": "prod",
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "metric": "",
              "namespace": "",
              "queryType": "Azure Resource Graph",
              "refId": "A",
              "samplingType": "",
              "service": "metric",
              "subscriptions": [
                "0e221a1b-69be-4f9f-8cd0-2122054bf7f1"
              ],
              "useBackends": false,
              "useCustomSeriesNaming": false
            }
          ],
          "title": "Resource Counts",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "P1EB995EACC6832D3"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "mappings": [],
              "thresholds": {
                "mode": "percentage",
                "steps": [
                  {
                    "color": "green"
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 11,
            "x": 12,
            "y": 25
          },
          "id": 100,
          "options": {
            "colorMode": "none",
            "graphMode": "none",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "limit": 40,
              "values": true
            },
            "text": {
              "titleSize": 18,
              "valueSize": 18
            },
            "textMode": "value_and_name"
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "account": "",
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": ""
              },
              "azureMonitor": {
                "aggOptions": [],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "timeGrain": "auto",
                "timeGrains": [],
                "top": "10"
              },
              "azureResourceGraph": {
                "query": "where type has \"microsoft.network\"\r\n    or type has 'microsoft.cdn'\r\n| extend type = case(\r\n\ttype == 'microsoft.network/networkinterfaces', \"NICs\",\r\n\ttype == 'microsoft.network/networksecuritygroups', \"NSGs\", \r\n\ttype == \"microsoft.network/publicipaddresses\", \"Public IPs\", \r\n\ttype == 'microsoft.network/virtualnetworks', \"vNets\",\r\n\ttype == 'microsoft.network/networkwatchers/connectionmonitors', \"Connection Monitors\",\r\n\ttype == 'microsoft.network/privatednszones', \"Private DNS\",\r\n\ttype == 'microsoft.network/virtualnetworkgateways', @\"vNet Gateways\",\r\n\ttype == 'microsoft.network/connections', \"Connections\",\r\n\ttype == 'microsoft.network/networkwatchers', \"Network Watchers\",\r\n\ttype == 'microsoft.network/privateendpoints', \"Private Endpoints\",\r\n\ttype == 'microsoft.network/localnetworkgateways', \"Local Network Gateways\",\r\n\ttype == 'microsoft.network/privatednszones/virtualnetworklinks', \"vNet Links\",\r\n\ttype == 'microsoft.network/dnszones', 'DNS Zones',\r\n\ttype == 'microsoft.network/networkwatchers/flowlogs', 'Flow Logs',\r\n\ttype == 'microsoft.network/routetables', 'Route Tables',\r\n\ttype == 'microsoft.network/loadbalancers', 'Load Balancers',\r\n\ttype == 'microsoft.network/ddosprotectionplans', 'DDoS Protection Plans',\r\n\ttype == 'microsoft.network/applicationsecuritygroups', 'App Security Groups',\r\n\ttype == 'microsoft.network/azurefirewalls', 'Azure Firewalls',\r\n\ttype == 'microsoft.network/applicationgateways', 'App Gateways',\r\n\ttype == 'microsoft.network/frontdoors', 'Front Doors',\r\n\ttype == 'microsoft.network/applicationgatewaywebapplicationfirewallpolicies', 'AppGateway Policies',\r\n\ttype == 'microsoft.network/bastionhosts', 'Bastion Hosts',\r\n\ttype == 'microsoft.network/frontdoorwebapplicationfirewallpolicies', 'FrontDoor Policies',\r\n\ttype == 'microsoft.network/firewallpolicies', 'Firewall Policies',\r\n\ttype == 'microsoft.network/networkintentpolicies', 'Network Intent Policies',\r\n\ttype == 'microsoft.network/trafficmanagerprofiles', 'Traffic Manager Profiles',\r\n\ttype == 'microsoft.network/publicipprefixes', 'PublicIP Prefixes',\r\n\ttype == 'microsoft.network/privatelinkservices', 'Private Link',\r\n\ttype == 'microsoft.network/expressroutecircuits', 'Express Route Circuits',\r\n\ttype =~ 'microsoft.cdn/cdnwebapplicationfirewallpolicies', 'CDN Web App Firewall Policies',\r\n\ttype =~ 'microsoft.cdn/profiles', 'CDN Profiles',\r\n\ttype =~ 'microsoft.cdn/profiles/afdendpoints', 'CDN Front Door Endpoints',\r\n\ttype =~ 'microsoft.cdn/profiles/endpoints', 'CDN Endpoints',\r\n\tstrcat(\"Not Translated: \", type))\r\n| summarize count() by type",
                "resultFormat": "table"
              },
              "backends": [],
              "datasource": {
                "type": "grafana-azure-monitor-datasource",
                "uid": "P1EB995EACC6832D3"
              },
              "dimension": "",
              "environment": "prod",
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "metric": "",
              "namespace": "",
              "queryType": "Azure Resource Graph",
              "refId": "A",
              "samplingType": "",
              "service": "metric",
              "subscriptions": [
                "0e221a1b-69be-4f9f-8cd0-2122054bf7f1"
              ],
              "useBackends": false,
              "useCustomSeriesNaming": false
            }
          ],
          "title": "Networking Overview",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "P1EB995EACC6832D3"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green"
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 6,
            "w": 6,
            "x": 0,
            "y": 33
          },
          "id": 108,
          "options": {
            "colorMode": "none",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": true
            },
            "text": {},
            "textMode": "auto"
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "account": "",
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": ""
              },
              "azureMonitor": {
                "aggOptions": [],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "timeGrain": "auto",
                "timeGrains": [],
                "top": "10"
              },
              "azureResourceGraph": {
                "query": "Resources | where type == \"microsoft.compute/virtualmachines\"\r\n| extend vmState = tostring(properties.extended.instanceView.powerState.displayStatus)\r\n| extend vmState = iif(isempty(vmState), \"VM State Unknown\", (vmState))\r\n| summarize count() by vmState",
                "resultFormat": "table"
              },
              "backends": [],
              "datasource": {
                "type": "grafana-azure-monitor-datasource",
                "uid": "P1EB995EACC6832D3"
              },
              "dimension": "",
              "environment": "prod",
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "metric": "",
              "namespace": "",
              "queryType": "Azure Resource Graph",
              "refId": "A",
              "samplingType": "",
              "service": "metric",
              "subscriptions": [
                "$sub"
              ],
              "useBackends": false,
              "useCustomSeriesNaming": false
            }
          ],
          "title": "Current VM Status",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "P1EB995EACC6832D3"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "custom": {
                "align": "auto",
                "displayMode": "auto",
                "inspect": false
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green"
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 6,
            "w": 18,
            "x": 6,
            "y": 33
          },
          "id": 110,
          "options": {
            "footer": {
              "fields": "",
              "reducer": [
                "sum"
              ],
              "show": false
            },
            "showHeader": true
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "account": "",
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": ""
              },
              "azureMonitor": {
                "aggOptions": [],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "timeGrain": "auto",
                "timeGrains": [],
                "top": "10"
              },
              "azureResourceGraph": {
                "query": "Resources \r\n| where type == \"microsoft.compute/virtualmachines\"\r\n| extend vmID = tolower(id)\r\n| extend osDiskId= tolower(tostring(properties.storageProfile.osDisk.managedDisk.id))\r\n        | join kind=leftouter(resources\r\n            | where type =~ 'microsoft.compute/disks'\r\n            | where properties !has 'Unattached'\r\n            | where properties has 'osType'\r\n            | project timeCreated = tostring(properties.timeCreated), OS = tostring(properties.osType), osSku = tostring(sku.name), osDiskSizeGB = toint(properties.diskSizeGB), osDiskId=tolower(tostring(id))) on osDiskId\r\n        | join kind=leftouter(resources\r\n\t\t\t| where type =~ 'microsoft.compute/availabilitysets'\r\n\t\t\t| extend VirtualMachines = array_length(properties.virtualMachines)\r\n\t\t\t| mv-expand VirtualMachine=properties.virtualMachines\r\n\t\t\t| extend FaultDomainCount = properties.platformFaultDomainCount\r\n\t\t\t| extend UpdateDomainCount = properties.platformUpdateDomainCount\r\n\t\t\t| extend vmID = tolower(VirtualMachine.id)\r\n\t\t\t| project AvailabilitySetID = id, vmID, FaultDomainCount, UpdateDomainCount ) on vmID\r\n\t\t| join kind=leftouter(resources\r\n\t\t\t| where type =~ 'microsoft.sqlvirtualmachine/sqlvirtualmachines'\r\n\t\t\t| extend SQLLicense = properties.sqlServerLicenseType\r\n\t\t\t| extend SQLImage = properties.sqlImageOffer\r\n\t\t\t| extend SQLSku = properties.sqlImageSku\r\n\t\t\t| extend SQLManagement = properties.sqlManagement\r\n\t\t\t| extend vmID = tostring(tolower(properties.virtualMachineResourceId))\r\n\t\t\t| project SQLId=id, SQLLicense, SQLImage, SQLSku, SQLManagement, vmID ) on vmID\r\n| project-away vmID1, vmID2, osDiskId1\r\n| extend Details = pack_all()\r\n| project vmID, SQLId, AvailabilitySetID, OS, resourceGroup, location, subscriptionId, SQLLicense, SQLImage,SQLSku, SQLManagement, FaultDomainCount, UpdateDomainCount, Details",
                "resultFormat": "table"
              },
              "backends": [],
              "datasource": {
                "type": "grafana-azure-monitor-datasource",
                "uid": "P1EB995EACC6832D3"
              },
              "dimension": "",
              "environment": "prod",
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "metric": "",
              "namespace": "",
              "queryType": "Azure Resource Graph",
              "refId": "A",
              "samplingType": "",
              "service": "metric",
              "subscriptions": [
                "$sub"
              ],
              "useBackends": false,
              "useCustomSeriesNaming": false
            }
          ],
          "title": "VM Overview",
          "type": "table"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "P1EB995EACC6832D3"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green"
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 11,
            "w": 6,
            "x": 0,
            "y": 39
          },
          "id": 112,
          "options": {
            "colorMode": "none",
            "graphMode": "area",
            "justifyMode": "center",
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": true
            },
            "text": {},
            "textMode": "auto"
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "account": "",
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": ""
              },
              "azureMonitor": {
                "aggOptions": [],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "timeGrain": "auto",
                "timeGrains": [],
                "top": "10"
              },
              "azureResourceGraph": {
                "query": "resources\r\n| where type has 'microsoft.web'\r\n\t or type =~ 'microsoft.apimanagement/service'\r\n\t or type =~ 'microsoft.network/frontdoors'\r\n\t or type =~ 'microsoft.network/applicationgateways'\r\n\t or type =~ 'microsoft.appconfiguration/configurationstores'\r\n| extend type = case(\r\n\ttype == 'microsoft.web/serverfarms', \"App Service Plans\",\r\n\tkind == 'functionapp', \"Azure Functions\", \r\n\tkind == \"api\", \"API Apps\", \r\n\ttype == 'microsoft.web/sites', \"App Services\",\r\n\ttype =~ 'microsoft.network/applicationgateways', 'App Gateways',\r\n\ttype =~ 'microsoft.network/frontdoors', 'Front Door',\r\n\ttype =~ 'microsoft.apimanagement/service', 'API Management',\r\n\ttype =~ 'microsoft.web/certificates', 'App Certificates',\r\n\ttype =~ 'microsoft.appconfiguration/configurationstores', 'App Config Stores',\r\n\tstrcat(\"Not Translated: \", type))\r\n| where type !has \"Not Translated\"\r\n| summarize count() by type",
                "resultFormat": "table"
              },
              "backends": [],
              "datasource": {
                "type": "grafana-azure-monitor-datasource",
                "uid": "P1EB995EACC6832D3"
              },
              "dimension": "",
              "environment": "prod",
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "metric": "",
              "namespace": "",
              "queryType": "Azure Resource Graph",
              "refId": "A",
              "samplingType": "",
              "service": "metric",
              "subscriptions": [
                "$sub"
              ],
              "useBackends": false,
              "useCustomSeriesNaming": false
            }
          ],
          "title": "Apps Overview",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "P1EB995EACC6832D3"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "custom": {
                "align": "auto",
                "displayMode": "auto",
                "inspect": false
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green"
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 11,
            "w": 18,
            "x": 6,
            "y": 39
          },
          "id": 114,
          "options": {
            "footer": {
              "fields": "",
              "reducer": [
                "sum"
              ],
              "show": false
            },
            "showHeader": true
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "account": "",
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": ""
              },
              "azureMonitor": {
                "aggOptions": [],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "timeGrain": "auto",
                "timeGrains": [],
                "top": "10"
              },
              "azureResourceGraph": {
                "query": "resources\r\n| where type has 'microsoft.web'\r\n\t or type =~ 'microsoft.apimanagement/service'\r\n\t or type =~ 'microsoft.network/frontdoors'\r\n\t or type =~ 'microsoft.network/applicationgateways'\r\n\t or type =~ 'microsoft.appconfiguration/configurationstores'\r\n| extend type = case(\r\n\ttype == 'microsoft.web/serverfarms', \"App Service Plans\",\r\n\tkind == 'functionapp', \"Azure Functions\", \r\n\tkind == \"api\", \"API Apps\", \r\n\ttype == 'microsoft.web/sites', \"App Services\",\r\n\ttype =~ 'microsoft.network/applicationgateways', 'App Gateways',\r\n\ttype =~ 'microsoft.network/frontdoors', 'Front Door',\r\n\ttype =~ 'microsoft.apimanagement/service', 'API Management',\r\n\ttype =~ 'microsoft.web/certificates', 'App Certificates',\r\n\ttype =~ 'microsoft.appconfiguration/configurationstores', 'App Config Stores',\r\n\tstrcat(\"Not Translated: \", type))\r\n| where type !has \"Not Translated\"\r\n| extend Sku = case(\r\n\ttype =~ 'App Gateways', properties.sku.name, \r\n\ttype =~ 'Azure Functions', properties.sku,\r\n\ttype =~ 'API Management', sku.name,\r\n\ttype =~ 'App Service Plans', sku.name,\r\n\ttype =~ 'App Services', properties.sku,\r\n\ttype =~ 'App Config Stores', sku.name,\r\n\t' ')\r\n| extend State = case(\r\n\ttype =~ 'App Config Stores', properties.provisioningState,\r\n\ttype =~ 'App Service Plans', properties.status,\r\n\ttype =~ 'Azure Functions', properties.enabled,\r\n\ttype =~ 'App Services', properties.state,\r\n\ttype =~ 'API Management', properties.provisioningState,\r\n\ttype =~ 'App Gateways', properties.provisioningState,\r\n\ttype =~ 'Front Door', properties.provisioningState,\r\n\t' ')\r\n| mv-expand publicIpId=properties.frontendIPConfigurations\r\n| mv-expand publicIpId = publicIpId.properties.publicIPAddress.id\r\n| extend publicIpId = tostring(publicIpId)\r\n\t| join kind=leftouter(\r\n\t  \tResources\r\n  \t\t| where type =~ 'microsoft.network/publicipaddresses'\r\n  \t\t| project publicIpId = id, publicIpAddress = tostring(properties.ipAddress)) on publicIpId\r\n| extend PublicIP = case(\r\n\ttype =~ 'API Management', properties.publicIPAddresses,\r\n\ttype =~ 'App Gateways', publicIpAddress,\r\n\t' ')\r\n| extend Details = pack_all()\r\n| project Resource=id, type, subscriptionId, Sku, State, PublicIP, Details",
                "resultFormat": "table"
              },
              "backends": [],
              "datasource": {
                "type": "grafana-azure-monitor-datasource",
                "uid": "P1EB995EACC6832D3"
              },
              "dimension": "",
              "environment": "prod",
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "metric": "",
              "namespace": "",
              "queryType": "Azure Resource Graph",
              "refId": "A",
              "samplingType": "",
              "service": "metric",
              "subscriptions": [
                "0e221a1b-69be-4f9f-8cd0-2122054bf7f1"
              ],
              "useBackends": false,
              "useCustomSeriesNaming": false
            }
          ],
          "title": "Apps Detailed View",
          "type": "table"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "P1EB995EACC6832D3"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green"
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 10,
            "w": 6,
            "x": 0,
            "y": 50
          },
          "id": 120,
          "options": {
            "colorMode": "none",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": true
            },
            "text": {},
            "textMode": "auto"
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "account": "",
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": ""
              },
              "azureMonitor": {
                "aggOptions": [],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "timeGrain": "auto",
                "timeGrains": [],
                "top": "10"
              },
              "azureResourceGraph": {
                "query": "resources\r\n| where type =~ 'microsoft.containerservice/managedclusters'\r\n\tor type =~ 'microsoft.containerregistry/registries'\r\n\tor type =~ 'microsoft.containerinstance/containergroups'\r\n| extend type = case(\r\n\ttype =~ 'microsoft.containerservice/managedclusters', 'AKS',\r\n\ttype =~ 'microsoft.containerregistry/registries', 'Container Registry',\r\n\ttype =~ 'microsoft.containerinstance/containergroups', 'Container Instnaces',\r\n\tstrcat(\"Not Translated: \", type))\r\n| where type !has \"Not Translated\"\r\n| summarize count() by type\t",
                "resultFormat": "table"
              },
              "backends": [],
              "datasource": {
                "type": "grafana-azure-monitor-datasource",
                "uid": "P1EB995EACC6832D3"
              },
              "dimension": "",
              "environment": "prod",
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "metric": "",
              "namespace": "",
              "queryType": "Azure Resource Graph",
              "refId": "A",
              "samplingType": "",
              "service": "metric",
              "subscriptions": [
                "0e221a1b-69be-4f9f-8cd0-2122054bf7f1"
              ],
              "useBackends": false,
              "useCustomSeriesNaming": false
            }
          ],
          "title": "Containers Overview",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "grafana-azure-monitor-datasource",
            "uid": "P1EB995EACC6832D3"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "custom": {
                "align": "auto",
                "displayMode": "auto",
                "inspect": false
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green"
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 10,
            "w": 18,
            "x": 6,
            "y": 50
          },
          "id": 122,
          "options": {
            "footer": {
              "fields": "",
              "reducer": [
                "sum"
              ],
              "show": false
            },
            "showHeader": true
          },
          "pluginVersion": "9.1.8",
          "targets": [
            {
              "account": "",
              "appInsights": {
                "dimension": [],
                "metricName": "select",
                "timeGrain": "auto"
              },
              "azureLogAnalytics": {
                "query": "//change this example to create your own time series query\n<table name>                                                              //the table to query (e.g. Usage, Heartbeat, Perf)\n| where $__timeFilter(TimeGenerated)                                      //this is a macro used to show the full chart’s time range, choose the datetime column here\n| summarize count() by <group by column>, bin(TimeGenerated, $__interval) //change “group by column” to a column in your table, such as “Computer”. The $__interval macro is used to auto-select the time grain. Can also use 1h, 5m etc.\n| order by TimeGenerated asc",
                "resultFormat": "time_series",
                "workspace": ""
              },
              "azureMonitor": {
                "aggOptions": [],
                "dimensionFilter": "*",
                "dimensionFilters": [],
                "timeGrain": "auto",
                "timeGrains": [],
                "top": "10"
              },
              "azureResourceGraph": {
                "query": "resources\r\n| where type =~ 'microsoft.containerservice/managedclusters'\r\n\tor type =~ 'microsoft.containerregistry/registries'\r\n\tor type =~ 'microsoft.containerinstance/containergroups'\r\n| extend type = case(\r\n\ttype =~ 'microsoft.containerservice/managedclusters', 'AKS',\r\n\ttype =~ 'microsoft.containerregistry/registries', 'Container Registry',\r\n\ttype =~ 'microsoft.containerinstance/containergroups', 'Container Instnaces',\r\n\tstrcat(\"Not Translated: \", type))\r\n| where type !has \"Not Translated\"\r\n| extend Tier = sku.tier\r\n| extend sku = sku.name\r\n| extend State = case(\r\n\ttype =~ 'Container Registry', properties.provisioningState,\r\n\ttype =~ 'Container Instance', properties.instanceView.state,\r\n\tproperties.powerState.code)\r\n| extend Containers = properties.containers\r\n| mvexpand Containers\r\n| extend RestartCount = Containers.properties.instanceView.restartCount\r\n| extend Image = Containers.properties.image\r\n| extend RestartPolicy = properties.restartPolicy\r\n| extend IP = properties.ipAddress.ip\r\n| extend Version = properties.kubernetesVersion\r\n| extend AgentProfiles = properties.agentPoolProfiles\r\n| mvexpand AgentProfiles\r\n| extend NodeCount = AgentProfiles.[\"count\"]\r\n| extend Details = pack_all()\r\n| project id, type, location, resourceGroup, subscriptionId, sku, Tier, State, RestartCount, Version, NodeCount, Details",
                "resultFormat": "table"
              },
              "backends": [],
              "datasource": {
                "type": "grafana-azure-monitor-datasource",
                "uid": "P1EB995EACC6832D3"
              },
              "dimension": "",
              "environment": "prod",
              "insightsAnalytics": {
                "query": "",
                "resultFormat": "time_series"
              },
              "metric": "",
              "namespace": "",
              "queryType": "Azure Resource Graph",
              "refId": "A",
              "samplingType": "",
              "service": "metric",
              "subscriptions": [
                "$sub"
              ],
              "useBackends": false,
              "useCustomSeriesNaming": false
            }
          ],
          "title": "Containers Detailed View",
          "type": "table"
        }
      ],
      "title": "Resources",
      "type": "row"
    }
  ],
  "refresh": "1m",
  "schemaVersion": 37,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": [
      {
        "current": {
          "selected": false,
          "text": "Grafana-testing",
          "value": "Grafana-testing"
        },
        "datasource": {
          "type": "grafana-azure-monitor-datasource",
          "uid": "${ds}"
        },
        "definition": "",
        "hide": 0,
        "includeAll": false,
        "label": "CDN R-Group",
        "multi": false,
        "name": "cdn_rg",
        "options": [],
        "query": {
          "azureLogAnalytics": {
            "query": "",
            "resource": ""
          },
          "queryType": "Azure Resource Groups",
          "refId": "A",
          "subscription": "$sub"
        },
        "refresh": 2,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      },
      {
        "current": {
          "selected": false,
          "text": "grafana-CDN",
          "value": "grafana-CDN"
        },
        "datasource": {
          "type": "grafana-azure-monitor-datasource",
          "uid": "${ds}"
        },
        "definition": "",
        "hide": 0,
        "includeAll": false,
        "label": "CDN",
        "multi": false,
        "name": "cdn",
        "options": [],
        "query": {
          "azureLogAnalytics": {
            "query": "",
            "resource": ""
          },
          "namespace": "microsoft.cdn/profiles",
          "queryType": "Azure Resource Names",
          "refId": "A",
          "resourceGroup": "$cdn_rg",
          "subscription": "$sub"
        },
        "refresh": 2,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      },
      {
        "current": {
          "selected": false,
          "text": "Grafana-testing",
          "value": "Grafana-testing"
        },
        "datasource": {
          "type": "grafana-azure-monitor-datasource",
          "uid": "${ds}"
        },
        "definition": "",
        "hide": 0,
        "includeAll": false,
        "label": "LB R-Group",
        "multi": false,
        "name": "lb_rg",
        "options": [],
        "query": {
          "azureLogAnalytics": {
            "query": "",
            "resource": ""
          },
          "queryType": "Azure Resource Groups",
          "refId": "A",
          "subscription": "$sub"
        },
        "refresh": 2,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      },
      {
        "current": {
          "selected": false,
          "text": "grafana-LB",
          "value": "grafana-LB"
        },
        "datasource": {
          "type": "grafana-azure-monitor-datasource",
          "uid": "${ds}"
        },
        "definition": "",
        "hide": 0,
        "includeAll": false,
        "label": "LB",
        "multi": false,
        "name": "lb",
        "options": [],
        "query": {
          "azureLogAnalytics": {
            "query": "",
            "resource": ""
          },
          "namespace": "microsoft.network/loadbalancers",
          "queryType": "Azure Resource Names",
          "refId": "A",
          "resourceGroup": "$lb_rg",
          "subscription": "$sub"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      },
      {
        "current": {
          "selected": false,
          "text": "TerraformState",
          "value": "TerraformState"
        },
        "datasource": {
          "type": "grafana-azure-monitor-datasource",
          "uid": "${ds}"
        },
        "definition": "",
        "hide": 0,
        "includeAll": false,
        "label": "Storage R-Group",
        "multi": false,
        "name": "storage_rg",
        "options": [],
        "query": {
          "azureLogAnalytics": {
            "query": "",
            "resource": ""
          },
          "queryType": "Azure Resource Groups",
          "refId": "A",
          "subscription": "$sub"
        },
        "refresh": 2,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      },
      {
        "current": {
          "selected": false,
          "text": "tqdevterraformstate",
          "value": "tqdevterraformstate"
        },
        "datasource": {
          "type": "grafana-azure-monitor-datasource",
          "uid": "${ds}"
        },
        "definition": "",
        "hide": 0,
        "includeAll": false,
        "label": "Storage",
        "multi": false,
        "name": "stor",
        "options": [],
        "query": {
          "azureLogAnalytics": {
            "query": "",
            "resource": ""
          },
          "namespace": "microsoft.storage/storageaccounts",
          "queryType": "Azure Resource Names",
          "refId": "A",
          "resourceGroup": "$storage_rg",
          "subscription": "$sub"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      },
      {
        "current": {
          "selected": false,
          "text": "Azure Monitor",
          "value": "Azure Monitor"
        },
        "hide": 2,
        "includeAll": false,
        "label": "Data source",
        "multi": false,
        "name": "ds",
        "options": [],
        "query": "grafana-azure-monitor-datasource",
        "queryValue": "",
        "refresh": 1,
        "regex": "Azure Monitor",
        "skipUrlSync": false,
        "type": "datasource"
      },
      {
        "current": {
          "selected": false,
          "text": "Azure DEV Subscription",
          "value": "0e221a1b-69be-4f9f-8cd0-2122054bf7f1"
        },
        "datasource": {
          "type": "grafana-azure-monitor-datasource",
          "uid": "${ds}"
        },
        "definition": "regions()",
        "hide": 2,
        "includeAll": false,
        "label": "Subscription",
        "multi": false,
        "name": "sub",
        "options": [],
        "query": {
          "azureLogAnalytics": {
            "query": "",
            "resource": "/subscriptions/0e221a1b-69be-4f9f-8cd0-2122054bf7f1/resourcegroups/grafana-testing/providers/microsoft.operationalinsights/workspaces/grafana-la"
          },
          "queryType": "Azure Subscriptions",
          "refId": "A"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      },
      {
        "current": {
          "selected": false,
          "text": "net.hr",
          "value": "net.hr"
        },
        "datasource": {
          "type": "influxdb",
          "uid": "P951FEA4DE68E13C5"
        },
        "definition": "SHOW TAG VALUES FROM \"ping\" WITH KEY = \"url\"",
        "description": "UptimeURL",
        "hide": 0,
        "includeAll": false,
        "label": "UptimeURL",
        "multi": false,
        "name": "PingURL",
        "options": [],
        "query": "SHOW TAG VALUES FROM \"ping\" WITH KEY = \"url\"",
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      }
    ]
  },
  "time": {
    "from": "now-24h",
    "to": "now"
  },
  "timepicker": {
    "refresh_intervals": [
      "30s",
      "1m",
      "5m",
      "15m",
      "30m",
      "1h",
      "2h",
      "1d"
    ]
  },
  "timezone": "",
  "title": "Azure Resource Monitoring",
  "uid": "pGdT1QNVz",
  "version": 74,
  "weekStart": ""
}
```

