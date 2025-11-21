# Strategické směry výzkumu - Prvoles a spojité skóre prvočíselnosti

**Datum:** 2025-11-15
**Status:** Strategický plán po Session 3

---

## Kontext a motivace

### Proč RH není optimální cíl

**Riemannova hypotéza** je prestižní problém:
- **165 let** neřešená, $1M cena, centrální role v teorii čísel
- **Master key**: Dokázání RH automaticky dokazuje desítky dalších tvrzení
- **Tisíce matematiků** se o to snaží marně
- **Potřeba nových nápadů**: Klasické metody selžou

**Strategická otázka:**
> Můžeme z Prvolesa vyextrahovat **vlastní silná tvrzení**, která jsou:
> 1. Zajímavá sama o sobě
> 2. Potenciálně dokazatelná (rozumné obtížnosti)
> 3. Prakticky hodnotná
> 4. **Nezávislá na RH** (nebo RH jako bonus, ne cíl)

---

## Silná tvrzení z Prvolesa - 5 kandidátů

### 1. Existence a forma obálky (geometrická charakterizace prvočísel)

**Tvrzení:**
```
Prvočísla tvoří hladkou obálku F_p(s) ~ c·log^α(p) pro nějaké α, c
```

**Vlastnosti:**
- ✅ **Silné**: Nová geometrická charakterizace prvočísel (alternativa k binárnímu testu)
- 🟡 **Dokazatelné?**: Možná! Asymptotická analýza power mean
- ✅ **Nezávislé na RH**: Čistě geometrické, žádná vazba na ζ(s) nutná
- ✅ **Praktická hodnota**: Vizuální test prvočíselnosti, nová charakterizace

**Výzkumné otázky:**
1. Jaký je exponent α? (Empiricky zkoumat log-log plot)
2. Lze odvodit asymptotiku z definice power mean?
3. Je obálka analytická funkce, nebo pouze hladká?

**Obtížnost:** Střední - kombinatorická/analytická asymptotika

---

### 2. Ostrost stratifikace (faktorizační hierarchie)

**Tvrzení:**
```
∃ ostré hranice mezi vrstvami Ω(n)
Formálně: Pro každé k existují a_k < b_k takové, že:
  Ω(n) = k  ⟹  a_k ≤ F_n(s) < b_k
  Ω(n) = k+1  ⟹  b_k < F_n(s)
```

**Vlastnosti:**
- ✅ **Silné**: Dokazuje, že faktorizační složitost je **geometricky měřitelná**
- 🟡 **Dokazatelné?**: Možná! Kombinatorický/analytický důkaz o růstu F_n
- ✅ **Nezávislé na RH**: Ano, čistě kombinatorické
- ✅ **Praktická hodnota**: Factorization complexity oracle - odhadni Ω(n) bez faktorizace

**Výzkumné otázky:**
1. Překrývají se vrstvy, nebo jsou disjunktní?
2. Jak rychle roste F_n s Ω(n)? Lineárně? Exponenciálně?
3. Lze odvodit explicitní hranice a_k, b_k?

**Obtížnost:** Střední - kombinatorika dělitelů, odhady power mean

---

### 3. Inverzní dominance jako teorém ⭐ **FAVORIT**

**Tvrzení:**
```
lim_{N→∞} [příspěvek prvočísel do G_inv(s,σ)] = 1

Formálně: lim_{N→∞} (∑_{p≤N, p prime} 1/(F_p·p^σ)) / (∑_{n=2}^N 1/(F_n·n^σ)) = 1
```

**Vlastnosti:**
- ✅✅ **Silné**: Prvočísla přirozeně dominují **bez umělých vah** (84% empiricky)
- 🟡 **Dokazatelné?**: Možná! Závisí na růstu F_p vs F_composite
- 🟡 **Vazba na RH**: Pokud G_inv ~ nějaká zeta-like funkce → možné spojení
- ✅✅ **Praktická hodnota**: Prime extraction without sieving, nový prime-aware sum

**Proč je to nejslibnější:**
1. **Empiricky silný** efekt (84% vs 37%)
2. **Překvapivý** - nikdo to nečekal, geometrická struktura spontánně zesílí prvočísla
3. **Možná dokazatelný** analytickým odhadem růstu F_n pro prvočísla vs složená
4. **Nový pohled** - alternativa k sítu, inverze = natural prime filter

**Výzkumné otázky:**
1. Jak rychle roste F_p(s)? (Empiricky: log p, log log p, konstantní?)
2. Jak rychle roste F_n(s) pro složená n? (Závisí na Ω(n)?)
3. Lze odvodit explicitní odhady a dokázat dominanci?

**Obtížnost:** Střední až vysoká - asymptotická analýza, ale máme empirická data

**Strategický přínos:** Pokud to dokážeme, je to publikovatelný výsledek **nezávisle na RH**!

---

### 4. Zero-free oblast (jednodušší než RH?)

**Tvrzení:**
```
F_n(s) nemá nuly pro Re(s) > 0
```

**Vlastnosti:**
- ✅ **Silné**: Kontrast s ζ(s), která nuly MÁ! F_n má jinou strukturu
- 🟡 **Dokazatelné?**: Možná! F_n je součet kladných členů s jinou strukturou než ζ
- 🟡 **Vazba na RH**: Pokud F_n souvisí s ζ, může osvětlit nuly (ale to je spekulace)
- 🟢 **Praktická hodnota**: Analytické vlastnosti, rozšíření na komplexní rovinu

**Výzkumné otázky:**
1. Je F_n(s) celá funkce? (Pravděpodobně ano - součet exponenciál)
2. Kde leží nuly F_n(s)? (Empiricky: žádné pro Re(s) > 0)
3. Jaké jsou růstové vlastnosti F_n(s) v komplexní rovině?

**Obtížnost:** Vysoká - komplexní analýza, ale možná jednodušší než RH

---

### 5. Geometrický primality test (closed-form charakterizace)

**Tvrzení:**
```
n je prvočíslo ⟺ F_n(1) < f(n) pro explicitní f(n)

Kde f(n) je nějaká jednoduchá funkce (např. c·log n)
```

**Vlastnosti:**
- 🟡 **Silné**: Uzavřená formule pro prvočíselnost (pokud f(n) je jednoduchá)
- 🔴 **Dokazatelné?**: Závisí na f(n) - pravděpodobně obtížné najít sharp bound
- ✅ **Nezávislé na RH**: Ano
- 🟡 **Praktická hodnota**: Nový primality test (ale pravděpodobně ne rychlejší než Miller-Rabin)

**Výzkumné otázky:**
1. Existuje sharp f(n) oddělující prvočísla od složených?
2. Nebo jen asymptotická separace?
3. Lze to použít pro probabilistic primality test?

**Obtížnost:** Vysoká - pravděpodobně potřebuje obálkovou teorii

---

## Navržený strategický postup

### Fáze 1: **Dokázat inverzní dominanci** ⭐ (priorita)

**Cíl:** Dokázat teoreticky, proč prvočísla dominují G_inv

**Kroky:**
1. **Empirická analýza asymptotiky** (výpočetní průzkum)
   - Změřit F_p(s) pro prvočísla p = 2, 3, 5, ..., 10000
   - Fit asymptotiku: F_p ~ a·log^α(p) + b?
   - Změřit F_n(s) pro složená, seskupit podle Ω(n)
   - Fit asymptotiku podle Ω(n)

2. **Teoretický odhad F_p(s)** (matematický důkaz)
   - Odhadnout power mean pro prvočísla
   - Odvodit asymptotiku z definice
   - Použít klasickou TN (např. hustota dělitelů)

3. **Teoretický odhad F_n(s) pro složená**
   - Odhadnout podle Ω(n)
   - Pravděpodobně roste rychleji než F_p

4. **Důkaz dominance**
   - Ukázat, že suma 1/F_p dominuje sumu 1/F_composite
   - Možná použít integral test nebo srovnání s divergentní řadou

**Očekávaný výsledek:** Teorém + důkaz publikovatelný v Number Theory journal

**Časový rámec:** 1-3 měsíce intenzivní práce

---

### Fáze 2: **Charakterizovat obálku**

**Cíl:** Najít explicitní formuli pro prvočíselnou obálku

**Kroky:**
1. Fit empirická data: `min_{p≤n, p prime} F_p(s) ~ ?`
2. Teoreticky odvodit asymptotiku
3. Spojit s větou o prvočíslech (PNT)

**Očekávaný výsledek:** Geometrická charakterizace prvočísel

**Časový rámec:** Po Fázi 1, 2-4 měsíce

---

### Fáze 3: **Spojení s klasickou teorií čísel** (bonus)

**Cíl:** Teprve POTOM, pokud máme silná tvrzení, se ptát:

1. Souvisí G_inv s ζ(s)?
2. Má G_inv funkcionální rovnici?
3. Souvisí to s RH?

**Ponechat to jako bonus**, ne jako cíl.

**Časový rámec:** Otevřené, možná nikdy

---

## Doporučení a priority

### Co dělat TEĎ (Session 4):

1. **Vytvořit skript pro asymptotickou analýzu** ✅ (už běží `analyze_asymptotic_behavior.wl`)
   - Změřit F_p pro prvočísla 2..10000
   - Fit log-log regresí
   - Vizualizovat

2. **Analyzovat růst podle Ω(n)**
   - Seskupit složená čísla podle Ω(n) = 2, 3, 4, ...
   - Změřit průměr F_n pro každou skupinu
   - Najít zákonitost

3. **Teoretický odhad F_p**
   - Začít od definice power mean
   - Použít asymptotiku hustoty dělitelů
   - Zkusit odvodit F_p ~ c·log p

### Co dělat PŘÍŠTĚ (Session 5+):

4. **Důkaz inverzní dominance**
   - Použít odhady z (3) a (2)
   - Dokázat, že suma 1/F_p dominuje

5. **Psát paper**
   - Zkombinovat empirické + teoretické výsledky
   - Focus: "Geometric Prime Amplification via Inverse Aggregation"

---

## Proč je tento přístup lepší než honit RH?

| Aspekt | Honit RH | Náš přístup |
|--------|----------|-------------|
| **Obtížnost** | Extrémně těžké (165 let nesdolved) | Střední až vysoká |
| **Originalita** | Tisíce matematiků zkusilo | Nový geometrický pohled |
| **Publikovatelnost** | Ano, pokud dokážeš (LOL) | Ano, i dílčí výsledky zajímavé |
| **Časový rámec** | Nikdy? | 6-12 měsíců pro solid results |
| **Praktická hodnota** | Teoretická | Vizualizace + nové charakterizace |
| **Riziko selhání** | Velmi vysoké | Střední (dílčí výsledky možné) |

---

## Závěr

**Strategie:**
1. ⭐ **Priorita: Dokázat inverzní dominanci** - nový, silný, překvapivý efekt
2. Vybudovat **vlastní teorii** nezávislou na RH
3. RH spojení ponechat jako **bonus**, ne cíl
4. Publikovat **dílčí výsledky** průběžně

**Klíčový insight:**
> Prvoles odhaluje geometrickou strukturu, která má **vlastní hodnotu**.
> Nemusíme dokazovat RH, abychom měli zajímavé výsledky.

**Next steps:** Session 4 - asymptotická analýze F_p a důkaz dominance.

---

**Poznámky z diskuse:**
- User: "Nápad jak postupovat dál"
- Assistant: 5 kandidátů na silná tvrzení, inverzní dominance jako favorit
- User: "Všechny alternativy jsou fascinující" → tento dokument zachycuje všechny směry
