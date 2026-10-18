+++
title = "Vorbereitungs-Checkliste"
weight = 2
+++

Große Downloads und Installationen kosten Zeit in der Lehrveranstaltung, besonders wenn 20 Laptops am selben WLAN hängen. Arbeite diese Liste **zu Hause und mindestens zwei Tage vor jeder Einheit** ab. Pro Einheit gibt es eine kurze Liste, die allgemeinen Punkte gelten für den ganzen Kurs.

## Allgemein (einmalig, vor der ersten Einheit)

- [ ] **Laptop mit Administratorrechten.** Du musst Software installieren dürfen. Gesperrte Schul- oder Dienstgeräte funktionieren meist nicht, siehe Ausweichlösungen im [Lab]({{% relref "/01-virtualization-containerization/lab" %}}#besonderheiten-und-ausweichlösungen).
- [ ] **Freier Speicher: mindestens 30 GB**, RAM: mindestens 8 GB.
- [ ] **Virtualisierung im BIOS/UEFI aktiviert** (*Intel VT-x* bzw. *AMD-V (SVM)*). Prüfen: Task-Manager → Leistung → CPU → „Virtualisierung: Aktiviert“. Die Änderung braucht einen Neustart, also nicht erst in der Einheit erledigen.
- [ ] **Ladegerät** mitbringen. VMs verbrauchen viel Akku.
- [ ] **Git installiert** (`git --version`) und **GitHub-Konto** angelegt.
- [ ] **Portfolio-Repository:** Einladung angenommen, einmal `git clone` probiert (Name und E-Mail mit `git config` gesetzt).
- [ ] **Texteditor** mit Markdown-Vorschau, z. B. Visual Studio Code mit der Erweiterung *Markdown Preview Mermaid Support*.
- [ ] **SSH-Client** vorhanden: `ssh -V` im Terminal. Er ist in Windows 10/11 (PowerShell), macOS und Linux enthalten.

## Einheit 1: Virtualisierung & Containerisierung

**Vor** der Einheit herunterladen und testen:

- [ ] **Virtualisierung gewählt und installiert** (Tabelle *Welche Virtualisierung?* im [Lab]({{% relref "/01-virtualization-containerization/lab" %}})):
  - **VirtualBox 7.x** ([virtualbox.org](https://www.virtualbox.org)) installiert und einmal gestartet. Windows: Treiberinstallation zulassen und bei Aufforderung neu starten.
  - **Linux:** `virt-manager` installiert, Benutzer in der Gruppe `libvirt`, `ls /dev/kvm` zeigt die Datei.
  - **Apple Silicon (M1–M4):** **UTM** ([mac.getutm.app](https://mac.getutm.app)) installiert.
  - **Windows Pro/Education mit WSL2 oder Hyper-V:** Windows-Feature **Hyper-V** aktiviert (Neustart nötig).
- [ ] **Debian-13-DVD-Image** zu Hause heruntergeladen (Datei `debian-13.x.x-<arch>-DVD-1.iso`, ca. 4 GB, [debian.org/CD/http-ftp](https://www.debian.org/CD/http-ftp/)): `amd64` für Intel/AMD, `arm64` für Apple Silicon. **Nicht** das kleine Netinst-Image: Das lädt während der Installation aus dem Internet, und die Installation machen wir gemeinsam in der Einheit.
- [ ] **Download geprüft:** Prüfsumme mit der Datei `SHA512SUMS` im selben Download-Ordner vergleichen. Windows (PowerShell): `Get-FileHash -Algorithm SHA512 <datei>.iso`; macOS: `shasum -a 512 <datei>.iso`; Linux: `sha512sum <datei>.iso`. Ein defekter Download fällt sonst erst bei der Installation auf.

Vorher wissen:

- [ ] Im Debian-Installer **Root-Passwort leer lassen** (dann funktioniert `sudo`), **keinen Netzwerk-Spiegelserver** verwenden und bei der Softwareauswahl **nur** *SSH server* und *Standard-Systemwerkzeuge* anhaken (Abhilfe bei fehlendem SSH: Hinweis in Lab Teil 1.4).
- [ ] **Zugriff vom Host:** VirtualBox braucht eine **Portweiterleitung** (Host `2222` → Gast `22`, Host `8080` → Gast `8080`). Bei virt-manager, UTM und Hyper-V erreichst du die VM direkt über ihre IP-Adresse.
- [ ] VirtualBox: **Ports 2222 und 8080** am Laptop freihalten (kein anderes Programm darauf).

## Einheit 2: Netzwerke I

- [ ] **Konto bei der Cisco Networking Academy** angelegt ([netacad.com](https://www.netacad.com/), kostenlos) und die Bestätigungs-E-Mail beantwortet.
- [ ] **Cisco Packet Tracer 9.0.1 installiert** und **einmal mit dem Konto angemeldet** (die erste Anmeldung braucht Internet). Ein leeres Projekt speichern und wieder öffnen. Siehe [Lab, Teil 0]({{% relref "/02-networking-1/lab" %}}).
- [ ] **Die VM `debian-lab` aus Einheit 1 startet noch**, du kannst dich anmelden und per SSH verbinden (VirtualBox: `ssh -p 2222 <user>@127.0.0.1`, sonst `ssh <user>@<VM-IP>`). Wenn nicht, stelle den Snapshot `00-frisch-installiert` oder `10-docker-installiert` **zu Hause** wieder her.
- [ ] **Freier Speicherplatz:** mindestens 10 GB frei für Klone und zusätzliche VMs.
- [ ] **VM aktualisiert:** `sudo apt update && sudo apt upgrade -y`, danach neuen Snapshot erstellen.
- [ ] **Werkzeuge in der VM installiert** (zu Hause laden, nicht im WLAN der Einheit): `sudo apt install -y python3 iputils-tracepath bind9-dnsutils traceroute tcpdump nmap`. Prüfen mit `ip a`, `ping -c 3 1.1.1.1`, `tracepath -V` und `python3 --version`.
- [ ] **Netzwerkeinstellungen deiner Virtualisierung kennen:** Wo stellst du das Netz der VM ein (VirtualBox: *Einstellungen → Netzwerk*; virt-manager: *NIC*; UTM: *Network*; Hyper-V: *Netzwerkkarte*)? Finde das Menü einmal; im Lab wechselst du optional von NAT auf eine Brücke.
- [ ] **Diagramm-Werkzeug bereit:** VS Code mit Mermaid-Vorschau oder [diagrams.net](https://app.diagrams.net) (Desktop-App oder Browser). Probiere ein kleines Diagramm aus.
- [ ] **Technik vorab lesen:** [Netzwerkdiagramme und IP-Pläne]({{% relref "/00-documentation/network-diagrams-ip-plans" %}}).
- [ ] **Optional:** [Wireshark](https://www.wireshark.org/download.html) am Host. Unter Windows die Npcap-Installation zulassen.
- [ ] **Abgabe aus Einheit 1 im Portfolio** ist gepusht (Branch `session-01`, Pull Request geöffnet), damit der neue Branch `session-02` sauber startet.

## Weitere Einheiten

Die Vorbereitung für die weiteren Einheiten wird hier ergänzt, sobald die Kapitel freigegeben sind.

## Wenn etwas nicht funktioniert

Kämpfe nicht allein während der Einheit: Notiere die **genaue Fehlermeldung** (Screenshot), das Betriebssystem und den Schritt, bei dem du warst, und melde dich bei der Lehrperson. Solche Notizen sind auch gutes Material für die Dokumentationsaufgabe.
