+++
title = "Team 8: Remote access"
weight = 8
+++

**Windows world:** `10.50.13.17`, Remote Desktop (RDP) · **Linux world:** `10.50.13.28`, OpenSSH and xrdp (Debian container)

## The role at a school

The IT custodian is at home, and a service on the server in the basement has hung. Instead of driving to school, they connect over the network. Or: students work from weak laptops on a powerful server with programs they cannot install themselves. Both are **remote access**: as a **command line** (SSH, PowerShell remoting) for administration and as a **graphical desktop** (RDP) for working with programs.

## Dependencies

- Session 1: none (local accounts).
- Session 2: directory service (team 3) for login with domain accounts.

## Goal in the Windows world

- **Remote Desktop** switched on, with *Network Level Authentication* (NLA), firewall rule only for the lab VLAN.
- One local group may log in (*Remote Desktop Users*), others may not.
- **PowerShell remoting** (WinRM) switched on for administration.
- Hint: registry value `fDenyTSConnections`, `Enable-NetFirewallRule`, `Enable-PSRemoting`.

{{% callout style="info" title="Two sessions or more?" %}}
Windows Server allows **two** simultaneous Remote Desktop sessions for **administration** without an additional licence. For more users you need the *Remote Desktop Session Host* role and **RDS client access licences** (RDS CAL) per user or device. You do **not** install the session host role in the lab, but it belongs in the comparison.
{{% /callout %}}

## Goal in the Linux world

- **OpenSSH server** runs, login with a **key** instead of a password, `root` may not log in directly.
- **xrdp** with a lightweight desktop (Xfce) as graphical remote access. Any number of simultaneous sessions, no client access licences.
- Only members of a group (`fernzugriff`) may log in via SSH and RDP.
- Hint: packages `openssh-server`, `xrdp`, `xfce4`; configuration in `/etc/ssh/sshd_config.d/` and `/etc/xrdp/`. Check with `sshd -t`.

## Goal in session 2

1. Login with **domain accounts** (the Windows server joins `win.schule.lan`, the container `linux.schule.lan` with `sssd`).
2. **Combination:** the Windows test client opens a session **on the Linux container** with Remote Desktop Connection (`mstsc`) (xrdp speaks RDP). The Linux test client opens a session on the Windows server with *Remmina*.
3. For some years now Windows has had a built-in **OpenSSH server**. Switch it on and connect to Windows via SSH.
4. Optional: [Apache Guacamole](https://guacamole.apache.org/) as remote access **in the browser**, without a program on the client.

## Acceptance tests

| Test | Windows test client | Linux test client |
|---|---|---|
| Command line | `Enter-PSSession -ComputerName 10.50.13.17` or `ssh lehrer01@10.50.13.28` | `ssh lehrer01@10.50.13.28` |
| Graphical desktop | `mstsc /v:10.50.13.17` and `mstsc /v:10.50.13.28` | Remmina to `10.50.13.17` and `10.50.13.28` |
| Only the group | `schueler01` (not in the group) is rejected | as on the left |
| Password login disabled | | `ssh -o PubkeyAuthentication=no lehrer01@10.50.13.28` is rejected |

## Pitfalls

- **Never** open Remote Desktop directly to the internet. From outside only via VPN or a gateway with multi-factor login.
- SSH: whoever disables password login before their key works locks themselves out. In Proxmox the console helps; at a school, not always.
- Windows firewall rules have different names depending on the system language. Address rules via the group (`-Group`) instead of the displayed name.
- xrdp in the container: the desktop (Xfce) must be installed in the container; otherwise the screen stays black after login.

## Entry points

- Microsoft Learn: [Enable Remote Desktop](https://learn.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/remote-desktop-allow-access), [Licensing Remote Desktop Services](https://learn.microsoft.com/en-us/windows-server/remote/remote-desktop-services/rds-client-access-license)
- Microsoft Learn: [OpenSSH for Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview), [Enable-PSRemoting](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/enable-psremoting)
- OpenSSH: `man sshd_config`; Debian Wiki: [SSH](https://wiki.debian.org/SSH)
- xrdp: [project page and wiki](https://github.com/neutrinolabs/xrdp)

## Comparison questions

- What does it cost to give 25 students a server desktop at the same time, in each world?
- Which protocols are open, which vendor-specific? (Hint: RDP is documented, xrdp speaks it.)
- Who at a school may access servers remotely, and how is that logged?
- Which solution would you recommend to a team of teachers that has only half a day per week for IT?
