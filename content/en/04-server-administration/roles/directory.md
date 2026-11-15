+++
title = "Team 3: Directory service"
weight = 3
+++

**Windows world:** `10.50.13.12`, Active Directory Domain Services (AD DS) · **Linux world:** `10.50.13.23`, Samba as an Active Directory domain controller (Debian **VM**)

This team has three people because almost all other roles wait for you in session 2.

## The role at a school

A teacher logs in with **one** account on the computer in the staff room, in the computer lab and on the projector PC. Her class folder is there everywhere, so is the printer, and when she leaves the school, the administration locks **one** account instead of twenty. That is what a **directory service** does: a central list of users, groups and devices, with login (Kerberos), queries (LDAP) and policies. In Austria, at many schools this is an Active Directory.

## Dependencies

- A static address and a **final computer name** **before** the setup. You do not rename a domain controller afterwards.
- DNS: the domain controller itself becomes the DNS server of its domain. Forwarder to `10.50.13.254`.
- **Time:** Kerberos refuses login when the clocks differ by more than 5 minutes.

## Goal in the Windows world

- Computer name `dc` (fully `dc.win.schule.lan`), static address `10.50.13.12`, DNS server `127.0.0.1`.
- **AD DS** role installed, new forest `win.schule.lan`, NetBIOS name `WINSCHULE`, DNS server integrated.
- Organizational units `Lehrende`, `Schueler`, `Gruppen`, `Geraete`.
- Test accounts `lehrer01`–`lehrer03`, `schueler01`–`schueler05`, groups `GG-Lehrende`, `GG-Schueler`.
- Hint: `Install-WindowsFeature AD-Domain-Services -IncludeManagementTools`, then `Install-ADDSForest`. Accounts with `New-ADOrganizationalUnit`, `New-ADUser`, `New-ADGroup`.

## Goal in the Linux world

- The Debian VM is installed (the Debian 13 image is attached; minimal, **without** a desktop, with SSH server).
- Computer name `dc` (fully `dc.linux.schule.lan`), static address `10.50.13.23`, entry in `/etc/hosts`.
- Samba as **AD domain controller** for `linux.schule.lan`, NetBIOS name `LXSCHULE`, Samba's internal DNS server with forwarding to `10.50.13.254`.
- The same organizational units, accounts and groups as in the Windows world.
- Hint: packages `samba`, `krb5-user`, `winbind`, `smbclient`. Set up with `samba-tool domain provision`, accounts with `samba-tool user add`, `samba-tool group add`, `samba-tool ou add`. The service is called `samba-ad-dc`; the services `smbd`, `nmbd` and `winbind` are **disabled** on a domain controller.

{{% callout style="info" title="Why a VM and not a container?" %}}
Samba stores the permissions of the logon scripts and policies (`sysvol`) in extended file attributes and ACLs. In an unprivileged Linux container this often does not work or only partly. That is why the Linux domain controller runs as its own VM.
{{% /callout %}}

## Goal in session 2

1. The **test clients** join the domains: the Windows test client `win.schule.lan`, the Linux test client `linux.schule.lan` (with `realm join`, packages `realmd` and `sssd`).
2. The servers of teams 4, 5 and 8 join the domain of their world so that shares, printers and remote access work with domain accounts. You support these teams.
3. **Combination:** a second Linux machine (e.g. another team's container) joins the **Windows** domain, or the Windows test client logs in to the **Samba** domain. Both work because Samba speaks the same protocols (LDAP, Kerberos, SMB).
4. Conditional DNS forwarders together with team 2.

## Acceptance tests

| Test | Windows test client | Linux test client |
|---|---|---|
| Domain controller found via DNS | `Resolve-DnsName _ldap._tcp.win.schule.lan -Type SRV` | `host -t SRV _ldap._tcp.linux.schule.lan` |
| Kerberos login | log in as `WINSCHULE\lehrer01` | `kinit lehrer01@LINUX.SCHULE.LAN`, then `klist` |
| Query accounts | `Get-ADUser -Filter * -SearchBase "OU=Lehrende,DC=win,DC=schule,DC=lan"` (on the DC) | `samba-tool user list` (on the DC) |
| Group membership on the client | `whoami /groups` | `id lehrer01@linux.schule.lan` |

## Pitfalls

- **Computer name or address changed after the setup:** rebuild the domain (snapshot!).
- The domain controller points with its DNS setting **to itself**, not to `10.50.13.254`. Otherwise it does not find its own SRV records.
- Samba: **delete** or rename `/etc/samba/smb.conf` before `samba-tool domain provision`, and replace `/etc/krb5.conf` with the generated file afterwards.
- Samba: `/etc/resolv.conf` must point to `127.0.0.1` or its own address.
- Avoid domain names ending in `.local` (collides with multicast DNS on Apple devices).
- Password policy: test accounts need passwords that meet the default policy.

## Entry points

- Microsoft Learn: [Install AD DS using PowerShell](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-)
- Microsoft Learn: [ActiveDirectory module (PowerShell)](https://learn.microsoft.com/en-us/powershell/module/activedirectory/)
- Samba Wiki: [Setting up Samba as an Active Directory Domain Controller](https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller)
- Samba Wiki: [Distribution-specific Package Installation](https://wiki.samba.org/index.php/Distribution-specific_Package_Installation)
- Debian Wiki: [AD Server with Samba](https://wiki.debian.org/AD%20Server)

## Comparison questions

- Samba can do much of what Active Directory does, but not everything (e.g. parts of Group Policy, management only with the Windows tools RSAT or the command line). Which of it does a school really need?
- What does a domain controller cost in each world: server licence, client access licences (CAL) for every teacher and every child?
- How many people at a school can look after a Samba domain in an emergency, how many an Active Directory?
- A directory service contains names, classes and login times of minors. Where is the data, who has access, who is responsible?
- Microsoft increasingly promotes the cloud (Entra ID). What would the switch mean for your role?
