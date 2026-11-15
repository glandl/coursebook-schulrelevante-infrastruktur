+++
title = "Sicherheit und Datenschutz"
weight = 80
+++

{{% callout style="warning" title="Keine Rechtsberatung" %}}
Dieser Abschnitt gibt eine technische Orientierung. Rechtliche Fragen (z. B. Protokollierung, Speicherdauer, Jugendschutzfilter) klärt die Schule mit der Datenschutzbeauftragten bzw. dem Datenschutzbeauftragten und dem Schulerhalter.
{{% /callout %}}

## Das Wichtigste in Kürze

| Thema | Maßnahme |
|---|---|
| **VLAN ist keine Firewall** | Zwischen VLANs immer Zugriffsregeln nach der Berechtigungsmatrix. Ohne Regeln erreicht jedes VLAN jedes andere über den Router. |
| **Native VLAN** | Auf Trunks nicht VLAN 1 als ungetaggtes VLAN verwenden, sondern ein eigenes, sonst ungenutztes VLAN. Das erschwert *VLAN Hopping* (ein Angreifer schickt Rahmen mit zwei Tags). |
| **Ungenutzte Ports** | Abschalten (`shutdown`) und einem ungenutzten VLAN zuordnen. Netzwerkdosen in Klassenräumen sind frei zugänglich. |
| **Kein automatischer Trunk** | Ports zu Endgeräten fest als Access-Port einstellen (`switchport mode access`), damit kein Gerät einen Trunk aushandeln kann. |
| **Fremde DHCP-Server** | *DHCP Snooping* am Switch: DHCP-Antworten nur von den Ports der echten Server. |
| **Netzwerkmanagement** | Switches, Access Points und Router nur aus dem Management-VLAN (99) verwalten, nie aus dem Schüler- oder Gäste-WLAN. |
| **DNS-Resolver** | Rekursive Anfragen nur aus dem eigenen Netz beantworten, sonst wird der Server für Angriffe auf Dritte missbraucht. |
| **Gäste-WLAN** | Eigenes VLAN, nur Internet, Geräte untereinander isoliert. Ein Captive Portal verschlüsselt nichts. |

## Datenschutz im Schulkontext

- **DHCP-Protokolle** zeigen, welches Gerät (MAC-Adresse, Gerätename wie „Laptop-von-Anna“) wann im Netz war. Das sind personenbezogene Daten, auch bei Schülerinnen und Schülern.
- **DNS-Protokolle** zeigen, welche Seiten aufgerufen wurden. Sie sind aussagekräftiger als viele denken. Festlegen, ob protokolliert wird, wer die Protokolle sehen darf und wann sie gelöscht werden.
- **DNS-Filter** (z. B. für Jugendschutz) sind üblich. Sie sollten transparent sein: Schülerinnen, Schüler und Eltern sollten wissen, dass gefiltert wird und nach welchen Regeln.
- **Captive Portals** mit Anmeldung (Name, E-Mail, Telefonnummer) erheben Daten. Nur so viel abfragen wie nötig und die Daten nach kurzer Zeit löschen.
