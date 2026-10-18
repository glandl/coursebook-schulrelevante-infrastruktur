+++
title = "Praxis-Lab"
weight = 30
+++

{{% callout style="warning" title="Status: ungeprüft" %}}
Die Befehle und Einstellungen in diesem Lab wurden noch **nicht** in der Kursumgebung ausgeführt. Das gilt besonders für den Debian-Installer und die Varianten virt-manager, UTM und Hyper-V (Menünamen, Snapshots, Klonen). Stand der Software-Angaben: Oktober 2026. Prüfe Versionen vor dem Einsatz. *Getestet am: offen.*
{{% /callout %}}

## Überblick

| Teil | Inhalt | Dauer |
|---|---|---|
| 0 | Vorbereitung und Hardware-Check | 15 min |
| 1 | Debian-VM anlegen, Snapshots, Klon | 60 min |
| 2 | Docker installieren und erste Container | 25 min |
| 3 | Docker Compose: Nextcloud mit Datenbank, Volumes, Backup | 35 min |

**Mindestausstattung:** 8 GB RAM (davon 2 GB für die VM), 30 GB freier Speicher, 64-Bit-CPU mit aktivierter Virtualisierung. Debian ohne Desktop braucht im Leerlauf nur etwa 150 MB RAM; auf schwachen Geräten reicht für Teil 1 und 2 auch 1 GB.

**Verwendete Software:**

| Software | Version | Hinweis |
|---|---|---|
| Debian GNU/Linux | 13 „trixie“, DVD-Image `DVD-1` (`amd64`, auf Apple Silicon `arm64`), ca. 4 GB | [debian.org/CD/http-ftp](https://www.debian.org/CD/http-ftp/) |
| Virtualisierung | eine der vier Varianten unten | |
| Docker Engine + Compose-Plugin | aktuelle stabile Version | [docs.docker.com/engine/install/debian](https://docs.docker.com/engine/install/debian/) |
| Nextcloud (Image) | `nextcloud:<Hauptversion>-apache` (z. B. `31-apache`) | [hub.docker.com/_/nextcloud](https://hub.docker.com/_/nextcloud) |
| MariaDB (Image) | `mariadb:11` | [hub.docker.com/_/mariadb](https://hub.docker.com/_/mariadb) |

### Welche Virtualisierung?

Wähle **eine** Variante passend zu deinem Gerät. Die Anleitung zeigt die Unterschiede in Registerkarten; deine Auswahl gilt für alle Registerkarten im Kurs.

| Dein Gerät | Variante | Warum |
|---|---|---|
| Windows Home, Intel-Mac, Linux ohne Erfahrung | **VirtualBox** 7.x ([virtualbox.org](https://www.virtualbox.org)) | gleiche Oberfläche auf allen Systemen |
| Linux | **virt-manager** mit QEMU/KVM (Paket der Distribution) | eingebauter Hypervisor des Linux-Kernels, schneller als VirtualBox |
| Mac mit Apple Silicon (M1–M4) | **UTM** ([mac.getutm.app](https://mac.getutm.app)), nutzt QEMU | VirtualBox unterstützt Apple Silicon nur eingeschränkt |
| Windows Pro/Education mit **WSL2 oder Hyper-V aktiv** | **Hyper-V-Manager** (in Windows enthalten) | VirtualBox läuft neben Hyper-V nur stark gebremst |

VirtualBox, UTM und virt-manager sind **Typ-2-Oberflächen** auf dem Laptop; KVM und Hyper-V sind Hypervisoren, die im Betriebssystem stecken (siehe [Theorie]({{% relref "theory" %}})).

## Teil 0: Vorbereitung

Downloads und Installationen sollten vorab erledigt sein, siehe [Vorbereitungs-Checkliste]({{% relref "/preparation" %}}).

### Virtualisierung prüfen

- **Windows:** Task-Manager → Leistung → CPU → „Virtualisierung: Aktiviert“. Falls „Deaktiviert“: im BIOS/UEFI *Intel VT-x* bzw. *AMD-V (SVM)* einschalten.
- **macOS:** In der Regel aktiv.
- **Linux:** `lscpu | grep -i virtualization`; für virt-manager zusätzlich `ls /dev/kvm` (die Datei muss existieren).

### Besonderheiten und Ausweichlösungen

| Situation | Lösung |
|---|---|
| **Windows Home mit WSL2 aktiv** | Hyper-V-Manager gibt es in Windows Home nicht. VirtualBox läuft dann über die Windows-Hypervisor-Plattform, langsamer. Funktioniert, VM mit 1 GB RAM betreiben. |
| **Weniger als 8 GB RAM** | VM mit 1 GB RAM, Teil 3 (Nextcloud) durch die leichtere nginx-Variante ersetzen (3.4). |
| **Gerät gesperrt, keine Installation erlaubt** | Eigener Laptop am Kurstag oder Cloud-Alternative: Linux-Umgebung bei [killercoda.com](https://killercoda.com) bzw. GitHub Codespaces mit Docker (Teil 2 und 3 möglich, Teil 1 entfällt). |

### Ordner im Portfolio anlegen

Du hältst deine Ergebnisse von Beginn an fest (siehe [Dokumentationsaufgabe]({{% relref "documentation" %}})):

```bash
cd <dein-portfolio>
git switch -c einheit-01
mkdir -p 01-virtualization-containerization/assets
```

## Teil 1: Debian-VM

### 1.1 VM anlegen

{{< tabs groupid="vm-platform" >}}
{{% tab title="VirtualBox" %}}
1. VirtualBox starten → **Neu**.
2. Name: `debian-lab`, ISO-Image: das Debian-DVD-Image, **„Unbeaufsichtigte Installation überspringen“** aktivieren (damit du die Installation einmal siehst).
3. Hardware: **2 CPU-Kerne**, **2048 MB RAM**. Festplatte: **20 GB**, dynamisch alloziert (VDI).
4. Unter *Einstellungen → Netzwerk* bleibt **NAT**. Für den Zugriff vom Host richtest du **Portweiterleitungen** ein: *Erweitert → Portweiterleitung* → Name `ssh`, Protokoll TCP, Host-Port `2222`, Gast-Port `22`. Zusätzlich: Host-Port `8080` → Gast-Port `8080` (für Teil 2 und 3).
{{% /tab %}}
{{% tab title="Linux: virt-manager" %}}
Einmalig installieren (Debian/Ubuntu): `sudo apt install virt-manager`, dann deinen Benutzer zur Gruppe `libvirt` hinzufügen (`sudo usermod -aG libvirt $USER`) und neu anmelden.

1. virt-manager starten → **Neue virtuelle Maschine** → *Lokales Installationsmedium* → das Debian-DVD-Image wählen. Das Betriebssystem wird meist erkannt, sonst *Debian 13* eintragen.
2. **2048 MB RAM**, **2 CPUs**, Festplatte **20 GB** (Format qcow2, Standard).
3. Name: `debian-lab`, Netzwerk: **Virtuelles Netzwerk „default“: NAT** (Standard).

Das Netz `default` ist ein NAT-Netz `192.168.122.0/24`. Anders als bei VirtualBox erreicht der Host die VM **direkt über ihre IP-Adresse**, eine Portweiterleitung ist nicht nötig.
{{% /tab %}}
{{% tab title="macOS: UTM" %}}
1. UTM starten → **+** → **Virtualize** (nicht *Emulate*) → **Linux**.
2. *Boot ISO Image*: das Debian-DVD-Image für **arm64**.
3. **2048 MB RAM**, **2 CPU-Kerne**, Festplatte **20 GB**.
4. Name: `debian-lab`. Netzwerk: **Shared Network** (Standard).

Im *Shared Network* bekommt die VM eine Adresse aus `192.168.64.0/24`. Der Mac erreicht die VM **direkt über ihre IP-Adresse**, eine Portweiterleitung ist nicht nötig.
{{% /tab %}}
{{% tab title="Windows: Hyper-V" %}}
Einmalig aktivieren: *Windows-Features aktivieren oder deaktivieren* → **Hyper-V** → Neustart. Nur in Windows Pro, Education und Enterprise.

1. Hyper-V-Manager → **Neu → Virtueller Computer**.
2. Name: `debian-lab`, **Generation 2**, **2048 MB** Arbeitsspeicher (dynamischen Arbeitsspeicher abschalten), Netzwerk: **Default Switch**, Festplatte **20 GB**, Installationsmedium: das Debian-DVD-Image (`amd64`).
3. **Vor dem ersten Start:** *Einstellungen → Sicherheit* → Vorlage für sicheren Start auf **Microsoft UEFI-Zertifizierungsstelle** umstellen. Mit der Standardvorlage „Microsoft Windows“ startet Debian nicht.
4. *Einstellungen → Prozessor*: **2** virtuelle Prozessoren.

Der *Default Switch* ist ein NAT-Netz mit Adressen aus `172.x.x.x`. Der Host erreicht die VM **direkt über ihre IP-Adresse**. Achtung: Das Netz und damit die Adresse kann sich nach einem Neustart von Windows ändern.
{{% /tab %}}
{{< /tabs >}}

📸 *Screenshot: VM-Zusammenfassung (Name, RAM, CPU, Disk, Netzwerk).*

### 1.2 Debian installieren

Starte die VM und wähle im Startmenü **Install** (die Textvariante ist schneller als *Graphical install*, beide funktionieren). Das DVD-Image enthält alle Pakete, die du brauchst: Die Installation läuft **ohne Internet** und dauert etwa 5–10 Minuten. So bremsen sich die Laptops im gemeinsamen WLAN nicht gegenseitig aus.

| Schritt | Auswahl |
|---|---|
| Sprache, Standort, Tastatur | nach Wunsch (z. B. *German*, *Österreich*, *Deutsch*) |
| Rechnername | `debian-lab`, Domain leer lassen |
| **Root-Passwort** | **leer lassen** (zweimal Enter). Dann bekommt dein Benutzer `sudo`-Rechte, wie in den Befehlen dieses Kurses angenommen. |
| Benutzer | Name frei wählen (z. B. `admin`), **starkes Passwort** |
| Festplatte | *Geführt – vollständige Festplatte verwenden*, *Alle Dateien auf eine Partition*, Änderungen schreiben: *Ja* |
| Weitere Installationsmedien einlesen | **Nein** |
| **Netzwerk-Spiegelserver verwenden?** | **Nein**. Sonst lädt der Installer Updates aus dem Internet. Die Online-Paketquellen trägst du nach der Installation selbst ein (unten). |
| Paketverwendungsstatistik (*popularity-contest*) | **Nein** (überträgt sonst Nutzungsdaten) |
| **Softwareauswahl** | **nur** *SSH server* und *Standard-Systemwerkzeuge*. *Debian desktop environment* und *GNOME* **abwählen**. |
| GRUB-Bootloader | *Ja*, auf die einzige Festplatte (`/dev/sda` bzw. `/dev/vda`) |

Nach der Installation neu starten (UTM: vorher unter *CD/DVD* die ISO auswerfen), dann an der Konsole anmelden.

**Paketquellen aus dem Internet einschalten.** Weil du keinen Spiegelserver gewählt hast, kennt `apt` bisher nur die DVD. Trage die Online-Paketquellen ein (am besten per Kopieren und Einfügen, z. B. nach der SSH-Anmeldung aus 1.4):

```bash
# DVD als Paketquelle abschalten
sudo sed -i 's/^deb cdrom:/# deb cdrom:/' /etc/apt/sources.list
# Online-Paketquellen für Debian 13 eintragen
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
grep -rn cdrom /etc/apt/     # darf nur noch auskommentierte Zeilen (#) zeigen
```

**Erwartet:** `sudo apt update` in 1.3 lädt die Paketlisten von `deb.debian.org` und `security.debian.org` ohne Fehler. Warnt `apt`, eine Quelle sei *mehrfach konfiguriert*, hat der Installer schon Zeilen in `/etc/apt/sources.list` eingetragen: Lösche dort die doppelten Zeilen (`sudo nano /etc/apt/sources.list`).

### 1.3 Erste Schritte in Linux

```bash
whoami            # Benutzername
hostnamectl       # Hostname, Betriebssystem, Kernel
ip -br addr       # Netzwerkschnittstellen (kurz) und IP-Adresse der VM
df -h /           # Festplattenbelegung
free -h           # Arbeitsspeicher
```

Notiere die IP-Adresse aus `ip -br addr` (die Zeile, die nicht `lo` heißt). Bei virt-manager, UTM und Hyper-V brauchst du sie im Folgenden als `<VM-IP>`.

System aktualisieren:

```bash
sudo apt update
sudo apt upgrade -y
```

**Erwartet:** `apt update` listet Paketquellen ohne Fehler, `apt upgrade` installiert ggf. Updates. Meldet `sudo`, dein Benutzer sei nicht in der *sudoers*-Datei, hast du ein Root-Passwort vergeben: siehe Fehlersuche.

📸 *Screenshot: `hostnamectl` und `ip -br addr`.*

### 1.4 Zugriff per SSH vom Host

Auf dem **Host** (nicht in der VM):

{{< tabs groupid="vm-platform" >}}
{{% tab title="VirtualBox" %}}
```bash
ssh -p 2222 <benutzer>@127.0.0.1
```

SSH über die Portweiterleitung ist nur vom Host aus erreichbar, nicht von anderen Rechnern im Netz.
{{% /tab %}}
{{% tab title="Linux: virt-manager" %}}
```bash
ssh <benutzer>@<VM-IP>
```

Das Netz `192.168.122.0/24` existiert nur auf deinem Rechner, andere Geräte erreichen die VM nicht.
{{% /tab %}}
{{% tab title="macOS: UTM" %}}
```bash
ssh <benutzer>@<VM-IP>
```

Das *Shared Network* existiert nur auf deinem Mac, andere Geräte erreichen die VM nicht.
{{% /tab %}}
{{% tab title="Windows: Hyper-V" %}}
```powershell
ssh <benutzer>@<VM-IP>
```

Der *Default Switch* ist nur vom Host aus erreichbar. Klappt die Verbindung nach einem Neustart nicht mehr, prüfe die Adresse in der VM erneut mit `ip -br addr`.
{{% /tab %}}
{{< /tabs >}}

Beim ersten Verbinden bestätigst du den Fingerabdruck mit `yes`. **Erwartet:** Du bist auf dem Server angemeldet.

> **Tipp – SSH funktioniert nicht?** Wurde bei der Softwareauswahl *SSH server* nicht angehakt, fehlt der Dienst. Installiere ihn in der VM (Konsole des VM-Fensters):
>
> ```bash
> sudo apt update
> sudo apt install openssh-server
> sudo systemctl enable --now ssh
> systemctl status ssh
> ```
>
> **Erwartet:** `status` zeigt `active (running)`. Danach den `ssh`-Befehl auf dem Host erneut ausführen.

### 1.5 Snapshot erstellen und zurückkehren

**1. Snapshot aufnehmen.** Name: `00-frisch-installiert`, Beschreibung: „Nach Installation und Updates“.

{{< tabs groupid="vm-platform" >}}
{{% tab title="VirtualBox" %}}
VM-Manager → VM wählen → **Snapshots** → **Aufnehmen**.
{{% /tab %}}
{{% tab title="Linux: virt-manager" %}}
VM öffnen → Menü *Ansicht* → **Snapshots** → **+** (unten links). Snapshots funktionieren mit dem Festplattenformat qcow2 (Standard).
{{% /tab %}}
{{% tab title="macOS: UTM" %}}
UTM hat (Stand UTM 4.x, nicht verifiziert) **keine Snapshot-Funktion** in der Oberfläche. Ersatz: VM herunterfahren, **Rechtsklick → Clone** und die Kopie `debian-lab-00-frisch-installiert` nennen. Zum „Zurückkehren“ startest du später die Kopie. Das braucht mehr Speicherplatz als ein Snapshot; überlege, warum.
{{% /tab %}}
{{% tab title="Windows: Hyper-V" %}}
Hyper-V nennt Snapshots **Prüfpunkte** (*Checkpoints*). Rechtsklick auf die VM → **Prüfpunkt**, danach im Bereich *Prüfpunkte* umbenennen.
{{% /tab %}}
{{< /tabs >}}

**2. In der VM etwas „kaputtmachen“** (**nur in dieser Übungs-VM!**):

```bash
sudo rm /etc/network/interfaces
ls /etc/network/interfaces
```

**Erwartet:** Fehlermeldung „No such file or directory“. Ohne diese Datei bekommt die VM nach dem nächsten Neustart keine Netzwerkadresse mehr.

**3. Zurückkehren:** VM ausschalten (`sudo poweroff`), dann

{{< tabs groupid="vm-platform" >}}
{{% tab title="VirtualBox" %}}
im Snapshot-Dialog den Snapshot wählen → **Wiederherstellen**.
{{% /tab %}}
{{% tab title="Linux: virt-manager" %}}
in der Snapshot-Ansicht den Snapshot wählen → **Snapshot ausführen** (Pfeil-Symbol).
{{% /tab %}}
{{% tab title="macOS: UTM" %}}
die kaputte VM löschen oder liegen lassen und die Kopie `debian-lab-00-frisch-installiert` starten.
{{% /tab %}}
{{% tab title="Windows: Hyper-V" %}}
Rechtsklick auf den Prüfpunkt → **Anwenden**.
{{% /tab %}}
{{< /tabs >}}

VM starten und prüfen: `ls /etc/network/interfaces` zeigt die Datei wieder.

📸 *Screenshot: Snapshot-Liste (UTM: VM-Liste mit Kopie).*

### 1.6 Klonen

VM herunterfahren, dann:

{{< tabs groupid="vm-platform" >}}
{{% tab title="VirtualBox" %}}
**Rechtsklick → Klonen**. Name `debian-lab-klon`, **MAC-Adressen für alle Netzwerkadapter neu generieren**, Klontyp **Vollständiger Klon**.
{{% /tab %}}
{{% tab title="Linux: virt-manager" %}}
**Rechtsklick → Klonen**. Name `debian-lab-klon`. virt-manager vergibt automatisch eine neue MAC-Adresse und kopiert die Festplatte.
{{% /tab %}}
{{% tab title="macOS: UTM" %}}
**Rechtsklick → Clone**, danach umbenennen in `debian-lab-klon`. Unter *Network* mit dem Würfel-Symbol eine **neue MAC-Adresse** erzeugen.
{{% /tab %}}
{{% tab title="Windows: Hyper-V" %}}
Hyper-V hat keine Klon-Funktion, man nutzt **Exportieren und Importieren**:

1. Rechtsklick → **Exportieren** in einen Ordner, z. B. `C:\VMs\export`.
2. *Aktion → Virtuellen Computer importieren* → den exportierten Ordner wählen → **Virtuellen Computer kopieren (neue eindeutige ID erstellen)**, eigene Zielordner angeben.
3. Die importierte VM in `debian-lab-klon` umbenennen. Unter *Netzwerkkarte → Erweiterte Features* bleibt **Dynamische MAC-Adresse** aktiv.
{{% /tab %}}
{{< /tabs >}}

Klon starten. Der Hostname lautet noch `debian-lab`: ändern mit

```bash
sudo hostnamectl set-hostname debian-lab-klon
sudo sed -i 's/debian-lab/debian-lab-klon/' /etc/hosts
sudo rm -f /etc/machine-id && sudo systemd-machine-id-setup
```

Die zweite Zeile passt den Eintrag in `/etc/hosts` an (sonst warnt `sudo`, es könne den Rechnernamen nicht auflösen). Die erneuerte *Machine-ID* verhindert Konflikte zwischen Klonen (z. B. gleiche DHCP-Adresse).

Den Klon darfst du danach löschen (VirtualBox: *Entfernen → Alle Dateien löschen*; virt-manager: *Löschen* mit Festplatte; UTM: *Delete*; Hyper-V: VM löschen und den Ordner der Festplatte von Hand entfernen). Wir arbeiten mit der ursprünglichen VM weiter.

{{< details summary="Für Neugierige: QEMU ohne Oberfläche" >}}
virt-manager und UTM sind Oberflächen für **QEMU**. Was eine VM ist, zeigt der Start von Hand am deutlichsten: CPU, RAM, Festplatte und Netz stehen in einer Zeile. Beispiel unter Linux mit einer Kopie der Festplatte aus virt-manager (VM vorher ausschalten):

```bash
sudo cp /var/lib/libvirt/images/debian-lab.qcow2 ~/ && sudo chown $USER ~/debian-lab.qcow2
cd ~
qemu-system-x86_64 -accel kvm -m 2048 -smp 2 \
  -drive file=debian-lab.qcow2,if=virtio \
  -netdev user,id=n0,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 \
  -device virtio-net,netdev=n0
```

`-netdev user` ist ein NAT-Netz mit denselben Adressen wie VirtualBox (`10.0.2.15`, Gateway `10.0.2.2`), `hostfwd` sind die Portweiterleitungen, danach geht `ssh -p 2222 <benutzer>@127.0.0.1`. Snapshots gehen mit `qemu-img snapshot -c <name> debian-lab.qcow2`. Unter macOS heißt die Beschleunigung `-accel hvf`, unter Windows `-accel whpx`. (Nicht verifiziert, nicht Teil der Bewertung.)
{{< /details >}}

## Teil 2: Docker

In der VM `debian-lab`:

### 2.1 Docker installieren

Folge der offiziellen Anleitung für Debian: [docs.docker.com/engine/install/debian](https://docs.docker.com/engine/install/debian/) (Methode **„apt repository“**). Sie ändert sich gelegentlich, daher hier nur der Ablauf: Paketquelle von Docker hinzufügen, dann

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

**Erwartet:** `docker ps` zeigt den laufenden Container `web`, `curl` liefert den HTML-Text „Welcome to nginx!“. Vom Host aus ist die Seite erreichbar: bei VirtualBox unter `http://localhost:8080` (Portweiterleitung aus 1.1), sonst unter `http://<VM-IP>:8080`.

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
      NEXTCLOUD_TRUSTED_DOMAINS: ${TRUSTED_DOMAINS}
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
TRUSTED_DOMAINS="localhost <VM-IP>"
EOF
chmod 600 .env
```

Erzeuge die Passwörter z. B. mit `openssl rand -base64 24`. `TRUSTED_DOMAINS` enthält die Adressen, unter denen Nextcloud aufgerufen werden darf: Bei VirtualBox reicht `localhost`, sonst trägst du zusätzlich die IP-Adresse der VM ein. **Die `.env`-Datei kommt niemals ins Git-Repository.**

### 3.2 Starten

```bash
docker compose up -d
docker compose ps
docker compose logs -f app      # mit Strg+C beenden
```

**Erwartet:** Beide Dienste `running`. Nach etwa einer Minute ist Nextcloud im Browser des Hosts erreichbar (VirtualBox: `http://localhost:8080`, sonst `http://<VM-IP>:8080`). Beim ersten Aufruf legst du ein Administratorkonto an (Daten: *Nextcloud-Admin*, starkes Passwort).

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

- [ ] VM `debian-lab` läuft und ist per SSH erreichbar.
- [ ] Snapshot-Liste zeigt mindestens `00-frisch-installiert`, `10-docker-installiert`, `20-nextcloud-laeuft` (UTM: entsprechende Kopien).
- [ ] `docker run hello-world` erfolgreich.
- [ ] Nextcloud (oder nginx-Variante) im Browser des Hosts erreichbar.
- [ ] Backup-Archive vorhanden **und** Restore getestet.
- [ ] Keine Passwörter oder `.env`-Datei im Portfolio-Repository.

## Fehlersuche

| Problem | Ursache und Lösung |
|---|---|
| VM startet nicht: „VT-x is not available“ | Virtualisierung im BIOS aktivieren, ggf. Hyper-V/WSL2 prüfen. |
| Hyper-V: VM startet nicht von der ISO, Meldung zu *Secure Boot* | Vorlage für sicheren Start auf **Microsoft UEFI-Zertifizierungsstelle** stellen (1.1, Schritt 3). |
| virt-manager: „KVM is not available“ oder keine Verbindung zu libvirt | `ls /dev/kvm` prüfen, Benutzer in Gruppe `libvirt`, neu anmelden, `sudo systemctl enable --now libvirtd`. |
| `<benutzer> is not in the sudoers file` | Bei der Installation wurde ein Root-Passwort vergeben. Mit `su -` als root anmelden, `usermod -aG sudo <benutzer>` ausführen, neu anmelden. |
| Kein Internet in der VM | Netzwerk wie in 1.1 eingestellt (NAT, *default*, *Shared Network*, *Default Switch*)? Neustart der VM, `ip -br addr` prüfen, `ping 1.1.1.1`, `ping debian.org` (trennt Routing und DNS). |
| SSH: „Connection refused“ | Läuft `ssh` in der VM (`systemctl status ssh`)? Existiert der Dienst nicht: `sudo apt install openssh-server`. VirtualBox: Portweiterleitung 2222→22 gesetzt? Sonst: richtige `<VM-IP>`? |
| `docker: permission denied` | Mit `sudo` ausführen oder Benutzer zur Gruppe `docker` hinzufügen und neu anmelden. |
| Port 8080 belegt | Anderen Port wählen (`-p 8081:80`) und bei VirtualBox die Portweiterleitung anpassen. |
| Nextcloud: „Trusted domain“-Fehler | Aufgerufene Adresse fehlt in `TRUSTED_DOMAINS`. Die Variable wirkt nur bei der Erstinstallation; danach `docker compose exec -u www-data app php occ config:system:set trusted_domains 1 --value=<VM-IP>`. |
| Wenig freier Speicher | `docker system prune` räumt ungenutzte Container und Images auf (**Vorsicht, löscht!**). |
