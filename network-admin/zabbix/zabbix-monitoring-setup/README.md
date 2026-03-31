# Zabbix Monitoring Setup with Slack Notifications

Personal Zabbix 7.4 lab.

## Overview

<p>This documentation covers the setup of Zabbix as an open source monitoring solution for tracking infrastructure resources and performance metrics. 
The entire environment was built as a lab in a virtualized setup using Proxmox VE. Zabbix Server was installed with MariaDB as the backend database and
Nginx + PHP 8.3 for web front end. Slack integration was added to deliver real-time alert notifications.

## Main Components
- Zabbix Server: Centralizes the collection of data from monitored devices, processes metrics, evaluates triggers (based on thresholds for Problems), generates
alerts and stores historical data
- Zabbix Agent 2: A lightweight that is installed on a host that will be monitored (servers, VMs etc.) They are the ones pushing data to the Zabbix Server or
responds to server polls.
</p>

## Tech Stack

- Proxmox VE - Virtualization platform
- Zabbix 7.4 - Monitoring platform
- MariaDB - Database backend
- Nginx + PHP 8.3 - Web service and frontend
- Zabbix Agent 2 - Installed on a monitored hosts

## Architecture
<div align="center">
  <img src="illustration/ZabbixInfra.jpg" 
       alt="Zabbix Infrastructure Diagram" 
       width="500">
</div>

<p>The illustration shows a simple setup of Zabbix Server and Agent as a Virtual Machine inside Proxmox. The environment shows Zabbix Agent sends Telemetry data to Zabbix Server.
Not only that it also provide sending an alert by emailing the User through Slack.
</p>

## Directories
<div align="center">
  
| Section              | Directory/Path                                      | Description                                                 | Links                                           |
|----------------------|-----------------------------------------------------|-------------------------------------------------------------|-------------------------------------------------|
| **Docs**             | `docs/installation.md`                              | Full installation steps for Zabbix Server + MariaDB + Nginx | [View](docs/installation.md)                    |
| **Docs**             | `docs/hosts.md`                                     | List of monitored hosts and how they were added             | [View](docs/hosts.md)                           |
| **Docs**             | `docs/templates.md`                                 | Used templates and custom triggers                          | [View](docs/templates.md)                       |
| **Docs**             | `docs/troubleshooting.md`                           | Common issues and solutions                                 | [View](docs/troubleshooting.md)                 |
| **Configs**          | `configs/zabbix_server.conf`                        | Main Zabbix Server configuration                            | [View](configs/zabbix_server.conf)              |
| **Configs**          | `configs/zabbix_agent2.conf`                        | Example Agent 2 configuration                               | [View](configs/zabbix_agent2.conf)              |
| **Configs**          | `configs/nginx.conf`                                | Nginx configuration for Zabbix frontend                     | [View](configs/nginx.conf)                      |

</div>

## Results
<div align="center">
  <img src="screenshots/dashboard.png"
       alt="Dashboard" 
       width="650">
  <p>Dashboard</p>
</div>

<div align="center">
  <img src="screenshots/Zabbix High CPU alerted.png"
       alt="Zabbix Warning and High Severity Alerts" 
       width="650">
  <p>Zabbix Alerted High CPU Usage from Warning to High Severity Problems on Ubuntu Server</p>
</div>

<div align="center">
  <img src="screenshots/Slack Messages.png"
       alt="Slack Messages" 
       width="650">
  <p>Slack Notification of High CPU Alerts</p>
</div>
