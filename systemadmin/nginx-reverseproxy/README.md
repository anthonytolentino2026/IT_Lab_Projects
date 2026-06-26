# Proxmox LXC Container with Nginx Configuration Documentation

## Overview

This document provides detailed instructions on how to set up a Proxmox Linux container with Nginx, including configuration changes, troubleshooting common issues, and verifying results. The purpose of this documentation is to ensure that the setup can be easily reproduced and maintained.

## Objective

The objective of this project is to configure a Proxmox LXC container with Nginx to handle both HTTP and WebSocket requests from clients. This setup involves creating an LXC container, installing necessary packages, configuring Nginx, and troubleshooting any issues that may arise during the process.

## Main Components
- **Proxmox VE**: Type 1 Hypervisor used to create Virtual Machines and Linux Containers.
- **Nginx**: Installed on the LXC container to handle HTTP requests efficiently. This handles all HTTP Requests customized from a server block in `sites-available` to manage both static and dynamic content based on client requests.
- **Pi-Hole DNS**: DNS Resolver which was used to map domain name of TrueNAS to the Reverse Proxy (Nginx)
- **Server Block Configuration**: By editing server blocks, This was used to define routes that could handle different types of requests, ensuring smooth performance for clients.

## Results

### Nginx Access Logs

<div align="center">
  <img src="images/nginx_accesslogs.png"
       alt="Nginx Access Logs"
       width="750">
  <p>Nginx logs confirming HTTP requests can access TrueNAS.</p>
</div>

### Accessing TrueNAS via Nginx

<div align="center">
  <img src="images/truenas.png"
       alt="TrueNAS"
       width="750">
  <p>Accessing TrueNAS through Nginx reverse proxy.</p>
</div>


## Learning Outcome

- Configuring Nginx as Reverse Proxy allows it to act as a gateway access to the Applications behind it.
- Specifying the server name for Nginx is important because this allows the it to forward/route the HTTP Request from the client endpoint to the Server.
- DNS Resolver helped redirecting the client requests by mapping TrueNAS's domain name to the IP address of Nginx, and when Nginx receives the HTTP Request it checks on its sites-available what is the IP address of TrueNAS

## Conclusion

This project successfully demonstrates how to set up a Proxmox LXC container with Nginx, allowing it to handle both HTTP and WebSocket requests. By following these instructions, you can easily replicate and maintain this setup for future reference or deployment needs. If you encounter any issues during the process, feel free to ask for assistance.
