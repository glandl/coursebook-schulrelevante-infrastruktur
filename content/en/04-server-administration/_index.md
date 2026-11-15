+++
title = "Server Roles: Windows and Linux"
type = "chapter"
weight = 40
+++

**Sessions:** 16.11.2026 and 23.11.2026 · **Documentation technique:** [Runbooks]({{% relref "/00-documentation/runbooks" %}}) · **Role runbook due:** 06.12.2026

A school network needs more than cables and addresses. Devices get their address automatically, names are resolved, teachers log in with *one* account on every computer, find their class folders, print, open the school website, and in summer 25 computer-lab PCs are set up again in one hour. Each of these tasks is a **server role**.

In this chapter you build, over two sessions, **a working school network together** out of eight server roles, and you build it **twice**:

- in the **Windows world** with Windows Server 2025, the way many Austrian schools work, and
- in the **Linux world** with Debian 13 and free software that does the same job without licence costs.

Each **role team** (two people, one team of three) takes **one** role and builds it in **both worlds**. How you split the work within the team is up to you. At the end, each team presents its role to the others and compares: what does each world do better, what does it cost, how dependent does it make the school on one vendor?

All machines run in the lecturer's **Proxmox lab**. You do **not** need your own VM on the laptop, just a browser. See [Access to the Proxmox lab]({{% relref "proxmox-access" %}}).

{{% callout style="info" title="Background reading" %}}
DHCP, DNS and VLANs are explained in [chapter 3 (self-study)]({{% relref "/03-networking-2" %}}). Read at least the sections on DHCP and DNS before you take on the DHCP, DNS or directory service role.
{{% /callout %}}

## The eight roles and the teams

| Team | Role | Windows world | Linux world |
|---|---|---|---|
| 1 | [DHCP]({{% relref "roles/dhcp" %}}) | `10.50.13.10` Windows DHCP server | `10.50.13.21` Kea |
| 2 | [DNS]({{% relref "roles/dns" %}}) | `10.50.13.11` Windows DNS server | `10.50.13.22` BIND 9 |
| 3 (three people) | [Directory service]({{% relref "roles/directory" %}}) | `10.50.13.12` Active Directory (AD DS) | `10.50.13.23` Samba AD (VM) |
| 4 | [File shares]({{% relref "roles/file-shares" %}}) | `10.50.13.13` SMB shares with NTFS permissions | `10.50.13.24` Samba |
| 5 | [Printing]({{% relref "roles/print" %}}) | `10.50.13.14` print server | `10.50.13.25` CUPS |
| 6 | [Web]({{% relref "roles/web" %}}) | `10.50.13.15` IIS | `10.50.13.26` nginx |
| 7 | [Client deployment]({{% relref "roles/deployment" %}}) | `10.50.13.16` Windows reference machine | `10.50.13.27` FOG Project (VM) |
| 8 | [Remote access]({{% relref "roles/remote-access" %}}) | `10.50.13.17` Remote Desktop (RDP) | `10.50.13.28` SSH and xrdp |

People are assigned to teams at the start of the first session.

## IP plan of the lab

All machines are in **one** network, the **lab VLAN 50**. It is separated from the lecturer's other network and has internet access via the lab router.

| Range | Use |
|---|---|
| `10.50.13.0/24` | Lab VLAN 50, subnet mask `255.255.255.0` |
| `.10–.17` | Windows world servers (teams 1–8) |
| `.18–.19` | Windows world, lecturer (certificate services demo) |
| `.21–.28` | Linux world servers (teams 1–8) |
| `.29–.30` | Linux world, lecturer |
| `.100–.119` | DHCP range of the Windows DHCP server (team 1) |
| `.120–.139` | DHCP range of Kea (team 1) |
| `.254` | **Lab router**: gateway and DNS forwarder. It does **not** hand out addresses via DHCP. Nobody except the lecturer changes it. |

All servers have **static addresses**. As DNS server they first use `10.50.13.254`. Once DNS and the directory service are running, the Windows world servers switch to `10.50.13.12` (domain controller) and the Linux world servers to `10.50.13.23`.

| Domain | World | Responsible |
|---|---|---|
| `win.schule.lan` | Windows world | team 3 (AD DS with integrated DNS), team 2 (forwarders, zones) |
| `linux.schule.lan` | Linux world | team 3 (Samba AD), team 2 (BIND, forwarders) |

## Test clients

Whether a role really works shows on the device of a teacher or a student. For this, the lecturer provides **two test clients** (from the end of the first session):

- **Windows test client:** Windows 11 Enterprise (evaluation), gets its address from the Windows DHCP server and joins the domain `win.schule.lan`.
- **Linux test client:** Debian 13 with the Xfce desktop, gets its address from Kea and joins the domain `linux.schule.lan`.

All teams may use and restart the test clients. Only the lecturer can reset them. Agree who is testing what at the moment.

## Session plan

**Session 1 (16.11.2026, 08:45–13:00): every role runs on its own**

| Time | Duration | Content |
|---|---|---|
| 08:45–09:15 | 30 min | Introduction: what is a server role? The roles of a school at a glance, Windows and Linux compared |
| 09:15–09:30 | 15 min | Proxmox access, team table, IP plan, lab rules |
| 09:30–10:45 | 75 min | Team work: build your own role **on its own** in both worlds (local users, no domain yet) |
| 10:45–11:00 | 15 min | Break |
| 11:00–12:15 | 75 min | Team work (continued), first acceptance tests |
| 12:15–12:30 | 15 min | Break |
| 12:30–13:00 | 30 min | Status round: each team shows in one minute what runs in both worlds and what does not. First entry in the role runbook |

**Session 2 (23.11.2026, 08:45–13:00): the roles work together**

| Time | Duration | Content |
|---|---|---|
| 08:45–09:00 | 15 min | [Integration]({{% relref "integration" %}}): start check, DNS forwarding between the worlds |
| 09:00–10:15 | 75 min | Integration: test clients and servers join the domain, shares, printers and remote access with domain accounts, DHCP hands out the right DNS server, tests from the test client |
| 10:15–10:30 | 15 min | Break |
| 10:30–11:15 | 45 min | Combinations Windows and Linux (Linux client on Windows AD, Windows client on a Samba share, PXE boot with FOG), [lecturer demo: certificate services]({{% relref "ad-cs-demo" %}}) |
| 11:15–11:30 | 15 min | Break |
| 11:30–12:30 | 60 min | [Role presentations]({{% relref "presentation" %}}): 8 teams × 6 min, with changeover time |
| 12:30–13:00 | 30 min | Wrap-up, bridge to session 5 (device management builds on these roles) |

## What is submitted

- **Role runbook** (graded, due **06.12.2026**): see [documentation task]({{% relref "documentation" %}}).
- **Role presentation** (required, not graded): see [role presentation]({{% relref "presentation" %}}).
- There is **no** separate homework in this chapter.

{{% pages display="tree" levels="1" %}}
