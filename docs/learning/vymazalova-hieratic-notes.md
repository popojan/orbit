# Hana Vymazalová: Staroegyptská matematika — Čtenářské poznámky

**Zdroj:** Vymazalová, H. *Staroegyptská matematika: Hieratické matematické texty*. Praha: Český egyptologický ústav, 2006.
**PDF:** [dml.cz/handle/10338.dmlcz/401065](https://dml.cz/handle/10338.dmlcz/401065)

**Účel:** Systematické poznámky při čtení, hledání spojitostí s Orbit projektem (γ framework, Egyptian fractions, CF).

---

## Struktura knihy

### Část I: Staroegyptská matematika (teoretický úvod)
- I.1 Úvod
- I.2 Jazykové prostředky
- I.3 Staroegyptské jednotky délky a objemu
- I.4 Počítání se zlomky
- I.5 Řešení rovnic
- I.6 Výpočet obsahu plochy
- I.7 Výpočet objemu tělesa
- I.8 Výpočet sklonu pyramidy (seked)
- I.9 Slovní úlohy různého zaměření
- I.10 Stanovení kvality piva a chleba
- I.11 Staroegyptská matematika (závěr)

### Část II: Překlady hieratických matematických textů
- II.1 Moskevský matematický papyrus
- II.2 Fragmenty papyru nalezené v Káhúnu
- II.3 Fragmenty papyru z muzea v Berlíně
- II.4 Dřevěné tabulky nalezené v Achmímu (Akhmim Wooden Tablets!)
- II.5 Rhindův matematický papyrus
- II.6 Kožený svitek

---

## Část I.1-I.2: Úvod a jazykové prostředky (řádky 1-500)

### Kontext
- Texty z **první poloviny 2. tisíciletí př. Kr.**
- Psány **hieratickým písmem** (ne hieroglyfy — ty pro oficiální účely)
- Gramaticky **klasická (střední) egyptština**
- Většina na papyru, ale i dřevěné tabulky, kožený svitek, ostraka

### Klíčové poznatky

#### Číselný systém
- **Nepoziční desítkový systém** (jako římské číslice)
- Číslice pro 1, 10, 100, 1000, 10000, 100000, 1000000
- Čísla = kombinace potřebného počtu číslic

#### Zlomky
- **Kmenné zlomky** (unit fractions): 1/n
- Zápis: znak nad číslovkou (v hieratice tečka)
- **Výjimka: 2/3** — vlastní znak (jediný ne-kmenný zlomek!)
- Všechny operace musí dát výsledek jako součet kmenných zlomků

**🔗 Orbit connection:** Toto je přesně co řeší náš `EgyptianFractions` modul!

#### Matematické operace — terminologie
| Operace | Egyptský termín | Význam |
|---------|-----------------|--------|
| Obecně | *iri* | "dělat, počítat" |
| Sčítání | *wah* | "spojit, připojit" |
| Odčítání | *chebi* | "zmenšit" |
| Násobení | *iri* + *sep* | "počítej s x y-krát" |
| Dělení | *iri* + *r gemet* | "počítej dokud nenajdeš" |
| Dělení | *nis* | přímo "dělit" |
| Výsledek | *cheper* | "vzniknout, stát se" |
| Výsledek | *demedž* | "sečteno, celkem" |

#### Násobení — algoritmus zdvojování
```
15 × 13:
  \1   15
   2   30
  \4   60
  \8  120
  --------
  13  195   (protože 1+4+8=13, sečti 15+60+120)
```
- Zdvojnásobování činitele
- Sčítání vybraných řádků
- **🔗 Orbit:** Souvisí s binárním rozkladem čísla!

#### Dělení — inverzní algoritmus
```
43 ÷ 8:
  \1    8
   2   16
  \4   32
  \1/8  1
  \1/4  2
  ---------
  5+1/8+1/4  (protože 8+32+1+2=43)
```
- Stejný princip jako násobení, jen hledáme v pravém sloupci

#### Umocňování
- *seš* = "mocnina"
- *h.ajet* = "pravoúhelník" (→ geometrický význam x²!)
- "spočítej pravoúhelník z x" = x²

#### Odmocňování
- *k.enbet* = "odmocnit"
- Předpokládá se geometrický přístup + empirické vztahy

**Klíčový poznatek:** Ve všech dochovaných textech jsou odmocňované hodnoty **"bezproblémové"** — mají celočíselné výsledky (√16=4, √100=10, √64=8 atd.). Jediná výjimka je B1 (pythagorejská trojice).

> *"Téměř ve všech případech je odmocňovaná hodnota opět bezproblémová, jedinou výjimkou je výpočet na berlínském papyru."* — Vymazalová

**Důsledek:** Egypťané pravděpodobně **neměli algoritmus pro iracionální odmocniny**. Úlohy byly konstruovány tak, aby výsledky vycházely celá čísla. Znali √n pro malá n z paměti/tabulek.

**🔗 Orbit connection:** Zásadní rozdíl oproti řecké matematice — Pythagorejci museli řešit √2 krizi, Egypťané se jí vyhnuli konstrukcí úloh!

---

## Část I.3: Jednotky délky a objemu (řádky 500-700)

### Délkové jednotky
| Jednotka | Hodnota | Vztah |
|----------|---------|-------|
| 1 loket | 52,5 cm | = 7 dlaní |
| 1 dlaň | 75 mm | = 4 prsty |
| 1 prst | 18,5 mm | |
| 1 chet | 52,5 m | = 100 loktů |
| 1 secat | 2756,5 m² | = 1 chet² |

### Objemové jednotky (obilí)
| Jednotka | Hodnota | Vztah |
|----------|---------|-------|
| **1 měřice (hekat)** | 4,805 l | **= 320 ro** |
| 1 ro | 0,015 l | |
| 1 henu | 0,4805 l | = 1/10 měřice |
| 1 pytel | 96,114 l | = 20 měřic |

**🔗 Key relationship:** 1 loket³ = 1½ pytle, tedy 1 pytel = ⅔ lokte³

### Horovo oko (Eye of Horus) — zlomky měřice

Speciální systém zlomků pro měřici:
```
1/2 + 1/4 + 1/8 + 1/16 + 1/32 + 1/64 = 63/64
```

Znaky těchto zlomků dohromady tvoří **vedžat** (posvátné oko boha Hora).

**🔗 Orbit connection:**
- Chybějící 1/64 je klíčové!
- 1 měřice = 64/64 Horova oka = 320 ro
- Tedy 1/64 měřice = 5 ro
- Zbytek R (v 1/64 jednotkách) = 5R ro
- Formule: `64/64 × 1/n = Q/64 + (5R/n)/320`

### Akhmim Wooden Tablets — výpočty s měřicí

Příklady z tabulek pro převod 1/n měřice na zlomky Horova oka:

```
1/7 měřice:
  320 ÷ 7 = 45 + 1/2 + 1/7 + 1/14 ro
  = 1/8 + 1/64 měřice + (1/2 + 1/7 + 1/14) ro
  Zkouška: 7 × (1/8 + 1/64 měřice + zbytek) = 1 měřice ✓

1/10 měřice:
  320 ÷ 10 = 32 ro
  = 1/16 + 1/32 měřice + 2 ro ✓

1/11 měřice:
  320 ÷ 11 = 29 + 1/11 ro
  = 1/16 + 1/64 měřice + (4 + 1/11) ro ✓

1/13 měřice:
  320 ÷ 13 = 24 + 1/2 + 1/13 + 1/26 ro
  = 1/16 + 1/64 měřice + (4 + 1/2 + 1/13) ro ✓
```

**Zajímavost:** Výpočet pro 1/3 měřice používá **odlišnou metodu** — postupné zdvojnásobování od 1/64.

---

## Část I.4: Počítání se zlomky (řádky 900-1000)

### Tabulka 2÷n

Klíčová tabulka pro zdvojnásobování lichých zlomků.

**Proč důležitá:**
- Zdvojnásobování = základ násobení a dělení
- 2 × 1/(2k) = 1/k (snadné)
- 2 × 1/(2k+1) = ? (složité — nutno rozložit na kmenné zlomky)

**Dochované verze:**
1. Káhúnský papyrus: 1/3 až 1/21
2. Rhindův papyrus: 1/3 až 1/101 (s písemnými výpočty)

**Příklad z Rhindova papyru:**
```
2 ÷ 7 = 1/4 + 1/28

Postup:
  2 ÷ 7 = 1/4 ... zbytek 1/4
  1/4 ÷ 7 = 1/4 × 1/7 = 1/28
  Tedy: 2/7 = 1/4 + 1/28 ✓
```

**🔗 Orbit connection:** Toto je přesně tabulka v `data/rhind-2n-table.md`!

> *"Tabulku 2÷n tedy snad můžeme považovat za pokus o **kodifikaci nejednoznačných rozkladů**, aby písař, který ji měl při práci po ruce, nemusel nad dvojnásobky dlouho přemítat."* — Vymazalová

**Klíčový citát!** Potvrzuje náš poznatek: Egyptian fraction rozklady **nejsou jedinečné**, ale Egypťané potřebovali kanonickou verzi.

### Začátek tabulky 2÷n
```
2 ÷ 3 = 2/3           (výjimka — vlastní symbol)
2 ÷ 5 = 1/3 + 1/15
2 ÷ 7 = 1/4 + 1/28
2 ÷ 9 = 1/6 + 1/18
2 ÷ 11 = 1/6 + 1/66
```

---

## Část I.5: Řešení rovnic (řádky 1500-2100)

### Metoda falešné pozice (*aha*)

Egypťané řešili lineární rovnice metodou **falešné pozice**:

1. Zvol vhodné počáteční číslo (obvykle aby se dobře dělilo)
2. Proveď operace s tímto číslem
3. Porovnej s požadovaným výsledkem
4. Škáluj poměrem

**Příklad R24:** "Číslo a jeho sedmina dají dohromady 19"
```
Rovnice: x + x/7 = 19

Postup:
1. Zvol x = 7 (dobře dělitelné 7)
2. 7 + 7/7 = 7 + 1 = 8
3. Potřebujeme 19, máme 8
4. Škáluj: 7 × (19/8) = 7 × (2 + 1/4 + 1/8) = 16 + 1/2 + 1/8

Zkouška: 16.625 + 16.625/7 = 16.625 + 2.375 = 19 ✓
```

### Kvadratické rovnice (B1)

Berlínský papyrus obsahuje úlohu B1 — **nejstarší dochovaná kvadratická rovnice**:

```
x² + y² = 100
y = (3/4)x

Řešení:
x² + (9/16)x² = 100
(25/16)x² = 100
x² = 64
x = 8, y = 6
```

**🔗 Orbit connection:** Pythagorejská trojice (6, 8, 10)! Egypťané znali x² + y² = z² vztahy.

---

## Část I.6: Výpočet obsahu plochy (řádky 2100-2800)

### Obdélník a trojúhelník

Standardní vzorce:
- Obdélník: S = a × b
- Trojúhelník: S = (1/2) × základna × výška

### Lichoběžník

- S = (1/2)(a + b) × h

### Kruh — klíčový vzorec!

**Egyptský postup:**
```
Obsah kruhu = (d - d/9)² = (8d/9)²
```

Kde d = průměr.

**Odvození π:**
```
S = (8d/9)² = 64d²/81

Moderní: S = π(d/2)² = πd²/4

Porovnání: 64/81 = π/4
         π = 256/81 ≈ 3.1605
```

**🔗 Orbit connection:**
- Egyptská aproximace π ≈ 256/81 = 3.160493...
- Skutečné π ≈ 3.141592...
- Chyba < 0.6%
- Racionální aproximace jako v γ frameworku!

### Jak Egypťané odvodili vzorec?

Vymazalová cituje teorii **osmiúhelníkové aproximace**:

1. Nakresli čtverec o straně 9
2. Ořízni rohy (pravoúhlé trojúhelníky 3×3)
3. Zbyde osmiúhelník ≈ kruh
4. Plocha = 81 - 4×(9/2) = 81 - 18 = 63 ≈ 64

Odtud (8/9 × d)² aproximuje kruh.

---

## Část I.7: Výpočet objemu tělesa (řádky 2800-3000)

### Kvádr (sýpka)
- V = a × b × c (v loktech³)
- Převod na pytle: V × 1.5

### Válec
- V = (8d/9)² × h
- Používá kruhový vzorec pro podstavu

### Komolý jehlan (M14 — slavná úloha!)

**Moskevský papyrus M14** obsahuje správný vzorec pro komolý jehlan:

```
V = (h/3)(a² + ab + b²)
```

**🔗 Orbit connection:** Tento vzorec je algebraicky náročný — vyžaduje součet geometrické řady. Jak ho Egypťané odvodili bez formální algebry?

---

## Část I.8: Výpočet sklonu pyramidy — seked (řádky 3000-3200)

### Definice

**Seked** = horizontální posun na 1 loket vertikálního vzestupu

```
seked = (základna/2) / výška × 7 dlaní
```

Tedy seked je **kotangens** úhlu sklonu, měřený v dlaních na loket.

**Příklad R56:**
```
Pyramida: základna 360 loktů, výška 250 loktů
seked = (180/250) × 7 = 5.04 dlaně = 5 + 1/25 dlaně
```

**🔗 Orbit connection:**
- Velká pyramida: seked ≈ 5.5 dlaně = 5 + 1/2
- Odpovídá úhlu 51°50'
- Souvisí s poměrem π a φ!

---

## Část I.9: Slovní úlohy (řádky 3200-3400)

### Aritmetické posloupnosti

**R40:** Rozděl 100 bochníků mezi 5 lidí tak, že rozdíl mezi sousedy je konstantní a 3 menší díly = 1/7 dvou větších.

```
a₁ + a₂ + a₃ + a₄ + a₅ = 100
a₅ - a₄ = a₄ - a₃ = ... = d (konstanta)
a₁ + a₂ + a₃ = (1/7)(a₄ + a₅)

Řešení: 1⅔, 10⅚, 20, 29⅙, 38⅓
```

### Geometrické posloupnosti

**R79 — slavná úloha:** "7 domů, 49 koček, 343 myší, 2401 klasů, 16807 zrn ječmene"

```
7 + 49 + 343 + 2401 + 16807 = 19607
= 7 × (1 + 7 + 49 + 343 + 2401)
= 7 × (7⁵ - 1)/(7 - 1)
= 7 × 2801 = 19607
```

**🔗 Orbit connection:** Geometrická řada! Egypťané znali součet mocnin.

---

## Část I.10: Kvalita piva a chleba — pesu (řádky 3400-3700)

### Definice pesu

**Pesu** = míra kvality/síly:
```
pesu = počet bochníků / spotřeba obilí (v měřicích)
```

Vyšší pesu = slabší produkt (více kusů z téhož množství).

### Typické úlohy

**R69:** Směnit bochníky různých pesu při zachování celkové hodnoty.

**R72-R78:** Výpočty s pivem — pesu piva závisí na množství obilí a sladu.

---

## Část I.11: Závěr teoretické části

Vymazalová shrnuje:
- Egyptská matematika byla **praktická**, ne abstraktní
- Sloužila **administrativě** (daně, zásoby, stavby)
- **Neznali nulu** ani záporná čísla
- Zlomky pouze **kmenné** (kromě 2/3)
- Metody empirické, ne důkazové

---

## Část II: Překlady hieratických textů (souhrn)

### Chronologie textů

| Text | Sepsán | Předloha | Období |
|------|--------|----------|--------|
| **Káhúnský papyrus** | 12. dynastie | — | cca 1994–1797 př. Kr. |
| **Achmímské tabulky** | 12. dynastie | — | cca 1994–1797 př. Kr. |
| **Moskevský papyrus** | 13. dynastie | 12. dynastie? | cca 1797–1650 př. Kr. |
| **Rhindův papyrus** | 15. dynastie (16. stol.) | **12. dynastie (19. stol.)** | opis cca 1550, předloha cca 1850 př. Kr. |
| **Berlínský papyrus** | Střední říše | — | cca 2000–1700 př. Kr. |
| **Kožený svitek** | ? | — | datace nejistá |

**🔗 Klíčový poznatek:** Všechny hlavní texty mají původ v **12. dynastii** (cca 1994–1797 př. Kr.) = "zlatý věk" egyptské matematiky! Rhind je jen pozdější opis.

### II.1 Moskevský matematický papyrus (M1-M25)

**Datace:** Sepsán 13. dynastie, předloha možná 12. dynastie

25 úloh, z toho nejslavnější:
- **M10:** Obsah povrchu půlkoule (?)
- **M14:** Objem komolého jehlanu

### II.2 Káhúnský papyrus (K1-K8)

**Datace:** 12. dynastie (opuštěné sídliště u pyramidy Senusreta II.)

Fragmenty včetně:
- K3-K4: Tabulka 2÷n (**nejstarší dochovaná verze!**)
- K6: Výpočet objemu válce

### II.3 Berlínský papyrus (B1-B4)

**Datace:** Střední říše (přibližně)

- **B1:** Kvadratická rovnice (viz výše)
- B2-B4: Fragmentární úlohy

### II.4 Achmímské dřevěné tabulky (AWT)

**Datace:** 12. dynastie (na základě písma a osobních jmen)

Dvě tabulky s výpočty 1/n měřice v systému Horova oka.

**🔗 Orbit connection:** Klíčový zdroj pro pochopení převodů mezi systémy zlomků!

### II.5 Rhindův matematický papyrus (R1-R87)

**Datace:** Sepsán 15. dynastie (16. stol. př. Kr., písař Ahmes za Apopiho), ale **předloha z 12. dynastie** (19. stol. př. Kr., za Amenemheta III.)

Nejrozsáhlejší zdroj:
- **R1-R6:** Dělení n bochníků mezi 10 lidí
- **R7-R20:** Násobení zlomků
- **R21-R23:** Doplňování (completion problems)
- **R24-R38:** Aha úlohy (lineární rovnice)
- **R39-R40:** Aritmetické posloupnosti
- **R41-R46:** Objemy sýpek
- **R47:** Převod pytel↔měřice↔henu
- **R48-R55:** Plochy (trojúhelník, lichoběžník, kruh)
- **R56-R60:** Seked (sklon pyramidy)
- **R61:** Vzorce pro 2/3
- **R62-R68:** Různé úlohy
- **R69-R78:** Pesu (pivo, chléb)
- **R79:** Geometrická řada (7 domů)
- **R80-R84:** Převody jednotek, krmení ptáků

#### R61B — vzorec pro 2/3 lichého zlomku

```
2/3 × 1/(2k+1) = 1/(2(2k+1)) + 1/(6(2k+1))
```

**🔗 Orbit connection:** Systematické pravidlo pro práci se zlomky!

### II.6 Kožený svitek

26 identit pro sčítání zlomků, např.:
```
1/9 + 1/18 = 1/6
1/5 + 1/20 = 1/4
1/4 + 1/8 + 1/16 + 1/64 = 1/2 + 1/32
```

**🔗 Orbit connection:** Tyto identity jsou speciální případy obecnějších vztahů v EgyptianFractions modulu.

---

## Klíčové Orbit Connections — Souhrn

### 1. Egyptian Fractions modul
- Přímá implementace egyptského zlomkového systému
- 2÷n tabulka v `data/rhind-2n-table.md` — srovnání s Rhindovým papyrem
- Nejednoznačnost rozkladů: Egypťané řešili kodifikací, Orbit CF-kanonicitou

### 2. Binární rozklad
- Egyptské násobení = binární expanze
- Zdvojování činitele ↔ bitový posun
- Sčítání vybraných řádků ↔ binární součet

### 3. Geometrické řady
- Horovo oko: 1/2 + 1/4 + ... + 1/64 = 63/64 = 1 - 2⁻⁶
- R79: 7 + 49 + ... + 16807 = (7⁶-7)/(7-1)
- Archimédovské téma: konvergence řad

### 4. Racionální aproximace π
- Egyptské: π ≈ 256/81 ≈ 3.1605
- γ framework: racionální parametrizace kruhu
- Chyba < 0.6% — prakticky dostatečné

### 5. Pyramidy a geometrie
- Seked = kotangens v racionálních jednotkách
- Velká pyramida: seked 5½ dlaně ↔ poměry π, φ
- Komolý jehlan (M14): geometrická řada v algebraickém vzorci

### 6. Eye of Horus algebra
- 1 hekat = 320 ro = 64/64 Horova oka
- Formule: 1/n hekatu = Q/64 (Horovo oko) + R ro (zbytek)
- Duální reprezentace: mocniny 2 + desetinný zbytek

---

## Naše úvahy a spekulace

Reflexe nad knihou, souvislosti s Orbit projektem a spekulace o pyramidách viz:

**[Vymazalová Reading: Reflections and Orbit Connections](../sessions/2025-12-12-vymazalova-reflections/README.md)**

---

*Poznámky kompletovány 2025-12-12 na základě systematického čtení celého textu.*
