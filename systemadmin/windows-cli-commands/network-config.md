# Windows 10 Network Configuration via CLI

This documentation explains how to configure a **static IP address**, **disable Windows Firewall**, and revert the interface back to **DHCP** using Windows Command Prompt (`netsh`).

> ⚠️ All commands must be executed in **Command Prompt (Run as Administrator)**.

---

## 🖥️ Environment

- OS: Windows 10  
- Interface Name: `Ethernet`  
- Static IP Address: `172.16.3.10`  
- Subnet Mask: `255.255.255.0`  
- Default Gateway: `172.16.3.1`  

---

# Windows 10 (Machine 1)

## 1️⃣ Set Static IP Address

```cmd
netsh interface ip set address name="Ethernet" static 172.16.3.10 255.255.255.0 172.16.3.1
```

### Explanation:
- `name="Ethernet"` → Target network interface  
- `static` → Sets static configuration  
- `172.16.3.10` → IP Address  
- `255.255.255.0` → Subnet Mask  
- `172.16.3.1` → Default Gateway  

---

## 2️⃣ Disable Windows Firewall

```cmd
netsh advfirewall set allprofiles off
```

> ⚠️ Recommended for lab/testing purposes only.

---

## 3️⃣ Set Interface Back to DHCP

```cmd
netsh interface ip set address name="Ethernet" source=dhcp
```

---

# Windows 10 (Machine 2)

The same configuration steps were applied to the second Windows 10 machine.

## 1️⃣ Set Static IP Address

```cmd
netsh interface ip set address name="Ethernet" static 172.16.3.10 255.255.255.0 172.16.3.1
```

## 2️⃣ Disable Windows Firewall

```cmd
netsh advfirewall set allprofiles off
```

## 3️⃣ Set Interface Back to DHCP

```cmd
netsh interface ip set address name="Ethernet" source=dhcp
```

---

# 🔎 Verification Commands

## Check Current IP Configuration

```cmd
ipconfig /all
```

## Check Firewall Status

```cmd
netsh advfirewall show allprofiles
```

## List Network Interfaces

```cmd
netsh interface show interface
```

---

# 📌 Notes

- Ensure the interface name matches your system (`Ethernet`, `Wi-Fi`, etc.)
- Administrator privileges are required.
- Intended for lab, testing, and controlled environments.
