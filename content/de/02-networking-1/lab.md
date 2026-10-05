+++
title = "Praxis-Lab"
weight = 30
+++

{{% callout style="warning" title="Status: ungeprüft" %}}
Die Befehle und Einstellungen in diesem Lab wurden noch **nicht** in der Kursumgebung ausgeführt. Das gilt besonders für die Menüpunkte und Bezeichnungen in Filius (Teil 3). Stand der Software-Angaben: Oktober 2026. Prüfe Versionen vor dem Einsatz. *Getestet am: offen.*
{{% /callout %}}

## Überblick

| Teil | Inhalt | Dauer |
|---|---|---|
| 0 | Vorbereitung: Filius installieren (**vor der Einheit**) | 15 min (zu Hause) |
| 1 | Netzwerkwerkzeuge in der Ubuntu-VM aus Einheit 1 | 40 min |
| 2 | Subnetting und IP-Plan | 35 min |
| 3 | Schulnetz in Filius: Router, DHCP, DNS, Webserver | 45 min |

**Mindestausstattung:** wie in Einheit 1 (8 GB RAM, die VM `ubuntu-lab` aus Einheit 1) plus Filius (klein, benötigt Java).

**Verwendete Software:**

| Software | Version | Hinweis |
|---|---|---|
| Ubuntu Server (VM `ubuntu-lab`) | 24.04 LTS | aus Einheit 1 |
| Filius | aktuelle Version | kostenlos und ohne Konto, [lernsoftware-filius.de](https://www.lernsoftware-filius.de/); deutsche Oberfläche, läuft auf Windows, macOS und Linux (Java erforderlich, falls nicht mitgeliefert) |
| Python 3 | in Ubuntu enthalten | für Subnetting-Berechnungen (`ipaddress`) |

## Teil 0: Vorbereitung (vor der Einheit)

1. Filius von der Projektseite herunterladen und installieren (Hinweise zu Java auf der Download-Seite beachten). Starte das Programm einmal und speichere ein leeres Projekt, um zu prüfen, dass alles läuft.
2. Die VM `ubuntu-lab` aus Einheit 1 starten, per SSH anmelden (siehe [Einheit 1, Lab 1.4]({{% relref "/01-virtualization-containerization/lab" %}})).
3. Portfolio-Ordner anlegen:

```bash
cd <dein-portfolio>
git switch -c einheit-02
mkdir -p 02-networking-1/assets
```

### Ausweichlösungen

| Situation | Lösung |
|---|---|
| **Filius lässt sich nicht installieren** (Gerät gesperrt, Java fehlt) | Teil 3 gemeinsam am Beamer als Vorführung mitverfolgen, danach Teil 2 vertiefen. Die Dokumentationsaufgabe nutzt dann das Netz aus dem Beispiel der Lehrperson. |
| **VM `ubuntu-lab` nicht mehr vorhanden** | Teil 1 mit WSL2 oder einem Linux-Rechner durchführen. Die Adressen weichen dann ab, die Befehle sind gleich. |
| **Apple Silicon** | Filius benötigt eine passende Java-Version für arm64 (nicht verifiziert). Die VM läuft in UTM wie in Einheit 1. |

## Teil 1: Netzwerkwerkzeuge in der Ubuntu-VM

**Ziel:** Du liest Adresse, Gateway, DNS und offene Ports ab und prüfst das Netz von unten nach oben. Notiere alle Ausgaben in deiner Dokumentation.

### 1.1 Schnittstelle und Adresse (Schicht 1–3)

```bash
ip -br link        # Schnittstellen, Zustand (UP/DOWN), MAC-Adresse
ip -br addr        # IP-Adressen je Schnittstelle
ip route           # Routing-Tabelle, Standard-Gateway
```

**Erwartet (VirtualBox, NAT):** Eine Schnittstelle (meist `enp0s3`) mit `10.0.2.15/24` und `default via 10.0.2.2`. Das ist die Standardkonfiguration des VirtualBox-NAT-Netzes. Beantworte: Welche MAC-Adresse hat die VM? Welche Netzadresse und welcher Präfix? Wie viele Geräte passen in dieses Netz?

Gültigkeit der Adresse (DHCP-Lease) anzeigen:

```bash
ip addr show enp0s3     # Schnittstellennamen ggf. anpassen
```

In der Zeile `inet` steht `valid_lft <Sekunden>`: so lange gilt die per DHCP erhaltene Adresse noch.

### 1.2 Gateway und Internet (Schicht 3)

```bash
ping -c 3 10.0.2.2      # das Gateway
ping -c 3 1.1.1.1       # ein Ziel im Internet (nur per IP-Adresse)
```

**Erwartet:** Antworten ohne Paketverlust. Antwortet das Gateway, aber nicht `1.1.1.1`, liegt das Problem hinter dem Router (Internetanbindung).

### 1.3 Namensauflösung (DNS, Schicht 7)

```bash
resolvectl status | head -20      # welcher DNS-Server wird verwendet?
resolvectl query ubuntu.com       # Name auflösen
ping -c 3 ubuntu.com              # funktioniert nur, wenn DNS funktioniert
```

**Erwartet:** Als DNS-Server erscheint in VirtualBox-NAT meist `10.0.2.3`. Die Abfrage liefert eine oder mehrere Adressen. Merke dir: Funktioniert `ping 1.1.1.1`, aber nicht `ping ubuntu.com`, liegt das Problem bei **DNS**, nicht bei der Verbindung.

*Optional:* Mit `sudo apt install bind9-dnsutils` steht `dig ubuntu.com` zur Verfügung, das mehr Details zeigt.

### 1.4 Weg der Pakete

```bash
tracepath -n 1.1.1.1
```

**Erwartet:** Liste der Zwischenstationen (Hops). Der erste Hop ist das Gateway `10.0.2.2`. Einzelne Zeilen mit `no reply` sind normal (manche Geräte antworten nicht).

### 1.5 Nachbarn im lokalen Netz (ARP, Schicht 2)

```bash
ip neigh
```

**Erwartet:** Ein Eintrag für das Gateway `10.0.2.2` mit dessen MAC-Adresse (nach dem Ping). Das ist die ARP-Tabelle: Das Gerät kennt nur Nachbarn im **eigenen** Netz per MAC.

### 1.6 Wer lauscht auf welchem Port? (Schicht 4)

```bash
ss -tuln              # TCP und UDP, nur lauschende Ports, numerisch
sudo ss -tulpn        # zusätzlich mit Programmnamen
```

**Erwartet:** Der SSH-Server lauscht auf `0.0.0.0:22` (und `[::]:22`), außerdem lokale Dienste auf `127.0.0.x:53` (Namensauflösung). Beantworte: Welche dieser Ports sind von außen erreichbar, welche nur lokal (`127.0.0.1`)? Das ist die Grundfrage jeder Härtung.

Wenn du in Einheit 1 Docker-Container mit Portfreigabe gestartet hast, erscheinen sie ebenfalls (z. B. `:8080`).

### 1.7 Vergleich: anderes Netz (optional, 10 min)

Ändere in den VM-Einstellungen *Netzwerk → Angeschlossen an* von **NAT** auf **Netzwerkbrücke** (*Bridged Adapter*) und starte die VM neu. Prüfe dann erneut `ip -br addr` und `ip route`.

**Erwartet:** Die VM hat jetzt eine Adresse **aus dem Netz, in dem dein Laptop hängt** (z. B. WLAN der Schule). Beobachte Gateway und DNS. Stelle danach wieder **NAT** ein.

{{% callout style="warning" title="Nur mit Erlaubnis" %}}
Eine Netzwerkbrücke macht die VM zu einem **eigenständigen Gerät im Schulnetz**. Sie ist im Schul-WLAN oft nicht erlaubt oder technisch gesperrt. Führe diesen Schritt nur aus, wenn er erlaubt ist, und scanne niemals fremde Geräte oder Netze.
{{% /callout %}}

## Teil 2: Subnetting und IP-Plan

### 2.1 Rechnen mit Python

Python ist auf Ubuntu Server enthalten. Das Modul `ipaddress` rechnet Netze aus:

```bash
python3 - <<'EOF'
import ipaddress as ip
n = ip.ip_network("10.10.20.0/25")
print("Netzadresse:   ", n.network_address)
print("Netzmaske:     ", n.netmask)
print("Broadcast:     ", n.broadcast_address)
print("nutzbar von/bis:", n[1], "-", n[-2])
print("nutzbare Geräte:", n.num_addresses - 2)
EOF
```

**Erwartet:** Netzadresse `10.10.20.0`, Netzmaske `255.255.255.128`, Broadcast `10.10.20.127`, nutzbar `10.10.20.1 – 10.10.20.126`, 126 Geräte.

Weitere Fragen, die du mit Python (oder von Hand) beantwortest:

```bash
python3 -c "import ipaddress as ip; print(ip.ip_address('10.10.20.130') in ip.ip_network('10.10.20.0/25'))"
python3 -c "import ipaddress as ip; print(list(ip.ip_network('10.10.20.0/24').subnets(new_prefix=26)))"
```

Erkläre, was die beiden Zeilen ausgeben und warum.

### 2.2 IP-Plan für die Mittelschule Musterstadt

**Szenario:** Die *Mittelschule Musterstadt* (400 Schüler, 40 Lehrende) plant ihr Netz neu. Gesamtbereich: **`10.10.0.0/16`**. Konvention: **dritter Oktett = VLAN-ID**, Gateway immer `.1`. (VLANs werden in [Einheit 3]({{% relref "/03-networking-2" %}}) umgesetzt. Hier dient die ID zunächst als Nummer des Netzes.)

| Netz | VLAN | Geräte (geschätzt) | Hinweis |
|---|---|---|---|
| Verwaltung | 10 | 15 | Direktion, Sekretariat |
| Lehrende | 20 | 60 | rund 1,5 Geräte je Lehrperson |
| Schüler-WLAN | 30 | 350 | nicht alle 400 gleichzeitig mit Gerät |
| Server | 40 | 12 | interne Dienste |
| EDV-Raum | 50 | 30 | feste PCs |
| Gäste-WLAN | 60 | 60 | getrennt vom Schulnetz |
| Drucker und Geräte | 70 | 25 | Drucker, Beamer, Kopierer |
| Netzwerkmanagement | 99 | 30 | Switches, Access Points |

**Aufgabe:**

1. Rechne je Netz mit **30 % Reserve** (`Geräte × 1,3`, aufrunden).
2. Wähle den **kleinsten Präfix**, der reicht (Tabelle in der Theorie).
3. Trage Netzadresse (`10.10.<VLAN>.0/<Präfix>`), Gateway, nutzbaren Bereich und einen DHCP-Bereich ein (Server und Netzwerkgeräte bekommen feste Adressen, kein DHCP).
4. Prüfe die Ergebnisse mit Python.

Vorlage:

```markdown
| Netz | VLAN | Adresse | Gateway | nutzbar | DHCP-Bereich | Zweck |
|---|---|---|---|---|---|---|
| Verwaltung | 10 | 10.10.10.0/?? | 10.10.10.1 | … | … | … |
```

**Lösungsvorschlag (erst nach dem eigenen Versuch ansehen):**

| Netz | VLAN | Bedarf mit 30 % Reserve | Adresse | nutzbar |
|---|---|---|---|---|
| Verwaltung | 10 | 20 | 10.10.10.0/27 | .1 – .30 (30) |
| Lehrende | 20 | 78 | 10.10.20.0/25 | .1 – .126 (126) |
| Schüler-WLAN | 30 | 455 | 10.10.30.0/23 | 10.10.30.1 – 10.10.31.254 (510) |
| Server | 40 | 16 | 10.10.40.0/27 | .1 – .30 (30) |
| EDV-Raum | 50 | 39 | 10.10.50.0/26 | .1 – .62 (62) |
| Gäste-WLAN | 60 | 78 | 10.10.60.0/25 | .1 – .126 (126) |
| Drucker und Geräte | 70 | 33 | 10.10.70.0/26 | .1 – .62 (62) |
| Netzwerkmanagement | 99 | 39 | 10.10.99.0/26 | .1 – .62 (62) |

Der Rest des jeweiligen `/24` bleibt **reserviert** für Wachstum (z. B. kann `10.10.10.0/27` später zu `/26` oder `/25` erweitert werden, ohne die anderen Netze zu berühren). Das Schüler-WLAN belegt zwei /24-Blöcke (`30` und `31`), deshalb gibt es kein VLAN 31.

### 2.3 Ergebnis festhalten

Speichere deine ausgefüllte Tabelle als `02-networking-1/ip-plan-lab.md` im Portfolio. Sie wird in der [Dokumentationsaufgabe]({{% relref "documentation" %}}) wiederverwendet.

## Teil 3: Schulnetz in Filius

**Ziel:** Du baust ein kleines Schulnetz mit drei Netzen (Verwaltung, Lehrende, Server), vergibst Adressen von Hand und per DHCP, richtest DNS und einen Webserver ein und beobachtest, wie die Pakete durch die Schichten laufen. Die Adressen entsprechen dem Plan aus Teil 2. VLANs und Zugriffsregeln folgen in Einheit 3. **WLAN** lässt sich in Filius nicht simulieren und wird über Theorie, Übung und Hausaufgabe behandelt.

**Bedienung in Filius:** Das Programm hat zwei Modi. Im **Entwurfsmodus** (Hammer-Symbol) baust und konfigurierst du das Netz. Im **Aktionsmodus** (Play-Symbol) läuft die Simulation: Dort installierst du Software auf den Rechnern und führst Befehle aus. Die Namen der Menüpunkte können je nach Version abweichen.

### 3.1 Topologie aufbauen (ca. 8 min)

Entwurfsmodus: Komponenten per Drag and Drop auf die Arbeitsfläche ziehen und mit Kabeln verbinden.

| Gerät | Filius-Komponente | Name | Verbunden mit |
|---|---|---|---|
| Router | **Vermittlungsrechner** | `r1` | je ein Anschluss an `sw-verw`, `sw-lehr`, `sw-srv` |
| Switch | Switch | `sw-verw`, `sw-lehr`, `sw-srv` | `r1` und seine Rechner |
| Rechner Verwaltung | Rechner | `pc-verw-01`, `pc-verw-02` | `sw-verw` |
| DHCP-Server | Rechner | `srv-dhcp-01` | `sw-verw` |
| Rechner Lehrende | Rechner | `pc-lehr-01`, `pc-lehr-02` | `sw-lehr` |
| Webserver und DNS | Rechner | `srv-web-01` | `sw-srv` |

Benenne die Komponenten um (Doppelklick, Feld *Anzeigename*). Die Namen müssen exakt wie im Plan lauten. Der Vermittlungsrechner braucht **drei Netzwerkkarten** (Anschlüsse): Prüfe in seiner Konfiguration, dass drei Schnittstellen vorhanden sind.

### 3.2 Adressen festlegen (ca. 8 min)

Doppelklick auf die Komponente und die Adressen eintragen:

| Gerät | IP-Adresse | Netzmaske | Gateway | DNS-Server |
|---|---|---|---|---|
| `r1` Schnittstelle 1 (zu `sw-verw`) | `10.10.10.1` | `255.255.255.224` | – | – |
| `r1` Schnittstelle 2 (zu `sw-lehr`) | `10.10.20.1` | `255.255.255.128` | – | – |
| `r1` Schnittstelle 3 (zu `sw-srv`) | `10.10.40.1` | `255.255.255.224` | – | – |
| `srv-dhcp-01` | `10.10.10.2` | `255.255.255.224` | `10.10.10.1` | `10.10.40.10` |
| `srv-web-01` | `10.10.40.10` | `255.255.255.224` | `10.10.40.1` | `10.10.40.10` |
| `pc-lehr-01` | `10.10.20.10` | `255.255.255.128` | `10.10.20.1` | `10.10.40.10` |
| `pc-lehr-02` | `10.10.20.11` | `255.255.255.128` | `10.10.20.1` | `10.10.40.10` |
| `pc-verw-01`, `pc-verw-02` | per DHCP (3.3) | | | |

Die direkt verbundenen Netze kennt der Vermittlungsrechner von selbst. Eine Routing-Tabelle ist nur nötig, wenn Netze **hinter** einem weiteren Router liegen (hier nicht).

**Wichtig:** Für Verwaltung vergibt `srv-dhcp-01` später die Adressen. Im Lehrenden-Netz bleiben die Adressen **fest**, damit du beides vergleichen kannst. (Nach meiner Kenntnis arbeitet der DHCP-Server in Filius nur im eigenen Netz. In einem echten Schulnetz übernimmt meist der Router oder ein zentraler Server mit DHCP-Relay diese Aufgabe für alle Netze.)

### 3.3 Dienste einrichten (ca. 9 min)

Wechsle in den **Aktionsmodus**. Software installierst du per Doppelklick auf den Rechner → *Softwareinstallation* (Anwendung auswählen, installieren, anwenden).

1. **`srv-web-01`**: *Webserver* und *DNS-Server* installieren. Webserver starten (Doppelklick auf das Symbol). Im DNS-Server einen **Adress-Eintrag** anlegen: Name `web.schule.test` → `10.10.40.10`. (Die Endung `.test` ist für Übungen reserviert und kollidiert nicht mit echten Domains.) DNS-Server starten.
2. **`srv-dhcp-01`**: *DHCP-Server* installieren. Einstellungen: Adressbereich `10.10.10.10` bis `10.10.10.30`, Netzmaske `255.255.255.224`, Gateway `10.10.10.1`, DNS-Server `10.10.40.10`. DHCP **aktivieren** und starten. Die Adressen `.1` bis `.9` bleiben für feste Geräte frei (Router, Server).
3. **`pc-verw-01`, `pc-verw-02`**: In der Rechner-Konfiguration **DHCP zur Konfiguration verwenden** auswählen. Auf beiden Rechnern *Terminal* und *Webbrowser* installieren. Auf `pc-lehr-01` und `pc-lehr-02` ebenfalls.

**Erwartet:** Die Verwaltungs-PCs erhalten nach kurzer Zeit Adressen aus `10.10.10.10–30` samt Gateway und DNS-Server.

### 3.4 Testen von unten nach oben (ca. 8 min)

Auf `pc-verw-01` → *Terminal* (Befehle mit `help` anzeigen, falls ein Befehl anders heißt):

```text
ipconfig
ping 10.10.10.1
ping 10.10.20.10
ping 10.10.40.10
traceroute 10.10.40.10
ping web.schule.test
```

Öffne im *Webbrowser* `http://10.10.40.10` und danach `http://web.schule.test`. Wiederhole die Tests von `pc-lehr-01` aus.

**Erwartet:** Alle Pings sind erfolgreich. `traceroute` zeigt `10.10.10.1` als ersten Hop. Der Browser lädt die Startseite des Webservers, einmal per IP-Adresse und einmal per Name. Notiere: Welche Adresse hat `pc-verw-01` bekommen, und woher kommt sie?

### 3.5 Pakete beobachten (ca. 6 min)

Im Aktionsmodus: Rechtsklick auf `pc-verw-01` → **Datenaustausch** (Anzeige der Pakete). Starte auf dem PC erneut einen `ping` auf `10.10.40.10` und rufe die Webseite auf. Beobachte die Einträge je Schicht (Vermittlung/IP, Transport, Anwendung):

- Welche Pakete erscheinen **vor** dem ersten Ping (ARP, wer fragt nach wem)?
- Welche Adressen stehen als Quelle und Ziel im Paket, und was ändert sich beim Durchgang durch den Router?
- Beim Aufruf von `web.schule.test`: Wo erscheint die **DNS-Anfrage** und wo die HTTP-Anfrage?

Um den DHCP-Ablauf zu sehen, stelle `pc-verw-02` auf eine feste Adresse um, starte ihn neu oder aktiviere DHCP erneut und beobachte die Meldungen (DISCOVER, OFFER, REQUEST, ACK) am `srv-dhcp-01`. Vergleiche mit dem Diagramm in der Theorie.

### 3.6 Fehlersuche üben (ca. 6 min)

Baue einen Fehler ein und finde ihn mit der Schichten-Reihenfolge. Tausche mit einer Partnerin oder einem Partner: Einer baut einen Fehler ein, der oder die andere sucht.

| Fehler | Beobachtung | Ursache zeigen mit |
|---|---|---|
| Falsche **Netzmaske** am `pc-lehr-01` (z. B. `255.255.255.0`) | | `ipconfig`, Vergleich mit dem Plan |
| **Gateway** am `pc-lehr-01` gelöscht | Ping im eigenen Netz geht, ins andere nicht | `ipconfig`, `traceroute` |
| **DNS-Eintrag** entfernt | `ping 10.10.40.10` geht, `ping web.schule.test` nicht | DNS-Server prüfen |
| **Kabel** zwischen `r1` und `sw-srv` entfernt | Server nicht erreichbar | Entwurfsmodus, Topologie |

Stelle danach den Zustand wieder her.

### 3.7 Speichern und Screenshots

Speichere das Projekt als `02-networking-1/assets/schulnetz.fls`. Mache Screenshots: Topologie (mit sichtbaren Namen), `ipconfig` eines DHCP-Clients, ein Ping zwischen Netzen oder der Browser mit `web.schule.test` und das Fenster *Datenaustausch*.

## Erwartete Ergebnisse (Checkliste)

- [ ] `ip -br addr`, `ip route`, `resolvectl status` und `ss -tuln` der VM notiert und erklärt.
- [ ] Unterschied „Ping auf IP funktioniert, Name nicht“ erklärbar (DNS).
- [ ] IP-Plan (Teil 2) ausgefüllt, mit Python geprüft.
- [ ] Filius-Netz: Verwaltungs-PCs erhalten Adressen per DHCP, Lehrenden-PCs haben feste Adressen.
- [ ] Ping und Browser-Zugriff zwischen allen Netzen und auf den Webserver funktionieren, auch per Name.
- [ ] Im *Datenaustausch* ARP, DNS und HTTP gefunden und erklärt.
- [ ] Eingebauten Fehler selbst gefunden und repariert (3.6).
- [ ] Datei `schulnetz.fls` im Portfolio, keine echten Passwörter.

## Fehlersuche

| Problem | Ursache und Lösung |
|---|---|
| `ip -br addr` zeigt keine Adresse | Netzwerkmodus in VirtualBox prüfen (NAT?), VM neu starten. |
| `ping 1.1.1.1` geht, `ping ubuntu.com` nicht | DNS-Problem: `resolvectl status` prüfen, VM neu starten. |
| `tracepath` fehlt | `sudo apt install iputils-tracepath`. |
| Python meldet `ModuleNotFoundError` | `python3` verwenden (nicht `python`), das Modul `ipaddress` ist Teil der Standardbibliothek. |
| Filius: Simulation reagiert nicht | Aktionsmodus aktiv? Dienste (Webserver, DNS, DHCP) wirklich **gestartet**? |
| Filius: PC bekommt keine DHCP-Adresse | `srv-dhcp-01` im selben Netz wie der PC? DHCP aktiviert, Bereich und Netzmaske richtig? Beim PC *DHCP verwenden* gewählt? |
| Filius: Ping zwischen Netzen schlägt fehl | Gateway am Rechner eingetragen? Alle drei Schnittstellen von `r1` konfiguriert und mit dem richtigen Switch verbunden? |
| Filius: Name wird nicht aufgelöst | DNS-Server auf `srv-web-01` gestartet, Eintrag `web.schule.test` vorhanden, DNS-Server-Adresse am Rechner eingetragen? |
