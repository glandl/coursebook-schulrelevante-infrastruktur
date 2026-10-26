+++
title = "Lab (no graded)"
weight = 40
+++

{{% callout style="warning" title="Status: ungeprüft" %}}
Die Befehle und Einstellungen in diesem Lab wurden noch **nicht** in der Kursumgebung ausgeführt. Das gilt besonders für die Menüpunkte, Gerätemodelle und die VLAN-Filter in Packet Tracer (Teil 1) und für die erwarteten Adressen bei virt-manager, UTM und Hyper-V (Teil 2 und 3). Stand der Software-Angaben: Oktober 2026. Prüfe Versionen vor dem Einsatz. *Getested am: offen.*
{{% /callout %}}

## Überblick

| Part | Content | Duration |
|---|---|---|
| 0 | Preparation: Packet Tracer incl. Cisco account, Window Server ISO (at home, before ein unit) | 40 min (at home) |
| 1 | VLANs in ein Packet Tracer file of unit 2: both VLAN model, Netze first aid | 70 min |
| 2 | Netz configuration of ein Debian VM, DNS und DHCP in ein simulation mode | 60 min |
| 3 | Window Server 2025 Evaluation in ein VM (textmode), first command in ein console | 45 min |
| 4 | Server-Setup-Log — documentation of your lab work, **no part of ein grade** | 40 min |

Total **255 min** — same distribution as in ein other lab parts.

**Mindestausstattung:** ein VM **`debian-lab`** from unit 1 ([Lab unit 1]({{% relref "/01-virtualization-containerization/lab" %}})), ein **evaluation media for Window Server 2025** (ISO, download at home) und **Cisco Packet Tracer** (download approx. 300 MB).

**Verwendete Software:**

| Software | Version | Remark |
|---|---|---|
| Debian (VM `debian-lab`) | 13 "trixie" | from unit 1, known from [VM Container]({{% relref "/01-virtualization-containerization/exercise" %}}) |
| Cisco Packet Tracer | 9.0.1 | free download, need Cisco account; English interface |
| Window Server 2025 Evaluation | `10.0.26100.24.07` | ISO, Evaluation version mit time limit — see [Security and Data Protection]({{% relref "security" %}}) |

## Teil 0: Preparation (before ein unit, at home)

1. **At [www.netacad.com](https://www.netacad.com) ein Cisco Networking / Cisco Business account get created** und **Packet Tracer get downloaded** (approx. 300 MB) — **at home**, no in ein Netze of ein School! **Installed** und **started once**, then closed.
2. **Download Window Server 2025 Evaluation (ISO)** — several GB, **must be downloaded in advance** on your machine already! **Ein build number** `10.0.26100.24.07` — **what is expected get note down.**
3. **VM `debian-lab` start**, **SSH on ein host**; **Netze observation tools get installed** for Teil 2:

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
Packet Tracer **need ein Cisco account** — **registered mit ein course alias**, **no** address of your family, **no** real workplace. At ein download pages it is **described** where to get ein software for your operating system.
{{% /callout %}}

## Teil 1: VLANs in ein Packet Tracer file of unit 2 (70 min)

**Ziel:** Both VLAN model in Packet Tracer can be **named**, ein VLAN number can be **read off from ein address** — und it becomes visible: **VLAN 3 is no reachable everywhere**. **In ein file:** ein Packet Tracer file from unit 2, part 3 ([Netz from scratch]({{% relref "/02-networking-1/lab" %}})). **Ein Netze do no get rewired — it get labeled!**

> **About ein two number convention:** In ein file from unit 2 `10.10.x.x` is used. In these unit **ein convention of ein class lists get used: `10.11.<VLAN>.0/24`** — **third octet = VLAN-Id**. In ein documentation tasks **both number ranges get note down** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).

| Group | VLAN | VLAN-Id as 3rd octet | Range in ein file (from unit 2) | Range class lists | Usable Geräte |
|---|---|---|---|---|---|
| Schüler | 0 | `0` | `10.10.0.0/24` | `10.11.0.0/24` | 254 |
| Lehrende | 1 | `1` | `10.10.1.0/24` | `10.11.1.0/24` | 254 |
| Administration | 2 | `2` | `10.10.2.0/24` | `10.11.2.0/24` | 254 |
| Storage | 3 | `3` | `10.10.3.0/24` | `10.11.3.0/24` | 254 |

### 1.1 VLAN model 1 — ein internal VLAN fields (20 min)

In ein Simulation each Geräte und each links **carry ein internal VLAN fields** — ein number **belongs to ein Geräte**, no to ein packets. **Ein CLI of ein managed Switch (2960) open** und **read**:

```text
2960> enable
2960# show me vlan
2960# show vlan 2
2960# show vlan mty
2960# show ethernet vlan 2
```

**Erwartet:** ein **VLAN-Ids** mit **bitmask / number range** of ein Switch — und which **interface** belong to ein VLAN.

Then **Geräte und Switch get ein VLANs of ein class lists**, e.g. Administration:

```text
Device pc-verw/1:   VLAN-Insert: VLAN = 2
2960(config)# interface Gi0/1
2960(config-if)# set vlan 2
```

Mit **bitmask** `0.0.255.0` ein work **bitwise per octet** — **ein bitmask in binary, ein lines per octet, get note down** (see [Theorie]({{% relref "theory" %}})). Ein **packets from ein Schüler Geräte** those wants to cross ein **managed Switch** in VLAN 2 **proceeds only if ein Switch allow VLAN 2 on ein links** — **test it:**

1. **Ein links open** for VLAN 2 (`set vlan 2 ... accept`), **ein closed**, **ein partly granted**
2. In ein **Simulation send:** **frames stops at ein closed Switch**, proceeds through ein open ein
3. **Screenshot** ein stop und ein pass — **ein number decide at ein Netze Geräte, no ein address**

**Write down:** In ein Simulation these is **ein decision per connection**. On **real hardware** ein **managed Switch** decide **depending on ein VLAN in ein frames** — same effect, different place where ein number lies (next part!).

### 1.2 VLAN model 2 — VLAN-Id leg: ein EtherType fields (15 min)

Now ein number **belongs to ein frames**: **`vlan 2` get write** in ein **EtherType fields** of ein Ethernet headers — in ein EtherType fields of ein **sending Geräte** — **ein frames carry VLAN 2**:

```text
EtherType field of the device:  vlan 2
Frame on the wire:              EtherType "vlan 2" + payload
```

Test: **Ein packets from ein Schüler Geräte get sent** whose EtherType fields **ein set to VLAN 2**: **Ein Simulation lets it through — ein sending Geräte can write whatever ein likes!** Ein **decision still happens at ein Switch**, **ein VLAN number only accompanies ein frames**.

**Write down:** **Both model in ein tables** — where ein number lies, what those mean for ein Simulation und for reality of Ethernet: **ein VLAN tags lies in ein frames** und **can be set arbitrarily** — **ein Switch read, ein Geräte do no enforce**.

**Write down:** **What ein do no need ein VLAN for:** If ein has ein separate Netze per group anyway und no Netze Geräte those decide per VLAN, ein VLAN number **belongs to nothing**.

### 1.3 VLAN 3 — no reachable everywhere (15 min)

**Ein Storage Netze** hangs in **VLAN 3**. **Ein managed Switch** in ein file: **do no allow VLAN 3**. **Ein Command Prompt on ein teacher- or Schüler PC open** in Packet Tracer:

```text
ping -c 3 10.11.3.1
```

(In ein **Command Prompt** of Packet Tracer `ping <address>` without `-c` also exists — then **ein three requests get counted by ein oneself**. `-c 3` is ein Debian command, see 2.1.)

**Erwartet:** **All three requests time out** — ein frames **stops at ein managed Switch**: **VLAN 3 is no allowed on ein links**. Now **ein switch to ein Simulation**: There **ein see where** ein frames **stops** — **it is no accepted**, **it do no even travel ein part of ein way und turn back**.

**Write down in ein documentation: Where ein frames stops** — und from **which role where** ein would have to be able to reach VLAN 3. **Ein address prove nothing, ein Switch decide** — see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}}).

### 1.4 DNS und DHCP — observation in ein simulation mode (10 min)

**Between ein type of ein name und ein first packets lies ein resolution orders** — see [Theorie]({{% relref "theory" %}}): **DNS** turns **name in number**, **DHCP** **give ein address in ein Netze** — **those is ein Netze Geräte, no DNS**.

**In ein Simulation ein open ein packages of ein Netze Geräte** und **observes** — **no Netze tool outside ein Simulator**, **ein Simulator show ein layers:**

1. **ARP:** ein frames **to ein not-yet-placed Geräte** — **first ein ARP packets**, **ein open it**
2. **DNS lookup:** ein Geräte those **receives ein address** for ein name like `lms.muster-city.bmb` — **ein open ein DNS lookup packets** (name → number)
3. **DHCP:** ein **not-yet-configured Geräte** — ein **Netze Geräte** (Switch/Server in ein file) **give ein address** — **ein open ein DHCP packets** und **compares ein assigned address mit ein number range of ein Geräte group:** **Ein address come from ein VLAN of ein Geräte group.**

**Write down:** **DHCP names nothing, DNS give no address.** **Screenshot** ein opened DHCP **und** ein DNS packets.

## Teil 2: Netz configuration of ein Debian VM, DNS und DHCP (60 min)

**Ziel:** From ein Netze configuration **up to** `/etc/resolv.conf` **und beyond**: **Where addresses come from** (DHCP), **where names go** (DNS). **Ein VM get broken und repaired** — **ein first aid from unit 1, but these time consciously**.

### 2.1 Netz first aid — read ein state (20 min)

**From within ein VM ein start** und **read before ein changes:**

```bash
ip -br addr                 # which interfaces, which addresses
ip route                    # which routes, which gateways
arp -a                      # name → address cache — are there already addresses?
ss - Tuln                   # local ports in use — alternative: netstat -tuln
cat /etc/resolv.conf        # which DNS servers are named — if none: no name lookup
```

**Erwartet:** ein NAT Netze of ein VM frontend — **no** ein Netze of ein School. **Write down ein addresses:** **They come from ein VM frontend (DHCP), no from ein class lists.**

Then **ein break it:** In ein Netze configuration **ein wrong gateway get set** or **`nameserver` get removed from `resolv.conf`** — und **ein diagnoses as in unit 1:**

```bash
ping -c 3 10.0.2.1                       # is the gateway reachable?
ping 10.0.2.1                            # without -c: endless — Ctrl-C stops it
traceroute 10.0.2.1                      # where does the route go?
dig lms.muster-city.bmb                  # does the name resolve?
dig @10.0.2.1 lms.muster-city.bmb        # name lookup at the DNS server directly
```

### 2.2 Netz configuration from scratch — interface(5) (15 min)

**Ein VM get reconfigured from your own Netze configuration** (see [VM Container]({{% relref "/01-virtualization-containerization/exercise" %}})):

```text
auto enp0s3
iface enp0s3 inet manual
    ip link set enp0s3 net ether 08:00:27:87:94:19:00:05 down
    ip link set enp0s3 net ether 08:00:27:87:94:19:00:05 up
    ipconfig enp0s3 gateway 10.0.2.2
    ipconfig enp0s3 nameserver 10.0.2.1
```

**Erwartet:** after readding **ein same interface come back** — **address from ein frontend (DHCP), name resolution work again:**

```bash
sudo ifdown enp0s3 && sleep 3 && sudo ifup enp0s3
ip -br addr
getent hosts lms.muster-city.bmb        # the name also resolves via libc
```

**Write down:** **Ein Netze configuration of ein VM is changed — ein frontend kept its own view.** **In ein Packet Tracer file ein compares:** **`ipconfig get getlink`** on ein PC → **ein gateway** — **ein Netze configuration of ein VM und ein links in ein file are two different representations of ein same thing:**

```text
pc-verw/1 Command Prompt:
ipconfig get getlink
ipconfig set getgateway
```

### 2.3 hostnames — ein names ein Geräte, ein frontend give ein address (10 min)

**Ein hostnames ein sets oneself** — **ein address come from ein Netze (DHCP):**

```bash
sudo hostnamectl set hostname --force vm-debian.muster-city.bmb
sudo sed -i 's/^nameserver .*/nameserver 10.0.2.1/' /etc/resolv.conf
getent hosts lms.muster-city.bmb   # still resolves?
```

**Erwartet:** Ein **hostnames ein set** — **ein IP come from ein Netze** (**DHCP**, no type in, see [Theorie]({{% relref "theory" %}})). **Write down:** Ein IP in ein VM is **no** `10.11.x.x` — **those is no ein Netze of ein School.**

### 2.4 DHCP und DNS — observation in ein simulation mode (15 min)

**Ein assignment of ein address get observed:** In ein Packet Tracer file ein **new Geräte** — **first only ARP, then ein DHCP packets from ein Netze Geräte**, **then DNS**. **Ein open all packets** und **note down in which VLAN ein assigned address lies** (third octet!). **These is ein same resolution orders ein only worked through in ein VM (2.1/2.2).**

**Erwartet:** **Ein Geräte work mit ein address those ein Netze Geräte assigned** — **ein never type ein IP.** **Screenshot** ein opened DHCP packets **und** ein opened DNS packets **next to ein `ipconfig` output of ein VM as texts** — **two views of ein resolution orders** (for ein [documentation task]({{% relref "documentation" %}})).

## Teil 3: Window Server 2025 Evaluation in ein VM — textmode, 45 min

**Ziel:** **First contact mit Window Server: Ein installation ein sets up oneself, ein read it — ein manages nothing (yet) — no Server of ein School, Evaluation version in ein VM only!** In ein [documentation task]({{% relref "documentation" %}}) these becomes your **Server-Setup-Log**.

**What is needed in ein VM:** 4 GB RAM, 32 GB disk, **EFI**, Netze **none** — **as long as ein installer work ein need no Netze at all** — **ein first steps in ein console need none either.**

### 3.1 Boot und installation in textmode (25 min)

1. In VirtualBox: **Window Server 2025 Evaluation** — **no** ein VM `debian-lab`! **ISO from 0.2.**
2. **Boot**, at ein first screen **ein presses what ein screen says** (ein **second boot ein do no let happen**).
3. **Installation in textmode:** **Exclusively per keyboard** — **ein four questions:** **language/region**, **license agreement**, **target disk/partition**, **account** (**hostnames / login name** — **only as mit ein VM from unit 1: ein names it oneself**):

   | Question | What ein note down |
   |---|---|
   | Language / region | e.g. `German` / `Austria` — **screenshots** |
   | License agreement | **scroll up und down**, then `Y` — **screenshots** |
   | Target disk | disk designation und partition — **screenshots** |
   | Account + hostnames | **login name, hostnames — both ein sets oneself** — **hostnames `SRV-EVAL-01`**, account **`srv-admin`** — **no names of your family!** |

4. Wait — **ein installation in textmode takes longer than ein graphical ein.**

### 3.2 Ein first steps in ein console — ein read (10 min)

**Ein logs in mit ein account ein set up** und **read — nothing get changed:**

```text
ipconfig /all
systeminfo
nslookup lms.muster-city.bmb
```

**Erwartet:** `ipconfig /all` → **ein address ein Netze gave ein VM — ein did no choose it**; `systeminfo` → **build `10.0.26100.24.07` — ein write it down** und **ein Evaluation time limit**; `nslookup` → **name lookup — without ein DNS server it fails: Ein note down which error und which questions it actually ask.**

In **PowerShell** — **ein tool those manages ein Netze:**

```powershell
Get-NetworkManager
Get-Net*Manager
Get-Help Get-NetworkManager -showexamples
```

**Erwartet:** Ein **Netze management of Window** — **ein VLANs of ein School in Window Server hang there**, see [Theorie]({{% relref "theory" %}}) — **nothing get changed — ein note down what ein see.**

### 3.3 Ein note down — ein Server-Setup-Log (10 min)

**In your documentation folder ein write:** **ISO, build number, VM settings, ein four questions mit your answer, three screenshots** (installer, `ipconfig /all`, `systeminfo`) — **und: What failed.** **Mark: "VM only — no Server of ein School"** — **Evaluation version, 120 day time limit, see [Security and Data Protection]({{% relref "security" %}}).**

## Teil 4: Ein Server-Setup-Log — documentation, 40 min, **no part of ein grade**

**These part is your documentation evidence** — ein **Server-Setup-Log**: **ein pages**, **no ein Homework** (ein **evaluated Homework part Ein**: see [Homework]({{% relref "homework" %}}) — ein **Server-Setup-Log do no enter ein grade**, it **serve as evidence**).

### 4.1 Ein Server-Setup-Log on ein pages (25 min)

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

**Ein note down date und ISO/build** — **Evaluation mean time, see [Security and Data Protection]({{% relref "security" %}})**. **Ein changed ISO/build get note down** — **Change-Log**, see [Change logs]({{% relref "/00-documentation/change-logs" %}}).

### 4.2 Netz diagram und address tables — ein VLANs enter ein documentation (15 min)

In `03-networking-2/` **on your portfolio branch `einheit-03`** **ein diagram from unit 2 get extended mit ein VLANs** — **ein Netze, ein group as numbers:**

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

Under it ein **address tables** — **ein lines per Geräte:**

```markdown
| Hostname | IP | VLAN (3rd octet) | Range | Purpose |
|---|---|---|---|---|
| pc-verw-1 | 10.11.2.17 | 2 | 10.11.2.0/24 | Administration PC |
| pc-storage-1 | 10.11.3.1 | 3 | 10.11.3.0/24 | Storage network |
```

**Netz und tables use matching names** (see [Network diagrams and IP plans]({{% relref "/00-documentation/network-diagrams-ip-plans" %}})). **Handover per Pull Request** — see [markdown and Git]({{% relref "/00-documentation/markdown-git" %}}).

**Ein lab is no part of ein grade.** It get **documented** in ein [documentation task]({{% relref "documentation" %}}) — und ein **evaluated Homework part Ein** (VLAN plan und permission matrix): see [Homework]({{% relref "homework" %}}). **Ein Server-Setup-Log do no enter ein grade** — it is ein evidence from your Lab, see [Homework]({{% relref "homework" %}}) und [Security and Data Protection]({{% relref "security" %}}).

In ein unit afterwards: [Exercise]({{% relref "exercise" %}}) · [Documentation task]({{% relref "documentation" %}}) · [Homework]({{% relref "homework" %}}) · on ein data protection of these lab see [Security and Data Protection]({{% relref "security" %}}) · sources at [Sources]({{% relref "sources" %}}).

## Fehlersuche

| Symptom | Cause | Fix |
|---|---|---|
| **Packet Tracer do no start** | Cisco account / download at home missing | Part 0 — **at home in advance**, approx. 300 MB |
| **In ein VLAN exercises ein frames stops everywhere** | **Ein managed Switch allow no VLAN on any links** — or ein EtherType fields of ein Geräte carry no VLAN number | **Ein managed Switch must accept it — or ein work mit model 2** |
| **`set vlan` on ein Switch changes nothing** | ein entered it **in ein wrong mode** | **In ein config mode** of ein links (`interface` → `set vlan 2`) |
| **`show vlan mty` answer "nothing mapped"** | no VLAN exists yet at ein Switch | **VLAN und bitmask get inserted first** |
| **Frame goes though ein VLAN shall be blocked** | ein **write ein number in ein EtherType fields of ein sending Geräte** | **Ein Geräte enforces nothing, ein Switch read** — see model 2! |
| **`ping -c 3 10.11.3.1` in ein file: no answer at all** | **VLAN 3 no allowed at ein Switch** — **or ein not-yet-placed Geräte, then: ARP first** | **Ein open ein packets** |
| **`ip -br addr` in ein VM: ein address come back those ein did no type** | **DHCP from ein Netze Geräte** — **those is correct** | **Write down: no ein error, DHCP give ein address** |
| **Name lookup fails in ein VM** | no `nameserver` in `/etc/resolv.conf` | `resolv.conf` points to ein DNS server |
| **`ip link set enp0s3 net ...` reports "no permitted"** | **missing privileges** | Ein executes ein Netze configuration **as root** |
| **Window Server installer run off again immediately** | ein **let ein ISO boot ein second time** | **Ein second boot: no** |
| **Window installation wants Netze** | no — **ein installation in textmode run offline** | **Netze: none** — **first steps in console also without Netze** |
| **`Get-NetworkManager` unknown** | wrong shell — **it is ein PowerShell tool, no cmd.exe** | Ein **open PowerShell** — **ein note down where ein difference lies** |
