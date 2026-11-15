+++
title = "Zugang zum Proxmox-Labor"
weight = 15
+++

Alle Server und Testclients dieses Kapitels laufen auf einem **Proxmox-VE-Server** der Lehrperson. Proxmox ist selbst ein Beispiel für die Linux-Welt: ein freier Hypervisor auf Debian-Basis, der virtuelle Maschinen (VMs) und Linux-Container (LXC) verwaltet (siehe [Kapitel 1]({{% relref "/01-virtualization-containerization" %}})).

## Anmelden

1. Die Adresse der Proxmox-Weboberfläche und deine Zugangsdaten bekommst du in der Einheit.
2. Beim Anmelden als **Realm** `Proxmox VE authentication server` wählen.
3. Links im Baum siehst du nur die Maschinen **deines Teams** (Pool `pool-team<N>`) und die beiden **Testclients**.

{{% callout style="warning" title="Nur über die Konsole" %}}
Das Labor-VLAN ist vom Universitätsnetz aus **nicht** erreichbar. Du kannst dich also **nicht** per SSH oder Remotedesktop vom Laptop aus verbinden. Alles läuft über die **Konsole** in der Proxmox-Weboberfläche, alle Tests laufen innerhalb des Labors. Für Tests „von außen“ verwendet ihr die Testclients oder eine Maschine eines anderen Teams.
{{% /callout %}}

## Die Konsole bedienen

| Maschine | Konsole | Tipp |
|---|---|---|
| Windows Server (VM) | *Console* (noVNC) | Strg+Alt+Entf über das Menü links (*Send Key*). Kopieren und Einfügen funktioniert in noVNC nur eingeschränkt. Längere Befehle über die Zwischenablage-Schaltfläche links einfügen. |
| Debian-Container (LXC) | *Console* (xterm.js) | Einfügen mit Strg+Umschalt+V bzw. Rechtsklick. Anmeldung als `root` oder mit dem Konto, das die Lehrperson angelegt hat. |
| Debian-VM (Teams 3 und 7) | *Console* | Installation vom Debian-Image, das bereits eingebunden ist (siehe Rollenkarte). |
| Testclients | *Console* (noVNC) | Grafische Oberfläche. Vor dem Testen kurz im Team-Kanal ansagen, wer den Testclient gerade verwendet. |

## Was du in Proxmox darfst

| Darfst du | Darfst du nicht |
|---|---|
| Konsole öffnen, starten, herunterfahren, neu starten | Maschinen anlegen, löschen oder ihre Hardware ändern |
| **Snapshots** deiner Maschinen anlegen und zurücksetzen | Maschinen anderer Teams sehen oder bedienen |
| ISO-Image im CD-Laufwerk wechseln | Netzwerkeinstellungen in Proxmox ändern |
| Testclients bedienen und neu starten | Testclients zurücksetzen (nur die Lehrperson) |

## Snapshots: deine Rückfahrkarte

Jede deiner Maschinen hat den Snapshot **`clean-start`**, den Zustand vor der ersten Einheit. Lege **vor jedem größeren Schritt** einen eigenen Snapshot an (*Snapshots → Take Snapshot*), z. B. `vor-dhcp-bereich`. Geht etwas schief, setzt du mit *Rollback* zurück.

Ein Snapshot ist praktisch, aber **kein Ersatz für die Spalte „Zurücknehmen“ im Runbook**: An einer Schule gibt es für den produktiven Domänencontroller nicht einfach einen Rollback-Knopf.

## Regeln im Labor

1. **Feste Adressen nur aus deinem Bereich** (siehe IP-Plan im [Kapitelüberblick]({{% relref "/04-server-administration" %}})). Eine doppelt vergebene Adresse legt die Maschine eines anderen Teams lahm.
2. **Kein zusätzlicher DHCP-Server.** Im Labor-VLAN vergeben nur der Windows-DHCP-Server und Kea von Team 1 Adressen, und auch die nur an die Testclients. Viele Programme (z. B. FOG, Docker, dnsmasq) bieten an, einen eigenen DHCP-Server zu starten: immer **ablehnen**.
3. **Der Labor-Router `10.50.13.254` ist tabu.** Er ist Gateway und DNS-Weiterleitung für alle.
4. **Keine echten Personendaten.** Benutzerkonten heißen z. B. `lehrer01`, `schueler01`, nicht wie echte Personen.
5. **Passwörter** für Testkonten notiert ihr im Runbook nur als Platzhalter (`<Passwort aus Passwortmanager>`), nie im Klartext im Portfolio.
6. **Windows-Evaluation:** Die Windows-Server-VMs laufen mit der **Evaluationsversion** (180 Tage ab Installation). Sie ist für das Labor gedacht, nicht für den Betrieb an einer Schule.
