+++
title = "Übung (Schulszenario)"
weight = 40
+++

Diese Übung ist **freiwillig** (nicht benotet), vertieft aber das Lab und bereitet die Hausaufgabe vor. Arbeite in Zweiergruppen.

## Szenario

Die *Mittelschule Musterstadt* erhält einen **neuen Klassentrakt** (ein Stockwerk) mit 12 Klassenräumen, einem EDV-Raum, einem Lehrerstützpunkt und einem Gang. Der Verteilerschrank steht am Ende des Gangs. Die Entfernung zum entferntesten Klassenraum beträgt etwa **60 m Kabellänge**. Jede Klasse hat bis zu 28 Schüler, die Tablets benutzen. Der Schulleiter fragt dich:

> „Wie viele Netzwerkdosen und WLAN-Geräte brauchen wir, was kostet das ungefähr, und wie sicher ist das Ganze?“

## Aufgabe

1. **Anforderungen sammeln.** Wie viele Geräte gleichzeitig pro Raum? Welche Dienste (Streaming, Updates, Prüfungen)? Welche Spitzenlast?
2. **Dosen und Kabel planen.** Wie viele Datendosen pro Klassenraum (Lehrerplatz, Beamer, AP, Reserve)? Welches Kabel (Kategorie)? Reicht ein Verteiler? Erstelle eine Stückliste (Dosen, Patchfelder, Switch-Ports mit Reserve).
3. **PoE-Budget rechnen.** 14 Access Points mit je 20 W (Annahme): Welche Gesamtleistung und welcher Switch-Typ (PoE-Standard, Portanzahl, Budget)?
4. **WLAN dimensionieren.** Wie viele Access Points, auf welchem Band, mit welcher Kanalbreite? Skizziere die Kanalverteilung für drei benachbarte Klassenräume (Mermaid oder Tabelle).
5. **Uplink und Internet.** Welche Bandbreite braucht der Uplink zum Hauptverteiler? Was bremst, wenn alle gleichzeitig Updates laden?
6. **Sicherheit.** Welche SSIDs und Netze? Wie melden sich Lehrende, Schüler und Gäste an? Wo hängen Drucker und Beamer?
7. **Präsentation:** Stellt in 3 Minuten euren Vorschlag dem „Schulleiter“ (einem anderen Team) vor. Erklärt ohne Fachbegriffe, warum ihr welche Entscheidung trefft.

## Leitfragen

- Was passiert, wenn ein Schüler zu Hause ein Kabel mit zwei Enden in zwei Dosen steckt?
- Wie finden Sie in zwei Jahren heraus, welche Dose zu welchem Port gehört?
- Wer darf das WLAN-Passwort kennen, und was passiert, wenn es jemand weitergibt?
- Was passiert in der Prüfung, wenn eine Klasse alle gleichzeitig ein Dokument herunterlädt?

## Erweiterung (für Schnelle)

Baue in Filius ein zweites Stockwerk mit eigenem Switch, einem eigenen Router-Anschluss und einem neuen Teilnetz, vergib Adressen und weise nach, dass beide Stockwerke miteinander und mit dem Server kommunizieren. Beschreibe, was bei Ausfall des Uplinks passiert.
