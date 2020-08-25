---
layout: post
title: Firmware 0.13 Pre-Announce
---

Endlich können wir verkünden, dass wir soweit sind, das Layer2 Routing-Protokoll batman-adv [[1]] von version 14 auf 15 zu aktualisieren. Diese Versionen sind inkompatibel zueinander, d.h. ein Knoten mit bat14 kann nicht mit einem Knoten mit bat15 kommunizeren.
Daher haben wir viel Zeit damit verbracht eine parallele Gatewayinfrastruktur aufzubauen, die neuer, besser und schöner ist. Damit der Wechsel möglichst Reibungslos abläuft ist das neute bat15 Netz auf Layer2 mit dem alten bat14 Netz gebridged. Klingt komisch, funktioniert aber. Damit Knoten ohne eigenen Uplink nicht abgeschnitten werden, verwenden wir wie auch schon beim ibss/802.11s Wechsel den Scheduled-Domain-Switch. Mit dem kommenden Update werden alle Knoten Zeitgleich am __03.09.2020 um 22:00 CEST__ die Konfiguration wechseln. Eine weitere Ankündigung zur Liveübertragung folgt noch.

Tests dazu haben wir im kleinen Maßstab schon durchgeführt. Auf einen richtigen Beta-Test müssen wir aufgrund des zeitgleichen Domain-Wechsels verzichten.

Der Zeitplan sieht wie folgt aus:

---

* _T - 801947s_  / 25.08.2020 15:14:13 __Firmware Signieren__
* _T - 801858s_  / 25.08.2020 15:15:42 __Beta Release__
* _T - 686197s_  / 26.08.2020 23:23:23 __Stable Release__
* _1599163200_   / 03.09.2020 22:00:00 __Take-Off__

---

![Countdown](https://monitor.luebeck.freifunk.net/render/d-solo/aqR0RBHGz/batman-migration?orgId=1&from=now-24h&to=now&panelId=2&width=1000&height=500&theme=light&tz=Europe%2FBerlin)

Nach dem Update wird das alte Netz noch für ein paar Tage bestehen bleiben, bis alle Knoten den Wechsel vollzogen haben.
Danach werden die alten Gateways neu aufgesetzt und auch Teil des neuen Netzes werden.

[1]: https://www.open-mesh.org/projects/batman-adv/wiki
[2]: https://monitor.luebeck.freifunk.net/render/d-solo/aqR0RBHGz/batman-migration?orgId=1&from=1598285731731&to=1598307331731&panelId=2&width=1000&height=500&tz=Europe%2FBerlin

![batman-adv]({{ site.url }}/images/batlogo_transparent.png)
