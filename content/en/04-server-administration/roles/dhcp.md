+++
title = "Team 1: DHCP"
weight = 1
+++

**Windows world:** `10.50.13.10`, Windows DHCP server · **Linux world:** `10.50.13.21`, Kea DHCPv4 (Debian container)

## The role at a school

On the first day of school, 25 students open their laptops and all of them are on the network immediately. Nobody types in an IP address. The DHCP server gives every device an address, subnet mask, gateway and DNS server, and remembers whom it "lent" what (*lease*). In real school networks every VLAN has its own range, and the router forwards the requests to a central server via DHCP relay (see [chapter 3]({{% relref "/03-networking-2/theory" %}}#dhcp)).

## Dependencies

- **None** for session 1. DHCP is the first role a device needs.
- For session 2: the DNS servers of the domains (`10.50.13.12`, `10.50.13.23`) must be running before you hand them out as a DHCP option.

## Goal in the Windows world

- The **DHCP Server** role is installed on `10.50.13.10`.
- A scope `10.50.13.100–10.50.13.119`, subnet mask `255.255.255.0`, lease time 8 hours.
- Options: router `10.50.13.254`, DNS server `10.50.13.254` (in session 2: `10.50.13.12`).
- A **MAC filter (allow list)**: the server answers **only** the Windows test client. You get the MAC address from the lecturer.
- Hint: PowerShell module `DhcpServer`; cmdlets start with `Add-DhcpServerv4…` and `Set-DhcpServerv4…`.

## Goal in the Linux world

- The package `kea-dhcp4-server` is installed and the service is running.
- A subnet `10.50.13.0/24` with a pool `10.50.13.120–10.50.13.139`, same options as above (DNS in session 2: `10.50.13.23`).
- A **client class** that admits only the MAC address of the Linux test client. The pool is restricted to this class.
- The configuration is in `/etc/kea/kea-dhcp4.conf` (JSON). Check before restarting: `kea-dhcp4 -t /etc/kea/kea-dhcp4.conf`.

## Goal in session 2

1. After the domain join, each server hands out the **DNS server of its domain** and the **domain name** (option 15).
2. Windows: the DHCP server is **authorized** in Active Directory (otherwise it does not start in a domain).
3. **PXE for team 7:** for team 7's machines (reference machine and target machines, MAC addresses from team 7) you hand out options **66** (*next server* = `10.50.13.27`) and **67** (*boot file*, depending on BIOS or UEFI; team 7 tells you which). Decide together whether Windows DHCP or Kea serves these machines.
4. **Combination:** swap the MAC addresses in the two allow lists. Now the Windows test client gets its address from Kea and the Linux test client from Windows. Does the client notice a difference?

## Acceptance tests

| Test | Windows test client | Linux test client |
|---|---|---|
| Address from the right range | `ipconfig /all` shows `.100–.119` and *DHCP Server: 10.50.13.10* | `ip -br addr` shows `.120–.139` |
| Renew lease | `ipconfig /release`, then `ipconfig /renew` | `nmcli device disconnect <interface>`, then `nmcli device connect <interface>` |
| Server knows the lease | `Get-DhcpServerv4Lease -ScopeId 10.50.13.0` | Kea log: `journalctl -u kea-dhcp4-server` |
| Other devices get **nothing** | a device not on the list gets no address | as on the left |

## Pitfalls

{{% callout style="warning" title="Two DHCP servers in the same network" %}}
Windows DHCP and Kea **both** hear every DHCP request in the lab VLAN. Without an allow list, the faster one answers, and the client may get the wrong DNS server. Do not start a scope or pool **without** a MAC filter.
{{% /callout %}}

- The server itself needs a **static** address; otherwise, in the worst case, it hands one out to itself.
- Kea does not start if the JSON has a typo. Always check with `-t` first.
- MAC addresses are written differently (`BC-24-11-…` on Windows, `bc:24:11:…` in Kea).
- In Kea, the right network interface (`eth0`) must be listed in `interfaces-config`.

## Entry points

- Microsoft Learn: [Deploy DHCP using Windows PowerShell](https://learn.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-deploy-wps)
- Microsoft Learn: [DhcpServer module (PowerShell)](https://learn.microsoft.com/en-us/powershell/module/dhcpserver/)
- ISC: [Kea Administrator Reference Manual](https://kea.readthedocs.io/), chapters *The DHCPv4 Server* and *Client Classification*
- Debian: `/usr/share/doc/kea-dhcp4-server/` and `man kea-dhcp4`

## Comparison questions

- How many lines of PowerShell versus how many lines of JSON? Which is easier to check and to keep under version control?
- How do you back up the configuration and the leases, and how do you restore them?
- What does the role cost (server licence, client access licences per device or user, *CAL*), what does Kea cost?
- High availability: Windows has *DHCP failover*, Kea the *high availability hook*. How much effort is each?
- What data does a DHCP server store about the students' devices (MAC, host name, time), and for how long?
