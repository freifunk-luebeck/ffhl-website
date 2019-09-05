---
layout: post
title: Firmware 0.11 Vorankündigung - Takeoff und ETA
---

Moin moin,

so, die ganzen Updates bisher waren größtenteils ein Selbstläufer.
Nun kommt der etwas spannendere und kniffligere Teil: Ein
Protokoll-Wechsel (IBSS/Adhoc-Mode -> 802.11s). Dieser ist
notwendig, damit wir endlich die neuesten Geräte unterstützen
können.

Die Schwierigkeit hierbei liegt darin, dass alle Geräte
gleichzeitig wechseln müssen. Um zu vermeiden, dass ausschließlich
per WLAN-Mesh angebundene Geräte von der Kommunikation nicht
abgeschnitten werden.

"Zündung" geht ab Freitag los: Ab dann, innerhalb von drei Tagen,
wird die scharf gestellte Firmware ausgerollt und auf die
Freifunk-Router eingespielt.

Diese Firmware beinhaltet dann einen festen Zeitpunkt für Freitag
den 13.9. um 10:10 Uhr: Das ist der Zeitpunkt des automatischen
Protokollwechsels.

Es wäre gut, wenn ihr eure Freifunk-Router bis zu diesem Zeitpunkt
möglichst lange online halten könntet.


Wenn euer Freifunk-Router das Update bekommen hat, um 10:10 (oder
vorher) aber nicht online ist, wird er spätestens nach zwei Stunden
Betriebszeit ohne Netzverbindung alternativ auch auf das neue
Protokoll wechseln.

Wenn euer Freifunk-Router das Update nicht bis zum Freitag, den
13.9. 10:10 erhalten konnte (zum Beispiel weil er die Zeit über
aus war) und ausschließlich per Mesh angebunden war/ist, werdet ihr
diesen manuell updaten müssen.

Wer den ganzen spannenden Takeoff live miterleben möchte, kann
sich zum Beispiel diese Statisk anschauen:

[https://monitor.luebeck.freifunk.net/statistik/d/gfLSBciWz/basic-stats?orgId=1&refresh=1m&fullscreen&panelId=8&from=now-21d&to=now](https://monitor.luebeck.freifunk.net/statistik/d/gfLSBciWz/basic-stats?orgId=1&refresh=1m&fullscreen&panelId=8&from=now-21d&to=now)

Dieser "Takeoff" wäre dann für Freitag den 6.9. bis Montag, den 9.9.

Zum Beobachten der Mondlandung/Touchdown am 13.9. um 10:10
wären z.B. die Graphen "Nodes" und "Mesh links" hier dann
interessant:

[https://monitor.luebeck.freifunk.net/statistik/d/gfLSBciWz/basic-stats?orgId=1&refresh=1m&from=now-21d&to=now](https://monitor.luebeck.freifunk.net/statistik/d/gfLSBciWz/basic-stats?orgId=1&refresh=1m&from=now-21d&to=now)

Gruß, Linus
