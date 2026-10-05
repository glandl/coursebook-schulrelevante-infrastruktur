+++
title = "Guided lab"
weight = 30
+++

{{% callout style="warning" title="Status: untested" %}}
The commands and settings in this lab have **not yet** been run in the course environment. Software information as of October 2026. Check versions before use. *Tested on: open.*
{{% /callout %}}

## Overview

| Part | Content | Duration |
|---|---|---|
| 0 | Preparation and hardware check | 15 min |
| 1 | Ubuntu Server VM in VirtualBox, snapshots, clone | 60 min |
| 2 | Install Docker and first containers | 25 min |
| 3 | Docker Compose: Nextcloud with database, volumes, backup | 35 min |

**Minimum hardware:** 8 GB RAM (of which 2 GB for the VM), 30 GB free storage, 64-bit CPU with virtualization enabled.

**Software used:**

| Software | Version | Note |
|---|---|---|
| VirtualBox | 7.x | [virtualbox.org](https://www.virtualbox.org) |
| Ubuntu Server | 24.04 LTS | [ubuntu.com/download/server](https://ubuntu.com/download/server) |
| Docker Engine + Compose plugin | current stable version | [docs.docker.com/engine/install/ubuntu](https://docs.docker.com/engine/install/ubuntu/) |
| Nextcloud (image) | `nextcloud:<major version>-apache` (e.g. `31-apache`) | [hub.docker.com/_/nextcloud](https://hub.docker.com/_/nextcloud) |
| MariaDB (image) | `mariadb:11` | [hub.docker.com/_/mariadb](https://hub.docker.com/_/mariadb) |

## Part 0: Preparation

### Check virtualization

- **Windows:** Task Manager → Performance → CPU → "Virtualization: Enabled". If "Disabled": enable *Intel VT-x* or *AMD-V (SVM)* in the BIOS/UEFI.
- **macOS (Intel):** Usually enabled.
- **Linux:** `lscpu | grep -i virtualization`

### Special cases and fallbacks

| Situation | Solution |
|---|---|
| **Windows Home / Hyper-V or WSL2 active** | VirtualBox then runs on the Windows Hypervisor Platform, somewhat slower. It works, just mind the performance. |
| **Apple Silicon (M1–M4)** | VirtualBox only supports Apple Silicon to a limited extent. Use **UTM** ([mac.getutm.app](https://mac.getutm.app)) with **Ubuntu Server for ARM64**. The steps from part 1 on are equivalent. |
| **Less than 8 GB RAM** | VM with 1 GB RAM, replace part 3 (Nextcloud) with a lighter service (nginx), see the note in part 2. |
| **Device locked, no installation allowed** | Own laptop or cloud alternative: Ubuntu VM at [killercoda.com](https://killercoda.com) or GitHub Codespaces with Docker (parts 2 and 3 possible, part 1 is skipped). |

### Create the folder in the portfolio

You record your results from the start (see [Documentation task]({{% relref "documentation" %}})):

```bash
cd <your-portfolio>
git switch -c session-01
mkdir -p 01-virtualization-containerization/assets
```

## Part 1: Ubuntu Server VM

### 1.1 Create the VM

1. Start VirtualBox → **New**.
2. Name: `ubuntu-lab`, ISO image: the downloaded Ubuntu Server ISO, enable **"Skip unattended installation"** (so you can see the installation once).
3. Hardware: **2 CPU cores**, **2048 MB RAM**. Hard disk: **20 GB**, dynamically allocated (VDI).
4. Under *Settings → Network* keep **NAT**. For SSH access from the host, set up a **port forwarding**: *Advanced → Port forwarding* → name `ssh`, protocol TCP, host port `2222`, guest port `22`. Additionally: host port `8080` → guest port `8080` (for part 3).

📸 *Screenshot: VM summary (name, RAM, CPU, disk, network).*

### 1.2 Install Ubuntu

Start the VM and choose in the installer:

- Language/keyboard: as you like (`English (US)` or `German`).
- Installation type: **Ubuntu Server** (not "minimized").
- Network: automatic (DHCP).
- Storage: entire disk, default suggestion.
- Profile: server name `ubuntu-lab`, choose a user name (e.g. `admin`), **strong password**.
- **Install OpenSSH server: yes**.
- Additional snaps: **none**.

After the installation: have the ISO removed, restart, log in.

### 1.3 First steps in Linux

```bash
whoami            # user name
hostnamectl       # hostname, operating system, kernel
ip -br addr       # network interfaces (brief)
df -h /           # disk usage
free -h           # memory
```

Update the system:

```bash
sudo apt update
sudo apt upgrade -y
```

**Expected:** `apt update` lists package sources without errors, `apt upgrade` installs updates if any.

📸 *Screenshot: `hostnamectl` and `ip -br addr`.*

### 1.4 SSH access from the host

On the **host** (not in the VM):

```bash
ssh -p 2222 <user>@127.0.0.1
```

On the first connection you confirm the fingerprint with `yes`. **Expected:** You are logged in on the server.

> **Note:** SSH through the port forwarding is only reachable from the host, not from other computers in the network.

> **Hint – SSH not possible?** On some machines the OpenSSH server was not installed during setup (the installer option "Install OpenSSH server" was not selected). Install it inside the VM (console of the VM window):
>
> ```bash
> sudo apt update
> sudo apt install openssh-server
> sudo systemctl enable --now ssh
> systemctl status ssh
> ```
>
> **Expected:** `status` shows `active (running)`. Then repeat the `ssh` command on the host.

### 1.5 Create a snapshot and go back

1. VM manager → select the VM → **Snapshots** → **Take**. Name: `00-fresh-install`, description: "After installation and updates".
2. "Break" something in the VM (**only in this practice VM!**):

   ```bash
   sudo rm -rf /etc/netplan
   ls /etc/netplan
   ```

   **Expected:** Error message "No such file or directory".
3. Shut down the VM (`sudo poweroff`), **Restore** in the snapshot dialog, start the VM and check: `ls /etc/netplan` shows the files again.

📸 *Screenshot: snapshot list.*

### 1.6 Cloning

1. Shut down the VM.
2. **Right-click → Clone**. Name `ubuntu-lab-clone`, **regenerate MAC addresses of all network adapters**, clone type **Full clone**.
3. Start the clone. The hostname is still `ubuntu-lab`: change it with

   ```bash
   sudo hostnamectl set-hostname ubuntu-lab-clone
   sudo rm -f /etc/machine-id && sudo systemd-machine-id-setup
   ```

The renewed *machine ID* prevents conflicts between clones (e.g. the same DHCP address).

You may delete the clone afterwards (*Remove → Delete all files*), we continue with the original VM.

## Part 2: Docker

In the VM `ubuntu-lab`:

### 2.1 Install Docker

Follow the official instructions for Ubuntu: [docs.docker.com/engine/install/ubuntu](https://docs.docker.com/engine/install/ubuntu/) (method **"apt repository"**). They change occasionally, so only the procedure is given here: add Docker's package source, then

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

**Expected:** `docker ps` shows the running container `web`, `curl` returns the HTML text "Welcome to nginx!". From the host the page is reachable at `http://localhost:8080` (port forwarding from 1.1).

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
EOF
chmod 600 .env
```

Generate the passwords e.g. with `openssl rand -base64 24`. **The `.env` file never goes into the Git repository.**

### 3.2 Start

```bash
docker compose up -d
docker compose ps
docker compose logs -f app      # end with Ctrl+C
```

**Expected:** Both services `running`. After about a minute Nextcloud is reachable at `http://localhost:8080` in the host's browser. On the first visit you create an administrator account (data: *Nextcloud admin*, strong password).

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

- [ ] VM `ubuntu-lab` runs and is reachable via SSH.
- [ ] Snapshot list shows at least `00-fresh-install`, `10-docker-installed`, `20-nextcloud-running`.
- [ ] `docker run hello-world` successful.
- [ ] Nextcloud (or the nginx variant) reachable in the host's browser.
- [ ] Backup archives exist **and** restore tested.
- [ ] No passwords or `.env` file in the portfolio repository.

## Troubleshooting

| Problem | Cause and solution |
|---|---|
| VM does not start: "VT-x is not available" | Enable virtualization in the BIOS, check Hyper-V/WSL2 if applicable. |
| No Internet in the VM | Network mode **NAT**? Restart the VM, check `ip -br addr`, `ping 1.1.1.1`, `ping ubuntu.com` (separates routing and DNS). |
| SSH: "Connection refused" | Is `ssh` running in the VM (`systemctl status ssh`)? If the service does not exist: `sudo apt install openssh-server`. Port forwarding 2222→22 set? |
| `docker: permission denied` | Run with `sudo` or add the user to the `docker` group and log in again. |
| Port 8080 in use | Choose another host port (`-p 8081:80`) and adjust the port forwarding. |
| Nextcloud: "Trusted domain" error | Access via `http://localhost:8080`. For another address set `NEXTCLOUD_TRUSTED_DOMAINS`. |
| Little free storage | `docker system prune` cleans up unused containers and images (**caution, it deletes!**). |
