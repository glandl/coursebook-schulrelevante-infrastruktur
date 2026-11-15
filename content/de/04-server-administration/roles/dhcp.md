+++
title = "Team 1: DHCP"
weight = 1
+++

**Windows-Welt:** `10.50.13.10`, Windows-DHCP-Server · **Linux-Welt:** `10.50.13.21`, Kea DHCPv4 (Debian-Container)

## Die Rolle an einer Schule

Am ersten Schultag klappen 25 Schülerinnen und Schüler ihre Laptops auf, und alle sind sofort im Netz. Niemand tippt eine IP-Adresse ein. Der DHCP-Server teilt jedem Gerät Adresse, Netzmaske, Gateway und DNS-Server zu und merkt sich, wem er was „geliehen“ hat (*Lease*). In echten Schulnetzen hat jedes VLAN einen eigenen Bereich, der Router leitet die Anfragen per DHCP-Relay an einen zentralen Server weiter (siehe [Kapitel 3]({{% relref "/03-networking-2/theory" %}}#dhcp)).

## Abhängigkeiten

- **Keine** für Einheit 1. DHCP ist die erste Rolle, die ein Gerät braucht.
- Für Einheit 2: Die DNS-Server der Domänen (`10.50.13.12`, `10.50.13.23`) müssen laufen, bevor ihr sie als DHCP-Option verteilt.

## Ziel in der Windows-Welt

- Die Rolle **DHCP-Server** ist auf `10.50.13.10` installiert.
- Ein Bereich (*Scope*) `10.50.13.100–10.50.13.119`, Netzmaske `255.255.255.0`, Lease-Dauer 8 Stunden.
- Optionen: Router `10.50.13.254`, DNS-Server `10.50.13.254` (in Einheit 2: `10.50.13.12`).
- Ein **MAC-Filter (Zulassungsliste)**: Der Server antwortet **nur** dem Windows-Testclient. Die MAC-Adresse bekommt ihr von der Lehrperson.
- Hinweis: PowerShell-Modul `DhcpServer`, Cmdlets beginnen mit `Add-DhcpServerv4…` und `Set-DhcpServerv4…`.

## Ziel in der Linux-Welt

- Paket `kea-dhcp4-server` ist installiert, der Dienst läuft.
- Ein Subnetz `10.50.13.0/24` mit einem Pool `10.50.13.120–10.50.13.139`, gleiche Optionen wie oben (DNS in Einheit 2: `10.50.13.23`).
- Eine **Client-Klasse**, die nur die MAC-Adresse des Linux-Testclients zulässt. Der Pool ist nur für diese Klasse freigegeben.
- Die Konfiguration steht in `/etc/kea/kea-dhcp4.conf` (JSON). Vor dem Neustart prüfen: `kea-dhcp4 -t /etc/kea/kea-dhcp4.conf`.

## Ziel in Einheit 2

1. Nach dem Domänenbeitritt verteilt jeder Server den **DNS-Server seiner Domäne** und den **Domänennamen** (Option 15).
2. Windows: Der DHCP-Server wird im Active Directory **autorisiert** (sonst startet er in einer Domäne nicht).
3. **PXE für Team 7:** Für die Maschinen von Team 7 (Referenzrechner und Zielrechner, MAC-Adressen von Team 7) verteilt ihr die Optionen **66** (*Next Server* = `10.50.13.27`) und **67** (*Boot-Datei*, abhängig von BIOS oder UEFI, Team 7 sagt euch welche). Entscheidet gemeinsam, ob Windows-DHCP oder Kea diese Maschinen bedient.
4. **Kombination:** Tauscht die MAC-Adressen in den beiden Zulassungslisten. Jetzt bekommt der Windows-Testclient seine Adresse von Kea und der Linux-Testclient von Windows. Merkt der Client einen Unterschied?

## Abnahmetests

| Test | Windows-Testclient | Linux-Testclient |
|---|---|---|
| Adresse aus dem richtigen Bereich | `ipconfig /all` zeigt `.100–.119` und *DHCP-Server: 10.50.13.10* | `ip -br addr` zeigt `.120–.139` |
| Lease erneuern | `ipconfig /release`, dann `ipconfig /renew` | `nmcli device disconnect <interface>`, dann `nmcli device connect <interface>` |
| Server kennt den Lease | `Get-DhcpServerv4Lease -ScopeId 10.50.13.0` | Kea-Log: `journalctl -u kea-dhcp4-server` |
| Fremde Geräte bekommen **nichts** | ein anderes Gerät ohne Eintrag in der Liste bekommt keine Adresse | wie links |

## Stolpersteine

{{% callout style="warning" title="Zwei DHCP-Server im selben Netz" %}}
Windows-DHCP und Kea hören **beide** jede DHCP-Anfrage im Labor-VLAN. Ohne Zulassungsliste antwortet der schnellere, und der Client bekommt womöglich den falschen DNS-Server. Startet keinen Bereich und keinen Pool **ohne** MAC-Filter.
{{% /callout %}}

- Der Server selbst braucht eine **feste** Adresse, sonst vergibt er sich im schlimmsten Fall selbst eine.
- Kea startet nicht, wenn das JSON einen Tippfehler hat. Immer zuerst mit `-t` prüfen.
- MAC-Adressen werden unterschiedlich geschrieben (`BC-24-11-…` bei Windows, `bc:24:11:…` bei Kea).
- Bei Kea muss das richtige Netzwerk-Interface (`eth0`) in `interfaces-config` stehen.

## Einstiegspunkte

- Microsoft Learn: [DHCP-Server mit PowerShell bereitstellen](https://learn.microsoft.com/de-de/windows-server/networking/technologies/dhcp/dhcp-deploy-wps)
- Microsoft Learn: [DhcpServer-Modul (PowerShell)](https://learn.microsoft.com/de-de/powershell/module/dhcpserver/)
- ISC: [Kea Administrator Reference Manual](https://kea.readthedocs.io/), Kapitel *The DHCPv4 Server* und *Client Classification*
- Debian: `/usr/share/doc/kea-dhcp4-server/` und `man kea-dhcp4`

## Vergleichsfragen

- Wie viele Zeilen PowerShell gegenüber wie vielen Zeilen JSON? Was ist leichter zu prüfen und zu versionieren?
- Wie sichert ihr die Konfiguration und die Leases, und wie stellt ihr sie wieder her?
- Was kostet die Rolle (Server-Lizenz, Zugriffslizenzen pro Gerät bzw. Benutzer, *CAL*), was kostet Kea?
- Ausfallsicherheit: Windows kennt *DHCP-Failover*, Kea den *High-Availability-Hook*. Wie viel Aufwand ist das jeweils?
- Welche Daten speichert ein DHCP-Server über die Geräte der Schülerinnen und Schüler (MAC, Hostname, Zeitpunkt), und wie lange?
