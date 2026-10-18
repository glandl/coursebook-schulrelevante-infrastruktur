+++
title = "Praxis-Lab"
weight = 30
+++

{{% callout style="warning" title="Status: ungeprüft" %}}
Die Befehle und Einstellungen in diesem Lab wurden noch **nicht** in der Kursumgebung ausgeführt. Das gilt besonders für die Menüpunkte, Gerätemodelle und das DHCP-Relay in Packet Tracer (Teil 3) und für die erwarteten Adressen bei virt-manager, UTM und Hyper-V (Teil 1). Stand der Software-Angaben: Oktober 2026. Prüfe Versionen vor dem Einsatz. *Getestet am: offen.*
{{% /callout %}}

## Überblick

| Teil | Inhalt | Dauer |
|---|---|---|
| 0 | Vorbereitung: Cisco-Konto anlegen, Packet Tracer installieren (**vor der Einheit**) | 20 min (zu Hause) |
| 1 | Netzwerkwerkzeuge in der Debian-VM aus Einheit 1 | 40 min |
| 2 | Subnetting und IP-Plan | 35 min |
| 3 | Schulnetz in Packet Tracer: Router, DHCP, DNS, Webserver | 45 min |

**Mindestausstattung:** wie in Einheit 1 (8 GB RAM, die VM `debian-lab` aus Einheit 1) plus Cisco Packet Tracer (ca. 300 MB Download, ca. 1 GB Speicher).

**Verwendete Software:**

| Software | Version | Hinweis |
|---|---|---|
| Debian (VM `debian-lab`) | 13 „trixie“ | aus Einheit 1, mit VirtualBox, virt-manager, UTM oder Hyper-V |
| Cisco Packet Tracer | 9.0.1 | kostenlos, benötigt ein kostenloses Konto bei der [Cisco Networking Academy](https://www.netacad.com/); englische Oberfläche; Windows, macOS und Linux (`.deb`-Paket) |
| Python 3 | aus den Debian-Paketquellen (`sudo apt install python3`) | für Subnetting-Berechnungen (`ipaddress`) |

## Teil 0: Vorbereitung (vor der Einheit)

1. **Konto anlegen** bei der [Cisco Networking Academy](https://www.netacad.com/) (kostenlos). Packet Tracer gibt es dort über den Kurs *Getting Started with Cisco Packet Tracer* bzw. die Seite *Resources → Download Packet Tracer*.
2. **Packet Tracer installieren** und **einmal starten**. Beim ersten Start meldest du dich mit dem Konto an; das braucht Internet und klappt im WLAN der Einheit oft nicht zuverlässig. Speichere ein leeres Projekt, um zu prüfen, dass alles läuft.
3. Optional: das Einführungsvideo bzw. den ersten Abschnitt des Kurses *Getting Started with Cisco Packet Tracer* ansehen (Arbeitsfläche, Geräte, Kabel).
4. Die VM `debian-lab` aus Einheit 1 starten, per SSH anmelden (siehe [Einheit 1, Lab 1.4]({{% relref "/01-virtualization-containerization/lab" %}})).
5. Portfolio-Ordner anlegen:

```bash
cd <dein-portfolio>
git switch -c einheit-02
mkdir -p 02-networking-1/assets
```

{{% callout style="info" title="Datenschutz: Cisco-Konto" %}}
Für Packet Tracer legst du ein Konto bei einem US-Unternehmen an. Verwende eine Adresse, die du dafür verwenden willst, und lies die Datenschutzhinweise. Für den Unterricht mit **minderjährigen** Schülerinnen und Schülern ist das ein Punkt, den die Schule klären muss (siehe Reflexion in der Dokumentationsaufgabe).
{{% /callout %}}

### Ausweichlösungen

| Situation | Lösung |
|---|---|
| **Packet Tracer lässt sich nicht installieren** (Gerät gesperrt) oder **kein Cisco-Konto gewünscht** | Teil 3 zu zweit an einem Laptop durchführen oder am Beamer als Vorführung mitverfolgen. Die Dokumentationsaufgabe nutzt dann die gemeinsame Datei bzw. das Netz der Lehrperson. |
| **Anmeldung beim ersten Start schlägt fehl** (kein Internet, Konto noch nicht bestätigt) | Bestätigungs-E-Mail prüfen, Anmeldung zu Hause wiederholen. Ohne Anmeldung startet Packet Tracer nicht bzw. nur eingeschränkt (nicht verifiziert). |
| **VM `debian-lab` nicht mehr vorhanden** | Teil 1 mit WSL2 oder einem Linux-Rechner durchführen. Die Adressen weichen dann ab, die Befehle sind gleich. |
| **Apple Silicon** | Packet Tracer für macOS läuft auf Apple Silicon (ggf. über Rosetta 2, nicht verifiziert). Die VM läuft in UTM wie in Einheit 1. |

## Teil 1: Netzwerkwerkzeuge in der Debian-VM

**Ziel:** Du liest Adresse, Gateway, DNS und offene Ports ab und prüfst das Netz von unten nach oben. Notiere alle Ausgaben in deiner Dokumentation.

### 1.1 Schnittstelle und Adresse (Schicht 1–3)

```bash
ip -br link        # Schnittstellen, Zustand (UP/DOWN), MAC-Adresse
ip -br addr        # IP-Adressen je Schnittstelle
ip route           # Routing-Tabelle, Standard-Gateway
```

**Erwartet:** Neben `lo` eine Schnittstelle mit einer privaten Adresse und eine Zeile `default via <Gateway>`. Die Werte hängen von deiner Virtualisierung ab; alle vier Varianten sind NAT-Netze, die nur auf deinem Laptop existieren:

{{< tabs groupid="vm-platform" >}}
{{% tab title="VirtualBox" %}}
| Schnittstelle | Adresse | Gateway | DNS-Server |
|---|---|---|---|
| meist `enp0s3` | `10.0.2.15/24` | `10.0.2.2` | `10.0.2.3` |

Das ist die feste Standardkonfiguration des VirtualBox-NAT-Netzes: Jede VM bekommt dieselbe Adresse, weil jede ihr eigenes NAT-Netz hat.
{{% /tab %}}
{{% tab title="Linux: virt-manager" %}}
| Schnittstelle | Adresse | Gateway | DNS-Server |
|---|---|---|---|
| meist `enp1s0` | `192.168.122.x/24` | `192.168.122.1` | `192.168.122.1` |

Das Netz `default` von libvirt: Der Host ist unter `192.168.122.1` zugleich Gateway, DHCP- und DNS-Server (Programm `dnsmasq`).
{{% /tab %}}
{{% tab title="macOS: UTM" %}}
| Schnittstelle | Adresse | Gateway | DNS-Server |
|---|---|---|---|
| meist `enp0s1` | `192.168.64.x/24` | `192.168.64.1` | `192.168.64.1` |

Das *Shared Network* von macOS: Der Mac ist Gateway, DHCP- und DNS-Server.
{{% /tab %}}
{{% tab title="Windows: Hyper-V" %}}
| Schnittstelle | Adresse | Gateway | DNS-Server |
|---|---|---|---|
| meist `eth0` | `172.x.y.z/20` | `172.x.y.1` | `172.x.y.1` |

Der *Default Switch*: Windows wählt das Netz beim Start selbst, die genauen Zahlen ändern sich daher.
{{% /tab %}}
{{< /tabs >}}

Trage deine Werte in die Dokumentation ein; in den folgenden Schritten steht `<Gateway>` für deine Gateway-Adresse. Beantworte: Welche MAC-Adresse hat die VM? Welche Netzadresse und welcher Präfix? Wie viele Geräte passen in dieses Netz?

Gültigkeit der Adresse (DHCP-Lease) anzeigen:

```bash
ip addr show enp0s3     # Schnittstellennamen ggf. anpassen
```

In der Zeile `inet` steht `valid_lft <Sekunden>`: so lange gilt die per DHCP erhaltene Adresse noch. Steht dort `forever`, trägt der DHCP-Client die Gültigkeit nicht an der Schnittstelle ein (abhängig vom DHCP-Client, nicht verifiziert).

### 1.2 Gateway und Internet (Schicht 3)

```bash
ping -c 3 <Gateway>     # das Gateway
ping -c 3 1.1.1.1       # ein Ziel im Internet (nur per IP-Adresse)
```

**Erwartet:** Antworten ohne Paketverlust. Antwortet das Gateway, aber nicht `1.1.1.1`, liegt das Problem hinter dem Router (Internetanbindung).

### 1.3 Namensauflösung (DNS, Schicht 7)

```bash
cat /etc/resolv.conf              # welcher DNS-Server wird verwendet?
getent hosts debian.org           # Name auflösen
ping -c 3 debian.org              # funktioniert nur, wenn DNS funktioniert
```

**Erwartet:** In der Zeile `nameserver` steht der DNS-Server aus der Tabelle in 1.1. Debian trägt ihn beim Bezug der Adresse per DHCP in diese Datei ein. `getent` liefert eine oder mehrere Adressen. Merke dir: Funktioniert `ping 1.1.1.1`, aber nicht `ping debian.org`, liegt das Problem bei **DNS**, nicht bei der Verbindung.

*Optional:* Mit `sudo apt install bind9-dnsutils` steht `dig debian.org` zur Verfügung, das mehr Details zeigt.

### 1.4 Weg der Pakete

```bash
tracepath -n 1.1.1.1
```

**Erwartet:** Liste der Zwischenstationen (Hops). Der erste Hop ist dein Gateway. Einzelne Zeilen mit `no reply` sind normal (manche Geräte antworten nicht).

### 1.5 Nachbarn im lokalen Netz (ARP, Schicht 2)

```bash
ip neigh
```

**Erwartet:** Ein Eintrag für dein Gateway mit dessen MAC-Adresse (nach dem Ping). Das ist die ARP-Tabelle: Das Gerät kennt nur Nachbarn im **eigenen** Netz per MAC.

### 1.6 Wer lauscht auf welchem Port? (Schicht 4)

```bash
ss -tuln              # TCP und UDP, nur lauschende Ports, numerisch
sudo ss -tulpn        # zusätzlich mit Programmnamen
```

**Erwartet:** Der SSH-Server lauscht auf `0.0.0.0:22` (und `[::]:22`), der DHCP-Client auf UDP-Port `68`. Je nach Installation kommen Dienste hinzu, die nur auf `127.0.0.1` lauschen. Beantworte: Welche dieser Ports sind von außen erreichbar, welche nur lokal (`127.0.0.1`)? Das ist die Grundfrage jeder Härtung.

Wenn du in Einheit 1 Docker-Container mit Portfreigabe gestartet hast, erscheinen sie ebenfalls (z. B. `:8080`).

### 1.7 Vergleich: anderes Netz (optional, 10 min)

Hänge die VM statt ins NAT-Netz **direkt in das Netz deines Laptops** (Brücke) und starte sie neu:

{{< tabs groupid="vm-platform" >}}
{{% tab title="VirtualBox" %}}
VM-Einstellungen *Netzwerk → Angeschlossen an*: **Netzwerkbrücke** (*Bridged Adapter*), als Name den WLAN- oder LAN-Adapter des Laptops. Danach wieder **NAT**.
{{% /tab %}}
{{% tab title="Linux: virt-manager" %}}
VM-Details → *NIC* → Netzwerkquelle **Host-Gerät … : macvtap**, Modus **Bridge**, Gerät: LAN-Adapter des Laptops. Über WLAN funktioniert macvtap meist nicht; dann den Schritt nur lesen. Achtung: Mit macvtap erreicht der Host selbst die VM nicht mehr. Danach wieder **Virtuelles Netzwerk „default“**.
{{% /tab %}}
{{% tab title="macOS: UTM" %}}
VM ausschalten → *Edit → Network* → *Network Mode*: **Bridged (Advanced)**, *Bridged Interface*: `en0` (meist WLAN). Danach wieder **Shared Network**.
{{% /tab %}}
{{% tab title="Windows: Hyper-V" %}}
*Manager für virtuelle Switches* → **Extern** → neuer Switch mit dem WLAN- oder LAN-Adapter, dann in den VM-Einstellungen die Netzwerkkarte auf diesen Switch stellen. Achtung: Windows baut dabei die Netzwerkverbindung des Laptops um, die Verbindung bricht kurz ab. Danach wieder **Default Switch** und den externen Switch löschen.
{{% /tab %}}
{{< /tabs >}}

Prüfe dann erneut `ip -br addr` und `ip route`.

**Erwartet:** Die VM hat jetzt eine Adresse **aus dem Netz, in dem dein Laptop hängt** (z. B. WLAN der Schule). Beobachte Gateway und DNS. Stelle danach die ursprüngliche Einstellung wieder her.

{{% callout style="warning" title="Nur mit Erlaubnis" %}}
Eine Netzwerkbrücke macht die VM zu einem **eigenständigen Gerät im Schulnetz**. Sie ist im Schul-WLAN oft nicht erlaubt oder technisch gesperrt. Führe diesen Schritt nur aus, wenn er erlaubt ist, und scanne niemals fremde Geräte oder Netze.
{{% /callout %}}

## Teil 2: Subnetting und IP-Plan

### 2.1 Rechnen mit Python

Python installierst du einmal mit `sudo apt install -y python3` (falls in der Vorbereitung noch nicht geschehen). Das Modul `ipaddress` rechnet Netze aus:

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

## Teil 3: Schulnetz in Packet Tracer

**Ziel:** Du baust ein kleines Schulnetz mit drei Netzen (Verwaltung, Lehrende, Server), konfigurierst den Router über die Kommandozeile, vergibst Adressen von Hand und per DHCP, richtest DNS und einen Webserver ein und beobachtest im Simulationsmodus, wie die Pakete durch die Schichten laufen. Die Adressen entsprechen dem Plan aus Teil 2. VLANs und Zugriffsregeln folgen in Einheit 3 mit derselben Datei.

**Bedienung in Packet Tracer:** Unten links wählst du die Gerätegruppe (*Network Devices*, *End Devices*, *Connections*), daneben das konkrete Gerät. Klick auf ein Gerät öffnet seine Registerkarten: **Config** (Einstellungen per Formular), **CLI** (Kommandozeile bei Routern und Switches), **Desktop** (Programme auf PCs: *IP Configuration*, *Command Prompt*, *Web Browser*), **Services** (Dienste auf Servern). Unten rechts wechselst du zwischen **Realtime** (Echtzeit) und **Simulation** (Pakete Schritt für Schritt). Die Oberfläche ist englisch; Menünamen können je nach Version abweichen.

### 3.1 Topologie aufbauen (ca. 8 min)

Geräte auf die Arbeitsfläche ziehen und verkabeln:

| Gerät | Packet-Tracer-Modell | Name | Verbunden mit |
|---|---|---|---|
| Router | **2911** (*Network Devices → Routers*) | `r1` | `Gi0/0` → `sw-verw`, `Gi0/1` → `sw-lehr`, `Gi0/2` → `sw-srv` |
| Switch | **2960** (*Network Devices → Switches*) | `sw-verw`, `sw-lehr`, `sw-srv` | Uplink `Gi0/1` zu `r1`, Rechner an `Fa0/1`, `Fa0/2`, … |
| Rechner Verwaltung | PC | `pc-verw-01`, `pc-verw-02` | `sw-verw` |
| Rechner Lehrende | PC | `pc-lehr-01`, `pc-lehr-02` | `sw-lehr` |
| Server (Web, DNS, DHCP) | Server | `srv-01` | `sw-srv` |

Kabel: *Connections* → **Copper Straight-Through** (durchgehende Linie), dann Gerät anklicken und den Anschluss **gezielt auswählen**. Die automatische Verbindung (Blitz-Symbol) wählt beliebige Ports, dann stimmt die Tabelle nicht mehr. Namen der PCs und des Servers änderst du unter *Config → Display Name*; den Router benennst du in 3.2 per CLI.

**Erwartet:** Nach einigen Sekunden werden die Punkte an den Kabelenden grün. Am Router bleiben sie **rot**, bis die Schnittstellen eingeschaltet sind (3.2): Router-Schnittstellen sind ab Werk abgeschaltet (`shutdown`).

### 3.2 Router per Kommandozeile konfigurieren (ca. 8 min)

Klick auf `r1` → **CLI**. Die Frage nach dem *initial configuration dialog* mit `no` beantworten. Dann:

```text
enable
configure terminal
hostname r1
interface GigabitEthernet0/0
 description Verwaltung (sw-verw)
 ip address 10.10.10.1 255.255.255.224
 ip helper-address 10.10.40.10
 no shutdown
interface GigabitEthernet0/1
 description Lehrende (sw-lehr)
 ip address 10.10.20.1 255.255.255.128
 no shutdown
interface GigabitEthernet0/2
 description Server (sw-srv)
 ip address 10.10.40.1 255.255.255.224
 no shutdown
end
copy running-config startup-config
```

Prüfen:

```text
show ip interface brief
show ip route
```

**Erwartet:** Alle drei Schnittstellen `up`/`up` mit den richtigen Adressen. `show ip route` zeigt drei Einträge mit `C` (*connected*): Direkt verbundene Netze kennt der Router von selbst, eine statische Route ist hier nicht nötig.

**Was macht `ip helper-address`?** DHCP-Anfragen sind Broadcasts und bleiben im eigenen Netz. Der Router leitet sie als **DHCP-Relay** gezielt an den Server `10.10.40.10` weiter. So reicht **ein** zentraler DHCP-Server für alle Netze, wie in einem echten Schulnetz.

### 3.3 Server und Rechner einrichten (ca. 10 min)

**Feste Adressen** (bei PCs und Server: *Desktop → IP Configuration → Static*):

| Gerät | IP-Adresse | Netzmaske | Gateway | DNS-Server |
|---|---|---|---|---|
| `srv-01` | `10.10.40.10` | `255.255.255.224` | `10.10.40.1` | `10.10.40.10` |
| `pc-lehr-01` | `10.10.20.10` | `255.255.255.128` | `10.10.20.1` | `10.10.40.10` |
| `pc-lehr-02` | `10.10.20.11` | `255.255.255.128` | `10.10.20.1` | `10.10.40.10` |
| `pc-verw-01`, `pc-verw-02` | per DHCP (siehe unten) | | | |

**Dienste auf `srv-01`** (Registerkarte *Services*):

1. **HTTP:** ist ab Werk eingeschaltet. Unter *HTTP* kannst du `index.html` bearbeiten, z. B. eine Überschrift „Schulserver Musterstadt“ eintragen.
2. **DNS:** *DNS Service* auf **On**. Eintrag anlegen: *Name* `web.schule.test`, *Type* `A Record`, *Address* `10.10.40.10` → **Add**. (Die Endung `.test` ist für Übungen reserviert und kollidiert nicht mit echten Domains.)
3. **DHCP:** *Service* auf **On**. Einen neuen Pool für die Verwaltung anlegen und mit **Add** speichern:

   | Feld | Wert |
   |---|---|
   | Pool Name | `verwaltung` |
   | Default Gateway | `10.10.10.1` |
   | DNS Server | `10.10.40.10` |
   | Start IP Address | `10.10.10.10` |
   | Subnet Mask | `255.255.255.224` |
   | Maximum Number of Users | `21` (also `.10` bis `.30`) |

   Den vorhandenen Eintrag `serverPool` lässt du unverändert. Die Adressen `.1` bis `.9` bleiben für feste Geräte frei (Router, Drucker).

**DHCP-Clients:** Auf `pc-verw-01` und `pc-verw-02` → *Desktop → IP Configuration* → **DHCP** wählen.

**Erwartet:** Nach wenigen Sekunden zeigen die Verwaltungs-PCs eine Adresse aus `10.10.10.10–30` samt Gateway `10.10.10.1` und DNS-Server `10.10.40.10`. Erscheint *DHCP request failed*, prüfe `ip helper-address` an `Gi0/0` und den Pool (Fehlersuche unten).

### 3.4 Testen von unten nach oben (ca. 7 min)

Auf `pc-verw-01` → *Desktop → Command Prompt*:

```text
ipconfig /all
ping 10.10.10.1
ping 10.10.20.10
ping 10.10.40.10
tracert 10.10.40.10
nslookup web.schule.test
ping web.schule.test
```

Öffne danach *Desktop → Web Browser* mit `http://10.10.40.10` und mit `http://web.schule.test`. Wiederhole die Tests von `pc-lehr-01` aus.

**Erwartet:** Alle Pings sind erfolgreich. Der **erste** Ping in ein anderes Netz meldet oft ein *Request timed out*, weil der Router zuerst per ARP die MAC-Adresse des Ziels ermittelt. `tracert` zeigt `10.10.10.1` als ersten Hop. `nslookup` liefert `10.10.40.10`. Der Browser lädt die Startseite, einmal per IP-Adresse und einmal per Name. Notiere: Welche Adresse hat `pc-verw-01` bekommen, und woher kommt sie?

### 3.5 Pakete beobachten im Simulationsmodus (ca. 6 min)

Unten rechts auf **Simulation** umschalten. Unter *Edit Filters* nur **ARP, ICMP, DNS, HTTP, DHCP** auswählen. Mit **Play** (oder *Capture/Forward* Schritt für Schritt) laufen die Pakete als Umschläge über die Arbeitsfläche; jedes Ereignis erscheint in der *Event List*. Ein Klick auf einen Umschlag zeigt die **OSI-Ansicht** (welche Schicht was tut) und die Paketinhalte (*Inbound/Outbound PDU Details*).

1. **ARP und ICMP:** Auf `pc-verw-01` im *Command Prompt* `arp -d` ausführen, dann `ping 10.10.40.10`. Welche Pakete kommen **vor** dem ersten ICMP-Paket (wer fragt nach wem)? Welche MAC-Adressen und welche IP-Adressen stehen im Paket vor und nach dem Router? Was ändert sich, was bleibt gleich?
2. **DNS und HTTP:** Im Browser `http://web.schule.test` aufrufen. Wo erscheint die DNS-Anfrage, wo die HTTP-Anfrage? Welche Ports (UDP/TCP) siehst du?
3. **DHCP:** Auf `pc-verw-02` im *Command Prompt* `ipconfig /release` und dann `ipconfig /renew`. Verfolge DISCOVER, OFFER, REQUEST und ACK. Was macht `r1` mit dem Broadcast (Relay)? Vergleiche mit dem Diagramm in der Theorie.

Danach zurück auf **Realtime** schalten.

### 3.6 Fehlersuche üben (ca. 6 min)

Baue einen Fehler ein und finde ihn mit der Schichten-Reihenfolge. Tausche mit einer Partnerin oder einem Partner: Einer baut einen Fehler ein, der oder die andere sucht.

| Fehler | Beobachtung | Ursache zeigen mit |
|---|---|---|
| Falsche **Netzmaske** am `pc-lehr-01` (z. B. `255.255.255.0`) | | `ipconfig`, Vergleich mit dem Plan |
| **Gateway** am `pc-lehr-01` gelöscht | Ping im eigenen Netz geht, ins andere nicht | `ipconfig`, `tracert` |
| **DNS-Eintrag** gelöscht | `ping 10.10.40.10` geht, `ping web.schule.test` nicht | `nslookup`, *Services → DNS* |
| `shutdown` auf `r1` `Gi0/2` | Server aus keinem Netz erreichbar, roter Punkt am Kabel | `show ip interface brief` |
| `no ip helper-address` auf `Gi0/0` | `ipconfig /renew` schlägt fehl | `show running-config` |

Stelle danach den Zustand wieder her.

### 3.7 Speichern und Screenshots

Speichere das Projekt als `02-networking-1/assets/schulnetz.pkt` (*File → Save As*). Du brauchst die Datei in Einheit 3 wieder. Mache Screenshots: Topologie (mit sichtbaren Namen), `ipconfig /all` eines DHCP-Clients, ein Ping zwischen Netzen oder der Browser mit `web.schule.test` und den Simulationsmodus mit geöffnetem DHCP- oder DNS-Paket. Kopiere außerdem `show ip interface brief` und `show running-config` von `r1` als Text.

### 3.8 Erweiterung: WLAN im Lehrerzimmer (optional)

Anders als viele einfache Simulatoren kann Packet Tracer WLAN darstellen:

1. Einen **AccessPoint-PT** (*Network Devices → Wireless Devices*) an `sw-lehr` anschließen. Unter *Config → Port 1*: SSID `schule-lehrende`, Authentifizierung **WPA2-PSK**, Passphrase frei wählen (keine echten Passwörter).
2. Einen **Laptop** hinzufügen. Unter *Physical* den Laptop ausschalten, die Ethernet-Karte herausziehen, das Modul **WPC300N** einsetzen, wieder einschalten.
3. Im Laptop *Desktop → PC Wireless* (oder *Config → Wireless0*) mit SSID und Passphrase verbinden. Feste Adresse aus dem Lehrenden-Netz, z. B. `10.10.20.20`, oder ergänze dafür einen DHCP-Pool und `ip helper-address` an `Gi0/1`.

**Erwartet:** Zwischen Laptop und Access Point erscheint eine Funkverbindung, `ping 10.10.40.10` funktioniert. Überlege: Warum landen WLAN-Geräte hier im selben Netz wie die Lehrenden-PCs, und warum ist das für ein Schüler-WLAN keine gute Idee? (Lösung mit VLANs in Einheit 3.)

## Erwartete Ergebnisse (Checkliste)

- [ ] `ip -br addr`, `ip route`, `/etc/resolv.conf` und `ss -tuln` der VM notiert und erklärt.
- [ ] Unterschied „Ping auf IP funktioniert, Name nicht“ erklärbar (DNS).
- [ ] IP-Plan (Teil 2) ausgefüllt, mit Python geprüft.
- [ ] Router `r1` per CLI konfiguriert, `show ip interface brief` zeigt drei Schnittstellen `up`.
- [ ] Packet-Tracer-Netz: Verwaltungs-PCs erhalten Adressen per DHCP (über das Relay), Lehrenden-PCs haben feste Adressen.
- [ ] Ping und Browser-Zugriff zwischen allen Netzen und auf den Webserver funktionieren, auch per Name.
- [ ] Im Simulationsmodus ARP, DHCP, DNS und HTTP gefunden und erklärt.
- [ ] Eingebauten Fehler selbst gefunden und repariert (3.6).
- [ ] Datei `schulnetz.pkt` im Portfolio, keine echten Passwörter.

## Fehlersuche

| Problem | Ursache und Lösung |
|---|---|
| `ip -br addr` zeigt keine Adresse | Netzwerk der VM wie in Einheit 1, Lab 1.1 eingestellt? VM neu starten. Fehlt `/etc/network/interfaces` (Übung aus Einheit 1), Snapshot wiederherstellen. |
| `ping 1.1.1.1` geht, `ping debian.org` nicht | DNS-Problem: `cat /etc/resolv.conf` prüfen, VM neu starten. |
| `tracepath` fehlt | `sudo apt install iputils-tracepath`. |
| Python meldet `ModuleNotFoundError` | `python3` verwenden (nicht `python`), das Modul `ipaddress` ist Teil der Standardbibliothek. |
| Packet Tracer: rote Punkte am Router | Schnittstelle noch `shutdown`: in der CLI `interface …` und `no shutdown`. Kabel am richtigen Port? |
| Packet Tracer: Pakete bewegen sich nicht | Steht der Modus auf **Simulation** ohne Play? Auf **Realtime** umschalten oder Play drücken. |
| Packet Tracer: *DHCP request failed* | `ip helper-address 10.10.40.10` an `Gi0/0`? DHCP-Dienst auf `srv-01` **On**, Pool mit richtigem Gateway (`10.10.10.1`) und Netzmaske? Server erreichbar (`ping 10.10.40.10` von `r1`)? |
| Packet Tracer: Ping zwischen Netzen schlägt fehl | Gateway am Rechner eingetragen? `show ip interface brief`: alle drei Schnittstellen `up`/`up` mit richtiger Adresse? Erster Ping darf wegen ARP ein *timed out* haben. |
| Packet Tracer: Name wird nicht aufgelöst | DNS-Dienst auf `srv-01` **On**, A-Record `web.schule.test` vorhanden, DNS-Server-Adresse am Rechner eingetragen? |
| Packet Tracer: Befehl in der CLI wird nicht angenommen | Richtiger Modus? `Router>` (nur anzeigen), `Router#` (nach `enable`), `Router(config)#` (nach `configure terminal`). Mit `?` die möglichen Befehle anzeigen. |
