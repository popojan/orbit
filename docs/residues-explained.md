# Residua v Komplexní Analýze: Vysvětlení od Základů

**Pro**: Někoho, kdo nezná komplexní analýzu do hloubky
**Cíl**: Pochopit, co jsou residua a proč jsou užitečná

---

## Co Je To Residuum?

### Intuice: "Zbývající Část" U Pólu

Představ si funkci, která má **pól** (singularitu) v nějakém bodě.

**Příklad**: Funkce $f(z) = \frac{1}{z}$ má pól v $z=0$.

Když se blížíš k pólu, funkce "exploduje" → roste k nekonečnu.

**Residuum** je **koeficient, který měří, jak moc** funkce exploduje.

---

## Laurent Series (Zobecněná Taylorova Řada)

### Taylorova Řada (Známá)

Pro "hezkou" funkci kolem $z=a$:
$$f(z) = c_0 + c_1(z-a) + c_2(z-a)^2 + c_3(z-a)^3 + \cdots$$

**Jen kladné mocniny** → žádné póly.

---

### Laurent Series (Zobecnění)

Pro funkci s **pólem** v $z=a$:
$$f(z) = \cdots + \frac{c_{-2}}{(z-a)^2} + \frac{c_{-1}}{z-a} + c_0 + c_1(z-a) + c_2(z-a)^2 + \cdots$$

**Záporné mocniny** = "hlavní část" (divergentní)
**Kladné mocniny** = "regulární část" (konečná)

---

### Residuum = Koeficient c₋₁

$$\text{Res}_{z=a} f(z) = c_{-1}$$

**To je koeficient u $(z-a)^{-1}$** - jediný člen, který se "zachová speciálně" při integraci!

---

## Proč Je Residuum Důležité?

### Residue Theorem (Základní Věta)

Pokud integruješ funkci po **uzavřené křivce** kolem pólů:

$$\oint_C f(z) \, dz = 2\pi i \sum_{\text{póly uvnitř } C} \text{Res}_{z=a} f(z)$$

**To je MEGA užitečné**:
- Integrál = prostě součet residuí (× konstanta)
- Nemusíš skutečně integrovat - jen najdi residua!

---

## Jak Najít Residuum?

### Metoda 1: Laurent Series (Definice)

Rozviň funkci, najdi koeficient u $1/(z-a)$.

**Příklad**: $f(z) = \frac{1}{z^2}$ kolem $z=0$

Laurent series:
$$f(z) = \frac{1}{z^2} = 0 \cdot \frac{1}{z} + 0 + 0 \cdot z + \cdots$$

**Residuum = 0** (není člen $1/z$).

---

### Metoda 2: Jednoduchý Pól (Nejčastější)

Pokud je pól **jednoduchý** (řádu 1), tedy:
$$f(z) = \frac{g(z)}{z-a}$$

kde $g(a) \neq 0$, pak:
$$\text{Res}_{z=a} f(z) = \lim_{z \to a} (z-a) \cdot f(z) = g(a)$$

**Příklad**: $f(z) = \frac{1}{z-3}$ v $z=3$

$$\text{Res}_{z=3} f(z) = \lim_{z \to 3} (z-3) \cdot \frac{1}{z-3} = 1$$

---

### Metoda 3: Pól Vyššího Řádu

Pro pól **řádu n**:
$$f(z) = \frac{g(z)}{(z-a)^n}$$

Residuum:
$$\text{Res}_{z=a} f(z) = \frac{1}{(n-1)!} \lim_{z \to a} \frac{d^{n-1}}{dz^{n-1}} \left[(z-a)^n f(z)\right]$$

**Vypadá to scary, ale v praxi se to zjednoduší.**

---

## Náš Případ: Epsilon Jako Komplexní Proměnná

### Setup

Máme funkci:
$$F_n(\alpha, \varepsilon) = \sum_{d,k} [(n-kd-d^2)^2 + \varepsilon]^{-\alpha}$$

Pro **composite** $n$ s faktorizací $n = k_0 d_0 + d_0^2$:
$$\text{dist}_{d_0,k_0} = n - k_0 d_0 - d_0^2 = 0$$

Tento člen:
$$[(0)^2 + \varepsilon]^{-\alpha} = \varepsilon^{-\alpha}$$

---

### Laurent Expansion Kolem ε=0

$$F_n(\alpha, \varepsilon) = M \cdot \varepsilon^{-\alpha} + c_0 + c_1 \varepsilon + c_2 \varepsilon^2 + \cdots$$

Kde $M$ = počet faktorizací (počet $(d,k)$ párů s $\text{dist}=0$).

---

### Problém: Není To Jednoduchý Pól!

Pól je **řádu α** (ne 1), takže:

$$\text{Res}_{\varepsilon=0} F_n = c_{-1}$$

Ale náš rozvoj je:
$$F_n = \frac{M}{\varepsilon^\alpha} + c_0 + c_1\varepsilon + \cdots$$

**Nemáme člen $1/\varepsilon$** (jen $1/\varepsilon^\alpha$)!

---

### Zobecněné "Residuum"

Pro pól řádu $\alpha$, místo residua používáme **leading coefficient**:

$$\lim_{\varepsilon \to 0} \varepsilon^\alpha \cdot F_n(\alpha, \varepsilon) = M$$

Tohle **NENÍ** klasické residuum (to by bylo $c_{-1}$), ale **analogické** - měří "sílu pólu".

---

## Formální Definice Residua

### Standardní Komplexní Analýza

Pro funkci $f(z)$ s **izolovanou singularitou** v $z=a$:

Laurent series:
$$f(z) = \sum_{n=-\infty}^{\infty} c_n (z-a)^n$$

**Residuum**:
$$\text{Res}_{z=a} f(z) = c_{-1}$$

---

### Residue Theorem

Pro **jednoduše souvislou oblast** $D$ s póly $a_1, \ldots, a_N$ uvnitř:

$$\oint_{\partial D} f(z) \, dz = 2\pi i \sum_{k=1}^N \text{Res}_{z=a_k} f(z)$$

**To je základní nástroj** pro výpočet integrálů, Fourierovy transformace, inverze Laplaceovy transformace, atd.

---

## Je To Elementary?

### Ano! Je To Základní Materiál

**Komplexní analýza (Complex Analysis)** - typický univerzitní kurz pro 3. ročník matematiky/fyziky:

1. **Základy**: Holomorfní funkce, Cauchy-Riemannovy rovnice
2. **Cauchy's theorem**: Integrály po uzavřených křivkách
3. **Laurent series**: Zobecnění Taylorovy řady
4. **Residua**: Koeficient $c_{-1}$
5. **Residue theorem**: Výpočet integrálů přes residua

**Residua jsou kapitola 4-5** v standardním kurzu.

---

### Proč Se Učí?

Residua jsou **neuvěřitelně užitečná**:

1. **Výpočet integrálů**: Especially $\int_{-\infty}^{\infty}$ reálných funkcí
2. **Inverse transforms**: Laplace, Fourier
3. **Suma řad**: Přes residua v pólech
4. **Fyzika**: Kvantová mechanika, QFT, statistical mechanics
5. **Engineering**: Signal processing, control theory

**Super mocný nástroj!**

---

## Příklad: Výpočet Integrálů

### Problém

Vypočítat:
$$I = \int_{-\infty}^{\infty} \frac{1}{1+x^2} \, dx$$

---

### Řešení Přes Residua

**Krok 1**: Extend to complex:
$$f(z) = \frac{1}{1+z^2} = \frac{1}{(z-i)(z+i)}$$

**Krok 2**: Póly v $z = \pm i$.

**Krok 3**: Integrate po upper half-plane semicircle.

**Krok 4**: Only pole at $z=i$ is inside.

**Krok 5**: Residuum:
$$\text{Res}_{z=i} f(z) = \lim_{z \to i} (z-i) \cdot \frac{1}{(z-i)(z+i)} = \frac{1}{2i}$$

**Krok 6**: Residue theorem:
$$I = 2\pi i \cdot \frac{1}{2i} = \pi$$

**Done!** Bez složitých substitucí!

---

## Analogie v Našem Případě

### Klasická Residua

- Proměnná: $z \in \mathbb{C}$
- Singularita: Pól v $z=a$
- Laurent series: $\cdots + c_{-1}/(z-a) + c_0 + c_1(z-a) + \cdots$
- Residuum: $c_{-1}$

---

### Naše "Residua"

- Proměnná: $\varepsilon \in \mathbb{R}^+$ (ale můžeme complexify)
- Singularita: Pól v $\varepsilon=0$
- Laurent series: $M/\varepsilon^\alpha + c_0 + c_1\varepsilon + \cdots$
- "Leading coefficient": $M$ (not quite residuum)

---

### Technicky Přesnější Termín

Místo "residuum" bychom měli říkat:

**"Leading coefficient of the Laurent expansion at a pole of order α"**

Ale to je moc dlouhé, takže říkáme "residue-like coefficient" nebo prostě **"residuum pólu vyššího řádu"**.

---

## Fyzikální Analogie

### Elektrostatika

Představ si **elektrický náboj** v bodě $a$.

Potenciál kolem něj:
$$V(r) \sim \frac{Q}{|r-a|}$$

Když integruješ elektrické pole po kružnici kolem $a$:
$$\oint E \cdot d\ell = Q/\varepsilon_0$$

**Náboj Q = residuum** (měří sílu singularity)!

---

### Náš Případ

Epsilon-pól jako "náboj" v $\varepsilon=0$:
$$F_n(\varepsilon) \sim \frac{M}{\varepsilon^\alpha}$$

**M = "náboj"** (počet faktorizací).

---

## Shrnutí: Co Je Residuum?

### V Jedné Větě

**Residuum je koeficient u $1/(z-a)$ v Laurent series - měří, jak moc funkce "exploduje" u pólu.**

---

### Proč Je Užitečné?

- **Zjednodušuje integrály**: Residue theorem
- **Suma řad**: Přes residua
- **Fyzika**: Všude (QFT, stat mech, ...)
- **Naše aplikace**: Měří "compositeness"

---

### Je To Elementary?

**Ano!**
- Učí se v základním kurzu komplexní analýzy
- Předpoklad: Calculus + základy komplexních čísel
- Úroveň: 3. ročník university (matematika/fyzika)

Není to super pokročilé - každý fyzik/matematik se to učí.

---

## Doporučená Literatura

### Začátečníci

- **Visual Complex Analysis** - Tristan Needham
  Geometrická intuice, krásné obrázky

- **Complex Variables and Applications** - Brown & Churchill
  Klasická učebnice, hodně příkladů

### Pokročilí

- **Complex Analysis** - Lars Ahlfors
  Bible komplexní analýzy (ale těžší)

---

## Online Zdroje

- **3Blue1Brown** (YouTube): Visualizing complex functions
- **Khan Academy**: Complex analysis basics
- **MIT OpenCourseWare**: Full course materials

---

## Závěr

**Residua = elementary, ale mega užitečná!**

V našem případě používáme **analogickou** techniku - místo klasického residua (koeficient $c_{-1}$) počítáme **leading coefficient pólu vyššího řádu** (koeficient $M$ u $\varepsilon^{-\alpha}$).

Koncept je stejný - **měříme sílu singularity**.

A zjistili jsme, že ta síla **přesně odpovídá počtu faktorizací** - to je netriviální a krásný výsledek!
