# WS2813 egyszálú adatátvitel protokoll leírása

A LED-eket vezérlő áramkörök egymás után vannak bekötve úgy, hogy az egyik áramkörnek az adatkimenete a következő áramkörnek az adatbemenetét képzi.

Egyszálú az adatátvitel, fontos a protokoll betartása, ahhoz, hogy adatokat tudjunk megjeleníteni a LED-fűzéren.

Amikor egy áramkör megkap egy 24 bit-es kódot, akkor ezt addig tárolja amíg más kódot nem kapna, vagy a tápforrást el nem veszti.

A 24 bit-es kód a következőképpen kell kinézzen:

8 bit GREEN | 8 bit RED | 8 bit BLUE

Az adatátvitel a következő sorrendben kell történjen: 

 - GREEN
 - RED
 - BLUE

**Az egyes byte-ok küldését úgy kell elvégezni, hogy az MSB-vel kell kezdeni és haladni az LSB fele.**

24 bit-es kód részletesebb felbontása:

 - **G7 G6 G5 G4 G3 G2 G1 G0 | R7 R6 R5 R4 R3 R2 R1 R0 | B7 B6 B5 B4 B3 B2 B1 B0**

A küldés a következő sorrendben kell elvégződjön:

 - *G7 G6 G5 G4 G3 G2 G1 G0 R7 R6 R5 R4 R3 R2 R1 R0 B7 B6 B5 B4 B3 B2 B1 B0*


Minden 24 bit-es adatátvitel után kell legalább 50 μs-ot várakozni. Ez jelzi azt, hogy egy 24 bit-es blokk továbbítása megtörtént.

Az egyes bit-ek átvitele a következőképp történik:

 - Logikai 1-es
   - 0.8 μs-ot magas feszűltségen
   - 0.45 μs-ot alacson feszűltségen
 - Logikai 0-ás
   - 0.4 μs-ot magas feszűltségen
   - 0.85 μs-ot alacson feszűltségen
 - 24 bit-es adatblokk küldése után: 
   - \> 50 μs

A bit-ek továbbításánál egy +/- 150 ns-os eltérés megengedett.

A várakozási értékeket nem az adatlapból, hanem az [alábbi](https://learn.adafruit.com/adafruit-neopixel-uberguide) útmutatóból vettem. Az útmutató szerint az adatlapban levő értékek rosszul vannak kiszámolva.

Egyelőre megpróbálok az útmutatóban megadott értékekkel dolgozni. Ha ez nem megfelelő működéshez vezet, akkor veszem az adatlapban levő értékeket.