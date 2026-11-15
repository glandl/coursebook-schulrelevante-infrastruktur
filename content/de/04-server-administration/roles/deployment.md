+++
title = "Team 7: Client-Verteilung"
weight = 7
+++

**FOG Project:** `10.50.13.27` (Debian-**VM**) · **Windows-Referenzrechner:** `10.50.13.16` · **zwei leere Zielrechner** (VMs ohne Betriebssystem)

## Die Rolle an einer Schule

Ende August: 25 Rechner im EDV-Raum, darauf ein Schuljahr lang Spuren von 300 Schülerinnen und Schülern. Statt jeden Rechner einzeln neu zu installieren, richtet man **einen** Rechner sauber ein (*Referenzrechner*), nimmt ein **Abbild** (*Image*) davon und spielt es über das Netz gleichzeitig auf alle anderen. Die Rechner starten dafür über das Netz (**PXE**), holen sich ein kleines Startprogramm und schreiben das Abbild auf ihre Festplatte.

## Warum hier nur eine Welt?

Für diese Rolle gibt es **keinen** Windows-Server-Teil. Die frühere Windows-Lösung, die *Windows-Bereitstellungsdienste* (WDS) mit dem *Microsoft Deployment Toolkit* (MDT), wird von Microsoft nicht mehr weiterentwickelt. Microsoft setzt stattdessen auf **Windows Autopilot** und **Intune**, also auf die Cloud (siehe Einheit 5). Prüft den aktuellen Stand in den Quellen.

**FOG Project** ist freie Software, läuft auf Linux und verteilt **Windows- und Linux-Abbilder**, auch gleichzeitig an einen ganzen Raum (*Multicast*). „Beide Welten“ heißt für euer Team also: **ein Windows-Abbild und ein Linux-Abbild** mit demselben freien Werkzeug.

## Abhängigkeiten

- Einheit 1: keine. Ihr installiert die Debian-VM und FOG.
- Einheit 2: **DHCP (Team 1)** muss euren Maschinen die PXE-Optionen 66 und 67 mitgeben. Ohne das startet kein Rechner über das Netz.

## Ziel in Einheit 1

1. **Debian-VM** installiert (Debian-13-Image ist eingebunden; minimal, ohne grafische Oberfläche, mit SSH-Server), feste Adresse `10.50.13.27`, Rechnername `fog`.
2. **FOG Project** installiert (aktuelle stabile Version aus dem offiziellen Repository, Installationsskript `installfog.sh`).
3. Weboberfläche `http://10.50.13.27/fog/` erreichbar (vom Windows-Testclient aus), Standardkennwort geändert.
4. Zwei **Abbild-Definitionen** angelegt: `win-referenz` (Windows) und `debian-referenz` (Linux).
5. MAC-Adressen eurer drei Maschinen (Referenzrechner, zwei Zielrechner) notiert und an Team 1 gegeben. Stellt in Proxmox fest, ob die Maschinen mit BIOS (SeaBIOS) oder UEFI (OVMF) starten.

{{% callout style="warning" title="FOG darf keinen eigenen DHCP-Server starten" %}}
Das Installationsskript fragt, ob FOG DHCP übernehmen soll. Die Antwort ist **Nein** (auch bei der Frage nach DHCP-Router und DNS). Im Labor-VLAN gibt es bereits zwei DHCP-Server von Team 1. Ein dritter würde allen Teams falsche Adressen geben.
{{% /callout %}}

## Ziel in Einheit 2

1. Mit Team 1: Die Zielrechner und der Referenzrechner bekommen per DHCP `next-server 10.50.13.27` und die passende Startdatei (`undionly.kpxe` für BIOS, `ipxe.efi` für UEFI).
2. **Linux-Abbild:** Auf Zielrechner 1 ein minimales Debian installieren, als `debian-referenz` aufnehmen (*Capture*), auf Zielrechner 2 verteilen (*Deploy*).
3. **Windows-Abbild:** Den Referenzrechner `.16` als `win-referenz` aufnehmen und auf einen Zielrechner verteilen.
4. Optional: **Multicast** auf beide Zielrechner gleichzeitig.

## Abnahmetests

| Test | Nachweis |
|---|---|
| FOG läuft | Weboberfläche vom Windows-Testclient erreichbar, Dashboard zeigt den Speicherknoten |
| PXE-Start | Zielrechner zeigt beim Start das FOG-Menü (Screenshot der Konsole) |
| Registrierung | Zielrechner erscheinen unter *Hosts* mit ihrer MAC-Adresse |
| Aufnahme | Abbild `debian-referenz` hat unter *Images* eine Größe > 0 |
| Verteilung | Zielrechner 2 startet nach der Verteilung das Debian vom Referenzrechner (gleicher Rechnername, gleiche Dateien) |

## Stolpersteine

- Kein PXE-Menü: Startreihenfolge in Proxmox (*Options → Boot Order*: Netzwerk zuerst), DHCP-Optionen, falsche Startdatei für BIOS/UEFI.
- Zielplatte kleiner als die Quelle: Abbildtyp *Single Disk – Resizable* wählen.
- Windows-Abbilder werden in der Praxis vorher mit **Sysprep** verallgemeinert, damit nicht 25 Rechner dieselbe Kennung haben. Im Labor dürft ihr das weglassen, im Runbook gehört es erklärt.
- Abbilder brauchen viel Platz. Die VM hat ca. 60 GB, das reicht für zwei kleine Abbilder.
- Das Installationsskript ändert viel am System (Webserver, Datenbank, TFTP, NFS). Vorher einen Snapshot anlegen.

## Einstiegspunkte

- FOG Project: [Dokumentation](https://docs.fogproject.org/), [Installation](https://docs.fogproject.org/en/latest/installation/), [Quellcode](https://github.com/FOGProject/fogproject)
- FOG Project: [Using FOG with an unmodifiable DHCP server / ProxyDHCP](https://docs.fogproject.org/) (Suche nach *DHCP*)
- iPXE: [Dokumentation](https://ipxe.org/docs)
- Microsoft Learn: [Windows Autopilot (Überblick)](https://learn.microsoft.com/de-de/autopilot/overview), [Sysprep](https://learn.microsoft.com/de-de/windows-hardware/manufacture/desktop/sysprep--generalize--a-windows-installation)

## Vergleichsfragen

- Abbild im eigenen Haus (FOG) oder Bereitstellung aus der Cloud (Autopilot): Was braucht jede Lösung (Lizenzen, Internetbandbreite, Hardware-Kennungen beim Hersteller registriert)?
- Wie lange dauert es, 25 Rechner mit FOG neu aufzusetzen, wie lange von Hand?
- Was passiert mit den Daten der Schülerinnen und Schüler auf den alten Festplatten?
- FOG wird von einer Gemeinschaft entwickelt. Was bedeutet das für Unterstützung im Notfall, was für die Abhängigkeit von einem Hersteller?
