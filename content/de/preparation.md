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

- [ ] **VirtualBox 7.x** installiert und einmal gestartet ([virtualbox.org](https://www.virtualbox.org)). Windows: Treiberinstallation zulassen und bei Aufforderung neu starten.
- [ ] **Ubuntu-Server-24.04-LTS-ISO** heruntergeladen (ca. 2–3 GB, [ubuntu.com/download/server](https://ubuntu.com/download/server)). Prüfe, dass die Datei vollständig ist; ein defekter Download fällt sonst erst bei der Installation auf.
- [ ] **Apple Silicon (M1–M4):** statt der beiden Punkte oben UTM ([mac.getutm.app](https://mac.getutm.app)) und die **Ubuntu-Server-ARM64-ISO**.
- [ ] **Windows mit WSL2/Hyper-V:** VirtualBox läuft, aber langsamer. Schließe vor der Einheit andere rechenintensive Programme und VMs.
- [ ] Optional, spart viel Zeit: **VM zu Hause anlegen und Ubuntu installieren** (Lab Teil 1), mit gesetztem Haken bei *Install OpenSSH server* im Installer. Snapshot `00-fresh-install` erstellen.
- [ ] Optional: in der laufenden VM `sudo apt update && sudo apt upgrade -y` ausführen, damit die Updates nicht während der Einheit geladen werden.

Vorher wissen:

- [ ] Die **Installer-Option „Install OpenSSH server“** muss aktiviert sein, sonst funktioniert SSH vom Host nicht (Abhilfe: Hinweis in Lab Teil 1.4).
- [ ] **Portweiterleitung** in VirtualBox: Host `2222` → Gast `22` und Host `8080` → Gast `8080`.
- [ ] **Ports 2222 und 8080** am Laptop freihalten (kein anderes Programm darauf).

## Einheit 2: Netzwerke I

{{% callout style="warning" title="Vorläufig" %}}
Das Kapitel ist noch ein Gerüst. Diese Liste beruht auf dem geplanten Thema (Netzwerkdiagramme und IP-Pläne) und dem Lab aus Einheit 1. Sie wird angepasst, sobald das Lab geschrieben ist.
{{% /callout %}}

- [ ] **Die VM aus Einheit 1 startet noch**, du kannst dich anmelden und `ssh -p 2222 <user>@127.0.0.1` funktioniert. Wenn nicht, stelle den Snapshot `00-fresh-install` oder `10-docker-installed` **zu Hause** wieder her.
- [ ] **Freier Speicherplatz:** mindestens 10 GB frei für Klone und zusätzliche VMs.
- [ ] **VM aktualisiert:** `sudo apt update && sudo apt upgrade -y`, danach neuen Snapshot erstellen.
- [ ] **Netzwerkwerkzeuge in der VM installiert** (zu Hause laden, nicht im WLAN der Einheit): `sudo apt install -y traceroute dnsutils tcpdump nmap`. Prüfen mit `ip a`, `ping -c 3 1.1.1.1` und `traceroute --version`.
- [ ] **Netzwerkeinstellungen in VirtualBox kennen:** *Einstellungen → Netzwerk*, Adaptertypen (NAT, Internes Netzwerk, Host-only-Adapter). Finde das Menü einmal, du wirst einen zweiten Adapter hinzufügen.
- [ ] **Diagramm-Werkzeug bereit:** VS Code mit Mermaid-Vorschau oder [diagrams.net](https://app.diagrams.net) (Desktop-App oder Browser). Probiere ein kleines Diagramm aus.
- [ ] **Technik vorab lesen:** [Netzwerkdiagramme und IP-Pläne]({{% relref "/00-documentation/network-diagrams-ip-plans" %}}).
- [ ] **Optional:** [Wireshark](https://www.wireshark.org/download.html) am Host. Unter Windows die Npcap-Installation zulassen.
- [ ] **Abgabe aus Einheit 1 im Portfolio** ist gepusht (Branch `session-01`, Pull Request geöffnet), damit der neue Branch `session-02` sauber startet.

## Weitere Einheiten

Die Vorbereitung für die weiteren Einheiten wird hier ergänzt, sobald die Kapitel freigegeben sind.

## Wenn etwas nicht funktioniert

Kämpfe nicht allein während der Einheit: Notiere die **genaue Fehlermeldung** (Screenshot), das Betriebssystem und den Schritt, bei dem du warst, und melde dich bei der Lehrperson. Solche Notizen sind auch gutes Material für die Dokumentationsaufgabe.
