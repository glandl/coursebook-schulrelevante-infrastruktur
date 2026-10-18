+++
title = "Preparation checklist"
weight = 2
+++

Large downloads and installations eat up the session time, especially when 20 laptops share one Wi-Fi. Work through this list **at home, at least two days before each session**. Per session there is a short list, the general points apply to the whole course.

## General (once, before the first session)

- [ ] **Laptop with admin rights.** You must be allowed to install software. Locked school or employer devices usually do not work, see the fallbacks in the [lab]({{% relref "/01-virtualization-containerization/lab" %}}#special-cases-and-fallbacks).
- [ ] **Free storage: at least 30 GB**, RAM: at least 8 GB.
- [ ] **Virtualization enabled in the BIOS/UEFI** (*Intel VT-x* / *AMD-V (SVM)*). Check: Task Manager → Performance → CPU → "Virtualization: Enabled". Changing it needs a restart, so do not leave it for the session.
- [ ] **Charger** with you. VMs drain the battery fast.
- [ ] **Git installed** (`git --version`) and **GitHub account** created.
- [ ] **Portfolio repository:** invitation accepted, `git clone` tried once (name and email set with `git config`).
- [ ] **Text editor** with Markdown preview, e.g. Visual Studio Code with the extension *Markdown Preview Mermaid Support*.
- [ ] **SSH client** available: `ssh -V` in a terminal. It is included in Windows 10/11 (PowerShell), macOS and Linux.

## Session 1: Virtualization & Containerization

Download and test **before** the session:

- [ ] **Virtualization chosen and installed** (table *Which virtualization?* in the [lab]({{% relref "/01-virtualization-containerization/lab" %}})):
  - **VirtualBox 7.x** ([virtualbox.org](https://www.virtualbox.org)) installed and started once. Windows: accept the driver installation and restart if asked.
  - **Linux:** `virt-manager` installed, user in the `libvirt` group, `ls /dev/kvm` shows the file.
  - **Apple Silicon (M1–M4):** **UTM** ([mac.getutm.app](https://mac.getutm.app)) installed.
  - **Windows Pro/Education with WSL2 or Hyper-V:** Windows feature **Hyper-V** enabled (restart needed).
- [ ] **Debian 13 DVD image** downloaded at home (file `debian-13.x.x-<arch>-DVD-1.iso`, about 4 GB, [debian.org/CD/http-ftp](https://www.debian.org/CD/http-ftp/)): `amd64` for Intel/AMD, `arm64` for Apple Silicon. **Not** the small netinst image: it downloads from the Internet during installation, and we do the installation together in the session.
- [ ] **Download checked:** compare the checksum with the file `SHA512SUMS` in the same download folder. Windows (PowerShell): `Get-FileHash -Algorithm SHA512 <file>.iso`; macOS: `shasum -a 512 <file>.iso`; Linux: `sha512sum <file>.iso`. A broken download otherwise only shows up during installation.

Know before you start:

- [ ] In the Debian installer, **leave the root password empty** (then `sudo` works), use **no network mirror** and in the software selection tick **only** *SSH server* and *standard system utilities* (fix for missing SSH: see the hint in lab part 1.4).
- [ ] **Access from the host:** VirtualBox needs **port forwarding** (host `2222` → guest `22`, host `8080` → guest `8080`). With virt-manager, UTM and Hyper-V you reach the VM directly via its IP address.
- [ ] VirtualBox: free the **ports 2222 and 8080** on your laptop (no other program using them).

## Session 2: Networking I

- [ ] **Cisco Networking Academy account** created ([netacad.com](https://www.netacad.com/), free) and the confirmation e-mail answered.
- [ ] **Cisco Packet Tracer 9.0.1 installed** and **logged in once with the account** (the first login needs Internet). Save an empty project and open it again. See [lab, part 0]({{% relref "/02-networking-1/lab" %}}).
- [ ] **The VM `debian-lab` from session 1 still starts**, you can log in and connect via SSH (VirtualBox: `ssh -p 2222 <user>@127.0.0.1`, otherwise `ssh <user>@<VM-IP>`). If not, restore the snapshot `00-fresh-install` or `10-docker-installed` **at home**.
- [ ] **Free disk space:** keep at least 10 GB free for clones and extra VMs.
- [ ] **Updated VM:** `sudo apt update && sudo apt upgrade -y`, then take a new snapshot.
- [ ] **Tools installed in the VM** (download at home, not on the session Wi-Fi): `sudo apt install -y python3 iputils-tracepath bind9-dnsutils traceroute tcpdump nmap`. Check with `ip a`, `ping -c 3 1.1.1.1`, `tracepath -V` and `python3 --version`.
- [ ] **Know the network settings of your virtualization:** where do you set the VM's network (VirtualBox: *Settings → Network*; virt-manager: *NIC*; UTM: *Network*; Hyper-V: *Network Adapter*)? Find the menu once; in the lab you optionally switch from NAT to a bridge.
- [ ] **Diagram tool ready:** VS Code with the Mermaid preview extension, or [diagrams.net](https://app.diagrams.net) (desktop app or browser). Try one small diagram.
- [ ] **Read the technique** [Network diagrams and IP plans]({{% relref "/00-documentation/network-diagrams-ip-plans" %}}) beforehand.
- [ ] **Optional:** [Wireshark](https://www.wireshark.org/download.html) on the host. On Windows, allow the Npcap installation.
- [ ] **Session 1 submission in the portfolio** is pushed (branch `session-01`, pull request opened), so the new branch `session-02` starts from a clean state.

## Further sessions

Preparation for the following sessions is added to this page when the chapters are released.

## If something does not work

Do not fight it alone during the session: note the **exact error message** (screenshot), the operating system and the step you were at, and report it to the lecturer. Such notes also make good material for the documentation task.
