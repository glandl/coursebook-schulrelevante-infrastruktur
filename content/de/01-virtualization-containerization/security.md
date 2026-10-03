+++
title = "Sicherheit und Datenschutz"
weight = 80
+++

{{% callout style="warning" title="Keine Rechtsberatung" %}}
Dieser Abschnitt gibt eine technische Orientierung. Rechtliche Fragen (z. B. Rechtsgrundlage, Auftragsverarbeitung) klärt die Schule mit der Datenschutzbeauftragten bzw. dem Datenschutzbeauftragten und dem Schulerhalter.
{{% /callout %}}

## Das Wichtigste in Kürze

| Thema | Maßnahme |
|---|---|
| **Updates** | Host, VM-Betriebssystem **und** Container-Images aktuell halten. Ein Container-Image wird nicht durch `apt upgrade` in der VM aktualisiert. |
| **Versionen fixieren** | In Compose-Dateien feste Image-Versionen, Updates kontrolliert (erst Backup oder Snapshot, dann `pull` und `up -d`). |
| **Isolation** | Eine VM isoliert stärker als ein Container. Sensible Systeme (z. B. Notenverwaltung) in eigener VM, möglichst eigenes Netz/VLAN (Einheit 3). |
| **Docker-Rechte** | Wer in der Gruppe `docker` ist, hat faktisch Root-Rechte auf dem Host. Nur Administratoren, nie Schüler-Konten. Docker-Socket nicht in Container einbinden. |
| **Container-Rechte** | Keine `--privileged`-Container, keine unnötigen Capabilities, Dienste möglichst nicht als `root` im Container. |
| **Ports** | Nur notwendige Ports veröffentlichen. Hinweis: Docker setzt eigene Firewall-Regeln. Veröffentlichte Ports sind oft erreichbar, auch wenn z. B. `ufw` sie blockieren soll. Auf `127.0.0.1:8080:80` binden, wenn der Dienst nur lokal erreichbar sein soll. |
| **Geheimnisse** | Passwörter, Tokens und Schlüssel in `.env` bzw. Secret-Verwaltung, nie im Repository, nie im Image, nicht in Screenshots. |
| **Backups** | Daten (Volumes, Datenbank) sichern, an anderem Ort aufbewahren, **Restore regelmäßig testen**, Backups ebenfalls schützen (Zugriff, Verschlüsselung). |
| **Snapshots** | Rückfallebene, kein Backup. Ältere Snapshots enthalten alte, ungepatchte Zustände und Daten, die ggf. gelöscht werden müssten. |
| **Images** | Nur offizielle oder vertrauenswürdige Quellen. Bei unbekannten Images prüfen, wer sie pflegt und wie aktuell sie sind. |
| **Zugriff** | Starke Passwörter, möglichst **SSH-Schlüssel** statt Passwort, Administratorkonten nicht mit Alltagskonten mischen. |
| **Protokolle** | Logs (`docker logs`, Systemlogs) enthalten ggf. personenbezogene Daten (Benutzernamen, IP-Adressen). Aufbewahrung begrenzen. |

## Datenschutz im Schulkontext

- **Personenbezogene Daten in VMs und Containern:** Auch Disk-Images, Snapshots, Volumes und Backups enthalten personenbezogene Daten und unterliegen demselben Schutz. Ein weitergegebenes VM-Image kann Schülerdaten enthalten.
- **Löschen:** Wer Daten löscht, muss auch Snapshots, Backups und Kopien berücksichtigen. Lösch- und Aufbewahrungsfristen gelten für alle Kopien.
- **Standort der Daten:** Bei Cloud-Diensten prüfen, wo die Daten liegen und ob ein Auftragsverarbeitungsvertrag (AVV) besteht. Bei Selbstbetrieb liegt die Verantwortung für technische Maßnahmen (TOM) bei der Schule.
- **Trennung:** Schul- und Testumgebung nicht vermischen. **Keine echten Schülerdaten in Übungsumgebungen**, im Unterricht Testdaten verwenden.
- **Verarbeitungsverzeichnis:** Neue Dienste (Wiki, Lernplattform, Tickets) sind neue Verarbeitungstätigkeiten und gehören ins Verzeichnis (siehe [Verarbeitungsverzeichnis und ADRs]({{% relref "/00-documentation/processing-register-adr" %}})).
- **Verantwortung:** Die Schule bleibt auch bei Betrieb durch Dritte oder Lehrende im Nebenamt verantwortlich. Klare Zuständigkeiten und Vertretung festlegen.

## Checkliste für einen neuen Dienst

- [ ] Wer ist verantwortlich, wer vertritt?
- [ ] Welche personenbezogenen Daten fallen an (Kategorien, Betroffene)?
- [ ] Image-/Softwareversion bekannt und fixiert, Update-Plan vorhanden?
- [ ] Backup eingerichtet **und Restore getestet**?
- [ ] Zugriff beschränkt (Konten, Netz, Ports)?
- [ ] Verschlüsselung der Übertragung (HTTPS) geplant?
- [ ] Eintrag im Verarbeitungsverzeichnis, ADR zur Entscheidung?
- [ ] Löschkonzept (inklusive Backups und Snapshots)?

Die Themen **Netzwerk-Trennung** (Einheit 2 und 3), **Server-Härtung und Backups** (Einheit 4) und **Datenschutzrecht** (Einheit 6) werden in den folgenden Einheiten vertieft.
