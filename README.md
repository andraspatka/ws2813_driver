# Újrakonfigurálható Digitális Áramkörök Projekt 2019 - 2020

Téma: 33. Programozható LED-fűzéren alapuló reklámpanel b) LED füzér vezérlése, adatok kiírása

## Mappastruktúra

### docs

Ez tartalmazza az általam írt dokumentációt, plusz a LED fűzér adatlapját, meg egy tartalmas útmutatót a LED fűzér használatáról.

### src

Ez a mappa tartalmazza a forráskódot. 

## BRAM hozzáadása a design-hoz

Vivado design suite-ban:
 - IP Catalog
 - Keresőbe: "BRAM"
 - Block memory generator
 - Single port RAM opció
   - Write/Read width: 24
   - Write/Read depth: 100
 - Other options:
   - Új *.coe file létrehozása
   - A következő példakód szerint kitölteni a coe file-t:
   - ```memory_initialization_radix=16;memory_initialization_vector=001,002,003,004,005,006,007,008,009,00A,00B,00C,00D,00E,00F,010; ```
   - "load init file" kipipálása
   - init file hozzáadása