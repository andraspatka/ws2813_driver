# Újrakonfigurálható Digitális Áramkörök Projekt 2019 - 2020

Téma: 33. Programozható LED-fűzéren alapuló reklámpanel b) LED füzér vezérlése, adatok kiírása

## Mappastruktúra

### docs

Ez tartalmazza az általam írt dokumentációt, plusz a LED fűzér adatlapját, meg egy tartalmas útmutatót a LED fűzér használatáról.

### src

Ez a mappa tartalmazza a forráskódot. 

## Vivado projekt felépítése

A vivado projektet gyorsan két lépésből, két script segítségével fel lehet építeni:
 - prep.py
 - build.tcl
 
Mindkét script az src mappában található.

Útmutató:
 - prep.py script futtatása
   - Ez létrehoz egy "vivado" nevezetű mappát és ide bemásolja a szükséges állományokat
 - Ezután a Vivado program elindítása után **Tools** -> **Run Tcl Script...** és a vivado mappában levő build.tcl script kiválasztása

A lépések követése után a projekt fel lesz építve, viszont még szükséges a projekthez a BRAM memóriák hozzáadása. 

## BRAM hozzáadása a design-hoz

**Aktuálisan a WS2813_TopLevel modulban két BRAM komponens van definiálva, ahhoz, hogy a projekt lefusson, két BRAM modult kell a projekthez hozzáadni. Hogyha több BRAM modulra van szükség (több ledfűzért kell vezérelni), ez esetben még hozzá kell adni a projekthez plusz BRAM modulokat és a WS2813_TopLevel állományt a kijelölt helyeken kell módosítani.**

Vivado design suite-ban:
 - IP Catalog
 - Keresőbe: "BRAM"
 - Block memory generator
 - Single port ROM opció
   - Width: 24
   - Depth: 90
 - Algorithm: Low Power
 - Other options (BRAM memória adattal való feltöltése):
   - Új *.coe file létrehozása / A már meglévő coe file hozzáadása
   - "load init file" kipipálása
   - init file hozzáadása
 - OK gomb

## Színek

A BRAM memóriába a színeket GRB formában kell feltölteni, tehát:
 - piros: 00FF00
 - zöld: FF0000
 - c. sárga: FFFF00
 - kék: 0000FF
 - fehér: FFFFFF
 - magenta: 00FFFF