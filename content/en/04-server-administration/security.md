+++
title = "Security and data protection"
weight = 80
+++

{{% callout style="warning" title="No legal advice" %}}
This section gives technical orientation. Legal questions (e.g. legal basis, retention periods, data processing agreements) are clarified by the school with the data protection officer and the school maintainer.
{{% /callout %}}

## The essentials

| Topic | Measure |
|---|---|
| **Few administrator accounts** | A normal account for daily work, a separate administrator account for administration. The domain administrator is used only for domain tasks. |
| **One service, one server** | Each role on its own server or container: a fault in or attack on the web server does not immediately reach the domain controller. This is exactly how the lab is built. |
| **Only necessary services** | What is not needed is not installed. Server Core and minimal Debian installations have a smaller attack surface. |
| **Updates** | Update servers regularly, in the lab too. Debian: `unattended-upgrades` for security updates. Windows: Windows Update. |
| **Remote access** | Never Remote Desktop or SSH directly from the internet. SSH with keys, Remote Desktop with NLA, from outside only via VPN with multi-factor login. |
| **Open resolvers and DHCP** | DNS answers recursive queries only from your own network. Only one planned DHCP server per network; rogue DHCP servers are blocked on the switch (*DHCP snooping*). |
| **Encryption** | Websites only with HTTPS. Internal certificates from your own certificate authority instead of clicking browser warnings away. SMB1 stays switched off. |
| **Backup** | Domain controllers, shares and configuration files are backed up, and restoring is practised. A snapshot is not a backup. |

## Data protection in the school context

- **Directory service:** it contains names, class membership, login times and groups of minors. This belongs in the record of processing activities (see [documentation script]({{% relref "/00-documentation/processing-register-adr" %}})).
- **Logs:** DHCP (which device was on the network when), DNS (which sites are visited), print server (who prints what) and remote access (who logs in when) generate personal logs. Decide who may see them and when they are deleted.
- **Own server or cloud:** for roles in the cloud (Entra ID, Universal Print, Autopilot), the data is with a provider. That requires a data processing agreement and a check of where the data is processed. With your own servers, the school is responsible for operation and security itself.
- **Images (team 7):** a disk image can contain data of the last person who used the reference machine. Never use the reference machine with real accounts. Wipe old disks securely before passing them on.
- **Test data:** in the lab only made-up names (`lehrer01`, `schueler01`). No real class lists.
