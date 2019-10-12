---
title: "Programozható LED-fűzéren alapuló reklámpanel - LED füzér vezérlése, adatok kiírása"
author: |
	| Patka Zsolt-András
	| Számítástechnika BSc
	| Sapientia EMTE
date: 05.10.2019
geometry: margin=2cm
output: pdf_document
---

# Bevezető

A projekt fő célja egy LED-fűzér vezérlése és ennek segítségével egy reklámszöveg megjelenítése. Ehhez egy FPGA lap és egy Worldsemi WS2813 ledfűzér lesz felhasználva.

# Követelmények

 - Protokoll helyes használata
 - Adatok (Külön ) kiírása lehetséges a LED fűzérre
 - Opcionális: 
   - Pár betű kódolása (3-4)
   - Betük tárolása BRAM memóriában

# Modulok

Állapotok:

 - READY: 
   - Alap állapot
   - "reset" jel esetén ide kerül vissza az automata
 - INIT:
   - minden LED-et kikapcsol (0x000000-t ír)
   - "clear" jel esetén ide kerül az automata
 - RENDER:
   - egyenként küldi a szín információt a LED-ekre
   - annyiszor végződik el itt a művelet, ahány LED-ünk van
   - "stop" jel esetén megáll a kiírás
 - DISPLAY:
   - megtörtént a kiírás

Modulok:

 - Következő állapot regiszter *Next State Register*
 - Állapot regiszter *State Register*
 - Szín regiszter *Colour Register*
 - Küldési logika regiszter *Transmission Logic Register*