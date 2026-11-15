+++
title = "Lab with solutions (optional)"
weight = 30
+++

{{% callout style="info" title="Optional, not graded" %}}
This lab is **optional**. There is nothing to submit. Every task has a **solution** you can expand. Try it yourself first, then compare.
{{% /callout %}}

{{% callout style="warning" title="Status: untested" %}}
The commands have **not** yet been run in Packet Tracer 9.0.1 or in the course environment. *Tested on: open.*
{{% /callout %}}

## Overview

| Part | Content | Duration | Prerequisite |
|---|---|---|---|
| 1 | VLANs in Packet Tracer: three groups on one switch, router on a stick | approx. 50 min | `schulnetz.pkt` from [session 2]({{% relref "/02-networking-1/lab" %}}) |
| 2 | Permission matrix as an access rule (ACL) | approx. 30 min | Part 1 |
| 3 | Observing DNS and DHCP in the Debian VM | approx. 30 min | VM `debian-lab` from session 1 |

## Part 1: VLANs in Packet Tracer

**Goal:** Instead of one switch per group, administration, teachers and students are connected to **one** switch in three VLANs. The router connects the VLANs over **one** cable (trunk) with subinterfaces.

**Starting point:** Open `schulnetz.pkt` and immediately save it as `schulnetz-vlan.pkt` (*File → Save As*).

### 1.1 Rebuild the topology

1. Delete the switch `sw-lehr`.
2. Rename `sw-verw` to `sw-01` (*Config → Display Name*).
3. Connect `pc-lehr-01` and `pc-lehr-02` to `sw-01` on ports `Fa0/3` and `Fa0/4`.
4. Add two new PCs `pc-sch-01` and `pc-sch-02` and connect them to `Fa0/5` and `Fa0/6`.
5. The cable `sw-01 Gi0/1` → `r1 Gi0/0` stays. It becomes the trunk.

| Port on `sw-01` | Device | VLAN |
|---|---|---|
| `Fa0/1`, `Fa0/2` | `pc-verw-01`, `pc-verw-02` | 10 Administration |
| `Fa0/3`, `Fa0/4` | `pc-lehr-01`, `pc-lehr-02` | 20 Teachers |
| `Fa0/5`, `Fa0/6` | `pc-sch-01`, `pc-sch-02` | 30 Students |
| `Gi0/1` | `r1` | Trunk (10, 20, 30) |

### 1.2 Create the VLANs on the switch

**Task:** On switch `sw-01`, use the CLI to create VLANs 10, 20 and 30 with names, assign the ports according to the table and make `Gi0/1` a trunk that carries only these three VLANs. Check with `show vlan brief` and `show interfaces trunk`.

{{< details summary="Solution 1.2" >}}
```text
enable
configure terminal
hostname sw-01
vlan 10
 name Verwaltung
vlan 20
 name Lehrende
vlan 30
 name Schueler
interface range FastEthernet0/1 - 2
 switchport mode access
 switchport access vlan 10
interface range FastEthernet0/3 - 4
 switchport mode access
 switchport access vlan 20
interface range FastEthernet0/5 - 6
 switchport mode access
 switchport access vlan 30
interface GigabitEthernet0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30
end
copy running-config startup-config
show vlan brief
show interfaces trunk
```

**Expected:** `show vlan brief` lists VLANs 10, 20 and 30 with two ports each. `Gi0/1` does **not** appear there, because trunk ports do not belong to a single VLAN. `show interfaces trunk` shows `Gi0/1` in mode `on` with the allowed VLANs `10,20,30`.
{{< /details >}}

### 1.3 Router on a stick

**Task:** On router `r1`, remove the address from `Gi0/0` and create three subinterfaces `Gi0/0.10`, `Gi0/0.20` and `Gi0/0.30`, each with 802.1Q encapsulation, the gateway address from the IP plan and the DHCP relay to `srv-01`. Shut down `Gi0/1` (formerly teachers).

Gateway addresses: administration `10.10.10.1/27`, teachers `10.10.20.1/25`, students `10.10.30.1/23`.

{{< details summary="Solution 1.3" >}}
```text
enable
configure terminal
interface GigabitEthernet0/0
 no ip address
 no ip helper-address
 no shutdown
interface GigabitEthernet0/0.10
 description VLAN 10 Verwaltung
 encapsulation dot1Q 10
 ip address 10.10.10.1 255.255.255.224
 ip helper-address 10.10.40.10
interface GigabitEthernet0/0.20
 description VLAN 20 Lehrende
 encapsulation dot1Q 20
 ip address 10.10.20.1 255.255.255.128
 ip helper-address 10.10.40.10
interface GigabitEthernet0/0.30
 description VLAN 30 Schueler
 encapsulation dot1Q 30
 ip address 10.10.30.1 255.255.254.0
 ip helper-address 10.10.40.10
interface GigabitEthernet0/1
 shutdown
end
copy running-config startup-config
show ip interface brief
show ip route
```

**Expected:** `show ip interface brief` shows `Gi0/0.10`, `Gi0/0.20` and `Gi0/0.30` as `up`/`up`. `show ip route` has three `C` entries for the VLAN networks and one for the server network `10.10.40.0/27`.

**Why `encapsulation dot1Q`?** The router has to know which 802.1Q tag belongs to which subinterface. A frame with tag 30 ends up in `Gi0/0.30`, a reply from `Gi0/0.30` gets tag 30.
{{< /details >}}

### 1.4 DHCP for the student VLAN

**Task:** On `srv-01` (*Services → DHCP*), create a pool `schueler` that hands out addresses starting at `10.10.30.10` (with matching gateway, DNS server and subnet mask). Set `pc-sch-01` and `pc-sch-02` to DHCP. Check with `ipconfig /all`.

{{< details summary="Solution 1.4" >}}
| Field | Value |
|---|---|
| Pool Name | `schueler` |
| Default Gateway | `10.10.30.1` |
| DNS Server | `10.10.40.10` |
| Start IP Address | `10.10.30.10` |
| Subnet Mask | `255.255.254.0` |
| Maximum Number of Users | e.g. `200` |

**Expected:** `pc-sch-01` gets `10.10.30.10` (or the next free address), gateway `10.10.30.1`, DNS `10.10.40.10`. The administration PCs still get addresses from their pool, because the relay on `Gi0/0.10` sends its own address `10.10.10.1` along, and from that the server recognizes the pool `verwaltung`.

The teachers' PCs have static addresses from session 2 and keep working unchanged.
{{< /details >}}

### 1.5 Test and understand

**Task:** From `pc-sch-01`, run `ping 10.10.10.10` (an administration PC; look up its address with `ipconfig` if needed), `ping 10.10.40.10`, and open `http://web.schule.test` in the browser. Answer:

1. What happens, and did you expect that?
2. In **simulation mode**, follow an ICMP packet from `pc-sch-01` to an administration PC. On which cable does the frame carry an 802.1Q tag, on which not? Which VLAN ID is in the frame before and after the router?

{{< details summary="Solution 1.5" >}}
1. **Everything works**: the student PC reaches the administration PC, the server and the web page. That is the most important insight of this part: **VLANs separate, but the router connects them again**. Without an access rule, the separation is only a detour through the router. We change that in part 2.
2. Between `pc-sch-01` and `sw-01` (access port), the frame carries **no** tag. On the trunk `sw-01` → `r1` it carries tag **30**. The router routes into VLAN 10 and sends the frame back over the same trunk with tag **10**. From `sw-01` to the administration PC, again **without** a tag. In the *PDU Details*, you find the tag in the field *802.1Q* or *TCI/VLAN*.
{{< /details >}}

## Part 2: The permission matrix as an access rule

**Goal:** The **student Wi-Fi** row of the permission matrix from the [theory]({{% relref "theory" %}}#the-permission-matrix) is enforced on the router:

| from students (VLAN 30) to | allowed |
|---|---|
| Administration (`10.10.10.0/27`) | no |
| Teachers (`10.10.20.0/25`) | no |
| Server `10.10.40.10` | DNS (UDP 53) and web (TCP 80) only |
| everything else (internet) | yes |
| DHCP | yes (otherwise no student PC gets an address) |

### 2.1 Write the rule

**Task:** Write an *extended ACL* `SCHUELER-IN` and apply it **inbound** on `Gi0/0.30`. Pay attention to the order: the first matching line decides, and at the end there is an invisible "deny everything".

Tip: give ports as numbers (DHCP 67, DNS 53, HTTP 80). Cisco ACLs use a **wildcard mask** (the inverted mask) instead of the subnet mask: `/23` → `0.0.1.255`, `/27` → `0.0.0.31`, `/25` → `0.0.0.127`.

{{< details summary="Solution 2.1" >}}
```text
enable
configure terminal
ip access-list extended SCHUELER-IN
 remark always allow DHCP
 permit udp any any eq 67
 remark DNS and web to the school server
 permit udp 10.10.30.0 0.0.1.255 host 10.10.40.10 eq 53
 permit tcp 10.10.30.0 0.0.1.255 host 10.10.40.10 eq 80
 remark no administration, no teachers, nothing else on the server
 deny ip 10.10.30.0 0.0.1.255 10.10.10.0 0.0.0.31
 deny ip 10.10.30.0 0.0.1.255 10.10.20.0 0.0.0.127
 deny ip 10.10.30.0 0.0.1.255 10.10.40.0 0.0.0.31
 remark internet
 permit ip 10.10.30.0 0.0.1.255 any
interface GigabitEthernet0/0.30
 ip access-group SCHUELER-IN in
end
copy running-config startup-config
show access-lists
```

The line `permit udp any any eq 67` (DHCP server port) is at the very top because a device without an address sends its DHCP request from `0.0.0.0`. No rule with `10.10.30.0` would match it.
{{< /details >}}

### 2.2 Test

**Task:** From `pc-sch-01`, test: `ping 10.10.10.10`, `ping 10.10.40.10`, browser `http://web.schule.test`, `ipconfig /renew`. Then test a `ping` from `pc-verw-01` to `pc-sch-01`. Explain every result.

{{< details summary="Solution 2.2" >}}
| Test | Result | Why |
|---|---|---|
| `pc-sch-01` → `ping 10.10.10.10` | fails | line `deny … 10.10.10.0 0.0.0.31` |
| `pc-sch-01` → `ping 10.10.40.10` | fails | ping is ICMP; only DNS and HTTP are allowed. The line `deny … 10.10.40.0` matches |
| Browser `http://web.schule.test` | works | DNS (UDP 53) and HTTP (TCP 80) to the server are allowed |
| `ipconfig /renew` | works | the first line allows DHCP |
| `pc-verw-01` → `ping pc-sch-01` | fails | The request reaches the student PC, but its **reply** goes inbound through `Gi0/0.30` and hits the line `deny … 10.10.10.0`. |

The last case shows a limit of simple ACLs: they do not remember connections (*stateless*). A firewall with state tracking (*stateful*) would automatically let replies to allowed requests through. In practice, a firewall is therefore usually placed between VLANs.

**Remember:** `ping` is a poor test for an access rule that only allows certain services. Test the service itself (here: the browser).
{{< /details >}}

## Part 3: DNS and DHCP in the Debian VM

**Goal:** You observe on a real Linux system which settings it got via DHCP and how it resolves names. Start `debian-lab` and log in (in the VM or via SSH).

### 3.1 What did DHCP deliver?

**Task:** Find out: IP address and prefix, how long the address is still valid, the gateway and the DNS server. Also find the DHCP client's messages in the system log.

{{< details summary="Solution 3.1" >}}
```bash
ip -4 addr show          # address, prefix, valid_lft = remaining lease time
ip route                 # line "default via …" = gateway
cat /etc/resolv.conf     # line "nameserver …" = DNS server
sudo journalctl -b | grep -i dhcp
```

**Expected (VirtualBox with NAT):** address `10.0.2.15/24`, `valid_lft` e.g. `86000sec`, gateway `10.0.2.2`, DNS server `10.0.2.3`. For other platforms see the table in the [session 2 lab]({{% relref "/02-networking-1/lab" %}}). Depending on the DHCP client, the log shows the steps of the lease (offer, acknowledgement) and the address received.

If it says `valid_lft forever`, the VM has a **static** address and no DHCP.
{{< /details >}}

### 3.2 Resolving names with `dig`

**Task:** Resolve `debian.org` with `dig`. Find in the output: the answer, the TTL, the server that was asked. Repeat the query after a few seconds. What changes?

{{< details summary="Solution 3.2" >}}
```bash
dig debian.org
dig debian.org      # again after a few seconds
```

- The `ANSWER SECTION` contains `debian.org.  <TTL>  IN  A  <address>`.
- The line `;; SERVER:` names the resolver that was asked (e.g. `10.0.2.3#53`).
- In the second query the **TTL is smaller** (and `Query time` is often shorter): the resolver answers from its cache and counts down the remaining time.
{{< /details >}}

### 3.3 Record types and reverse lookup

**Task:** Query the types `AAAA` and `MX` for `debian.org`, and resolve the address `1.1.1.1` in reverse. Compare `getent hosts localhost` with `dig localhost`. Why do they differ?

{{< details summary="Solution 3.3" >}}
```bash
dig debian.org AAAA +short
dig debian.org MX +short
dig -x 1.1.1.1 +short          # PTR record: one.one.one.one.
getent hosts localhost         # 127.0.0.1 or ::1 localhost
dig localhost +short           # usually empty
```

`getent` asks the way programs do: first `/etc/hosts`, then DNS (order in `/etc/nsswitch.conf`, line `hosts:`). `localhost` is in `/etc/hosts`. `dig` asks **only** the DNS server and ignores `/etc/hosts`. This matters when troubleshooting: if `getent` works but `dig` does not, the name is probably only in `/etc/hosts`.
{{< /details >}}

### 3.4 Without DNS

**Task:** Back up `/etc/resolv.conf`, enter an address as `nameserver` where no DNS server runs (e.g. `192.0.2.1`), and test `ping -c 2 1.1.1.1` and `ping -c 2 debian.org`. Restore the file afterwards.

{{< details summary="Solution 3.4" >}}
```bash
sudo cp /etc/resolv.conf /etc/resolv.conf.orig
echo "nameserver 192.0.2.1" | sudo tee /etc/resolv.conf
ping -c 2 1.1.1.1        # works: the connection is there
ping -c 2 debian.org     # fails after a delay: name cannot be resolved
sudo cp /etc/resolv.conf.orig /etc/resolv.conf
ping -c 2 debian.org     # works again
```

This is the typical "the internet is down" picture when actually only DNS is missing. `192.0.2.0/24` is a range reserved for documentation (RFC 5737); nobody answers there. The DHCP client may overwrite `/etc/resolv.conf` anyway at the next lease renewal.
{{< /details >}}
