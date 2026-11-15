+++
title = "Serverrollen: Windows und Linux"
type = "chapter"
weight = 4
+++

**Einheiten:** 16.11.2026 und 23.11.2026 · **Dokumentationstechnik:** [Runbooks]({{% relref "/00-documentation/runbooks" %}}) · **Abgabe Rollen-Runbook:** 06.12.2026

Ein Schulnetz braucht mehr als Kabel und Adressen. Geräte bekommen ihre Adresse automatisch, Namen werden aufgelöst, Lehrende melden sich mit *einem* Konto an jedem Rechner an, finden ihre Klassenordner, drucken, rufen die Schulwebseite auf, und im Sommer werden 25 EDV-Raum-Rechner in einer Stunde neu aufgesetzt. Jede dieser Aufgaben ist eine **Serverrolle**.

In diesem Kapitel baut ihr in zwei Einheiten **gemeinsam ein funktionierendes Schulnetz** aus acht Serverrollen, und zwar **zweimal**:

- in der **Windows-Welt** mit Windows Server 2025, so wie viele österreichische Schulen arbeiten, und
- in der **Linux-Welt** mit Debian 13 und freier Software, die dieselbe Aufgabe ohne Lizenzkosten erfüllt.

Jedes **Rollenteam** (zwei Personen, ein Team zu dritt) übernimmt **eine** Rolle und baut sie in **beiden Welten**. Wie ihr die Arbeit im Team aufteilt, entscheidet ihr selbst. Am Ende stellt jedes Team seine Rolle den anderen vor und vergleicht: Was kann welche Welt besser, was kostet es, wie abhängig macht es die Schule von einem Hersteller?

Alle Maschinen laufen im **Proxmox-Labor** der Lehrperson. Ihr braucht **keine** eigene VM am Laptop, nur einen Browser. Siehe [Zugang zum Proxmox-Labor]({{% relref "proxmox-access" %}}).

{{% callout style="info" title="Hintergrund zum Nachlesen" %}}
DHCP, DNS und VLANs sind in [Kapitel 3 (Selbststudium)]({{% relref "/03-networking-2" %}}) erklärt. Lies dort mindestens die Abschnitte zu DHCP und DNS, bevor ihr die Rollen DHCP, DNS oder Verzeichnisdienst übernehmt.
{{% /callout %}}

## Die acht Rollen und die Teams

| Team | Rolle | Windows-Welt | Linux-Welt |
|---|---|---|---|
| 1 | [DHCP]({{% relref "roles/dhcp" %}}) | `10.50.13.10` Windows-DHCP-Server | `10.50.13.21` Kea |
| 2 | [DNS]({{% relref "roles/dns" %}}) | `10.50.13.11` Windows-DNS-Server | `10.50.13.22` BIND 9 |
| 3 (zu dritt) | [Verzeichnisdienst]({{% relref "roles/directory" %}}) | `10.50.13.12` Active Directory (AD DS) | `10.50.13.23` Samba AD (VM) |
| 4 | [Dateifreigaben]({{% relref "roles/file-shares" %}}) | `10.50.13.13` SMB-Freigaben mit NTFS-Rechten | `10.50.13.24` Samba |
| 5 | [Drucken]({{% relref "roles/print" %}}) | `10.50.13.14` Druckserver | `10.50.13.25` CUPS |
| 6 | [Web]({{% relref "roles/web" %}}) | `10.50.13.15` IIS | `10.50.13.26` nginx |
| 7 | [Client-Verteilung]({{% relref "roles/deployment" %}}) | `10.50.13.16` Windows-Referenzrechner | `10.50.13.27` FOG Project (VM) |
| 8 | [Fernzugriff]({{% relref "roles/remote-access" %}}) | `10.50.13.17` Remotedesktop (RDP) | `10.50.13.28` SSH und xrdp |

Die Zuteilung der Personen zu den Teams erfolgt zu Beginn der ersten Einheit.

## IP-Plan des Labors

Alle Maschinen liegen in **einem** Netz, dem **Labor-VLAN 50**. Es ist vom übrigen Netz der Lehrperson getrennt und hat Internetzugang über den Labor-Router.

| Bereich | Verwendung |
|---|---|
| `10.50.13.0/24` | Labor-VLAN 50, Netzmaske `255.255.255.0` |
| `.10–.17` | Server der Windows-Welt (Teams 1–8) |
| `.18–.19` | Windows-Welt, Lehrperson (Demo Zertifikatsdienste) |
| `.21–.28` | Server der Linux-Welt (Teams 1–8) |
| `.29–.30` | Linux-Welt, Lehrperson |
| `.100–.119` | DHCP-Bereich des Windows-DHCP-Servers (Team 1) |
| `.120–.139` | DHCP-Bereich von Kea (Team 1) |
| `.254` | **Labor-Router**: Gateway und DNS-Weiterleitung. Er vergibt **keine** Adressen per DHCP. Niemand außer der Lehrperson ändert ihn. |

Alle Server haben **feste Adressen**. Als DNS-Server verwenden sie zuerst `10.50.13.254`. Sobald DNS und Verzeichnisdienst laufen, stellen die Server der Windows-Welt auf `10.50.13.12` (Domänencontroller) um, die der Linux-Welt auf `10.50.13.23`.

| Domäne | Welt | Zuständig |
|---|---|---|
| `win.schule.lan` | Windows-Welt | Team 3 (AD DS mit integriertem DNS), Team 2 (Weiterleitungen, Zonen) |
| `linux.schule.lan` | Linux-Welt | Team 3 (Samba AD), Team 2 (BIND, Weiterleitungen) |

## Testclients

Ob eine Rolle wirklich funktioniert, zeigt sich am Gerät einer Lehrerin oder eines Schülers. Dafür stellt die Lehrperson **zwei Testclients** bereit (ab Ende der ersten Einheit):

- **Windows-Testclient:** Windows 11 Enterprise (Evaluation), bekommt seine Adresse vom Windows-DHCP-Server und tritt der Domäne `win.schule.lan` bei.
- **Linux-Testclient:** Debian 13 mit Xfce-Oberfläche, bekommt seine Adresse von Kea und tritt der Domäne `linux.schule.lan` bei.

Alle Teams dürfen die Testclients verwenden und neu starten. Zurücksetzen kann sie nur die Lehrperson. Sprecht euch ab, wer gerade womit testet.

## Ablauf der Einheiten

**Einheit 1 (16.11.2026, 08:45–13:00): Jede Rolle läuft für sich**

| Uhrzeit | Dauer | Inhalt |
|---|---|---|
| 08:45–09:15 | 30 min | Einführung: Was ist eine Serverrolle? Die Rollen einer Schule im Überblick, Windows und Linux im Vergleich |
| 09:15–09:30 | 15 min | Proxmox-Zugang, Teamtabelle, IP-Plan, Regeln im Labor |
| 09:30–10:45 | 75 min | Teamarbeit: eigene Rolle **für sich** in beiden Welten aufbauen (lokale Benutzer, noch ohne Domäne) |
| 10:45–11:00 | 15 min | Pause |
| 11:00–12:15 | 75 min | Teamarbeit (Fortsetzung), erste Abnahmetests |
| 12:15–12:30 | 15 min | Pause |
| 12:30–13:00 | 30 min | Statusrunde: Jedes Team zeigt in einer Minute, was in beiden Welten läuft und was nicht. Erster Eintrag ins Rollen-Runbook |

**Einheit 2 (23.11.2026, 08:45–13:00): Die Rollen arbeiten zusammen**

| Uhrzeit | Dauer | Inhalt |
|---|---|---|
| 08:45–09:00 | 15 min | DNS-Weiterleitungen zwischen den Welten, Testclients treten ihrer Domäne bei |
| 09:00–10:15 | 75 min | Integration: Freigaben, Drucker und Fernzugriff mit Domänenkonten, DHCP verteilt den richtigen DNS-Server, Tests vom Testclient |
| 10:15–10:30 | 15 min | Pause |
| 10:30–11:15 | 45 min | Kombinationen Windows und Linux (Linux-Client an Windows-AD, Windows-Client an Samba-Freigabe, PXE-Start mit FOG), Demo der Lehrperson: Zertifikatsdienste |
| 11:15–11:30 | 15 min | Pause |
| 11:30–12:30 | 60 min | [Rollenpräsentationen]({{% relref "presentation" %}}): 8 Teams × 6 min, mit Wechselzeit |
| 12:30–13:00 | 30 min | Abschluss, Überleitung zu Einheit 5 (Geräteverwaltung baut auf diesen Rollen auf) |

## Was abgegeben wird

- **Rollen-Runbook** (bewertet, Abgabe **06.12.2026**): siehe [Dokumentationsaufgabe]({{% relref "documentation" %}}).
- **Rollenpräsentation** (Pflicht, nicht bewertet): siehe [Rollenpräsentation]({{% relref "presentation" %}}).
- Eine eigene Hausaufgabe gibt es in diesem Kapitel **nicht**.

{{% pages display="tree" levels="1" %}}
