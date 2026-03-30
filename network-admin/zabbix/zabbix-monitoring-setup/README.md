# My Zabbix Monitoring Setup

Personal Zabbix 7.4 lab / production setup.

## Current Infrastructure

- **Zabbix Server**: 172.16.2.14 (Ubuntu 24.04)
- **Monitored Hosts**:
  - Zabbix Server itself
  - Ubuntu Server (`ubuntu-server-01`)

## Tech Stack

- Zabbix 7.4
- MariaDB
- Nginx + PHP 8.3
- Zabbix Agent 2 (on monitored hosts)

## Lessons Learned


## Screenshots

![Dashboard](screenshots/dashboard.png)
![Ubuntu Server Host](screenshots/ubuntu-server-host.png)

## Future Plans

- Add Cisco devices via SNMP
- Set up notifications using Slack 
- Deploy Zabbix Proxy
