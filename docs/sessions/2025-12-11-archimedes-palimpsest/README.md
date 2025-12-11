# Archimedův palimpsest a Metoda

**Session:** 2025-12-11
**Status:** 🔬 Exploratory research
**Topic:** Greek mathematics, proto-calculus, historical connections

---

## Co je Archimedův palimpsest?

Pergamenový kodex z 10. století obsahující opsané Archimedovy spisy. Ve 13. století (kolem roku 1229) byl pergamen seškrábán a přepsán křesťanskými modlitbami (euchologion) - odtud název "palimpsest" (παλίμψηστον = znovu seškrábaný).

### Časová osa

| Rok | Událost |
|-----|---------|
| ~530 | Isidor z Milétu (architekt Hagia Sofia) pravděpodobně sestavil původní kompilaci |
| ~950 | Byzantský písař v Konstantinopoli opisuje Archimedovy texty |
| ~1229 | Pergamen seškrábán, přepsán modlitbami |
| 1840s | Constantin von Tischendorf odstraní jeden list (nyní Cambridge) |
| 1899 | Papadopoulos-Kerameus katalogizuje rukopis, přepisuje části textu |
| 1906 | **Johan Ludvig Heiberg** identifikuje Archimedův text v knihovně Metochion v Konstantinopoli |
| 1910-1915 | Heiberg publikuje přepisy |
| 1920s | Rukopis zmizí z knihovny, končí ve francouzské sbírce (Marie Louis Sirieux) |
| po 1938 | Falzifikátor přidá čtyři byzantské malby se zlatým listem |
| 1998 (29. října) | Prodej v aukci Christie's New York za $2 000 000 anonymnímu kupci |
| 1999+ | Výzkum ve Walters Art Museum, Baltimore |
| 2005-2008 | Rentgenová fluorescence (Stanford Synchrotron) čte text pod falešnými malbami |

### Obsah palimpsestu

1. **Metoda (Ἔφοδος)** - jediný dochovaný exemplář!
2. **Stomachion** - kombinatorický problém
3. **O plovoucích tělesech** (řecky) - nejúplnější verze
4. **O kouli a válci**
5. **Měření kruhu**
6. **O spirálách**
7. **O rovnováze rovin**
8. Fragmenty **řečí Hyperida** (attický řečník, nesouvisí s Archimedem)

---

## Metoda (Ἔφοδος / The Method of Mechanical Theorems)

### Proč je revoluční

Řecká matematika = axiomatické důkazy (Eukleidovský styl). Archimedes vždy publikoval hotové důkazy, ale **nikdy neprozradil, jak na výsledky přišel**.

Metoda je dopis Eratosthenovi (hlavnímu knihovníkovi Alexandrijské knihovny), kde Archimedes odhaluje svou **heuristiku** - metodu "indivisibilií" (nedělitelných).

### Mechanická metoda

Postup:
1. Představ si geometrický útvar jako **fyzické těleso**
2. "Rozřež" ho na nekonečně mnoho rovnoběžných řezů (indivisibilia)
3. Tyto řezy mají "váhu" úměrnou jejich délce/ploše
4. **Zvaž** je na páce pomocí zákona rovnováhy momentů
5. Z rovnováhy odvoď objem/plochu
6. Pak teprve hledej formální důkaz metodou exhausce

### Archimedova vlastní rezervovanost

Archimedes sám nepovažoval metodu indivisibilií za rigorózní matematiku. Proto:
- Používal ji jako heuristiku k *nalezení* výsledků
- Publikoval pouze formální důkazy metodou exhausce
- V Metodě explicitně vysvětluje, že tento přístup není důkaz, ale cesta k objevu

### Historický význam

- **Proto-infinitezimální kalkulus** - téměř 2000 let před Newtonem/Leibnizem
- Ukazuje, že Archimedes *myslel* fyzikálně/intuitivně, ale *psal* formálně
- Metoda indivisibilií byla znovu objevena Keplerem a rozvinuta **Cavalerim** (17. stol.)
- Bez palimpsestu bychom o tomto přístupu nevěděli

---

## Stomachion (Ostomachion / Loculus Archimedis)

### Co jsme věděli před palimpsestem
- Existovaly zmínky v arabských a latinských pramenech
- Znali jsme ho jako "skládačku" - 14 dílů tvořících čtverec
- Nejstarší známá matematická hádanka

### Co odhalil palimpsest
Archimedes řešil **kombinatorický problém**: "Kolika způsoby lze složit čtverec z těchto 14 dílů?"

### Moderní řešení (2003)

Tým matematiků (Persi Diaconis, Susan Holmes ze Stanfordu; Fan Chung, Ron Graham z UCSD) spočítal:

- **536** geometricky odlišných řešení
- × 32 symetrií (4 rotace × 2 zrcadlení × 4 výměny identických trojúhelníků)
- = **17 152** celkových řešení

Výsledek nezávisle potvrdil William Cutler počítačovým programem.

### Význam

Stomachion je pravděpodobně **první dochovaný kombinatorický problém** v historii matematiky. Reviel Netz (Stanford) argumentuje, že toto odvětví matematiky nepřišlo ke slovu až do vzniku informatiky.

Není jasné, zda Archimedes sám správný počet spočítal - ale "from all we know of him, more likely than not, he did."

---

## Cattle Problem (Problema Bovinum)

**Poznámka:** Tento problém *není* z palimpsestu, ale z jiného rukopisu.

### Objev

V roce **1773** objevil Gotthold Ephraim Lessing báseň o 44 řádcích v řeckém rukopisu v **Herzog August Library ve Wolfenbüttelu** (Německo).

### Obsah

Problém připisovaný Archimedovi, adresovaný Eratosthenovi. Popisuje "stáda Slunečního boha" (Hélia) na Sicílii - čtyři barvy skotu (bílý, černý, žíhaný, hnědý) v určitých poměrech.

### Homérská inspirace

Problém přímo navazuje na **Odysseu (kniha XII)**, kde Kirké varuje Odyssea před stády Hélia na ostrově Thrinakia:
- Homér uvádí 7 stád po 50 kusech = 350 skotu
- Archimedes vytváří mnohem složitější verzi s diofantickými podmínkami

### Řešení

- **1880**: Carl Ernst August Amthor nalezl obecné řešení
- Nejmenší řešení má přibližně **206 545 číslic** (~7.76×10²⁰⁶⁵⁴⁴)
- Kompletní výpočet musel počkat na počítačový věk

### Egyptská souvislost?

**Přímé spojení:**
- Eratosthenes byl ředitelem Alexandrijské knihovny (řecko-egyptské prostředí)
- V helénistickém Egyptě: Hélios ↔ Ra (interpretatio graeca)

**Ale:**
- "Stáda Slunce" jsou primárně **homérský motiv** (Thrinakia/Sicílie)
- Archimedes žil v Syrakusách, 85 km od Taorminy - byl s Homérovým příběhem důvěrně obeznámen
- Solární kulty existovaly v obou kulturách nezávisle

**Závěr:** Souvislost je literární (Homér → Archimedes), ne nábožensko-kulturní (Egypt → Řecko).

---

## Technologie rozluštění

### Multispektrální zobrazování (1999-2005)
- UV a infračervené světlo
- Odhalilo většinu textu pod modlitbami

### Rentgenová fluorescence - XRF (2005-2008)

Problém: Čtyři stránky byly pokryty **falešnými byzantskými malbami** (přidány po 1938 falzifikátorem pro zvýšení hodnoty). Zlato v malbách blokovalo optické metody.

Řešení: **Stanford Synchrotron Radiation Laboratory (SSRL)**
- Fyzik Uwe Bergmann navrhl použít XRF (studoval stopové kovy ve špenátu!)
- Rentgenové záření detekuje **železo v originálním inkoustu**
- Synchrotronové záření je mnohem intenzivnější a laditelné než běžné RTG

Citace Bergmanna: *"We're getting a vastly better understanding of one of the greatest minds of all times. We are also showing it is possible to read completely hidden texts in ancient documents without harming them."*

---

## Reference

### Primární zdroje

1. **The Archimedes Palimpsest Project** (oficiální stránky)
   - https://archimedespalimpsest.org/
   - Historie: https://www.archimedespalimpsest.org/about/history/index.php
   - Stomachion: https://www.archimedespalimpsest.org/about/scholarship/combinatorics.php

2. Netz, R., & Noel, W. (2007). *The Archimedes Codex: How a Medieval Prayer Book Is Revealing the True Genius of Antiquity's Greatest Scientist*. Da Capo Press.

### Stomachion

3. Chung, F., & Graham, R. "A tour of Archimedes' Stomachion"
   - https://mathweb.ucsd.edu/~fan/stomach/tour/stomach.html

4. Netz, R., Acerbi, F., & Wilson, N. "Towards a Reconstruction of Archimedes' Stomachion." *SCIAMVS* 5 (2004): 67-99.
   - https://www.sciamvs.org/files/SCIAMVS_05_067-099_Netz_Acerbi_Wilson.pdf

### Metoda

5. Cal State LA - Archimedes' Method (detailed analysis)
   - https://web.calstatela.edu/faculty/hmendel/Ancient%20Mathematics/Archimedes/Archimedes%20Method/ArchMethodCrude.html

6. Wikipedia: The Method of Mechanical Theorems
   - https://en.wikipedia.org/wiki/The_Method_of_Mechanical_Theorems

### Cattle Problem

7. Vardi, I. "Archimedes' Cattle Problem" (NYU)
   - https://math.nyu.edu/Archimedes/Cattle/cattle_vardi.pdf

8. Wikipedia: Archimedes's cattle problem
   - https://en.wikipedia.org/wiki/Archimedes's_cattle_problem

### XRF imaging

9. Stanford News (2006): "Modern X-ray technology reveals Archimedes' math theory under forged painting"
   - https://news.stanford.edu/news/2006/august9/arch-080906.html

10. SLAC Technical Summary
    - https://www.slac.stanford.edu/gen/com/images/technical%20summary_final.pdf

### Další

11. Heath, T. L. (1912). *The Works of Archimedes*. Cambridge University Press.
    - Online: https://archive.org/details/worksofarchimede00markup

12. PBS NOVA: "Inside the Archimedes Palimpsest"
    - https://www.pbs.org/wgbh/nova/physics/inside-archimedes-palimpsest.html

---

## Otevřené otázky

1. **Kompletní Metoda** - Část textu chybí nebo je nečitelná. Co dalšího Archimedes odhalil?

2. **Stomachion** - Dokončil Archimedes kombinatorický výpočet, nebo jen položil otázku?

3. **Identita kupce** - Anonymní americký kupec z "high-tech industry" (spekuluje se o Jeffu Bezosovi)

4. **Další palimpsesty?** - Existují další ztracené texty ukryté pod středověkými rukopisy?

---

## Souvislost s projektem Orbit

Archimedova "mechanická metoda" představuje zajímavý historický precedens pro:
- Heuristické vs. formální matematické myšlení
- Fyzikální intuice jako nástroj matematického objevu
- Skryté metody za publikovanými výsledky

Paralela s moderní explorativní matematikou: experimentální/numerické ověření → pak formální důkaz.

---

*Session initiated: 2025-12-11*
