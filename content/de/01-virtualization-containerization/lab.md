+++
title = "Praxis-Lab"
weight = 30
+++

{{% callout style="warning" title="Status: ungeprüft" %}}
Die Befehle und Einstellungen in diesem Lab wurden noch **nicht** in der Kursumgebung ausgeführt. Stand der Software-Angaben: Oktober 2026. Prüfe Versionen vor dem Einsatz. *Getestet am: offen.*
{{% /callout %}}

## Überblick

| Teil | Inhalt | Dauer |
|---|---|---|
| 0 | Vorbereitung und Hardware-Check | 15 min |
| 1 | Ubuntu-Server-VM in VirtualBox, Snapshots, Klon | 60 min |
| 2 | Docker installieren und erste Container | 25 min |
| 3 | Docker Compose: Nextcloud mit Datenbank, Volumes, Backup | 35 min |

**Mindestausstattung:** 8 GB RAM (davon 2 GB für die VM), 30 GB freier Speicher, 64-Bit-CPU mit aktivierter Virtualisierung.

**Verwendete Software:**

| Software | Version | Hinweis |
|---|---|---|
| VirtualBox | 7.x | [virtualbox.org](https://www.virtualbox.org) |
| Ubuntu Server | 24.04 LTS | [ubuntu.com/download/server](https://ubuntu.com/download/server) |
| Docker Engine + Compose-Plugin | aktuelle stabile Version | [docs.docker.com/engine/install/ubuntu](https://docs.docker.com/engine/install/ubuntu/) |
| Nextcloud (Image) | `nextcloud:<Hauptversion>-apache` (z. B. `31-apache`) | [hub.docker.com/_/nextcloud](https://hub.docker.com/_/nextcloud) |
| MariaDB (Image) | `mariadb:11` | [hub.docker.com/_/mariadb](https://hub.docker.com/_/mariadb) |

## Teil 0: Vorbereitung

### Virtualisierung prüfen

- **Windows:** Task-Manager → Leistung → CPU → „Virtualisierung: Aktiviert“. Falls „Deaktiviert“: im BIOS/UEFI *Intel VT-x* bzw. *AMD-V (SVM)* einschalten.
- **macOS (Intel):** In der Regel aktiv.
- **Linux:** `lscpu | grep -i virtualization`

### Besonderheiten und Ausweichlösungen

| Situation | Lösung |
|---|---|
| **Windows Home / Hyper-V oder WSL2 aktiv** | VirtualBox läuft dann über die Windows-Hypervisor-Plattform, etwas langsamer. Funktioniert, nur Leistung beachten. |
| **Apple Silicon (M1–M4)** | VirtualBox unterstützt Apple Silicon nur eingeschränkt. Nutze **UTM** ([mac.getutm.app](https://mac.getutm.app)) mit **Ubuntu Server für ARM64**. Die Schritte ab Teil 1 sind sinngemäß gleich. |
| **Weniger als 8 GB RAM** | VM mit 1 GB RAM, Teil 3 (Nextcloud) in Teil 2 mit leichterem Dienst ersetzen (nginx), siehe Hinweis dort. |
| **Gerät gesperrt, keine Installation erlaubt** | Eigener Tag-Laptop oder Cloud-Alternative: Ubuntu VM bei [killercoda.com](https://killercoda.com) bzw. GitHub Codespaces mit Docker (Teil 2 und 3 möglich, Teil 1 entfällt). |

### Ordner im Portfolio anlegen

Du hältst deine Ergebnisse von Beginn an fest (siehe [Dokumentationsaufgabe]({{% relref "documentation" %}})):

```bash
cd <dein-portfolio>
git switch -c einheit-01
mkdir -p 01-virtualization-containerization/assets
```

## Teil 1: Ubuntu-Server-VM

### 1.1 VM anlegen

1. VirtualBox starten → **Neu**.
2. Name: `ubuntu-lab`, ISO-Image: heruntergeladene Ubuntu-Server-ISO, **„Unbeaufsichtigte Installation überspringen“** aktivieren (damit du die Installation einmal sehen kannst).
3. Hardware: **2 CPU-Kerne**, **2048 MB RAM**. Festplatte: **20 GB**, dynamisch alloziert (VDI).
4. Unter *Einstellungen → Netzwerk* bleibt **NAT**. Für den Zugriff per SSH vom Host richtest du eine **Portweiterleitung** ein: *Erweitert → Portweiterleitung* → Name `ssh`, Protokoll TCP, Host-Port `2222`, Gast-Port `22`. Zusätzlich: Host-Port `8080` → Gast-Port `8080` (für Teil 3).

📸 *Screenshot: VM-Zusammenfassung (Name, RAM, CPU, Disk, Netzwerk).*

### 1.2 Ubuntu installieren

Starte die VM und wähle im Installer:

- Sprache/Tastatur: nach Wunsch (`Deutsch (Österreich)` bzw. `German`).
- Installationsart: **Ubuntu Server** (nicht „minimized“).
- Netzwerk: automatisch (DHCP).
- Speicher: gesamter Datenträger, Standardvorschlag.
- Profil: Server-Name `ubuntu-lab`, Benutzername frei wählen (z. B. `admin`), **starkes Passwort**.
- **OpenSSH-Server installieren: ja**.
- Zusätzliche Snaps: **keine**.

Nach der Installation: ISO entfernen lassen, neu starten, anmelden.

### 1.3 Erste Schritte in Linux

```bash
whoami            # Benutzername
hostnamectl       # Hostname, Betriebssystem, Kernel
ip -br addr       # Netzwerkschnittstellen (kurz)
df -h /           # Festplattenbelegung
free -h           # Arbeitsspeicher
```

System aktualisieren:

```bash
sudo apt update
sudo apt upgrade -y
```

**Erwartet:** `apt update` listet Paketquellen ohne Fehler, `apt upgrade` installiert ggf. Updates.

📸 *Screenshot: `hostnamectl` und `ip -br addr`.*

### 1.4 Zugriff per SSH vom Host

Auf dem **Host** (nicht in der VM):

```bash
ssh -p 2222 <benutzer>@127.0.0.1
```

Beim ersten Verbinden bestätigst du den Fingerabdruck mit `yes`. **Erwartet:** Du bist auf dem Server angemeldet.

> **Hinweis:** SSH über die Portweiterleitung ist nur vom Host aus erreichbar, nicht von anderen Rechnern im Netz.

### 1.5 Snapshot erstellen und zurückkehren

1. VM-Manager → VM wählen → **Snapshots** → **Aufnehmen**. Name: `00-frisch-installiert`, Beschreibung: „Nach Installation und Updates“.
2. In der VM etwas „kaputtmachen“ (**nur in dieser Übungs-VM!**):

   ```bash
   sudo rm -rf /etc/netplan
   ls /etc/netplan
   ```

   **Erwartet:** Fehlermeldung „No such file or directory“.
3. VM ausschalten (`sudo poweroff`), im Snapshot-Dialog **Wiederherstellen**, VM starten und prüfen: `ls /etc/netplan` zeigt die Dateien wieder.

📸 *Screenshot: Snapshot-Liste.*

### 1.6 Klonen

1. VM herunterfahren.
2. **Rechtsklick → Klonen**. Name `ubuntu-lab-klon`, **MAC-Adressen für alle Netzwerkadapter neu generieren**, Klontyp **Vollständiger Klon**.
3. Klon starten. Der Hostname lautet noch `ubuntu-lab`: ändern mit

   ```bash
   sudo hostnamectl set-hostname ubuntu-lab-klon
   sudo rm -f /etc/machine-id && sudo systemd-machine-id-setup
   ```

Die erneuerte *Machine-ID* verhindert Konflikte zwischen Klonen (z. B. gleiche DHCP-Adresse).

Den Klon darfst du danach löschen (*Entfernen → Alle Dateien löschen*), wir arbeiten mit der ursprünglichen VM weiter.

## Teil 2: Docker

In der VM `ubuntu-lab`:

### 2.1 Docker installieren

Folge der offiziellen Anleitung für Ubuntu: [docs.docker.com/engine/install/ubuntu](https://docs.docker.com/engine/install/ubuntu/) (Methode **„apt repository“**). Sie ändert sich gelegentlich, daher hier nur der Ablauf: Paketquelle von Docker hinzufügen, dann

```bash
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Optional, damit nicht jeder Befehl `sudo` braucht (Achtung, siehe [Sicherheit]({{% relref "security" %}})):

```bash
sudo usermod -aG docker $USER
# neu anmelden, damit die Gruppe gilt
```

Test:

```bash
docker --version
docker compose version
docker run --rm hello-world
```

**Erwartet:** Versionsangaben, und die Meldung „Hello from Docker!“.

📸 *Screenshot: Ausgabe von `hello-world`.*

💾 **Neuer Snapshot:** `10-docker-installiert`.

### 2.2 Ein Container: Webserver nginx

```bash
docker run -d --name web -p 8080:80 nginx:stable
docker ps
curl http://localhost:8080
```

**Erwartet:** `docker ps` zeigt den laufenden Container `web`, `curl` liefert den HTML-Text „Welcome to nginx!“. Vom Host aus ist die Seite unter `http://localhost:8080` erreichbar (Portweiterleitung aus 1.1).

Nützliche Befehle:

```bash
docker logs web            # Ausgabe des Containers
docker exec -it web sh     # Shell im Container (mit exit verlassen)
docker stats --no-stream   # Ressourcenverbrauch
docker images              # lokale Images
```

### 2.3 Flüchtige Daten zeigen

```bash
docker exec web sh -c 'echo "Hallo" > /usr/share/nginx/html/test.txt'
curl http://localhost:8080/test.txt        # liefert: Hallo
docker rm -f web
docker run -d --name web -p 8080:80 nginx:stable
curl http://localhost:8080/test.txt        # 404: Datei ist weg
```

**Erkenntnis:** Daten im Container sind mit dem Container verschwunden. Persistente Daten gehören in ein Volume (Teil 3).

Aufräumen: `docker rm -f web`.

> **Wenig RAM?** Bleibe bei nginx und gehe zu 3.4 (Volumes mit nginx) statt Nextcloud.

## Teil 3: Docker Compose – Nextcloud mit Datenbank

Nextcloud ist eine Open-Source-Plattform für Dateiablage und Zusammenarbeit, die an Schulen häufig eingesetzt wird. Wir starten sie mit einer MariaDB-Datenbank.

### 3.1 Projektordner und Compose-Datei

```bash
mkdir -p ~/nextcloud && cd ~/nextcloud
nano compose.yaml
```

Inhalt (Hauptversion der Images fixieren, nicht `latest` verwenden):

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
    image: nextcloud:31-apache   # Hauptversion fixieren, aktuelle Tags auf Docker Hub prüfen
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

Passwörter stehen **nicht** in der Datei, sondern in einer separaten `.env`-Datei im selben Ordner:

```bash
cat > .env <<'EOF'
DB_PASSWORD=<zufälliges-passwort-1>
DB_ROOT_PASSWORD=<zufälliges-passwort-2>
EOF
chmod 600 .env
```

Erzeuge die Passwörter z. B. mit `openssl rand -base64 24`. **Die `.env`-Datei kommt niemals ins Git-Repository.**

### 3.2 Starten

```bash
docker compose up -d
docker compose ps
docker compose logs -f app      # mit Strg+C beenden
```

**Erwartet:** Beide Dienste `running`. Nach etwa einer Minute ist Nextcloud unter `http://localhost:8080` im Browser des Hosts erreichbar. Beim ersten Aufruf legst du ein Administratorkonto an (Daten: *Nextcloud-Admin*, starkes Passwort).

📸 *Screenshot: `docker compose ps` und Anmeldeseite von Nextcloud (ohne Passwörter!).*

💾 **Neuer Snapshot:** `20-nextcloud-laeuft`.

### 3.3 Daten sichern und wiederherstellen

Volumes lassen sich über einen Hilfscontainer sichern:

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

> Der Volume-Name besteht aus dem Projektnamen (hier Ordnername `nextcloud`) und dem Namen im Compose-File. `docker volume ls` zeigt die tatsächlichen Namen. Prüfe sie, bevor du den Befehl ausführst.

**Restore-Test (wichtig!):** Ein Backup ist erst dann ein Backup, wenn die Wiederherstellung funktioniert.

```bash
docker compose down -v          # löscht Container UND Volumes (Achtung!)
docker compose up -d --no-start # Volumes neu anlegen, Dienste nicht starten
docker run --rm -v nextcloud_nextcloud-data:/data -v ~/backup:/backup alpine \
  tar xzf /backup/nextcloud-data.tar.gz -C /data
docker run --rm -v nextcloud_db-data:/data -v ~/backup:/backup alpine \
  tar xzf /backup/db-data.tar.gz -C /data
docker compose start
```

**Erwartet:** Nextcloud ist wieder da, das Administratorkonto existiert noch.

> **Hinweis:** Ein *Dateikopie-Backup einer laufenden Datenbank* ist riskant. Deshalb wird hier vorher gestoppt. Im Betrieb nutzt man Datenbank-Dumps (`mariadb-dump`). Das Thema wird in Einheit 4 vertieft.

### 3.4 Variante für wenig RAM: nginx mit Volume

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
docker compose exec web sh -c 'echo "Hallo Schule" > /usr/share/nginx/html/index.html'
docker compose down        # Container weg, Volume bleibt
docker compose up -d
curl http://localhost:8080 # liefert: Hallo Schule
```

### 3.5 Aufräumen

```bash
docker compose down          # Container entfernen, Volumes bleiben
docker system df             # Platzverbrauch von Images, Containern, Volumes
```

## Erwartete Ergebnisse (Checkliste)

- [ ] VM `ubuntu-lab` läuft und ist per SSH erreichbar.
- [ ] Snapshot-Liste zeigt mindestens `00-frisch-installiert`, `10-docker-installiert`, `20-nextcloud-laeuft`.
- [ ] `docker run hello-world` erfolgreich.
- [ ] Nextcloud (oder nginx-Variante) im Browser des Hosts erreichbar.
- [ ] Backup-Archive vorhanden **und** Restore getestet.
- [ ] Keine Passwörter oder `.env`-Datei im Portfolio-Repository.

## Fehlersuche

| Problem | Ursache und Lösung |
|---|---|
| VM startet nicht: „VT-x is not available“ | Virtualisierung im BIOS aktivieren, ggf. Hyper-V/WSL2 prüfen. |
| Kein Internet in der VM | Netzwerkmodus **NAT**? Neustart der VM, `ip -br addr` prüfen, `ping 1.1.1.1`, `ping ubuntu.com` (trennt Routing und DNS). |
| SSH: „Connection refused“ | Läuft `ssh` in der VM (`systemctl status ssh`)? Portweiterleitung 2222→22 gesetzt? |
| `docker: permission denied` | Mit `sudo` ausführen oder Benutzer zur Gruppe `docker` hinzufügen und neu anmelden. |
| Port 8080 belegt | Anderen Host-Port wählen (`-p 8081:80`) und Portweiterleitung anpassen. |
| Nextcloud: „Trusted domain“-Fehler | Aufruf über `http://localhost:8080`. Bei anderer Adresse `NEXTCLOUD_TRUSTED_DOMAINS` setzen. |
| Wenig freier Speicher | `docker system prune` räumt ungenutzte Container und Images auf (**Vorsicht, löscht!**). |
