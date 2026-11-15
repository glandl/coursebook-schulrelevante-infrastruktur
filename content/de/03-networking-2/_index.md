+++
title = "Netzwerktechnik II: VLANs, DNS, DHCP"
type = "chapter"
weight = 3
+++

**Selbststudium** · keine eigene Einheit · nicht bewertet · **Zeitbedarf:** ca. 2 Stunden Theorie, optional ca. 2 Stunden Lab

{{% callout style="info" title="Selbststudium" %}}
Dieses Kapitel hat **keine eigene Einheit** im Stundenplan und **keine** Hausaufgabe oder bewertete Abgabe. Du arbeitest es selbstständig durch. Es ist die Grundlage für [Kapitel 4 (Serverrollen)]({{% relref "/04-server-administration" %}}) am 16.11. und 23.11.2026: Wer dort die Rollen **DHCP**, **DNS** oder **Verzeichnisdienst** übernimmt, sollte die entsprechenden Abschnitte der Theorie vorher gelesen haben.
{{% /callout %}}

In [Einheit 2]({{% relref "/02-networking-1" %}}) hast du das Netz der *Mittelschule Musterstadt* geplant: ein IP-Plan mit einem eigenen Netz pro Gruppe (Verwaltung, Lehrende, Schüler-WLAN, Server, …) und ein kleines Schulnetz in Packet Tracer. Offen blieb die Frage aus Lab-Schritt 3.8: Warum landen WLAN-Geräte im selben Netz wie die Lehrenden-PCs, und wie trennt man das, **ohne** für jede Gruppe eigene Switches zu kaufen?

Dieses Kapitel beantwortet drei Fragen:

1. **VLANs:** Wie trennt man mehrere Netze auf denselben Switches, und wo wird entschieden, wer mit wem sprechen darf?
2. **DHCP:** Wie bekommt ein Gerät seine Adresse, ohne dass jemand sie eintippt, auch über VLAN-Grenzen hinweg?
3. **DNS:** Wie findet ein Gerät einen Server über seinen Namen, im Schulnetz und im Internet?

| Seite | Inhalt | Pflicht? |
|---|---|---|
| [Lernziele]({{% relref "learning-goals" %}}) | Was du danach kannst | lesen |
| [Theorie]({{% relref "theory" %}}) | VLANs, Berechtigungsmatrix, DHCP, DNS, Captive Portal | lesen (Vorbereitung für Kapitel 4) |
| [Lab mit Lösungen]({{% relref "lab" %}}) | VLANs und Zugriffsregeln in Packet Tracer, DNS und DHCP in der Debian-VM | **freiwillig** |
| [Sicherheit und Datenschutz]({{% relref "security" %}}) | Was bei VLANs, DHCP und DNS schiefgehen kann | lesen |
| [Quellen]({{% relref "sources" %}}) | Standards und Dokumentationen | bei Bedarf |

{{% pages display="tree" levels="1" %}}
