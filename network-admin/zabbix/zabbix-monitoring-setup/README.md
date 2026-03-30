# Zabbix Monitoring Setup

Personal Zabbix 7.4 lab.

## Setup

- **Zabbix Server**
- **Zabbix Agent**

## Tech Stack

- Zabbix 7.4
- MariaDB
- Nginx + PHP 8.3
- Zabbix Agent 2 (on monitored hosts)

## Directories

| Section              | Directory/Path                                      | Description                                                 | Links                                           |
|----------------------|-----------------------------------------------------|-------------------------------------------------------------|-------------------------------------------------|
| **Docs**             | `docs/installation.md`                              | Full installation steps for Zabbix Server + MariaDB + Nginx | [View](docs/installation.md)                    |
| **Docs**             | `docs/hosts.md`                                     | List of monitored hosts and how they were added             | [View](docs/hosts.md)                           |
| **Docs**             | `docs/templates.md`                                 | Used templates and custom triggers                          | [View](docs/templates.md)                       |
| **Docs**             | `docs/troubleshooting.md`                           | Common issues and solutions                                 | [View](docs/troubleshooting.md)                 |
| **Configs**          | `configs/zabbix_server.conf`                        | Main Zabbix Server configuration                            | [View](configs/zabbix_server.conf)              |
| **Configs**          | `configs/zabbix_agent2.conf`                        | Example Agent 2 configuration                               | [View](configs/zabbix_agent2.conf)              |
| **Configs**          | `configs/nginx.conf`                                | Nginx configuration for Zabbix frontend                     | [View](configs/nginx.conf)                      |

## Lessons Learned


## Results

![Dashboard](screenshots/dashboard.png)
![Ubuntu Server Host](screenshots/ubuntu-server-resource-usage.png)
![Warning Severity Issue](screenshots/Zabbix-warning-severity.png)

## Future Plans

- Add Cisco devices via SNMP
- Set up notifications using Slack 
- Deploy Zabbix Proxy
