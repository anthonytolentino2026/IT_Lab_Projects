# KVM Virtualization Setup on CachyOS

## 1. Understanding the Virtualization Components

| Component | Description |
|---|---|
| **KVM** | Linux kernel virtualization infrastructure that uses the CPU's hardware virtualization capabilities. |
| **QEMU** | Provides virtual machine hardware emulation and device virtualization. |
| **libvirt** | Manages and controls virtual machines and virtual networks. |
| **virt-manager** | Graphical interface for creating, configuring, and managing virtual machines. |
| **OVMF (UEFI)** | Provides UEFI firmware for virtual machines. |
| **dnsmasq** | Provides DHCP and DNS services for libvirt virtual networks. |
| **swtpm** | Software TPM emulator, useful for Windows 11 virtual machines. |

### How They work Together

- KVM handles hardware-assisted virtualization through the Linux Kernel.
- QEMU provides the virtual hardware and runs the virtual machine.
- libvirt manages virtual machines and their configurations.
- virt-manager provides a graphical interface for interacting with libvirt.

## 2. Check Hardware Virtualization Support

First, verify whether your laptop's CPU supports hardware virtualization.

```bash
lscpu | grep -E 'Virtualization|Model name'
```

Expected output:

**Intel processors:**

```text
Virtualization: VT-x
```

**AMD processors:**

```text
Virtualization: AMD-V
```

### Check also the KVM Kernel Modules

```bash
lsmod | grep kvm
```

For Intel processors, you should see something similar to:

```text
kvm_intel
kvm
irqbypass
```

For AMD processors:

```text
kvm_amd
kvm
```

> **Note:** KVM modules may not appear until KVM is loaded or a virtual machine is started. If the command returns nothing, it does not automatically mean your CPU lacks virtualization support.

---

## 3. Install the Virtualization Packages

CachyOS provides an official guide for configuring QEMU and Virtual Machine Manager.

Update the system:

```bash
sudo pacman -Syu
```

Install the required packages:

```bash
sudo pacman -S qemu-full virt-manager virt-viewer libvirt dnsmasq edk2-ovmf swtpm
```

### Package Descriptions

| Package | Purpose |
|---|---|
| `qemu-full` | QEMU virtualization and hardware emulation. |
| `virt-manager` | Graphical VM management interface. |
| `virt-viewer` | Standalone virtual machine console viewer. |
| `libvirt` | Virtual machine and network management service. |
| `dnsmasq` | DHCP and DNS services for virtual networks. |
| `edk2-ovmf` | UEFI firmware for virtual machines. |
| `swtpm` | Software-based TPM emulator. |

---

## 4. Enable libvirt

Enable the libvirt socket:

```bash
sudo systemctl enable --now libvirtd.socket
```

Check its status:

```bash
systemctl status libvirtd.socket
```

The socket allows libvirt to start its daemon when a client connects.

### Add your account to the libvirt group

First, verify that the group exists:

```bash
getent group libvirt
```

Example output:

```text
libvirt:x:951:
```

Add your current user to the group

```bash
usermod -aG libvirt $USER
```

> **Important:** Log out and log back in for the new group membership to take effect. Alternatively, start a new shell with `newgrp libvirt`.

---

## 5. Configure the Default Virtual Network

libvirt normally provides a default NAT network.

| Setting | Value |
|---|---|
| Network name | `default` |
| Network type | NAT |
| Virtual bridge | `virbr0` |
| Network address | `192.168.122.0/24` |
| Gateway | `192.168.122.1` |
| DHCP range | `192.168.122.2 - 192.168.122.254` |

### Enable Automatic Startup

```bash
sudo virsh net-autostart default
```

Expected output:

```text
Network default marked as autostarted
```

Check the network:

```bash
sudo virsh net-list --all
```

If the network is inactive, start it:

```bash
sudo virsh net-start default
```

Check the virtual bridge:

```bash
ip addr show virbr0
```

Expected address:

```text
inet 192.168.122.1/24
```

---

## 6. Launch Virtual Machine Manager

Launch Virtual Machine Manager:

```bash
virt-manager
```

You can now create and configure virtual machines through the graphical interface.

### Recommended VM Networking Settings

| Setting | Value |
|---|---|
| Network Source | Virtual network `default`: NAT |
| Device Model | Virtio |

With NAT networking, virtual machines use the host's network connection to access external networks without requiring their own physical LAN connection.

---

# 7. Additional Configuration: UFW Firewall

> **Important:** CachyOS may have UFW enabled. Its firewall policies can interfere with libvirt virtual networking.

During our Rocky Linux 10 installation, we encountered network connectivity problems:

1. The VM initially had difficulty obtaining network connectivity through the NAT interface.
2. The VM could reach an IP address, but DNS lookups such as `google.com` failed.

The DNS issue was resolved by allowing DNS traffic from the libvirt bridge to the host.

## 7.1 Configure libvirt to Use iptables

Edit the libvirt network configuration:

```bash
sudo nano /etc/libvirt/network.conf
```

Add the following setting if it is not already present:

```ini
firewall_backend = "iptables"
```

Alternatively, append it using:

```bash
echo 'firewall_backend = "iptables"' | sudo tee -a /etc/libvirt/network.conf
```

> **Note:** Check the configuration first to avoid duplicate entries.

This setting tells libvirt which firewall backend to use when managing virtual network firewall rules.

## 7.2 Enable the Default Virtual Network

Make sure the default network is configured to start automatically:

```bash
sudo virsh net-autostart default
```

If it is currently inactive:

```bash
sudo virsh net-start default
```

## 7.3 Allow VM Network Forwarding Through UFW

The default libvirt NAT network uses:

```text
192.168.122.0/24
```

Allow traffic from this subnet to be forwarded:

```bash
sudo ufw route allow from 192.168.122.0/24
```

This allows traffic originating from the virtual machine subnet to be routed through the host.

> **Security consideration:** This is a broad forwarding rule. Consider restricting the destination, interfaces, and permitted services according to your network security requirements.

## 7.4 Allow DNS Requests Through the Virtual Bridge

This was the important fix for our Rocky Linux installation.

The libvirt DNS service listens on:

```text
192.168.122.1
```

However, UFW's default incoming policy may block DNS requests addressed to the host itself.

Allow UDP port 53:

```bash
sudo ufw allow in on virbr0 to 192.168.122.1 port 53 proto udp
```

Allow TCP port 53:

```bash
sudo ufw allow in on virbr0 to 192.168.122.1 port 53 proto tcp
```

### Why Do We Need Both UDP and TCP?

- **UDP port 53:** Used for most ordinary DNS queries.
- **TCP port 53:** Used for DNS responses that require TCP, including certain larger responses and fallback scenarios.

These rules allow DNS requests arriving through `virbr0` to reach the host's libvirt DNS service.

### Verify UFW Rules

```bash
sudo ufw status numbered
```

You should see rules permitting DNS traffic on `virbr0` for both UDP and TCP.

---

# 8. Troubleshooting and Verification

If a virtual machine cannot access the network, troubleshoot the connection in layers.

### Check the libvirt Network

```bash
sudo virsh net-list --all
```

### Check the Virtual Bridge

```bash
ip addr show virbr0
```

### Check DHCP Leases

```bash
sudo virsh net-dhcp-leases default
```

### Check Whether dnsmasq Is Running

```bash
ps aux | grep '[d]nsmasq'
```

### Monitor DHCP Traffic

```bash
sudo tcpdump -ni virbr0 'port 67 or port 68'
```

### Monitor DNS Traffic

```bash
sudo tcpdump -ni virbr0 'port 53'
```

### Check UFW

```bash
sudo ufw status verbose
```

---

## 9. Virtual Network Architecture

The following illustrates how the Rocky Linux VM accesses the internet through libvirt NAT.

```text
+-----------------------------+
|       Rocky Linux VM        |
|                             |
|       192.168.122.x         |
+--------------+--------------+
               |
               |
               v
+-----------------------------+
|    libvirt Virtual Bridge   |
|           virbr0            |
|       192.168.122.1         |
+--------------+--------------+
               |
               |
               v
+-----------------------------+
|       dnsmasq Service       |
|                             |
|       DHCP / DNS            |
+--------------+--------------+
               |
               |
               v
+-----------------------------+
|        CachyOS Host         |
|                             |
|        NAT / Routing        |
+--------------+--------------+
               |
               |
               v
+-----------------------------+
|    Physical Network NIC     |
|                             |
|        10.1.1.10            |
+--------------+--------------+
               |
               v
           Internet
```

---

## 10. Official Documentation

- [CachyOS - QEMU and Virtual Machine Manager Setup](https://wiki.cachyos.org/virtualization/qemu_and_vmm_setup/)
- [libvirt Documentation](https://libvirt.org/docs.html)
- [QEMU Documentation](https://www.qemu.org/documentation/)
- [Arch Linux Wiki - QEMU](https://wiki.archlinux.org/title/QEMU)

---

## Final Notes

This setup provides a KVM/QEMU virtualization environment on CachyOS using libvirt and virt-manager.

The default NAT network is suitable for general virtual machine usage, including Linux server installations, Windows testing, and development environments.

Remember that UFW rules are part of the virtualization configuration. If DNS or network connectivity fails inside a VM, check the firewall policies on the host before assuming the guest operating system is misconfigured.
