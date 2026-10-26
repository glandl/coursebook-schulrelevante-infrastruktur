+++
title = "Lab (not graded)"
weight = 40
+++

{{% callout style="warning" title="Status: not yet fully checked" %}}
**There is neither cloud nor hybrid network** here, and **managed VLANs of real networks via cloud console** — and the **VLAN functionality of Packet Tracer version 9.0.1** is **not yet fully checked** in the course environment. Where this unit touches functions that cannot be shown yet, it **explicitly names** them. **No Wireshark** — this lab works with **Packet Tracer** and **one single Debian-Linux-VM** only. *Checked:* [[Lab]({{% relref "/03-networking-2/lab" %}}) — **open.**
{{% /callout %}}

## Überblick

| Part | Content | Duration |
|---|---|---|
| 0 | Preparation: Packet Tracer incl. Cisco account, Windows Server ISO (at home, before the unit) | 40 min (at home) |
| 1 | VLANs in the Packet Tracer file of unit 2: both VLAN models, network first aid | 70 min |
| 2 | Network configuration of the Debian VM, DNS and DHCP in the simulation mode | 60 min |
| 3 | Windows Server 2025 Evaluation in the VM (textmode), first commands in the console | 45 min |
| 4 | Server-Setup-Log — documentation of your lab work, **not part of the grade** | 40 min |

Total **255 min** — same distribution as in the other lab parts.

**Mindestausstattung:** the VM **`debian-lab`** from unit 1 ([Lab unit 1]({{% relref "/01-virtualization-containerization/lab" %}})), the **evaluation media for Windows Server 2025** (ISO, download at home) and **Cisco Packet Tracer** (download approx. 300 MB).

**Verwendete Software:**

| Software | Version | Remark |
|---|---|---|
| Debian (VM `debian-lab`) | 13 "trixie" | from unit 1, known from [VM Container]({{% relref "/01-virtualization-containerization/exercise" %}}) |
| Cisco Packet Tracer | 9.0.1 | free download, needs Cisco account; English interface |
| Windows Server 2025 Evaluation | `10.0.26100.24.07` | ISO, Evaluation version with time limit — see [Security and Data Protection]({{% relref "security" %}}) |

## Teil 0: Preparation (before the unit, at home)

1. **At [www.netacad.com](https://www.netacad.com) a Cisco Networking / Cisco Business account gets created** and **Packet Tracer gets downloaded** (approx. 300 MB) — **at home**, not in the network of the school! **Installed** and **started once**, then closed.
2. **Download Windows Server 2025 Evaluation (ISO)** — several GB, **must be downloaded in advance** on your machine already! **The build number** `10.0.26100.24.07` — **what is expected gets written down.**
3. **VM `debian-lab` starts**, **SSH on the host**; **network observation tools get installed** for Teil 2:

   ```bash
   sudo apt update
   sudo apt install -y iputils-tracepath bind9-dnsutils net-tools
   ```

4. **Portfolio preparation:**

   ```bash
   cd <your-portfolio>
   git switch -c einheit-03
   mkdir -p 03-networking-2/assets
   ```

{{% callout style="info" title="Datenschutz — Cisco account" %}}
Packet Tracer **needs a Cisco account** — **registered with the course alias**, **no** address of your family, **no** real workplace. At the download page it is **described** where to get the software for your operating system.
{{% /callout %}}

## Teil 1: VLANs in the Packet Tracer file of unit 2 (70 min)

**Ziel:** Both VLAN models in Packet Tracer can be **named**, the VLAN number can be **read off from an address** — and it becomes visible: **VLAN 3 is not reachable everywhere**. **In the file:** the Packet Tracer file from unit 2, part 3 ([Netz from scratch]({{% relref "/02-networking-1/lab" %}})). **The network does not get rewired — it gets labeled!**

> **About the two number conventions:** In the file from unit 2 `10.10.x.x` is used. In this unit **the convention of the class list gets used: `10.11.<VLAN>.0/24`** — **third octet = VLAN-Id**. In the documentation task **both number ranges get written down** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).

| Group | VLAN | VLAN-Id as 3rd octet | Range in the file (from unit 2) | Range class list | Usable devices |
|---|---|---|---|---|---|
| Schuler | 0 | `0` | `10.10.0.0/24` | `10.11.0.0/24` | 254 |
| Lehrende | 1 | `1` | `10.10.1.0/24` | `10.11.1.0/24` | 254 |
| Administration | 2 | `2` | `10.10.2.0/24` | `10.11.2.0/24` | 254 |
| Storage | 3 | `3` | `10.10.3.0/24` | `10.11.3.0/24` | 254 |

### 1.1 VLAN model 1 — the internal VLAN field (20 min)

In the Simulation every device and every link **carries an internal VLAN field** — the number **belongs to the device**, not to the packet. **The CLI of a managed Switch (2960) opens** and **reads**:

```text
2960> enable
2960# show me vlan
2960# show vlan 2
2960# show vlan mty
2960# show ethernet vlan 2
```

**Erwartet:** the **VLAN-Ids** with **bitmask / number range** of the Switch — and which **interfaces** belong to the VLAN.

Then **device and Switch get the VLANs of the class list**, e.g. Administration:

```text
Device pc-verw/1:   VLAN-Insert: VLAN = 2
2960(config)# interface Gi0/1
2960(config-if)# set vlan 2
```

With **bitmask** `0.0.255.0` one works **bitwise per octet** — **the bitmask in binary, one line per octet, gets written down** (see [Theorie]({{% relref "theory" %}})). A **packet from a Schuler device** that wants to cross the **managed Switch** into VLAN 2 **proceeds only if the Switch allows VLAN 2 on the link** — **test it:**

1. **One link open** for VLAN 2 (`set vlan 2 ... accept`), **one closed**, **one partly granted**
2. In the **Simulation send:** **frame stops at the closed Switch**, proceeds through the open one
3. **Screenshot** one stop and one pass — **the number decides at the network device, not the address**

**Write down:** In the Simulation this is **the decision per connection**. On **real hardware** a **managed Switch** decides **depending on the VLAN in the frame** — same effect, different place where the number lies (next part!).

### 1.2 VLAN model 2 — VLAN-Id leg: the EtherType field (15 min)

Now the number **belongs to the frame**: **`vlan 2` gets written** into the **EtherType field** of the Ethernet header — into the EtherType field of the **sending device** — **the frame carries VLAN 2**:

```text
EtherType field of the device:  vlan 2
Frame on the wire:              EtherType "vlan 2" + payload
```

Test: **One packet from a Schuler device gets sent** whose EtherType field **one set to VLAN 2**: **The Simulation lets it through — the sending device can write whatever one likes!** The **decision still happens at the Switch**, **the VLAN number only accompanies the frame**.

**Write down:** **Both models in one table** — where the number lies, what that means for the Simulation and for reality of Ethernet: **the VLAN tag lies in the frame** and **can be set arbitrarily** — **the Switch reads, the device does not enforce**.

**Write down:** **What one does not need a VLAN for:** If one has a separate network per group anyway and no network device that decides per VLAN, the VLAN number **belongs to nothing**.

### 1.3 VLAN 3 — not reachable everywhere (15 min)

**The Storage network** hangs in **VLAN 3**. **A managed Switch** in the file: **does not allow VLAN 3**. **The Command Prompt on a teacher- or Schuler PC opens** in Packet Tracer:

```text
ping -c 3 10.11.3.1
```

(In the **Command Prompt** of Packet Tracer `ping <address>` without `-c` also exists — then **the three requests get counted by one oneself**. `-c 3` is a Debian command, see 2.1.)

**Erwartet:** **All three requests time out** — the frame **stops at the managed Switch**: **VLAN 3 is not allowed on the link**. Now **one switches to the Simulation**: There **one sees where** the frame **stops** — **it is not accepted**, **it does not even travel a part of the way and turn back**.

**Write down in the documentation: Where the frame stops** — and from **which role where** one would have to be able to reach VLAN 3. **The address proves nothing, the Switch decides** — see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}}).

### 1.4 DNS and DHCP — observation in the simulation mode (10 min)

**Between the typing of a name and the first packet lies a resolution order** — see [Theorie]({{% relref "theory" %}}): **DNS** turns **name into number**, **DHCP** **gives an address in the network** — **that is a network device, not DNS**.

**In the Simulation one opens the packages of the network devices** and **observes** — **no network tool outside the Simulator**, **the Simulator shows the layers:**

1. **ARP:** one frame **to a not-yet-placed device** — **first the ARP packet**, **one opens it**
2. **DNS lookup:** one device that **receives an address** for a name like `lms.muster-city.bmb` — **one opens the DNS lookup packet** (name → number)
3. **DHCP:** one **not-yet-configured device** — the **network device** (Switch/Server in the file) **gives the address** — **one opens the DHCP packet** and **compares the assigned address with the number range of the device group:** **The address comes from the VLAN of the device group.**

**Write down:** **DHCP names nothing, DNS gives no address.** **Screenshot** one opened DHCP **and** one DNS packet.

## Teil 2: Network configuration of the Debian VM, DNS and DHCP (60 min)

**Ziel:** From the network configuration **up to** `/etc/resolv.conf` **and beyond**: **Where addresses come from** (DHCP), **where names go** (DNS). **The VM gets broken and repaired** — **the first aid from unit 1, but this time consciously**.

### 2.1 Network first aid — read the state (20 min)

**From within the VM one starts** and **reads before one changes:**

```bash
ip -br addr                 # which interfaces, which addresses
ip route                    # which routes, which gateways
arp -a                      # name → address cache — are there already addresses?
ss - Tuln                   # local ports in use — alternative: netstat -tuln
cat /etc/resolv.conf        # which DNS servers are named — if none: no name lookup
```

**Erwartet:** the NAT network of the VM frontend — **not** the network of the school. **Write down the addresses:** **They come from the VM frontend (DHCP), not from the class list.**

Then **one breaks it:** In the network configuration **the wrong gateway gets set** or **`nameserver` gets removed from `resolv.conf`** — and **one diagnoses as in unit 1:**

```bash
ping -c 3 10.0.2.1                       # is the gateway reachable?
ping 10.0.2.1                            # without -c: endless — Ctrl-C stops it
traceroute 10.0.2.1                      # where does the route go?
dig lms.muster-city.bmb                  # does the name resolve?
dig @10.0.2.1 lms.muster-city.bmb        # name lookup at the DNS server directly
```

### 2.2 Network configuration from scratch — interfaces(5) (15 min)

**The VM gets reconfigured from your own network configuration** (see [VM Container]({{% relref "/01-virtualization-containerization/exercise" %}})):

```text
auto enp0s3
iface enp0s3 inet manual
    ip link set enp0s3 net ether 08:00:27:87:94:19:00:05 down
    ip link set enp0s3 net ether 08:00:27:87:94:19:00:05 up
    ipconfig enp0s3 gateway 10.0.2.2
    ipconfig enp0s3 nameserver 10.0.2.1
```

**Erwartet:** after readding **the same interface comes back** — **address from the frontend (DHCP), name resolution works again:**

```bash
sudo ifdown enp0s3 && sleep 3 && sudo ifup enp0s3
ip -br addr
getent hosts lms.muster-city.bmb        # the name also resolves via libc
```

**Write down:** **The network configuration of the VM was changed — the frontend kept its own view.** **In the Packet Tracer file one compares:** **`ipconfig get getlink`** on the PC → **the gateway** — **the network configuration of the VM and the links in the file are two different representations of the same thing:**

```text
pc-verw/1 Command Prompt:
ipconfig get getlink
ipconfig set getgateway
```

### 2.3 hostname — one names the device, the frontend gives the address (10 min)

**The hostname one sets oneself** — **the address comes from the network (DHCP):**

```bash
sudo hostnamectl set hostname --force vm-debian.muster-city.bmb
sudo sed -i 's/^nameserver .*/nameserver 10.0.2.1/' /etc/resolv.conf
getent hosts lms.muster-city.bmb   # still resolves?
```

**Erwartet:** The **hostname one set** — **the IP comes from the network** (**DHCP**, not typed in, see [Theorie]({{% relref "theory" %}})). **Write down:** The IP in the VM is **not** `10.11.x.x` — **that is not the network of the school.**

### 2.4 DHCP and DNS — observation in the simulation mode (15 min)

**The assignment of the address gets observed:** In the Packet Tracer file one **new device** — **first only ARP, then the DHCP packet from the network device**, **then DNS**. **One opens all packets** and **writes down in which VLAN the assigned address lies** (third octet!). **This is the same resolution order one just worked through in the VM (2.1/2.2).**

**Erwartet:** **The device works with the address that the network device assigned** — **one never typed an IP.** **Screenshot** the opened DHCP packet **and** the opened DNS packet **next to the `ipconfig` output of the VM as text** — **two views of one resolution order** (for the [documentation task]({{% relref "documentation" %}})).

## Teil 3: Windows Server 2025 Evaluation in the VM — textmode, 45 min

**Ziel:** **First contact with Windows Server: The installation one sets up oneself, one reads it — one manages nothing (yet) — no Server of the school, Evaluation version in a VM only!** In the [documentation task]({{% relref "documentation" %}}) this becomes your **Server-Setup-Log**.

**What is needed in the VM:** 4 GB RAM, 32 GB disk, **EFI**, network **none** — **as long as the installer works one needs no network at all** — **the first steps in the console need none either.**

### 3.1 Boot and installation in textmode (25 min)

1. In VirtualBox: **Windows Server 2025 Evaluation** — **not** the VM `debian-lab`! **ISO from 0.2.**
2. **Boot**, at the first screen **one presses what the screen says** (a **second boot one does not let happen**).
3. **Installation in textmode:** **Exclusively per keyboard** — **the four questions:** **language/region**, **license agreement**, **target disk/partition**, **account** (**hostname / login name** — **just as with the VM from unit 1: one names it oneself**):

   | Question | What one writes down |
   |---|---|
   | Language / region | e.g. `German` / `Austria` — **screenshot** |
   | License agreement | **scroll up and down**, then `Y` — **screenshot** |
   | Target disk | disk designation and partition — **screenshot** |
   | Account + hostname | **login name, hostname — both one sets oneself** — **hostname `SRV-EVAL-01`**, account **`srv-admin`** — **no names of your family!** |

4. Wait — **the installation in textmode takes longer than the graphical one.**

### 3.2 The first steps in the console — one reads (10 min)

**One logs in with the account one set up** and **reads — nothing gets changed:**

```text
ipconfig /all
systeminfo
nslookup lms.muster-city.bmb
```

**Erwartet:** `ipconfig /all` → **the address the network gave the VM — one did not choose it**; `systeminfo` → **build `10.0.26100.24.07` — one writes it down** and **the Evaluation time limit**; `nslookup` → **name lookup — without a DNS server it fails: One writes down which error and which question it actually asks.**

In **PowerShell** — **the tool that manages the network:**

```powershell
Get-NetworkManager
Get-Net*Manager
Get-Help Get-NetworkManager -showexamples
```

**Erwartet:** The **network management of Windows** — **the VLANs of the school in Windows Server hang there**, see [Theorie]({{% relref "theory" %}}) — **nothing gets changed — one writes down what one sees.**

### 3.3 One writes down — the Server-Setup-Log (10 min)

**Into your documentation folder one writes:** **ISO, build number, VM settings, the four questions with your answers, three screenshots** (installer, `ipconfig /all`, `systeminfo`) — **and: What failed.** **Mark: "VM only — no Server of the school"** — **Evaluation version, 120 days time limit, see [Security and Data Protection]({{% relref "security" %}}).**

## Teil 4: The Server-Setup-Log — documentation, 40 min, **not part of the grade**

**This part is your documentation evidence** — the **Server-Setup-Log**: **one page**, **not the Homework** (the **evaluated Homework part A**: see [Homework]({{% relref "homework" %}}) — the **Server-Setup-Log does not enter the grade**, it **serves as evidence**).

### 4.1 The Server-Setup-Log on one page (25 min)

```markdown
## Server-Setup-Log — not part of the grade! VM only — no Server of the school!
- Date: <date>
- ISO: Windows Server 2025 Evaluation, build 10.0.26100.24.07
- VM settings: RAM 4 GB · disk 32 GB · EFI · network: none/bridge
- Installation in textmode — the four questions and the answers one entered: ...
- First commands in the console and what one read: ipconfig /all, systeminfo, nslookup,
  Get-NetworkManager, Get-Net*Manager, Get-Help ...
- Screenshots: installer (1), ipconfig /all (1), systeminfo (1)
- What failed: ...
```

**One writes down date and ISO/build** — **Evaluation means time, see [Security and Data Protection]({{% relref "security" %}})**. **The changed ISO/build gets written down** — **Change-Log**, see [Change logs]({{% relref "/00-documentation/change-logs" %}}).

### 4.2 Network diagram and address table — the VLANs enter the documentation (15 min)

In `03-networking-2/` **on your portfolio branch `einheit-03`** **the diagram from unit 2 gets extended with the VLANs** — **one network, the groups as numbers:**

```mermaid
%%{init: {'securityLevel': 'loose', 'mermaid': {'flowchart': {'rankSpacing': 40, 'nodeSpacing': 60}}}}%%
flowchart LR
    title VLAN plan Muster Schulnet  [03-networking-2/vlan-plan]  v1  <date>
    legend "VLAN-Id as 3rd octet · bitmask 0.0.255.0"
    net([10.11.0.0/16 · VLAN 0-3 · School network])
    dev0["pc-schuler-1<br/>VLAN 0 · 10.11.0.17"]
    dev1["pc-lehrer-1<br/>VLAN 1 · 10.11.1.7"]
    dev2["pc-verw-1<br/>VLAN 2 · 10.11.2.17"]
    dev3["pc-storage-1<br/>VLAN 3 · 10.11.3.1"]
    sw1{"managed Switch<br/>verw: VLAN 2 accept<br/>VLAN 3: ✘"}
    sw2{"managed Switch<br/>storage: VLAN 3 accept"}
    dev0 --- net
    dev2 --- sw1
    sw1 --- net
    dev3 --- sw2
    sw2 --- net
```

Under it the **address table** — **one line per device:**

```markdown
| Hostname | IP | VLAN (3rd octet) | Range | Purpose |
|---|---|---|---|---|
| pc-verw-1 | 10.11.2.17 | 2 | 10.11.2.0/24 | Administration PC |
| pc-storage-1 | 10.11.3.1 | 3 | 10.11.3.0/24 | Storage network |
```

**Network and table use matching names** (see [Network diagrams and IP plans]({{% relref "/00-documentation/network-diagrams-ip-plans" %}})). **Handover per Pull Request** — see [markdown and Git]({{% relref "/00-documentation/markdown-git" %}}).

**The lab is not part of the grade.** It gets **documented** in the [documentation task]({{% relref "documentation" %}}) — and the **evaluated Homework part A** (VLAN plan and permission matrix): see [Homework]({{% relref "homework" %}}). **The Server-Setup-Log does not enter the grade** — it is the evidence from your Lab, see [Homework]({{% relref "homework" %}}) and [Security and Data Protection]({{% relref "security" %}}).

In the unit afterwards: [Exercise]({{% relref "exercise" %}}) · [Documentation task]({{% relref "documentation" %}}) · [Homework]({{% relref "homework" %}}) · on the data protection of this lab see [Security and Data Protection]({{% relref "security" %}}) · sources at [Sources]({{% relref "sources" %}}).

## Fehlersuche

| Symptom | Cause | Fix |
|---|---|---|
| **Packet Tracer does not start** | Cisco account / download at home missing | Part 0 — **at home in advance**, approx. 300 MB |
| **In the VLAN exercise the frame stops everywhere** | **The managed Switch allows no VLAN on any link** — or the EtherType field of the device carries no VLAN number | **The managed Switch must accept it — or one works with model 2** |
| **`set vlan` on the Switch changes nothing** | one entered it **in the wrong mode** | **In the config mode** of the link (`interface` → `set vlan 2`) |
| **`show vlan mty` answers "nothing mapped"** | no VLAN exists yet at the Switch | **VLAN and bitmask get inserted first** |
| **Frame goes though the VLAN should be blocked** | one **wrote the number into the EtherType field of the sending device** | **The device enforces nothing, the Switch reads** — see model 2! |
| **`ping -c 3 10.11.3.1` in the file: no answer at all** | **VLAN 3 not allowed at the Switch** — **or a not-yet-placed device, then: ARP first** | **One opens the packets** |
| **`ip -br addr` in the VM: an address comes back that one did not type** | **DHCP from the network device** — **that is correct** | **Write down: not an error, DHCP gives the address** |
| **Name lookup fails in the VM** | no `nameserver` in `/etc/resolv.conf` | `resolv.conf` points to a DNS server |
| **`ip link set enp0s3 net ...` reports "not permitted"** | **missing privileges** | One executes the network configuration **as root** |
| **Windows Server installer runs off again immediately** | one **let the ISO boot a second time** | **A second boot: no** |
| **Windows installation wants network** | no — **the installation in textmode runs offline** | **network: none** — **first steps in console also without network** |
| **`Get-NetworkManager` unknown** | wrong shell — **it is a PowerShell tool, not cmd.exe** | One **opens PowerShell** — **one writes down where the difference lies** |
