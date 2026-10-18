+++
title = "Guided lab"
weight = 30
+++

{{% callout style="warning" title="Status: untested" %}}
The commands and settings in this lab have **not yet** been run in the course environment. This applies in particular to the Debian installer and the virt-manager, UTM and Hyper-V options (menu names, snapshots, cloning). Software information as of October 2026. Check versions before use. *Tested on: open.*
{{% /callout %}}

## Overview

| Part | Content | Duration |
|---|---|---|
| 0 | Preparation and hardware check | 15 min |
| 1 | Create a Debian VM, snapshots, clone | 60 min |
| 2 | Install Docker and first containers | 25 min |
| 3 | Docker Compose: Nextcloud with database, volumes, backup | 35 min |

**Minimum hardware:** 8 GB RAM (of which 2 GB for the VM), 30 GB free storage, 64-bit CPU with virtualization enabled. Debian without a desktop needs only about 150 MB RAM when idle; on weak devices 1 GB is enough for parts 1 and 2.

**Software used:**

| Software | Version | Note |
|---|---|---|
| Debian GNU/Linux | 13 "trixie", DVD image `DVD-1` (`amd64`, on Apple Silicon `arm64`), about 4 GB | [debian.org/CD/http-ftp](https://www.debian.org/CD/http-ftp/) |
| Virtualization | one of the four options below | |
| Docker Engine + Compose plugin | current stable version | [docs.docker.com/engine/install/debian](https://docs.docker.com/engine/install/debian/) |
| Nextcloud (image) | `nextcloud:<major version>-apache` (e.g. `31-apache`) | [hub.docker.com/_/nextcloud](https://hub.docker.com/_/nextcloud) |
| MariaDB (image) | `mariadb:11` | [hub.docker.com/_/mariadb](https://hub.docker.com/_/mariadb) |

### Which virtualization?

Choose **one** option that fits your device. The instructions show the differences in tabs; your choice applies to all tabs in the course.

| Your device | Option | Why |
|---|---|---|
| Windows Home, Intel Mac, Linux without experience | **VirtualBox** 7.x ([virtualbox.org](https://www.virtualbox.org)) | same interface on all systems |
| Linux | **virt-manager** with QEMU/KVM (distribution package) | the Linux kernel's built-in hypervisor, faster than VirtualBox |
| Mac with Apple Silicon (M1–M4) | **UTM** ([mac.getutm.app](https://mac.getutm.app)), uses QEMU | VirtualBox only supports Apple Silicon to a limited extent |
| Windows Pro/Education with **WSL2 or Hyper-V active** | **Hyper-V Manager** (included in Windows) | VirtualBox runs heavily slowed down next to Hyper-V |

VirtualBox, UTM and virt-manager are **type 2 front ends** on the laptop; KVM and Hyper-V are hypervisors built into the operating system (see [Theory]({{% relref "theory" %}})).

## Part 0: Preparation

Downloads and installations should be done beforehand, see the [preparation checklist]({{% relref "/preparation" %}}).

### Check virtualization

- **Windows:** Task Manager → Performance → CPU → "Virtualization: Enabled". If "Disabled": enable *Intel VT-x* or *AMD-V (SVM)* in the BIOS/UEFI.
- **macOS:** Usually enabled.
- **Linux:** `lscpu | grep -i virtualization`; for virt-manager also `ls /dev/kvm` (the file must exist).

### Special cases and fallbacks

| Situation | Solution |
|---|---|
| **Windows Home with WSL2 active** | Windows Home has no Hyper-V Manager. VirtualBox then runs on the Windows Hypervisor Platform, more slowly. It works; run the VM with 1 GB RAM. |
| **Less than 8 GB RAM** | VM with 1 GB RAM, replace part 3 (Nextcloud) with the lighter nginx option (3.4). |
| **Device locked, no installation allowed** | Own laptop on the course day or cloud alternative: Linux environment at [killercoda.com](https://killercoda.com) or GitHub Codespaces with Docker (parts 2 and 3 possible, part 1 is skipped). |

### Create the folder in the portfolio

You record your results from the start (see [Documentation task]({{% relref "documentation" %}})):

```bash
cd <your-portfolio>
git switch -c session-01
mkdir -p 01-virtualization-containerization/assets
```

## Part 1: Debian VM

### 1.1 Create the VM

{{< tabs groupid="vm-platform" >}}
{{% tab title="VirtualBox" %}}
1. Start VirtualBox → **New**.
2. Name: `debian-lab`, ISO image: the Debian DVD image, enable **"Skip unattended installation"** (so you see the installation once).
3. Hardware: **2 CPU cores**, **2048 MB RAM**. Hard disk: **20 GB**, dynamically allocated (VDI).
4. Under *Settings → Network* keep **NAT**. For access from the host, set up **port forwarding**: *Advanced → Port Forwarding* → name `ssh`, protocol TCP, host port `2222`, guest port `22`. In addition: host port `8080` → guest port `8080` (for parts 2 and 3).
{{% /tab %}}
{{% tab title="Linux: virt-manager" %}}
Install once (Debian/Ubuntu): `sudo apt install virt-manager`, then add your user to the `libvirt` group (`sudo usermod -aG libvirt $USER`) and log in again.

1. Start virt-manager → **New virtual machine** → *Local install media* → choose the Debian DVD image. The operating system is usually detected, otherwise enter *Debian 13*.
2. **2048 MB RAM**, **2 CPUs**, disk **20 GB** (format qcow2, default).
3. Name: `debian-lab`, network: **Virtual network "default": NAT** (default).

The `default` network is a NAT network `192.168.122.0/24`. Unlike VirtualBox, the host reaches the VM **directly via its IP address**, no port forwarding is needed.
{{% /tab %}}
{{% tab title="macOS: UTM" %}}
1. Start UTM → **+** → **Virtualize** (not *Emulate*) → **Linux**.
2. *Boot ISO Image*: the Debian DVD image for **arm64**.
3. **2048 MB RAM**, **2 CPU cores**, disk **20 GB**.
4. Name: `debian-lab`. Network: **Shared Network** (default).

In the *Shared Network* the VM gets an address from `192.168.64.0/24`. The Mac reaches the VM **directly via its IP address**, no port forwarding is needed.
{{% /tab %}}
{{% tab title="Windows: Hyper-V" %}}
Enable once: *Turn Windows features on or off* → **Hyper-V** → restart. Only in Windows Pro, Education and Enterprise.

1. Hyper-V Manager → **New → Virtual Machine**.
2. Name: `debian-lab`, **Generation 2**, **2048 MB** memory (turn off dynamic memory), network: **Default Switch**, hard disk **20 GB**, installation media: the Debian DVD image (`amd64`).
3. **Before the first start:** *Settings → Security* → set the Secure Boot template to **Microsoft UEFI Certificate Authority**. With the default template "Microsoft Windows" Debian does not boot.
4. *Settings → Processor*: **2** virtual processors.

The *Default Switch* is a NAT network with addresses from `172.x.x.x`. The host reaches the VM **directly via its IP address**. Caution: the network, and with it the address, can change after a Windows restart.
{{% /tab %}}
{{< /tabs >}}

📸 *Screenshot: VM summary (name, RAM, CPU, disk, network).*

### 1.2 Install Debian

Start the VM and choose **Install** in the boot menu (the text variant is faster than *Graphical install*, both work). The DVD image contains all the packages you need: the installation runs **without Internet** and takes about 5–10 minutes. This way the laptops do not slow each other down on the shared Wi-Fi.

| Step | Choice |
|---|---|
| Language, location, keyboard | as you like (e.g. *English*, *Austria*, *German*) |
| Hostname | `debian-lab`, leave the domain empty |
| **Root password** | **leave empty** (press Enter twice). Your user then gets `sudo` rights, as the commands in this course assume. |
| User | choose a name (e.g. `admin`), **strong password** |
| Disk | *Guided – use entire disk*, *All files in one partition*, write changes: *Yes* |
| Scan extra installation media | **No** |
| **Use a network mirror?** | **No**. Otherwise the installer downloads updates from the Internet. You add the online package sources yourself after the installation (below). |
| Package usage survey (*popularity-contest*) | **No** (otherwise usage data is sent) |
| **Software selection** | **only** *SSH server* and *standard system utilities*. **Deselect** *Debian desktop environment* and *GNOME*. |
| GRUB boot loader | *Yes*, on the only disk (`/dev/sda` or `/dev/vda`) |

After the installation, restart (UTM: eject the ISO under *CD/DVD* first), then log in at the console.

**Enable the package sources from the Internet.** Because you did not choose a network mirror, `apt` only knows the DVD so far. Add the online package sources (ideally by copy and paste, e.g. after logging in via SSH in 1.4):

```bash
# disable the DVD as a package source
sudo sed -i 's/^deb cdrom:/# deb cdrom:/' /etc/apt/sources.list
# add the online package sources for Debian 13
sudo tee /etc/apt/sources.list.d/debian.sources > /dev/null <<'EOF'
Types: deb
URIs: http://deb.debian.org/debian
Suites: trixie trixie-updates
Components: main
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: http://security.debian.org/debian-security
Suites: trixie-security
Components: main
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF
grep -rn cdrom /etc/apt/     # may only show commented-out lines (#)
```

**Expected:** `sudo apt update` in 1.3 downloads the package lists from `deb.debian.org` and `security.debian.org` without errors. If `apt` warns that a source is *configured multiple times*, the installer has already written lines to `/etc/apt/sources.list`: delete the duplicate lines there (`sudo nano /etc/apt/sources.list`).

### 1.3 First steps in Linux

```bash
whoami            # user name
hostnamectl       # hostname, operating system, kernel
ip -br addr       # network interfaces (short) and the VM's IP address
df -h /           # disk usage
free -h           # memory
```

Note the IP address from `ip -br addr` (the line that is not `lo`). With virt-manager, UTM and Hyper-V you need it below as `<VM-IP>`.

Update the system:

```bash
sudo apt update
sudo apt upgrade -y
```

**Expected:** `apt update` lists package sources without errors, `apt upgrade` installs updates if available. If `sudo` reports that your user is not in the *sudoers* file, you set a root password: see Troubleshooting.

📸 *Screenshot: `hostnamectl` and `ip -br addr`.*

### 1.4 Access via SSH from the host

On the **host** (not in the VM):

{{< tabs groupid="vm-platform" >}}
{{% tab title="VirtualBox" %}}
```bash
ssh -p 2222 <user>@127.0.0.1
```

SSH via port forwarding is only reachable from the host, not from other computers on the network.
{{% /tab %}}
{{% tab title="Linux: virt-manager" %}}
```bash
ssh <user>@<VM-IP>
```

The network `192.168.122.0/24` exists only on your computer; other devices cannot reach the VM.
{{% /tab %}}
{{% tab title="macOS: UTM" %}}
```bash
ssh <user>@<VM-IP>
```

The *Shared Network* exists only on your Mac; other devices cannot reach the VM.
{{% /tab %}}
{{% tab title="Windows: Hyper-V" %}}
```powershell
ssh <user>@<VM-IP>
```

The *Default Switch* is only reachable from the host. If the connection stops working after a restart, check the address in the VM again with `ip -br addr`.
{{% /tab %}}
{{< /tabs >}}

When you connect for the first time, confirm the fingerprint with `yes`. **Expected:** You are logged in to the server.

> **Tip – SSH does not work?** If *SSH server* was not ticked in the software selection, the service is missing. Install it in the VM (console of the VM window):
>
> ```bash
> sudo apt update
> sudo apt install openssh-server
> sudo systemctl enable --now ssh
> systemctl status ssh
> ```
>
> **Expected:** `status` shows `active (running)`. Then run the `ssh` command on the host again.

### 1.5 Take a snapshot and go back

**1. Take a snapshot.** Name: `00-fresh-install`, description: "After installation and updates".

{{< tabs groupid="vm-platform" >}}
{{% tab title="VirtualBox" %}}
VM manager → select the VM → **Snapshots** → **Take**.
{{% /tab %}}
{{% tab title="Linux: virt-manager" %}}
Open the VM → menu *View* → **Snapshots** → **+** (bottom left). Snapshots work with the disk format qcow2 (default).
{{% /tab %}}
{{% tab title="macOS: UTM" %}}
UTM has (as of UTM 4.x, not verified) **no snapshot function** in the interface. Substitute: shut down the VM, **right-click → Clone** and name the copy `debian-lab-00-fresh-install`. To "go back" you later start the copy. This needs more storage than a snapshot; think about why.
{{% /tab %}}
{{% tab title="Windows: Hyper-V" %}}
Hyper-V calls snapshots **checkpoints**. Right-click the VM → **Checkpoint**, then rename it in the *Checkpoints* pane.
{{% /tab %}}
{{< /tabs >}}

**2. "Break" something in the VM** (**only in this practice VM!**):

```bash
sudo rm /etc/network/interfaces
ls /etc/network/interfaces
```

**Expected:** error message "No such file or directory". Without this file the VM gets no network address after the next restart.

**3. Go back:** shut down the VM (`sudo poweroff`), then

{{< tabs groupid="vm-platform" >}}
{{% tab title="VirtualBox" %}}
select the snapshot in the snapshot dialog → **Restore**.
{{% /tab %}}
{{% tab title="Linux: virt-manager" %}}
select the snapshot in the snapshot view → **Run snapshot** (arrow icon).
{{% /tab %}}
{{% tab title="macOS: UTM" %}}
delete or keep the broken VM and start the copy `debian-lab-00-fresh-install`.
{{% /tab %}}
{{% tab title="Windows: Hyper-V" %}}
right-click the checkpoint → **Apply**.
{{% /tab %}}
{{< /tabs >}}

Start the VM and check: `ls /etc/network/interfaces` shows the file again.

📸 *Screenshot: snapshot list (UTM: VM list with the copy).*

### 1.6 Clone

Shut down the VM, then:

{{< tabs groupid="vm-platform" >}}
{{% tab title="VirtualBox" %}}
**Right-click → Clone**. Name `debian-lab-clone`, **regenerate MAC addresses of all network adapters**, clone type **Full clone**.
{{% /tab %}}
{{% tab title="Linux: virt-manager" %}}
**Right-click → Clone**. Name `debian-lab-clone`. virt-manager assigns a new MAC address automatically and copies the disk.
{{% /tab %}}
{{% tab title="macOS: UTM" %}}
**Right-click → Clone**, then rename it to `debian-lab-clone`. Under *Network* create a **new MAC address** with the dice icon.
{{% /tab %}}
{{% tab title="Windows: Hyper-V" %}}
Hyper-V has no clone function; you use **Export and Import**:

1. Right-click → **Export** to a folder, e.g. `C:\VMs\export`.
2. *Action → Import Virtual Machine* → choose the exported folder → **Copy the virtual machine (create a new unique ID)**, specify your own target folders.
3. Rename the imported VM to `debian-lab-clone`. Under *Network Adapter → Advanced Features* keep **Dynamic MAC address** enabled.
{{% /tab %}}
{{< /tabs >}}

Start the clone. The hostname is still `debian-lab`: change it with

```bash
sudo hostnamectl set-hostname debian-lab-clone
sudo sed -i 's/debian-lab/debian-lab-clone/' /etc/hosts
sudo rm -f /etc/machine-id && sudo systemd-machine-id-setup
```

The second line updates the entry in `/etc/hosts` (otherwise `sudo` warns that it cannot resolve the host name). The renewed *machine ID* prevents conflicts between clones (e.g. the same DHCP address).

You may delete the clone afterwards (VirtualBox: *Remove → Delete all files*; virt-manager: *Delete* with disk; UTM: *Delete*; Hyper-V: delete the VM and remove the disk folder by hand). We continue working with the original VM.

{{< details summary="For the curious: QEMU without a front end" >}}
virt-manager and UTM are front ends for **QEMU**. Starting a VM by hand shows most clearly what a VM is: CPU, RAM, disk and network are in one command. Example on Linux with a copy of the disk from virt-manager (shut down the VM first):

```bash
sudo cp /var/lib/libvirt/images/debian-lab.qcow2 ~/ && sudo chown $USER ~/debian-lab.qcow2
cd ~
qemu-system-x86_64 -accel kvm -m 2048 -smp 2 \
  -drive file=debian-lab.qcow2,if=virtio \
  -netdev user,id=n0,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 \
  -device virtio-net,netdev=n0
```

`-netdev user` is a NAT network with the same addresses as VirtualBox (`10.0.2.15`, gateway `10.0.2.2`), `hostfwd` are the port forwardings, after which `ssh -p 2222 <user>@127.0.0.1` works. Snapshots work with `qemu-img snapshot -c <name> debian-lab.qcow2`. On macOS the acceleration is `-accel hvf`, on Windows `-accel whpx`. (Not verified, not part of the assessment.)
{{< /details >}}

## Part 2: Docker

In the VM `debian-lab`:

### 2.1 Install Docker

Follow the official instructions for Debian: [docs.docker.com/engine/install/debian](https://docs.docker.com/engine/install/debian/) (method **"apt repository"**). They change occasionally, so only the procedure is given here: add Docker's package source, then

```bash
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Optional, so that not every command needs `sudo` (caution, see [Security]({{% relref "security" %}})):

```bash
sudo usermod -aG docker $USER
# log in again so the group takes effect
```

Test:

```bash
docker --version
docker compose version
docker run --rm hello-world
```

**Expected:** Version information, and the message "Hello from Docker!".

📸 *Screenshot: output of `hello-world`.*

💾 **New snapshot:** `10-docker-installed`.

### 2.2 One container: nginx web server

```bash
docker run -d --name web -p 8080:80 nginx:stable
docker ps
curl http://localhost:8080
```

**Expected:** `docker ps` shows the running container `web`, `curl` returns the HTML text "Welcome to nginx!". The page is reachable from the host: with VirtualBox at `http://localhost:8080` (port forwarding from 1.1), otherwise at `http://<VM-IP>:8080`.

Useful commands:

```bash
docker logs web            # output of the container
docker exec -it web sh     # shell in the container (leave with exit)
docker stats --no-stream   # resource usage
docker images              # local images
```

### 2.3 Show ephemeral data

```bash
docker exec web sh -c 'echo "Hello" > /usr/share/nginx/html/test.txt'
curl http://localhost:8080/test.txt        # returns: Hello
docker rm -f web
docker run -d --name web -p 8080:80 nginx:stable
curl http://localhost:8080/test.txt        # 404: the file is gone
```

**Insight:** Data in the container disappeared with the container. Persistent data belongs in a volume (part 3).

Clean up: `docker rm -f web`.

> **Little RAM?** Stay with nginx and go to 3.4 (volumes with nginx) instead of Nextcloud.

## Part 3: Docker Compose – Nextcloud with database

Nextcloud is an open-source platform for file storage and collaboration that is frequently used at schools. We start it with a MariaDB database.

### 3.1 Project folder and Compose file

```bash
mkdir -p ~/nextcloud && cd ~/nextcloud
nano compose.yaml
```

Content (pin the major version of the images, do not use `latest`):

```yaml
services:
  db:
    image: mariadb:11
    restart: unless-stopped
    environment:
      MARIADB_DATABASE: nextcloud
      MARIADB_USER: nextcloud
      MARIADB_PASSWORD: ${DB_PASSWORD}
      MARIADB_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
    volumes:
      - db-data:/var/lib/mysql

  app:
    image: nextcloud:31-apache   # pin the major version, check current tags on Docker Hub
    restart: unless-stopped
    depends_on:
      - db
    ports:
      - "8080:80"
    environment:
      MYSQL_HOST: db
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: ${DB_PASSWORD}
      NEXTCLOUD_TRUSTED_DOMAINS: ${TRUSTED_DOMAINS}
    volumes:
      - nextcloud-data:/var/www/html

volumes:
  db-data:
  nextcloud-data:
```

Passwords are **not** in the file, but in a separate `.env` file in the same folder:

```bash
cat > .env <<'EOF'
DB_PASSWORD=<random-password-1>
DB_ROOT_PASSWORD=<random-password-2>
TRUSTED_DOMAINS="localhost <VM-IP>"
EOF
chmod 600 .env
```

Generate the passwords e.g. with `openssl rand -base64 24`. `TRUSTED_DOMAINS` lists the addresses under which Nextcloud may be accessed: with VirtualBox `localhost` is enough, otherwise also enter the VM's IP address. **The `.env` file never goes into the Git repository.**

### 3.2 Start

```bash
docker compose up -d
docker compose ps
docker compose logs -f app      # end with Ctrl+C
```

**Expected:** Both services `running`. After about a minute Nextcloud is reachable in the host's browser (VirtualBox: `http://localhost:8080`, otherwise `http://<VM-IP>:8080`). On the first visit you create an administrator account (data: *Nextcloud admin*, strong password).

📸 *Screenshot: `docker compose ps` and the Nextcloud login page (without passwords!).*

💾 **New snapshot:** `20-nextcloud-running`.

### 3.3 Back up and restore data

Volumes can be backed up with a helper container:

```bash
docker compose stop
mkdir -p ~/backup
docker run --rm -v nextcloud_nextcloud-data:/data -v ~/backup:/backup alpine \
  tar czf /backup/nextcloud-data.tar.gz -C /data .
docker run --rm -v nextcloud_db-data:/data -v ~/backup:/backup alpine \
  tar czf /backup/db-data.tar.gz -C /data .
ls -lh ~/backup
docker compose start
```

> The volume name consists of the project name (here the folder name `nextcloud`) and the name in the Compose file. `docker volume ls` shows the actual names. Check them before you run the command.

**Restore test (important!):** A backup is only a backup once the restore works.

```bash
docker compose down -v          # deletes containers AND volumes (caution!)
docker compose up -d --no-start # recreate volumes, do not start the services
docker run --rm -v nextcloud_nextcloud-data:/data -v ~/backup:/backup alpine \
  tar xzf /backup/nextcloud-data.tar.gz -C /data
docker run --rm -v nextcloud_db-data:/data -v ~/backup:/backup alpine \
  tar xzf /backup/db-data.tar.gz -C /data
docker compose start
```

**Expected:** Nextcloud is back, the administrator account still exists.

> **Note:** A *file-copy backup of a running database* is risky. That is why the services are stopped first. In operation, database dumps (`mariadb-dump`) are used. The topic is deepened in session 4.

### 3.4 Variant for little RAM: nginx with volume

```bash
mkdir -p ~/web && cd ~/web
cat > compose.yaml <<'EOF'
services:
  web:
    image: nginx:stable
    ports:
      - "8080:80"
    volumes:
      - web-content:/usr/share/nginx/html
volumes:
  web-content:
EOF
docker compose up -d
docker compose exec web sh -c 'echo "Hello school" > /usr/share/nginx/html/index.html'
docker compose down        # container gone, volume stays
docker compose up -d
curl http://localhost:8080 # returns: Hello school
```

### 3.5 Clean up

```bash
docker compose down          # remove containers, volumes stay
docker system df             # space used by images, containers, volumes
```

## Expected results (checklist)

- [ ] VM `debian-lab` runs and is reachable via SSH.
- [ ] Snapshot list shows at least `00-fresh-install`, `10-docker-installed`, `20-nextcloud-running` (UTM: corresponding copies).
- [ ] `docker run hello-world` successful.
- [ ] Nextcloud (or the nginx variant) reachable in the host's browser.
- [ ] Backup archives exist **and** restore tested.
- [ ] No passwords or `.env` file in the portfolio repository.

## Troubleshooting

| Problem | Cause and solution |
|---|---|
| VM does not start: "VT-x is not available" | Enable virtualization in the BIOS, check Hyper-V/WSL2 if applicable. |
| Hyper-V: VM does not boot from the ISO, message about *Secure Boot* | Set the Secure Boot template to **Microsoft UEFI Certificate Authority** (1.1, step 3). |
| virt-manager: "KVM is not available" or no connection to libvirt | Check `ls /dev/kvm`, user in group `libvirt`, log in again, `sudo systemctl enable --now libvirtd`. |
| `<user> is not in the sudoers file` | A root password was set during installation. Log in as root with `su -`, run `usermod -aG sudo <user>`, log in again. |
| No Internet in the VM | Network set as in 1.1 (NAT, *default*, *Shared Network*, *Default Switch*)? Restart the VM, check `ip -br addr`, `ping 1.1.1.1`, `ping debian.org` (separates routing and DNS). |
| SSH: "Connection refused" | Is `ssh` running in the VM (`systemctl status ssh`)? If the service does not exist: `sudo apt install openssh-server`. VirtualBox: port forwarding 2222→22 set? Otherwise: correct `<VM-IP>`? |
| `docker: permission denied` | Run with `sudo` or add the user to the `docker` group and log in again. |
| Port 8080 in use | Choose another port (`-p 8081:80`) and, with VirtualBox, adjust the port forwarding. |
| Nextcloud: "Trusted domain" error | The address you used is missing from `TRUSTED_DOMAINS`. The variable only applies at the first installation; afterwards `docker compose exec -u www-data app php occ config:system:set trusted_domains 1 --value=<VM-IP>`. |
| Little free storage | `docker system prune` cleans up unused containers and images (**caution, it deletes!**). |
