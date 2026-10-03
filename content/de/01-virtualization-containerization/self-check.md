+++
title = "Selbsttest"
weight = 60
+++

Beantworte die Fragen zuerst selbst und öffne dann die Lösung.

{{% details title="Frage 1: Was ist der Unterschied zwischen einem Typ-1- und einem Typ-2-Hypervisor? Nenne je ein Beispiel." %}}
Ein **Typ-1-Hypervisor** läuft direkt auf der Hardware (Bare Metal), z. B. Proxmox VE oder VMware ESXi. Ein **Typ-2-Hypervisor** läuft als Programm in einem normalen Betriebssystem, z. B. VirtualBox. Typ 1 ist leistungsfähiger und für Server gedacht, Typ 2 praktisch für Laptop und Unterricht.
{{% /details %}}

{{% details title="Frage 2: Nenne drei Unterschiede zwischen VM und Container." %}}
- **Kernel:** VM hat eigenen Kernel, Container teilen den Host-Kernel.
- **Größe und Startzeit:** VMs sind GB-groß und starten in Sekunden bis Minuten, Container sind MB-groß und starten in Sekunden.
- **Isolation:** VMs sind stärker isoliert, bei Containern ist die Isolation schwächer.
- Weitere: Gast-Betriebssystem frei wählbar (VM) vs. Linux-Kernel nötig (Container), Ressourcenbedarf, Updatemodell.
{{% /details %}}

{{% details title="Frage 3: Warum ist ein Snapshot kein Backup?" %}}
Ein Snapshot liegt auf demselben Datenträger wie die VM. Fällt dieser aus oder wird die VM gelöscht, ist auch der Snapshot weg. Außerdem wachsen lange Snapshot-Ketten und verlangsamen die VM. Ein Backup liegt an **einem anderen Ort** und ist durch einen **Restore-Test** als funktionierend belegt.
{{% /details %}}

{{% details title="Frage 4: Du löschst einen Container, der eine Datenbank enthält, und alle Daten sind weg. Was wurde falsch gemacht, und wie vermeidest du das?" %}}
Das Dateisystem eines Container ist flüchtig. Daten wurden nicht in einem **Volume** (oder Bind Mount) gespeichert. Abhilfe: Verzeichnis der Datenbank als Volume einbinden (z. B. `db-data:/var/lib/mysql`) und regelmäßig sichern.
{{% /details %}}

{{% details title="Frage 5: Was bewirkt `docker run -d --name web -p 8080:80 nginx:stable`? Erkläre jeden Teil." %}}
- `docker run`: startet einen neuen Container aus einem Image.
- `-d`: im Hintergrund (detached).
- `--name web`: Name des Containers.
- `-p 8080:80`: Port 8080 am Host wird an Port 80 im Container weitergeleitet.
- `nginx:stable`: Image `nginx` mit dem Tag `stable`.
{{% /details %}}

{{% details title="Frage 6: Warum sollte man in einer Compose-Datei nicht `image: nextcloud:latest` verwenden?" %}}
`latest` ist ein beweglicher Tag. Ein späteres `docker compose pull` kann eine neue Hauptversion mit inkompatiblen Änderungen holen, und die Installation ist nicht mehr reproduzierbar. Besser eine **Hauptversion fixieren** (z. B. `nextcloud:31-apache`), kontrolliert aktualisieren und vorher ein Backup oder einen Snapshot erstellen.
{{% /details %}}

{{% details title="Frage 7: Welche Netzwerkmodi gibt es in VirtualBox, und welchen wählst du für eine Test-VM, die nur Updates laden soll und nicht aus dem LAN erreichbar sein darf?" %}}
NAT, NAT-Netzwerk, Bridged, Host-only, Internes Netz. Für die beschriebene Anforderung: **NAT**: Die VM erreicht das Internet über den Host, ist aber von außen nicht erreichbar.
{{% /details %}}

{{% details title="Frage 8: Die Schule betreibt eine Notenverwaltung, die nur unter Windows Server läuft. VM oder Container? Begründe." %}}
**VM**, da ein Windows-Betriebssystem nötig ist (Windows-Container sind nur auf Windows-Hosts mit eigener Technik möglich und für Altsoftware selten geeignet). Die VM bietet zudem stärkere Isolation für sensible Daten. Zusätzlich: Backup und Updatekonzept, Zugriff beschränken.
{{% /details %}}

{{% details title="Frage 9: Nenne zwei Gründe, warum der Docker-Socket oder die Mitgliedschaft in der Gruppe `docker` sicherheitskritisch ist." %}}
Wer Container starten darf, kann einen Container mit Zugriff auf das gesamte Host-Dateisystem starten und damit **faktisch Root-Rechte auf dem Host** erlangen. Der Docker-Socket (`/var/run/docker.sock`) darf deshalb nicht in Container eingebunden oder anderen Benutzern zugänglich gemacht werden, außer es ist unbedingt nötig und abgesichert.
{{% /details %}}

{{% details title="Frage 10: Wie erreichst du, dass ein Klon einer VM keine Konflikte mit dem Original verursacht?" %}}
Neue **MAC-Adressen** generieren, **Hostnamen** ändern, ggf. **Machine-ID** neu erzeugen, feste IP-Adressen und Zertifikate anpassen, SSH-Host-Keys neu erzeugen (bei Bedarf).
{{% /details %}}

{{% details title="Frage 11 (Schulkontext): Ein Kollege sagt: „Wir laufen mit Docker, da ist alles automatisch sicher.“ Was entgegnest du?" %}}
Container sind nicht automatisch sicher: Sie teilen den Kernel, Images können veraltet oder verwundbar sein, schlecht konfigurierte Container (privilegiert, Root, offene Ports) sind Einfallstore, und Daten in Volumes brauchen Backup, Zugriffsschutz und ggf. Verschlüsselung. Sicherheit entsteht durch **aktuelle Images, minimale Rechte, Netzwerktrennung, Backups und Dokumentation**.
{{% /details %}}

{{% details title="Frage 12 (Schulkontext): Wo gehört die Datei `.env` mit Passwörtern hin, wenn du die Compose-Datei dokumentierst?" %}}
Die Compose-Datei kann ins Repository, die **`.env` nicht** (in `.gitignore` eintragen). Dokumentiere nur die Namen der Variablen (z. B. in einer `.env.example` ohne Werte) und verweise darauf, wo die echten Werte liegen (Passwortmanager).
{{% /details %}}
