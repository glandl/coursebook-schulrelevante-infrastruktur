+++
title = "Sicherheit und Datenschutz"
weight = 80
+++

{{% callout style="warning" title="Keine Rechtsberatung" %}}
Dieser Abschnitt gibt eine technische Orientierung. Rechtliche Fragen (z. B. Rechtsgrundlage, Protokollierung, Auftragsverarbeitung) klärt die Schule mit der Datenschutzbeauftragten bzw. dem Datenschutzbeauftragten und dem Schulerhalter.
{{% /callout %}}

## Das Wichtigste in Kürze

| Thema | Maßnahme |
|---|---|
| **Trennung der Netze** | Verwaltung, Lehrende, Schüler, Gäste, Server und Netzwerkmanagement in **eigenen Netzen**. Schüler- und Gästegeräte gehören nie in das Verwaltungs- oder Servernetz. Die technische Umsetzung (VLANs, Zugriffsregeln) folgt in Einheit 3. |
| **Standardpasswörter** | Bei Routern, Switches und Access Points Standardzugänge ändern. Jedes Gerät hat ein eigenes, starkes Administrator-Passwort im Passwortmanager. |
| **Verwaltungszugang** | Verwaltungsoberfläche nur aus dem Managementnetz erreichbar, **SSH statt Telnet**, **HTTPS statt HTTP**, keine Weboberfläche aus dem Internet. |
| **Firmware** | Router, Switches und Access Points regelmäßig aktualisieren. Geräte ohne Updates ersetzen. |
| **WLAN-Verschlüsselung** | WPA2 oder WPA3, **kein** WEP/WPA/offenes WLAN. Für Lehrende und Schüler möglichst 802.1X (Einzelkonten), für Gäste ein getrenntes, isoliertes Netz mit eigenem Passwort. |
| **Passwortweitergabe** | Bei Pre-Shared Keys: Wechsel bei Personalwechsel und bei Verdacht auf Weitergabe einplanen. Passwörter nicht auf Plakate im Gang drucken. |
| **Client-Isolation** | In Schüler- und Gäste-WLAN die Kommunikation zwischen Geräten sperren (Client-Isolation), damit Geräte einander nicht angreifen. |
| **Unerlaubte Geräte** | Private WLAN-Router oder Switches in Klassenräumen können das Netz stören oder öffnen (Schleifen, falsche DHCP-Server). Nicht benötigte Dosen und Ports abschalten oder gegen Fremdgeräte absichern (Einheit 3). |
| **Physischer Schutz** | Verteilerräume und Schränke abschließen, Zugang dokumentieren. Wer Zugriff auf einen Switch hat, kann das Netz übernehmen. |
| **NAT ist keine Firewall** | Von außen erreichbare Dienste (Portweiterleitung) vermeiden. Wo nötig, gezielt freigeben und dokumentieren. |
| **Dokumentation** | Der IP-Plan und das Diagramm gehören zu den schützenswerten Unterlagen (sie zeigen Angriffsflächen). Keine Passwörter in Plänen. |

## Datenschutz im Schulkontext

- **Verbindungsdaten sind personenbezogen:** MAC-Adressen, IP-Adressen, Anmeldenamen, Verbindungszeiten und Aufenthaltsorte (welcher AP) können Personen zugeordnet werden. Das gilt für DHCP-Leases, WLAN-Controller und Firewall-Protokolle.
- **Protokollierung begrenzen:** Nur so viel protokollieren, wie für Betrieb und Sicherheit nötig ist, und die **Aufbewahrungsdauer festlegen**. Wer darf Protokolle einsehen, und zu welchem Zweck? Das ist vorab zu regeln und zu dokumentieren.
- **Anmeldung am WLAN:** Einzelkonten (802.1X) erlauben nachvollziehbaren Zugriff, bedeuten aber auch, dass **personenbezogene Daten verarbeitet** werden. Kläre Rechtsgrundlage, Information der Betroffenen und Zuständigkeit.
- **Gästenetz:** Gäste identifizieren sich oft nicht. Trotzdem klären, welche Daten anfallen (Geräte, Zeiten) und wie lange sie gespeichert werden.
- **Cloud-verwaltete Netzwerkgeräte:** Konfiguration und Nutzungsdaten liegen beim Anbieter. Standort der Daten, Auftragsverarbeitungsvertrag (AVV) und Zweck prüfen.
- **Inhaltsfilter und Jugendschutz:** Filterung des Internetzugangs berührt Datenschutz und Pädagogik. Technische Umsetzung und rechtliche Anforderungen werden in Einheit 6 behandelt.
- **Übungsumgebung:** Keine echten Namen, Geräte oder Passwörter aus dem Schulnetz in Dokumentationen, Screenshots oder Repositories. In der Übung werden Testwerte verwendet.
- **Eintrag im Verarbeitungsverzeichnis:** Betrieb von WLAN, Protokollierung und Filter sind Verarbeitungstätigkeiten (siehe [Verarbeitungsverzeichnis und ADRs]({{% relref "/00-documentation/processing-register-adr" %}})).

## Checkliste für ein neues Netz oder WLAN

- [ ] Wer ist verantwortlich, wer vertritt?
- [ ] Netze getrennt nach Nutzergruppen und Schutzbedarf?
- [ ] Standardpasswörter geändert, Verwaltungszugang beschränkt?
- [ ] WLAN-Sicherheitsverfahren festgelegt und begründet (PSK oder 802.1X)?
- [ ] Gästenetz getrennt und isoliert?
- [ ] Firmware-Stand dokumentiert, Update-Verantwortung geklärt?
- [ ] Protokollierung: Was wird gespeichert, wie lange, wer darf zugreifen?
- [ ] Eintrag im Verarbeitungsverzeichnis, bei Cloud-Verwaltung AVV geprüft?
- [ ] IP-Plan und Diagramm aktuell, ohne Passwörter?

Die Themen **Segmentierung mit VLANs und Zugriffsregeln** (Einheit 3), **Serverhärtung und Benutzerverwaltung** (Einheit 4) und **Datenschutzrecht und Jugendschutz** (Einheit 6) werden in den folgenden Einheiten vertieft.
