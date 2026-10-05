+++
title = "Dokumentationsaufgabe"
weight = 50
+++

{{% callout style="info" title="Technik" %}}
Lies zuerst im Dokumentationsskript: [Netzwerkdiagramme und IP-Pläne]({{% relref "/00-documentation/network-diagrams-ip-plans" %}})
{{% /callout %}}

## Aufgabe in dieser Einheit

Dokumentiere dein Lab als **Portfolio-Eintrag** (Pflichtabgabe, bewertet nach der [Rubrik]({{% relref "/rubric" %}})). Das ist **nicht** die Hausaufgabe, sondern der Nachweis deiner Laborarbeit. Der Schwerpunkt liegt auf **Diagramm und IP-Plan** deines Filius-Netzes.

**Ablage:** `02-networking-1/README.md` mit Bildern und der Datei `schulnetz.fls` in `assets/`, Branch `einheit-02`, Abgabe per Pull Request.

### Inhalt

1. **Umgebung:** Host-Betriebssystem, Filius-Version, Java-Version, Ubuntu-Version der VM.
2. **Netzdiagramm (logische Ebene)** als Mermaid-Diagramm mit Titel, Datum, Version, Legende und beschrifteten Verbindungen (Router, Switches, AP, Server, Netze mit Adresse).
3. **Netzübersicht und Adresstabelle** nach der Vorlage des Dokumentationsskripts (Netz, Adresse, Gateway, DHCP-Bereich, Zweck; Hostname, IP, Standort, Zweck). Namen im Diagramm und in den Tabellen stimmen überein.
4. **Durchführung** der wichtigen Schritte: Adressen und Routen des Vermittlungsrechners, DHCP-Bereich, DNS-Eintrag (als Tabelle oder Codeblock, nicht nur als Screenshot).
5. **Nachweise:** Mindestens **vier Screenshots**: Topologie in Filius, `ipconfig` eines DHCP-Clients, ein erfolgreicher Ping oder Browser-Zugriff zwischen Netzen, das Fenster *Datenaustausch* mit einer DHCP- oder DNS-Anfrage. Dazu die Ausgabe `ip -br addr` und `ip route` der Ubuntu-VM als Text.
6. **Probleme und Lösungen:** Mindestens ein aufgetretenes Problem mit Ursache und Lösung (z. B. die absichtlich herbeigeführte Störung aus 3.6).
7. **Reflexion (Schulkontext), ca. 150–200 Wörter:** Was würde sich in einem echten Schulnetz gegenüber der Simulation ändern (Anzahl der Geräte, WLAN, Verwaltung, Sicherheit, Zuständigkeit)? Was ist die größte Fehlerquelle bei der Netzplanung?
8. **Quellen:** Verwendete Anleitungen und Dokumentationen.

### Abgabe

- Pull Request auf `main` mit der PR-Vorlage aus dem Dokumentationsskript.
- Frist: gemeinsam mit der Hausaufgabe am **08.11.2026**. _Endgültige Frist für das Portfolio wird in der Einheit bestätigt._

### Kontrollliste

- [ ] README folgt der Vorlage (Ziel, Durchführung, Ergebnis, Probleme, Reflexion, Quellen).
- [ ] Diagramm mit Titel, Datum, Version, Legende; Verbindungen beschriftet.
- [ ] IP-Plan und Diagramm verwenden dieselben Namen und Adressen.
- [ ] Befehle sind kopierbar (Codeblöcke), Screenshots in `assets/` mit Alternativtext.
- [ ] Keine Passwörter im Repository, keine echten Adressen oder Namen aus dem Schulnetz.
- [ ] Mindestens drei sinnvolle Commits mit aussagekräftigen Nachrichten.
- [ ] Pull Request geöffnet, Reviewer eingetragen.
