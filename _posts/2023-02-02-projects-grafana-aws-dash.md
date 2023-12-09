---
title: AWS Cloudwatch metrics in grafana
date: 2023-02-02 12:00:00
categories: [Projects]
tags: [aws, grafana, dashboard]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

The Dashboard provides a comprehensive and visually appealing view of essential metrics collected from your Amazon Web Services (AWS) infrastructure. This dashboard combines the power of CloudWatch, AWS's monitoring and observability service, with Grafana's intuitive and customizable data visualization capabilities.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/grafana_dash_aws.png?raw=true){: .shadow }

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
  "id": 2,
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
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "cloudwatch",
        "uid": "P034F075C744B399F"
      },
      "editable": true,
      "error": false,
      "fieldConfig": {
        "defaults": {
          "displayName": "${__field.displayName}"
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 2,
      "grid": {},
      "gridPos": {
        "h": 7,
        "w": 13,
        "x": 5,
        "y": 0
      },
      "hiddenSeries": false,
      "id": 16,
      "isNew": true,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": true,
        "min": true,
        "show": true,
        "sort": "avg",
        "sortDesc": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 2,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "9.1.8",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [
        {
          "$$hashKey": "object:286",
          "alias": "BytesUploaded_Sum",
          "yaxis": 2
        }
      ],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "alias": "{{namespace}} - {{label}}",
          "application": {
            "filter": ""
          },
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "dimensions": {
            "DistributionId": "*",
            "Region": "Global"
          },
          "expression": "",
          "functions": [],
          "group": {
            "filter": ""
          },
          "host": {
            "filter": ""
          },
          "id": "",
          "item": {
            "filter": ""
          },
          "matchExact": true,
          "metricEditorMode": 0,
          "metricName": "BytesDownloaded",
          "metricQueryType": 0,
          "mode": 0,
          "namespace": "AWS/CloudFront",
          "options": {
            "showDisabledItems": false
          },
          "period": "",
          "refId": "A",
          "region": "us-east-1",
          "statistic": "Sum"
        },
        {
          "alias": "{{namespace}} - {{label}}",
          "application": {
            "filter": ""
          },
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "dimensions": {
            "DistributionId": "*",
            "Region": "Global"
          },
          "expression": "",
          "functions": [],
          "group": {
            "filter": ""
          },
          "host": {
            "filter": ""
          },
          "id": "",
          "item": {
            "filter": ""
          },
          "matchExact": true,
          "metricEditorMode": 0,
          "metricName": "BytesUploaded",
          "metricQueryType": 0,
          "mode": 0,
          "namespace": "AWS/CloudFront",
          "options": {
            "showDisabledItems": false
          },
          "period": "",
          "refId": "B",
          "region": "us-east-1",
          "statistic": "Sum"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Site traffic",
      "tooltip": {
        "msResolution": false,
        "shared": true,
        "sort": 0,
        "value_type": "cumulative"
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
          "$$hashKey": "object:257",
          "format": "bytes",
          "logBase": 1,
          "min": 0,
          "show": true
        },
        {
          "$$hashKey": "object:258",
          "format": "bytes",
          "logBase": 1,
          "min": "0",
          "show": true
        }
      ],
      "yaxis": {
        "align": false
      }
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
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "influxdb",
        "uid": "P951FEA4DE68E13C5"
      },
      "fill": 1,
      "fillGradient": 10,
      "gridPos": {
        "h": 5,
        "w": 6,
        "x": 18,
        "y": 5
      },
      "hiddenSeries": false,
      "id": 44,
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
      "nullPointMode": "connected",
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
      "thresholds": [],
      "timeRegions": [],
      "title": "Ping Response Time",
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
          "$$hashKey": "object:79",
          "format": "ms",
          "logBase": 1,
          "show": true
        },
        {
          "$$hashKey": "object:80",
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
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "cloudwatch",
        "uid": "P034F075C744B399F"
      },
      "editable": true,
      "error": false,
      "fieldConfig": {
        "defaults": {
          "displayName": "${__field.displayName}"
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 2,
      "grid": {},
      "gridPos": {
        "h": 6,
        "w": 13,
        "x": 5,
        "y": 7
      },
      "hiddenSeries": false,
      "id": 12,
      "isNew": true,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "hideEmpty": false,
        "hideZero": false,
        "max": true,
        "min": true,
        "rightSide": false,
        "show": true,
        "sort": "current",
        "sortDesc": true,
        "total": true,
        "values": true
      },
      "lines": true,
      "linewidth": 2,
      "links": [],
      "nullPointMode": "connected",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "9.1.8",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [
        {
          "$$hashKey": "object:80",
          "alias": "VolumeIdleTime_Average",
          "yaxis": 2
        },
        {
          "$$hashKey": "object:189",
          "alias": "TotalErrorRate_Sum",
          "yaxis": 2
        },
        {
          "$$hashKey": "object:65",
          "alias": "TotalErrorRate_Average",
          "yaxis": 2
        }
      ],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "alias": "{{namespace}} - {{label}} - {{metric}}",
          "application": {
            "filter": ""
          },
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "dimensions": {
            "DistributionId": "*",
            "Region": "Global"
          },
          "expression": "",
          "functions": [],
          "group": {
            "filter": ""
          },
          "host": {
            "filter": ""
          },
          "id": "",
          "item": {
            "filter": ""
          },
          "matchExact": true,
          "metricEditorMode": 0,
          "metricName": "Requests",
          "metricQueryType": 0,
          "mode": 0,
          "namespace": "AWS/CloudFront",
          "options": {
            "showDisabledItems": false
          },
          "period": "",
          "refId": "A",
          "region": "us-east-1",
          "statistic": "Sum"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "API Requests",
      "tooltip": {
        "msResolution": false,
        "shared": true,
        "sort": 0,
        "value_type": "cumulative"
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
          "$$hashKey": "object:87",
          "format": "none",
          "logBase": 1,
          "min": 0,
          "show": true
        },
        {
          "$$hashKey": "object:88",
          "format": "percent",
          "logBase": 1,
          "min": "0",
          "show": true
        }
      ],
      "yaxis": {
        "align": false
      }
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
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "cloudwatch",
        "uid": "P034F075C744B399F"
      },
      "editable": true,
      "error": false,
      "fieldConfig": {
        "defaults": {
          "displayName": "${__field.displayName}"
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 2,
      "grid": {},
      "gridPos": {
        "h": 9,
        "w": 13,
        "x": 5,
        "y": 13
      },
      "hiddenSeries": false,
      "id": 90,
      "isNew": true,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "hideEmpty": false,
        "hideZero": false,
        "max": true,
        "min": true,
        "rightSide": false,
        "show": true,
        "sort": "current",
        "sortDesc": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 2,
      "links": [],
      "nullPointMode": "null as zero",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "9.1.8",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [
        {
          "$$hashKey": "object:80",
          "alias": "VolumeIdleTime_Average",
          "yaxis": 2
        },
        {
          "$$hashKey": "object:189",
          "alias": "TotalErrorRate_Sum",
          "yaxis": 2
        },
        {
          "$$hashKey": "object:65",
          "alias": "TotalErrorRate_Average",
          "yaxis": 2
        }
      ],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "alias": "{{namespace}} - {{label}} - {{metric}}",
          "application": {
            "filter": ""
          },
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "dimensions": {
            "DistributionId": "*",
            "Region": "Global"
          },
          "expression": "",
          "functions": [],
          "group": {
            "filter": ""
          },
          "hide": false,
          "host": {
            "filter": ""
          },
          "id": "",
          "item": {
            "filter": ""
          },
          "label": "${LABEL} - ${PROP('MetricName')}",
          "matchExact": true,
          "metricEditorMode": 0,
          "metricName": "TotalErrorRate",
          "metricQueryType": 0,
          "mode": 0,
          "namespace": "AWS/CloudFront",
          "options": {
            "showDisabledItems": false
          },
          "period": "",
          "queryMode": "Metrics",
          "refId": "B",
          "region": "us-east-1",
          "sqlExpression": "",
          "statistic": "Average"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "TotalErrorRate",
      "tooltip": {
        "msResolution": false,
        "shared": true,
        "sort": 0,
        "value_type": "cumulative"
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
          "$$hashKey": "object:87",
          "format": "none",
          "label": "",
          "logBase": 1,
          "min": 0,
          "show": true
        },
        {
          "$$hashKey": "object:88",
          "format": "percent",
          "label": "",
          "logBase": 1,
          "min": "0",
          "show": true
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "cloudwatch",
        "uid": "P034F075C744B399F"
      },
      "editable": true,
      "error": false,
      "fieldConfig": {
        "defaults": {
          "displayName": "${__field.displayName}"
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 2,
      "grid": {},
      "gridPos": {
        "h": 7,
        "w": 5,
        "x": 0,
        "y": 15
      },
      "hiddenSeries": false,
      "id": 89,
      "isNew": true,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": true,
        "min": true,
        "show": true,
        "sort": "current",
        "sortDesc": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 2,
      "links": [],
      "nullPointMode": "null as zero",
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
      "stack": true,
      "steppedLine": false,
      "targets": [
        {
          "alias": "{{namespace}} - {{label}} - {{metric}}",
          "application": {
            "filter": ""
          },
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "dimensions": {
            "DistributionId": "*",
            "Region": "Global"
          },
          "expression": "",
          "functions": [],
          "group": {
            "filter": ""
          },
          "host": {
            "filter": ""
          },
          "id": "",
          "item": {
            "filter": ""
          },
          "matchExact": true,
          "metricEditorMode": 0,
          "metricName": "5xxErrorRate",
          "metricQueryType": 0,
          "mode": 0,
          "namespace": "AWS/CloudFront",
          "options": {
            "showDisabledItems": false
          },
          "period": "",
          "refId": "B",
          "region": "us-east-1",
          "statistic": "Average"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "CloudFront 5xx Issues",
      "tooltip": {
        "msResolution": false,
        "shared": true,
        "sort": 0,
        "value_type": "cumulative"
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
          "$$hashKey": "object:294",
          "format": "percent",
          "logBase": 1,
          "min": 0,
          "show": true
        },
        {
          "$$hashKey": "object:295",
          "format": "s",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "cloudwatch",
        "uid": "P034F075C744B399F"
      },
      "editable": true,
      "error": false,
      "fieldConfig": {
        "defaults": {
          "displayName": "${__field.displayName}"
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 2,
      "grid": {},
      "gridPos": {
        "h": 7,
        "w": 6,
        "x": 18,
        "y": 15
      },
      "hiddenSeries": false,
      "id": 18,
      "isNew": true,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": true,
        "min": true,
        "show": true,
        "sort": "current",
        "sortDesc": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 2,
      "links": [],
      "nullPointMode": "null as zero",
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
      "stack": true,
      "steppedLine": false,
      "targets": [
        {
          "alias": "{{namespace}} - {{label}} - {{metric}}",
          "application": {
            "filter": ""
          },
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "dimensions": {
            "DistributionId": "*",
            "Region": "Global"
          },
          "expression": "",
          "functions": [],
          "group": {
            "filter": ""
          },
          "host": {
            "filter": ""
          },
          "id": "",
          "item": {
            "filter": ""
          },
          "matchExact": true,
          "metricEditorMode": 0,
          "metricName": "4xxErrorRate",
          "metricQueryType": 0,
          "mode": 0,
          "namespace": "AWS/CloudFront",
          "options": {
            "showDisabledItems": false
          },
          "period": "",
          "refId": "A",
          "region": "us-east-1",
          "statistic": "Average"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "CloudFront 4xx Issues",
      "tooltip": {
        "msResolution": false,
        "shared": true,
        "sort": 0,
        "value_type": "cumulative"
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
          "$$hashKey": "object:245",
          "format": "percent",
          "logBase": 1,
          "min": 0,
          "show": true
        },
        {
          "$$hashKey": "object:246",
          "format": "s",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "collapsed": true,
      "datasource": {
        "type": "influxdb",
        "uid": "P951FEA4DE68E13C5"
      },
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 22
      },
      "id": 20,
      "panels": [
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "description": "",
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 0,
            "y": 23
          },
          "hiddenSeries": false,
          "id": 24,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
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
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "$loadbalancername"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HTTPCode_Target_5XX_Count",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "D",
              "region": "default",
              "returnData": false,
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HTTPCode_Target 5xx",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:1244",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:1245",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "description": "",
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 0,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 8,
            "y": 23
          },
          "hiddenSeries": false,
          "id": 27,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
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
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL} - ${PROP('MetricName')}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HTTPCode_ELB_4XX_Count",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "D",
              "region": "default",
              "returnData": false,
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HTTPCode_Target 4xx",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:3317",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:3318",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "description": "",
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 16,
            "y": 23
          },
          "hiddenSeries": false,
          "id": 28,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
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
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL} - ${PROP('MetricName')}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HTTPCode_ELB_3XX_Count",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "D",
              "region": "default",
              "returnData": false,
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HTTPCode_Target 3xx",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:3395",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:3396",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 0,
            "y": 31
          },
          "hiddenSeries": false,
          "id": 30,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
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
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL} - ${PROP('MetricName')}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HTTPCode_ELB_5XX_Count",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "B",
              "region": "default",
              "returnData": false,
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HTTPCode_ELB 5xx",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:3473",
              "decimals": 0,
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:3474",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": false
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 8,
            "y": 31
          },
          "hiddenSeries": false,
          "id": 32,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
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
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "- ${LABEL} - ${PROP('MetricName')}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HTTPCode_ELB_4XX_Count",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "A",
              "region": "default",
              "returnData": false,
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HTTPCode_ELB 4xx",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:3547",
              "decimals": 0,
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:3548",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": false
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 16,
            "y": 31
          },
          "hiddenSeries": false,
          "id": 31,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
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
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL} - ${PROP('MetricName')}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HTTPCode_ELB_3XX_Count",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "D",
              "region": "default",
              "returnData": false,
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HTTPCode_ELB 3xx",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:3921",
              "decimals": 0,
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:3922",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": false
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 0,
            "y": 39
          },
          "hiddenSeries": false,
          "id": 36,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "hideEmpty": true,
            "hideZero": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "connected",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:3995",
              "alias": "ProcessedBytes_Average",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "$loadbalancername"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "ConsumedLBCapacityUnits",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "A",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            },
            {
              "alias": "",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "ProcessedBytes",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "B",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            },
            {
              "alias": "",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "ConsumedLCUs",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "C",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "ConsumedLBCapacityUnits / ConsumedLCUs / ProcessedBytes",
          "tooltip": {
            "msResolution": false,
            "shared": true,
            "sort": 0,
            "value_type": "cumulative"
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
              "$$hashKey": "object:81",
              "format": "bytes",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:82",
              "format": "bytes",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 8,
            "y": 39
          },
          "hiddenSeries": false,
          "id": 34,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "hideEmpty": true,
            "hideZero": true,
            "max": true,
            "min": true,
            "show": true,
            "total": true,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
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
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{label}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "ActiveConnectionCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "D",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            },
            {
              "alias": "{{label}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "NewConnectionCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "C",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            },
            {
              "alias": "{{label}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "$loadbalancername"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "hide": false,
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "RejectedConnectionCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "B",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            },
            {
              "alias": "{{label}} ",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "$loadbalancername"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "TargetConnectionErrorCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "A",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "ConnectionCount",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:93",
              "decimals": 0,
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:94",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": false
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 16,
            "y": 39
          },
          "hiddenSeries": false,
          "id": 22,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "connected",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:4312",
              "alias": "TargetResponseTime_Average",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{label}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "RequestCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "A",
              "region": "default",
              "returnData": false,
              "statistic": "Sum"
            },
            {
              "alias": "{{label}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "TargetResponseTime",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ApplicationELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "B",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "RequestCount / TargetResponseTime",
          "tooltip": {
            "msResolution": false,
            "shared": true,
            "sort": 0,
            "value_type": "cumulative"
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
              "$$hashKey": "object:4319",
              "decimals": 0,
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:4320",
              "format": "s",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        }
      ],
      "targets": [
        {
          "datasource": {
            "type": "influxdb",
            "uid": "P951FEA4DE68E13C5"
          },
          "refId": "A"
        }
      ],
      "title": "ELB Application Load Balancer",
      "type": "row"
    },
    {
      "collapsed": true,
      "datasource": {
        "type": "influxdb",
        "uid": "P951FEA4DE68E13C5"
      },
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 23
      },
      "id": 52,
      "panels": [
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 12,
            "x": 0,
            "y": 48
          },
          "hiddenSeries": false,
          "id": 54,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
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
              "alias": "{{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*",
                "TargetGroup": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HealthyHostCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/NetworkELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "D",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "Healthy Hosts Count",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:121",
              "decimals": 0,
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:122",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": false
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 12,
            "x": 12,
            "y": 48
          },
          "hiddenSeries": false,
          "id": 91,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
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
              "alias": "{{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*",
                "TargetGroup": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "UnHealthyHostCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/NetworkELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "A",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "Unhealthy Hosts Count",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:504",
              "decimals": 0,
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:505",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": false
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 0,
            "y": 56
          },
          "hiddenSeries": false,
          "id": 60,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:4715",
              "alias": "IPv6ProcessedBytes_Sum",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "TCP_Client_Reset_Count",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/NetworkELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "D",
              "region": "default",
              "returnData": false,
              "statistic": "Sum"
            },
            {
              "alias": "{{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "TCP_ELB_Reset_Count",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/NetworkELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "A",
              "region": "default",
              "returnData": false,
              "statistic": "Sum"
            },
            {
              "alias": "{{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "TCP_Target_Reset_Count",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/NetworkELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "B",
              "region": "default",
              "returnData": false,
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "TCP",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:4722",
              "decimals": 0,
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:4723",
              "format": "decbytes",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 0,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 8,
            "y": 56
          },
          "hiddenSeries": false,
          "id": 58,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "connected",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:4800",
              "alias": "ProcessedBytes_Average",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{label}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "ProcessedBytes",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/NetworkELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "A",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            },
            {
              "alias": "{{label}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "ConsumedLCUs",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/NetworkELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "B",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "ConsumedLCUs / ProcessedBytes",
          "tooltip": {
            "msResolution": false,
            "shared": true,
            "sort": 0,
            "value_type": "cumulative"
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
              "$$hashKey": "object:4807",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:4808",
              "format": "bytes",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 16,
            "y": 56
          },
          "hiddenSeries": false,
          "id": 56,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "max",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "connected",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:4885",
              "alias": "TargetResponseTime_Average",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{label}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "ActiveFlowCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/NetworkELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "A",
              "region": "default",
              "returnData": false,
              "statistic": "Sum"
            },
            {
              "alias": "{{label}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancer": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "NewFlowCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/NetworkELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "B",
              "region": "default",
              "returnData": false,
              "statistic": "Average"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "Net /Active Flow Count",
          "tooltip": {
            "msResolution": false,
            "shared": true,
            "sort": 0,
            "value_type": "cumulative"
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
              "$$hashKey": "object:4892",
              "decimals": 0,
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:4893",
              "format": "s",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        }
      ],
      "targets": [
        {
          "datasource": {
            "type": "influxdb",
            "uid": "P951FEA4DE68E13C5"
          },
          "refId": "A"
        }
      ],
      "title": "NLB Network Load Balancer",
      "type": "row"
    },
    {
      "collapsed": true,
      "datasource": {
        "type": "influxdb",
        "uid": "P951FEA4DE68E13C5"
      },
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 24
      },
      "id": 62,
      "panels": [
        {
          "aliasColors": {
            "BackendConnectionErrors_Sum": "#BF1B00"
          },
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 0,
            "y": 25
          },
          "hiddenSeries": false,
          "id": 70,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:5018",
              "alias": "Latency_Average",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:5019",
              "alias": "SpilloverCount_Sum",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:5020",
              "alias": "BackendConnectionErrors_Sum",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL} - ${PROP('MetricName')}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HealthyHostCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "A",
              "region": "default",
              "sqlExpression": "",
              "statistic": "Average"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HealthyHostCount",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:347",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:348",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {
            "BackendConnectionErrors_Sum": "#BF1B00"
          },
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 8,
            "y": 25
          },
          "hiddenSeries": false,
          "id": 76,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:5115",
              "alias": "Latency_Average",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:5116",
              "alias": "SpilloverCount_Sum",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:5117",
              "alias": "BackendConnectionErrors_Sum",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL} - ${PROP('MetricName')}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "UnHealthyHostCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "B",
              "region": "default",
              "sqlExpression": "",
              "statistic": "Average"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "UnHealthyHostCount",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:347",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:348",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 16,
            "y": 25
          },
          "hiddenSeries": false,
          "id": 77,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "connected",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:5212",
              "alias": "Latency_Average",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "Latency",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "B",
              "region": "default",
              "statistic": "Average"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "Latency",
          "tooltip": {
            "msResolution": false,
            "shared": true,
            "sort": 0,
            "value_type": "cumulative"
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
              "$$hashKey": "object:816",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:817",
              "format": "s",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 0,
            "y": 33
          },
          "hiddenSeries": false,
          "id": 64,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "connected",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:5295",
              "alias": "Latency_Average",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "RequestCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "A",
              "region": "default",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "RequestCount",
          "tooltip": {
            "msResolution": false,
            "shared": true,
            "sort": 0,
            "value_type": "cumulative"
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
              "$$hashKey": "object:816",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:817",
              "format": "s",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {
            "BackendConnectionErrors_Sum": "#BF1B00"
          },
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 8,
            "y": 33
          },
          "hiddenSeries": false,
          "id": 75,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:5378",
              "alias": "Latency_Average",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:5379",
              "alias": "SpilloverCount_Sum",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:5380",
              "alias": "BackendConnectionErrors_Sum",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "$loadbalancername"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "BackendConnectionErrors",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "C",
              "region": "default",
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "BackendConnectionErrors",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:347",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:348",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 16,
            "y": 33
          },
          "hiddenSeries": false,
          "id": 93,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "connected",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:5475",
              "alias": "Latency_Average",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:5476",
              "alias": "SpilloverCount_Sum",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "$loadbalancername"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL} - ${PROP('MetricName')}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "SpilloverCount",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "A",
              "region": "default",
              "sqlExpression": "",
              "statistic": "Sum"
            },
            {
              "alias": "{{namespace}} - {{label}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL} - ${PROP('MetricName')}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "SurgeQueueLength",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "B",
              "region": "default",
              "sqlExpression": "",
              "statistic": "Maximum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "SpilloverCount / SurgeQueueLength",
          "tooltip": {
            "msResolution": false,
            "shared": true,
            "sort": 0,
            "value_type": "cumulative"
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
              "$$hashKey": "object:157",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:158",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {
            "HTTPCode_Backend_2XX_Sum": "#7EB26D",
            "HTTPCode_Backend_5XX_Sum": "#BF1B00",
            "HTTPCode_ELB_4XX_Sum": "#EAB839",
            "HTTPCode_ELB_5XX_Sum": "#99440A"
          },
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "description": "",
          "editable": true,
          "error": false,
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 0,
            "y": 41
          },
          "hiddenSeries": false,
          "id": 79,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:5565",
              "alias": "HTTPCode_ELB_4XX_Sum",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:5566",
              "alias": "HTTPCode_ELB_5XX_Sum",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "$loadbalancername"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HTTPCode_Backend_5XX",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "D",
              "region": "default",
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HTTPCode_Backend 5xx",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:324",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:325",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {
            "HTTPCode_Backend_2XX_Sum": "#7EB26D",
            "HTTPCode_Backend_5XX_Sum": "#BF1B00",
            "HTTPCode_ELB_4XX_Sum": "#EAB839",
            "HTTPCode_ELB_5XX_Sum": "#99440A"
          },
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "description": "",
          "editable": true,
          "error": false,
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 8,
            "y": 41
          },
          "hiddenSeries": false,
          "id": 78,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:5655",
              "alias": "HTTPCode_ELB_4XX_Sum",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:5656",
              "alias": "HTTPCode_ELB_5XX_Sum",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "$loadbalancername"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HTTPCode_Backend_4XX",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "C",
              "region": "default",
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HTTPCode_Backend 4xx",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:377",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:378",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {
            "HTTPCode_Backend_2XX_Sum": "#7EB26D",
            "HTTPCode_Backend_5XX_Sum": "#BF1B00",
            "HTTPCode_ELB_4XX_Sum": "#EAB839",
            "HTTPCode_ELB_5XX_Sum": "#99440A"
          },
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "description": "",
          "editable": true,
          "error": false,
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 16,
            "y": 41
          },
          "hiddenSeries": false,
          "id": 80,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:5833",
              "alias": "HTTPCode_ELB_4XX_Sum",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:5834",
              "alias": "HTTPCode_ELB_5XX_Sum",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "$loadbalancername"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HTTPCode_Backend_3XX",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "B",
              "region": "default",
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HTTPCode_Backend 3xx",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:434",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:435",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {
            "HTTPCode_Backend_2XX_Sum": "#7EB26D",
            "HTTPCode_Backend_5XX_Sum": "#BF1B00",
            "HTTPCode_ELB_4XX_Sum": "#EAB839",
            "HTTPCode_ELB_5XX_Sum": "#99440A"
          },
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "description": "",
          "editable": true,
          "error": false,
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 0,
            "y": 49
          },
          "hiddenSeries": false,
          "id": 83,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:5923",
              "alias": "HTTPCode_ELB_4XX_Sum",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:5924",
              "alias": "HTTPCode_ELB_5XX_Sum",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "$loadbalancername"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HTTPCode_ELB_5XX",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "F",
              "region": "default",
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HTTPCode_ELB 5xx",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:860",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:861",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {
            "HTTPCode_Backend_2XX_Sum": "#7EB26D",
            "HTTPCode_Backend_5XX_Sum": "#BF1B00",
            "HTTPCode_ELB_4XX_Sum": "#EAB839",
            "HTTPCode_ELB_5XX_Sum": "#99440A"
          },
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "description": "",
          "editable": true,
          "error": false,
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 8,
            "y": 49
          },
          "hiddenSeries": false,
          "id": 82,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:6013",
              "alias": "HTTPCode_ELB_4XX_Sum",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:6014",
              "alias": "HTTPCode_ELB_5XX_Sum",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "$loadbalancername"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HTTPCode_ELB_4XX",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "E",
              "region": "default",
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HTTPCode_ELB 4xx",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:548",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:549",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {
            "HTTPCode_Backend_2XX_Sum": "#7EB26D",
            "HTTPCode_Backend_5XX_Sum": "#BF1B00",
            "HTTPCode_ELB_4XX_Sum": "#EAB839",
            "HTTPCode_ELB_5XX_Sum": "#99440A"
          },
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "description": "",
          "editable": true,
          "error": false,
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 16,
            "y": 49
          },
          "hiddenSeries": false,
          "id": 81,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": true,
            "min": true,
            "show": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "null as zero",
          "options": {
            "alertThreshold": true
          },
          "percentage": false,
          "pluginVersion": "9.1.8",
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "$$hashKey": "object:6103",
              "alias": "HTTPCode_ELB_4XX_Sum",
              "yaxis": 2
            },
            {
              "$$hashKey": "object:6104",
              "alias": "HTTPCode_ELB_5XX_Sum",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": true,
          "steppedLine": false,
          "targets": [
            {
              "alias": "{{namespace}} - {{metric}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "LoadBalancerName": "$loadbalancername"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "label": "${LABEL}",
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "HTTPCode_Backend_2XX",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/ELB",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "queryMode": "Metrics",
              "refId": "A",
              "region": "default",
              "sqlExpression": "",
              "statistic": "Sum"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "HTTPCode_Backend 2xx",
          "tooltip": {
            "msResolution": false,
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
              "$$hashKey": "object:491",
              "format": "none",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:492",
              "format": "short",
              "logBase": 1,
              "min": 0,
              "show": true
            }
          ],
          "yaxis": {
            "align": false
          }
        }
      ],
      "targets": [
        {
          "datasource": {
            "type": "influxdb",
            "uid": "P951FEA4DE68E13C5"
          },
          "refId": "A"
        }
      ],
      "title": "ELB Clasic Load Balancer",
      "type": "row"
    },
    {
      "collapsed": true,
      "datasource": {
        "type": "influxdb",
        "uid": "P951FEA4DE68E13C5"
      },
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 25
      },
      "id": 8,
      "panels": [
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 13,
            "w": 12,
            "x": 0,
            "y": 26
          },
          "hiddenSeries": false,
          "id": 2,
          "isNew": true,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "hideEmpty": false,
            "hideZero": false,
            "max": true,
            "min": true,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "connected",
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
              "alias": "Total",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "Currency": "USD"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "EstimatedCharges",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/Billing",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "A",
              "region": "us-east-1",
              "returnData": false,
              "statistic": "Average"
            },
            {
              "alias": "{{ServiceName}}",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "Currency": "USD",
                "ServiceName": "*"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "EstimatedCharges",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/Billing",
              "options": {
                "showDisabledItems": false
              },
              "period": "",
              "refId": "B",
              "region": "us-east-1",
              "returnData": false,
              "statistic": "Average"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "Estimated charges",
          "tooltip": {
            "msResolution": false,
            "shared": true,
            "sort": 2,
            "value_type": "cumulative"
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
              "$$hashKey": "object:6201",
              "format": "currencyUSD",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:6202",
              "format": "short",
              "logBase": 1,
              "show": false
            }
          ],
          "yaxis": {
            "align": false
          }
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": {
            "type": "cloudwatch",
            "uid": "P034F075C744B399F"
          },
          "editable": true,
          "error": false,
          "fieldConfig": {
            "defaults": {
              "links": []
            },
            "overrides": []
          },
          "fill": 1,
          "fillGradient": 2,
          "grid": {},
          "gridPos": {
            "h": 13,
            "w": 11,
            "x": 12,
            "y": 26
          },
          "hiddenSeries": false,
          "id": 4,
          "isNew": true,
          "legend": {
            "alignAsTable": false,
            "avg": true,
            "current": true,
            "hideEmpty": false,
            "hideZero": false,
            "max": true,
            "min": true,
            "rightSide": false,
            "show": false,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 2,
          "links": [],
          "nullPointMode": "connected",
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
              "alias": "",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "Currency": "USD"
              },
              "expression": "",
              "functions": [],
              "group": {
                "filter": ""
              },
              "hide": true,
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "m1",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 0,
              "metricName": "EstimatedCharges",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/Billing",
              "options": {
                "showDisabledItems": false
              },
              "period": "86400",
              "refId": "A",
              "region": "us-east-1",
              "returnData": false,
              "statistic": "Average"
            },
            {
              "alias": "",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "Currency": "USD"
              },
              "expression": "RATE(m1) * PERIOD(m1)",
              "functions": [],
              "group": {
                "filter": ""
              },
              "hide": true,
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "m2",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 1,
              "metricName": "EstimatedCharges",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/Billing",
              "options": {
                "showDisabledItems": false
              },
              "period": "86400",
              "refId": "B",
              "region": "us-east-1",
              "returnData": false,
              "statistic": "Average"
            },
            {
              "alias": "Total estimated daily charge",
              "application": {
                "filter": ""
              },
              "datasource": {
                "type": "cloudwatch",
                "uid": "P034F075C744B399F"
              },
              "dimensions": {
                "Currency": "USD"
              },
              "expression": "IF(m2>0, m2)",
              "functions": [],
              "group": {
                "filter": ""
              },
              "hide": false,
              "highResolution": false,
              "host": {
                "filter": ""
              },
              "id": "m3",
              "item": {
                "filter": ""
              },
              "matchExact": true,
              "metricEditorMode": 1,
              "metricName": "EstimatedCharges",
              "metricQueryType": 0,
              "mode": 0,
              "namespace": "AWS/Billing",
              "options": {
                "showDisabledItems": false
              },
              "period": "86400",
              "refId": "C",
              "region": "us-east-1",
              "returnData": false,
              "statistic": "Average"
            }
          ],
          "thresholds": [],
          "timeRegions": [],
          "title": "Estimated daily charges",
          "tooltip": {
            "msResolution": false,
            "shared": true,
            "sort": 2,
            "value_type": "cumulative"
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
              "$$hashKey": "object:75",
              "format": "currencyUSD",
              "logBase": 1,
              "min": 0,
              "show": true
            },
            {
              "$$hashKey": "object:76",
              "format": "short",
              "logBase": 1,
              "show": false
            }
          ],
          "yaxis": {
            "align": false
          }
        }
      ],
      "targets": [
        {
          "datasource": {
            "type": "influxdb",
            "uid": "P951FEA4DE68E13C5"
          },
          "refId": "A"
        }
      ],
      "title": "Billing",
      "type": "row"
    }
  ],
  "refresh": "30s",
  "schemaVersion": 37,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": [
      {
        "current": {
          "selected": true,
          "text": "typeqast.com",
          "value": "typeqast.com"
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
      },
      {
        "current": {
          "selected": true,
          "text": [
            "All"
          ],
          "value": [
            "$__all"
          ]
        },
        "datasource": {
          "type": "cloudwatch",
          "uid": "P034F075C744B399F"
        },
        "definition": "dimension_values($region,AWS/ApplicationELB,ActiveConnectionCount,LoadBalancer)",
        "hide": 2,
        "includeAll": true,
        "label": "Load Balancer",
        "multi": true,
        "name": "loadbalancername",
        "options": [],
        "query": "dimension_values($region,AWS/ApplicationELB,ActiveConnectionCount,LoadBalancer)",
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      },
      {
        "current": {
          "selected": false,
          "text": "default",
          "value": "default"
        },
        "datasource": {
          "type": "cloudwatch",
          "uid": "P034F075C744B399F"
        },
        "definition": "regions()",
        "hide": 2,
        "includeAll": false,
        "label": "Region",
        "multi": false,
        "name": "region",
        "options": [],
        "query": "regions()",
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      }
    ]
  },
  "time": {
    "from": "now-7d",
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
  "title": "AWS Resource Monitoring",
  "uid": "2NjoRTNVz",
  "version": 2,
  "weekStart": ""
}
```