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

- [ ] **VirtualBox 7.x** installed and started once ([virtualbox.org](https://www.virtualbox.org)). Windows: also accept the driver installation and restart if asked.
- [ ] **Ubuntu Server 24.04 LTS ISO** downloaded (about 2–3 GB, [ubuntu.com/download/server](https://ubuntu.com/download/server)). Check that the file is complete; a broken download only shows up during installation.
- [ ] **Apple Silicon (M1–M4):** UTM ([mac.getutm.app](https://mac.getutm.app)) and the **Ubuntu Server ARM64** ISO instead of the two points above.
- [ ] **Windows with WSL2/Hyper-V:** VirtualBox works but is slower. Close other heavy programs and VMs before the session.
- [ ] Optional but saves a lot of time: **create the VM and install Ubuntu at home** (lab part 1), with *Install OpenSSH server* ticked in the installer. Take the snapshot `00-fresh-install`.
- [ ] Optional: in the running VM, run `sudo apt update && sudo apt upgrade -y` so the updates are not downloaded during the session.

Know before you start:

- [ ] The **installer option "Install OpenSSH server"** must be ticked, otherwise SSH from the host does not work (fix: see the hint in lab part 1.4).
- [ ] **Port forwarding** in VirtualBox: host `2222` → guest `22` and host `8080` → guest `8080`.
- [ ] Free the **ports 2222 and 8080** on your laptop (no other program using them).

## Session 2: Networking I

{{% callout style="warning" title="Provisional" %}}
The chapter is still a skeleton. This list is based on the planned topic (network diagrams and IP plans) and the session 1 lab. It will be adjusted when the lab is written.
{{% /callout %}}

- [ ] **The VM from session 1 still starts**, you can log in and `ssh -p 2222 <user>@127.0.0.1` works. If not, restore the snapshot `00-fresh-install` or `10-docker-installed` **at home**.
- [ ] **Free disk space:** keep at least 10 GB free for clones and extra VMs.
- [ ] **Updated VM:** `sudo apt update && sudo apt upgrade -y`, then take a new snapshot.
- [ ] **Network tools installed in the VM** (download at home, not on the session Wi-Fi): `sudo apt install -y traceroute dnsutils tcpdump nmap`. Check with `ip a`, `ping -c 3 1.1.1.1` and `traceroute --version`.
- [ ] **Know your own network settings** in VirtualBox: *Settings → Network*, adapter types (NAT, Internal Network, Host-only). Find the menu once, you will add a second adapter.
- [ ] **Diagram tool ready:** VS Code with the Mermaid preview extension, or [diagrams.net](https://app.diagrams.net) (desktop app or browser). Try one small diagram.
- [ ] **Read the technique** [Network diagrams and IP plans]({{% relref "/00-documentation/network-diagrams-ip-plans" %}}) beforehand.
- [ ] **Optional:** [Wireshark](https://www.wireshark.org/download.html) on the host. On Windows, allow the Npcap installation.
- [ ] **Session 1 submission in the portfolio** is pushed (branch `session-01`, pull request opened), so the new branch `session-02` starts from a clean state.

## Further sessions

Preparation for the following sessions is added to this page when the chapters are released.

## If something does not work

Do not fight it alone during the session: note the **exact error message** (screenshot), the operating system and the step you were at, and report it to the lecturer. Such notes also make good material for the documentation task.
