+++
title = "Lab mit Lösungen (freiwillig)"
weight = 30
+++

{{% callout style="info" title="Freiwillig, nicht bewertet" %}}
Dieses Lab ist **freiwillig**. Es gibt keine Abgabe. Zu jeder Aufgabe gibt es eine **Lösung** zum Aufklappen. Versuche es zuerst selbst und vergleiche dann.
{{% /callout %}}

{{% callout style="warning" title="Status: ungeprüft" %}}
Die Befehle wurden noch **nicht** in Packet Tracer 9.0.1 bzw. in der Kursumgebung ausgeführt. *Getestet am: offen.*
{{% /callout %}}

## Überblick

| Teil | Inhalt | Dauer | Voraussetzung |
|---|---|---|---|
| 1 | VLANs in Packet Tracer: drei Gruppen an einem Switch, Router on a stick | ca. 50 min | `schulnetz.pkt` aus [Einheit 2]({{% relref "/02-networking-1/lab" %}}) |
| 2 | Berechtigungsmatrix als Zugriffsregel (ACL) | ca. 30 min | Teil 1 |
| 3 | DNS und DHCP in der Debian-VM beobachten | ca. 30 min | VM `debian-lab` aus Einheit 1 |

## Teil 1: VLANs in Packet Tracer

**Ziel:** Statt eines Switches pro Gruppe hängen Verwaltung, Lehrende und Schüler an **einem** Switch in drei VLANs. Der Router verbindet die VLANs über **ein** Kabel (Trunk) mit Unterschnittstellen.

**Ausgangspunkt:** Öffne `schulnetz.pkt` und speichere es sofort unter `schulnetz-vlan.pkt` (*File → Save As*).

### 1.1 Topologie umbauen

1. Lösche den Switch `sw-lehr`.
2. Benenne `sw-verw` in `sw-01` um (*Config → Display Name*).
3. Schließe `pc-lehr-01` und `pc-lehr-02` an `sw-01` an den Ports `Fa0/3` und `Fa0/4` an.
4. Füge zwei neue PCs `pc-sch-01` und `pc-sch-02` hinzu und schließe sie an `Fa0/5` und `Fa0/6` an.
5. Das Kabel `sw-01 Gi0/1` → `r1 Gi0/0` bleibt. Es wird zum Trunk.

| Port an `sw-01` | Gerät | VLAN |
|---|---|---|
| `Fa0/1`, `Fa0/2` | `pc-verw-01`, `pc-verw-02` | 10 Verwaltung |
| `Fa0/3`, `Fa0/4` | `pc-lehr-01`, `pc-lehr-02` | 20 Lehrende |
| `Fa0/5`, `Fa0/6` | `pc-sch-01`, `pc-sch-02` | 30 Schüler |
| `Gi0/1` | `r1` | Trunk (10, 20, 30) |

### 1.2 VLANs am Switch anlegen

**Aufgabe:** Lege am Switch `sw-01` per CLI die VLANs 10, 20 und 30 mit Namen an, ordne die Ports laut Tabelle zu und mache `Gi0/1` zum Trunk, der nur diese drei VLANs überträgt. Prüfe mit `show vlan brief` und `show interfaces trunk`.

{{< details summary="Lösung 1.2" >}}
```text
enable
configure terminal
hostname sw-01
vlan 10
 name Verwaltung
vlan 20
 name Lehrende
vlan 30
 name Schueler
interface range FastEthernet0/1 - 2
 switchport mode access
 switchport access vlan 10
interface range FastEthernet0/3 - 4
 switchport mode access
 switchport access vlan 20
interface range FastEthernet0/5 - 6
 switchport mode access
 switchport access vlan 30
interface GigabitEthernet0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30
end
copy running-config startup-config
show vlan brief
show interfaces trunk
```

**Erwartet:** `show vlan brief` listet VLAN 10, 20 und 30 mit je zwei Ports. `Gi0/1` erscheint dort **nicht**, weil Trunk-Ports zu keinem einzelnen VLAN gehören. `show interfaces trunk` zeigt `Gi0/1` im Modus `on` mit den erlaubten VLANs `10,20,30`.
{{< /details >}}

### 1.3 Router on a stick

**Aufgabe:** Entferne am Router `r1` die Adresse von `Gi0/0` und lege drei Unterschnittstellen `Gi0/0.10`, `Gi0/0.20` und `Gi0/0.30` an, jeweils mit 802.1Q-Kapselung, der Gateway-Adresse aus dem IP-Plan und dem DHCP-Relay zu `srv-01`. Schalte `Gi0/1` (früher Lehrende) ab.

Gateway-Adressen: Verwaltung `10.10.10.1/27`, Lehrende `10.10.20.1/25`, Schüler `10.10.30.1/23`.

{{< details summary="Lösung 1.3" >}}
```text
enable
configure terminal
interface GigabitEthernet0/0
 no ip address
 no ip helper-address
 no shutdown
interface GigabitEthernet0/0.10
 description VLAN 10 Verwaltung
 encapsulation dot1Q 10
 ip address 10.10.10.1 255.255.255.224
 ip helper-address 10.10.40.10
interface GigabitEthernet0/0.20
 description VLAN 20 Lehrende
 encapsulation dot1Q 20
 ip address 10.10.20.1 255.255.255.128
 ip helper-address 10.10.40.10
interface GigabitEthernet0/0.30
 description VLAN 30 Schueler
 encapsulation dot1Q 30
 ip address 10.10.30.1 255.255.254.0
 ip helper-address 10.10.40.10
interface GigabitEthernet0/1
 shutdown
end
copy running-config startup-config
show ip interface brief
show ip route
```

**Erwartet:** `show ip interface brief` zeigt `Gi0/0.10`, `Gi0/0.20` und `Gi0/0.30` als `up`/`up`. `show ip route` hat drei `C`-Einträge für die VLAN-Netze und einen für das Server-Netz `10.10.40.0/27`.

**Warum `encapsulation dot1Q`?** Der Router muss wissen, welches 802.1Q-Tag zu welcher Unterschnittstelle gehört. Ein Rahmen mit Tag 30 landet in `Gi0/0.30`, eine Antwort aus `Gi0/0.30` bekommt Tag 30.
{{< /details >}}

### 1.4 DHCP für das Schüler-VLAN

**Aufgabe:** Lege auf `srv-01` (*Services → DHCP*) einen Pool `schueler` an, der Adressen ab `10.10.30.10` vergibt (Gateway, DNS-Server und Netzmaske passend). Stelle `pc-sch-01` und `pc-sch-02` auf DHCP. Prüfe mit `ipconfig /all`.

{{< details summary="Lösung 1.4" >}}
| Feld | Wert |
|---|---|
| Pool Name | `schueler` |
| Default Gateway | `10.10.30.1` |
| DNS Server | `10.10.40.10` |
| Start IP Address | `10.10.30.10` |
| Subnet Mask | `255.255.254.0` |
| Maximum Number of Users | z. B. `200` |

**Erwartet:** `pc-sch-01` bekommt `10.10.30.10` (oder die nächste freie Adresse), Gateway `10.10.30.1`, DNS `10.10.40.10`. Die Verwaltungs-PCs bekommen weiterhin Adressen aus ihrem Pool, weil das Relay an `Gi0/0.10` die eigene Adresse `10.10.10.1` mitschickt und der Server daran den Pool `verwaltung` erkennt.

Die Lehrenden-PCs haben feste Adressen aus Einheit 2 und funktionieren unverändert.
{{< /details >}}

### 1.5 Testen und verstehen

**Aufgabe:** Führe von `pc-sch-01` aus `ping 10.10.10.10` (ein Verwaltungs-PC, Adresse ggf. mit `ipconfig` nachsehen), `ping 10.10.40.10` und im Browser `http://web.schule.test` aus. Beantworte:

1. Was passiert, und hättest du das erwartet?
2. Beobachte im **Simulationsmodus** ein ICMP-Paket von `pc-sch-01` zu einem Verwaltungs-PC. Auf welchem Kabel trägt der Rahmen ein 802.1Q-Tag, auf welchem nicht? Welche VLAN-ID steht vor und nach dem Router?

{{< details summary="Lösung 1.5" >}}
1. **Alles funktioniert**: Der Schüler-PC erreicht den Verwaltungs-PC, den Server und die Webseite. Das ist die wichtigste Erkenntnis dieses Teils: **VLANs trennen, aber der Router verbindet sie wieder**. Ohne Zugriffsregel ist die Trennung nur eine Umleitung über den Router. Das ändern wir in Teil 2.
2. Zwischen `pc-sch-01` und `sw-01` (Access-Port) trägt der Rahmen **kein** Tag. Auf dem Trunk `sw-01` → `r1` trägt er das Tag **30**. Der Router routet ins VLAN 10 und schickt den Rahmen mit Tag **10** zurück auf denselben Trunk. Von `sw-01` zum Verwaltungs-PC wieder **ohne** Tag. In den *PDU Details* findest du das Tag im Feld *802.1Q* bzw. *TCI/VLAN*.
{{< /details >}}

## Teil 2: Berechtigungsmatrix als Zugriffsregel

**Ziel:** Die Zeile **Schüler-WLAN** der Berechtigungsmatrix aus der [Theorie]({{% relref "theory" %}}#die-berechtigungsmatrix) wird am Router durchgesetzt:

| von Schüler (VLAN 30) nach | erlaubt |
|---|---|
| Verwaltung (`10.10.10.0/27`) | nein |
| Lehrende (`10.10.20.0/25`) | nein |
| Server `10.10.40.10` | nur DNS (UDP 53) und Web (TCP 80) |
| alles andere (Internet) | ja |
| DHCP | ja (sonst bekommt kein Schüler-PC eine Adresse) |

### 2.1 Regel schreiben

**Aufgabe:** Schreibe eine *extended ACL* `SCHUELER-IN` und wende sie **eingehend** auf `Gi0/0.30` an. Achte auf die Reihenfolge: Die erste passende Zeile entscheidet, am Ende steht unsichtbar ein „alles verbieten“.

Tipp: Ports als Zahl angeben (DHCP 67, DNS 53, HTTP 80). Bei Cisco-ACLs steht statt der Netzmaske die **Wildcard-Maske** (die umgekehrte Maske): `/23` → `0.0.1.255`, `/27` → `0.0.0.31`, `/25` → `0.0.0.127`.

{{< details summary="Lösung 2.1" >}}
```text
enable
configure terminal
ip access-list extended SCHUELER-IN
 remark DHCP immer erlauben
 permit udp any any eq 67
 remark DNS und Web zum Schulserver
 permit udp 10.10.30.0 0.0.1.255 host 10.10.40.10 eq 53
 permit tcp 10.10.30.0 0.0.1.255 host 10.10.40.10 eq 80
 remark keine Verwaltung, keine Lehrenden, sonst nichts am Server
 deny ip 10.10.30.0 0.0.1.255 10.10.10.0 0.0.0.31
 deny ip 10.10.30.0 0.0.1.255 10.10.20.0 0.0.0.127
 deny ip 10.10.30.0 0.0.1.255 10.10.40.0 0.0.0.31
 remark Internet
 permit ip 10.10.30.0 0.0.1.255 any
interface GigabitEthernet0/0.30
 ip access-group SCHUELER-IN in
end
copy running-config startup-config
show access-lists
```

Die Zeile `permit udp any any eq 67` steht ganz oben, weil ein Gerät ohne Adresse seine DHCP-Anfrage von `0.0.0.0` schickt. Sie würde von keiner Regel mit `10.10.30.0` erfasst.
{{< /details >}}

### 2.2 Testen

**Aufgabe:** Teste von `pc-sch-01` aus: `ping 10.10.10.10`, `ping 10.10.40.10`, Browser `http://web.schule.test`, `ipconfig /renew`. Teste dann von `pc-verw-01` aus `ping` auf `pc-sch-01`. Erkläre jedes Ergebnis.

{{< details summary="Lösung 2.2" >}}
| Test | Ergebnis | Warum |
|---|---|---|
| `pc-sch-01` → `ping 10.10.10.10` | scheitert | Zeile `deny … 10.10.10.0 0.0.0.31` |
| `pc-sch-01` → `ping 10.10.40.10` | scheitert | Ping ist ICMP, erlaubt sind nur DNS und HTTP. Die Zeile `deny … 10.10.40.0` greift |
| Browser `http://web.schule.test` | funktioniert | DNS (UDP 53) und HTTP (TCP 80) zum Server sind erlaubt |
| `ipconfig /renew` | funktioniert | Erste Zeile erlaubt DHCP |
| `pc-verw-01` → `ping pc-sch-01` | scheitert | Die Anfrage kommt beim Schüler-PC an, aber seine **Antwort** geht eingehend durch `Gi0/0.30` und trifft die Zeile `deny … 10.10.10.0`. |

Der letzte Fall zeigt eine Grenze einfacher ACLs: Sie merken sich keine Verbindungen (*zustandslos*). Eine Firewall mit Zustandsprüfung (*stateful*) würde Antworten auf erlaubte Anfragen automatisch durchlassen. In der Praxis setzt man deshalb zwischen VLANs meist eine Firewall ein.

**Merke:** `ping` ist ein schlechter Test für eine Zugriffsregel, die nur bestimmte Dienste erlaubt. Teste den Dienst selbst (hier: den Browser).
{{< /details >}}

## Teil 3: DNS und DHCP in der Debian-VM

**Ziel:** Du beobachtest an einem echten Linux-System, welche Angaben es per DHCP bekommen hat und wie es Namen auflöst. Starte `debian-lab` und melde dich an (in der VM oder per SSH).

### 3.1 Was hat DHCP geliefert?

**Aufgabe:** Finde heraus: IP-Adresse und Präfix, wie lange die Adresse noch gültig ist, das Gateway und den DNS-Server. Finde außerdem im Systemprotokoll die Meldungen des DHCP-Clients.

{{< details summary="Lösung 3.1" >}}
```bash
ip -4 addr show          # Adresse, Präfix, valid_lft = Restlaufzeit der Leihe
ip route                 # Zeile "default via …" = Gateway
cat /etc/resolv.conf     # Zeile "nameserver …" = DNS-Server
sudo journalctl -b | grep -i dhcp
```

**Erwartet (VirtualBox mit NAT):** Adresse `10.0.2.15/24`, `valid_lft` z. B. `86000sec`, Gateway `10.0.2.2`, DNS-Server `10.0.2.3`. Bei anderen Plattformen siehe die Tabelle im [Lab von Einheit 2]({{% relref "/02-networking-1/lab" %}}). Im Protokoll siehst du je nach DHCP-Client die Schritte der Leihe (Angebot, Bestätigung) und die erhaltene Adresse.

Wenn `valid_lft forever` steht, hat die VM eine **feste** Adresse und kein DHCP.
{{< /details >}}

### 3.2 Namen auflösen mit `dig`

**Aufgabe:** Löse `debian.org` mit `dig` auf. Suche in der Ausgabe: die Antwort, die TTL, den befragten Server. Wiederhole die Abfrage nach ein paar Sekunden. Was ändert sich?

{{< details summary="Lösung 3.2" >}}
```bash
dig debian.org
dig debian.org      # nach einigen Sekunden erneut
```

- Im Abschnitt `ANSWER SECTION` steht `debian.org.  <TTL>  IN  A  <Adresse>`.
- Die Zeile `;; SERVER:` nennt den befragten Resolver (z. B. `10.0.2.3#53`).
- Bei der zweiten Abfrage ist die **TTL kleiner** (und `Query time` oft kürzer): Der Resolver antwortet aus seinem Zwischenspeicher und zählt die Restzeit herunter.
{{< /details >}}

### 3.3 Eintragstypen und Rückwärtsauflösung

**Aufgabe:** Frage für `debian.org` die Typen `AAAA` und `MX` ab, und löse die Adresse `1.1.1.1` rückwärts auf. Vergleiche `getent hosts localhost` mit `dig localhost`. Warum unterscheiden sie sich?

{{< details summary="Lösung 3.3" >}}
```bash
dig debian.org AAAA +short
dig debian.org MX +short
dig -x 1.1.1.1 +short          # PTR-Eintrag: one.one.one.one.
getent hosts localhost         # 127.0.0.1 oder ::1 localhost
dig localhost +short           # meist leer
```

`getent` fragt so, wie es Programme tun: zuerst `/etc/hosts`, dann DNS (Reihenfolge in `/etc/nsswitch.conf`, Zeile `hosts:`). `localhost` steht in `/etc/hosts`. `dig` fragt **nur** den DNS-Server und ignoriert `/etc/hosts`. Bei der Fehlersuche ist das wichtig: Funktioniert `getent`, aber nicht `dig`, steht der Name vermutlich nur in `/etc/hosts`.
{{< /details >}}

### 3.4 Ohne DNS

**Aufgabe:** Sichere `/etc/resolv.conf`, trage als `nameserver` eine Adresse ein, an der kein DNS-Server läuft (z. B. `192.0.2.1`), und teste `ping -c 2 1.1.1.1` und `ping -c 2 debian.org`. Stelle danach die Datei wieder her.

{{< details summary="Lösung 3.4" >}}
```bash
sudo cp /etc/resolv.conf /etc/resolv.conf.orig
echo "nameserver 192.0.2.1" | sudo tee /etc/resolv.conf
ping -c 2 1.1.1.1        # funktioniert: Verbindung ist da
ping -c 2 debian.org     # scheitert nach einer Wartezeit: Name nicht auflösbar
sudo cp /etc/resolv.conf.orig /etc/resolv.conf
ping -c 2 debian.org     # funktioniert wieder
```

Das ist das typische Bild „Internet geht nicht“, wenn eigentlich nur DNS fehlt. `192.0.2.0/24` ist ein für Dokumentation reservierter Bereich (RFC 5737), dort antwortet niemand. Der DHCP-Client kann `/etc/resolv.conf` bei der nächsten Verlängerung der Leihe ohnehin überschreiben.
{{< /details >}}
