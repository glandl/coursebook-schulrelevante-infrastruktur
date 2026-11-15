+++
title = "Team 2: DNS"
weight = 2
+++

**Windows world:** `10.50.13.11`, Windows DNS server · **Linux world:** `10.50.13.22`, BIND 9 (Debian container)

## The role at a school

Teachers type `moodle.schule.lan` or `drucker-lehrerzimmer`, not `10.50.13.15`. The DNS server translates names into addresses (and back) and forwards all other queries to the internet. Without DNS, almost nothing works at a Windows school: logging in to the domain finds the domain controller via DNS.

In the lab the work is split like this: the **domain zones** (`win.schule.lan`, `linux.schule.lan`) are created by team 3 when setting up the directory service. Your team builds the **DNS around the domains**: a zone with the names of all lab servers, the reverse lookup and the forwarders so that both worlds find each other.

## Dependencies

- **None** for session 1 (forwarding to the lab router `10.50.13.254`).
- For session 2: team 3's domain controllers are running.

## Goal in the Windows world

- The **DNS Server** role is installed on `10.50.13.11`, forwarder to `10.50.13.254`.
- A primary zone **`labor.test`** with an A record for **every** server of both worlds following the pattern `win-<role>` and `lx-<role>`, e.g. `win-dhcp.labor.test → 10.50.13.10`, `lx-dhcp.labor.test → 10.50.13.21`.
- Zone transfer allowed only to `10.50.13.22`.
- Hint: PowerShell module `DnsServer`, e.g. `Add-DnsServerPrimaryZone`, `Add-DnsServerResourceRecordA`.

## Goal in the Linux world

- The package `bind9` is installed; BIND works as a **resolver** for the lab (`allow-recursion` only for `10.50.13.0/24`) with forwarding to `10.50.13.254`.
- A primary zone for **reverse lookup** `13.50.10.in-addr.arpa` with PTR records for every server of both worlds.
- Zone transfer allowed only to `10.50.13.11`.
- Check before every restart: `named-checkconf` and `named-checkzone`.

## Goal in session 2

1. **Exchange across worlds:** BIND becomes a **secondary** server for `labor.test` (transfer from `10.50.13.11`), Windows becomes a secondary server for `13.50.10.in-addr.arpa` (transfer from `10.50.13.22`).
2. **Conditional forwarders** together with team 3: whoever asks for `linux.schule.lan` ends up at `10.50.13.23`, whoever asks for `win.schule.lan` at `10.50.13.12`. And the domain controllers forward `labor.test` to you.
3. Afterwards the Windows test client finds a Linux world server by name and vice versa.

## Acceptance tests

| Test | Windows test client | Linux test client |
|---|---|---|
| Forward | `Resolve-DnsName lx-web.labor.test -Server 10.50.13.11` | `dig @10.50.13.22 win-web.labor.test` |
| Reverse | `Resolve-DnsName 10.50.13.26 -Server 10.50.13.22` | `dig @10.50.13.11 -x 10.50.13.15` |
| Internet via the forwarder | `Resolve-DnsName debian.org -Server 10.50.13.11` | `dig @10.50.13.22 debian.org` |
| Zone transfer (session 2) | | `dig @10.50.13.22 labor.test AXFR` shows all records |
| Across worlds (session 2) | `Resolve-DnsName dc.linux.schule.lan` | `dig dc.win.schule.lan` |

## Pitfalls

- **Serial number** in the SOA record not increased: the secondary server does not pick up the change.
- Forgotten **dot** at the end of a name in BIND zone files (`ns.labor.test.`): the name becomes `ns.labor.test.labor.test`.
- An **open resolver** (`allow-recursion any`) answers queries from all over the world and can be abused for attacks.
- On Debian 13, `/etc/resolv.conf` sets the DNS server directly, without `systemd-resolved`. Check changes on the server itself with `dig @127.0.0.1`.
- `.test` is reserved for exercises (RFC 6761). At a real school, use a subdomain of your own registered domain (e.g. `intern.ms-musterstadt.at`), **not** `.local`.

## Entry points

- Microsoft Learn: [DNS in Windows Server](https://learn.microsoft.com/en-us/windows-server/networking/dns/dns-overview)
- Microsoft Learn: [DnsServer module (PowerShell)](https://learn.microsoft.com/en-us/powershell/module/dnsserver/)
- ISC: [BIND 9 Administrator Reference Manual](https://bind9.readthedocs.io/)
- Debian Wiki: [Bind9](https://wiki.debian.org/Bind9)
- IETF: [RFC 6761, Special-Use Domain Names](https://www.rfc-editor.org/rfc/rfc6761)

## Comparison questions

- Windows stores zones in a file or in Active Directory, BIND in text files. What does that mean for backup, version control (Git) and troubleshooting?
- Which world reports configuration errors earlier?
- What does a DNS server log about the students (which sites they visit)? Who at the school may see that?
- Would it make sense to run DNS for the school at a provider on the internet? What speaks for it, what against?
