+++
title = "Übung (Schulszenario)"
weight = 40
+++

Diese Übung ist **freiwillig** (nicht benotet), vertieft aber das Lab und bereitet die Hausaufgabe vor. Arbeite in Zweiergruppen.

## Szenario

Die *Mittelschule Musterstadt* (400 Schüler, 40 Lehrende) hat einen alten Server, der einmal ausfällt. Die Direktion fragt dich als IT-Verantwortliche/n:

> „Wir möchten eine Lernplattform, ein Wiki für das Kollegium und eine Dateiablage. Außerdem läuft die Notenverwaltung auf Windows Server 2016. Sollen wir alles auf neue Hardware kopieren oder gibt es etwas Besseres?“

## Aufgabe

1. **Dienste einordnen.** Erstelle eine Tabelle mit den vier Diensten (Lernplattform, Wiki, Dateiablage, Notenverwaltung) und notiere je Dienst:

   | Dienst | Betriebssystem-Anforderung | Schutzbedarf der Daten | Kritikalität | Empfehlung (VM / Container / Cloud) | Begründung |
   |---|---|---|---|---|---|

2. **Zielarchitektur skizzieren.** Zeichne mit Mermaid (siehe [Netzwerkdiagramme]({{% relref "/00-documentation/network-diagrams-ip-plans" %}})) einen Host mit VMs und Containern.
3. **Ressourcen schätzen.** Wie viele CPU-Kerne, wie viel RAM und Speicher braucht der Host mindestens? (Annahme: je Linux-VM 2 GB RAM, Windows-VM 4 GB, Container-Dienst 0,5 bis 1 GB, 30 % Reserve.)
4. **Ausfallszenario durchspielen.** Der Host fällt aus. Was geht verloren, wie schnell läuft der Betrieb wieder, was muss vorab bereitstehen? Notiere drei konkrete Maßnahmen.
5. **Präsentation:** Stellt in 3 Minuten euren Vorschlag der „Direktion“ (einem anderen Team) vor. Erklärt ohne Fachbegriffe, warum VMs oder Container.

## Leitfragen

- Muss die Notenverwaltung wirklich auf Windows laufen? Welche Auswirkungen hat ein Umzug?
- Wer betreut das System, wenn Sie krank sind?
- Wo liegen die Backups, und wann wurde zuletzt ein Restore getestet?
- Welche Daten dürfen die Schule nicht verlassen?

## Erweiterung (für Schnelle)

Starte im Lab einen zweiten Dienst (z. B. [Wiki.js](https://hub.docker.com/r/requarks/wiki) oder [Uptime Kuma](https://hub.docker.com/r/louislam/uptime-kuma)) mit Docker Compose neben Nextcloud. Prüfe, wie viel RAM beide zusammen brauchen (`docker stats`), und ob die VM dafür reicht.
