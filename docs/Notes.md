# FPGA jegyzet

## Tervezési lépések, megfontolások

1. Tanulmányozni, hogy az algoritmus milyen műveleteket kell elvégezzen
2. Minden egyes eredmény vagy részeredmény tárolására alkalmazunk egy regisztert
3. Tanulmányozzuk, hogy minden egyes regiszter körül milyen műveleteket kell elvégezni. Tanulmányozzuk a műveletek közötti adatfüggőségeket
4. Az adatfüggőségek alapján a műveleteket beosszuk a megfelelő fázisba
5. Állapotgráf elkészítése