# ASIDE: Lissajous Figures and Modular Inverses

**Datum:** 2025-11-29
**Status:** ✅ PROVEN (samostatná věta)
**Typ:** Odbočka - tematicky související, ale ne strukturálně spojeno s hlavní prací
**Autoři:** Jan Popelka, Claude Code

> **Poznámka:** Tato věta vznikla při zkoumání Inverse Parity Bias, ale není s ní
> hluboce spojena. Relevantní pro **Egyptian fractions** a funkci `lo1`.
> Ponecháno stranou pro případný návrat k tématu.

---

## Theorem (Lissajous Closest Point)

Pro Lissajousovu křivku s frekvencí ω = x/y (nesoudělné, x < y):

$$(X(t), Y(t)) = (\sin(\pi \omega t), \sin(\pi t))$$

s červenými body při celočíselných t = 0, 1, ..., 2y-1:

**Nejbližší nenulový bod k počátku leží při t = x⁻¹ mod y**

a má vzdálenost od počátku rovnou |sin(π/y)|.

---

## Důkaz

1. Červené body leží na x-ose (Y = sin(πt) = 0 pro celočíselné t).

2. X-souřadnice při t = b je sin(πxb/y).

3. Hledáme minimální nenulové |sin(πxb/y)| pro b ∈ {1, ..., 2y-1}.

4. Minimum sin funkce (nenulové) nastává když argument je co nejblíže k násobku π.

5. Pro b = x⁻¹ mod y:
   - xb ≡ 1 (mod y)
   - Tedy xb = 1 + ky pro nějaké k
   - sin(πxb/y) = sin(π(1+ky)/y) = sin(π/y + kπ) = ±sin(π/y)

6. |sin(π/y)| je minimální nenulová hodnota, protože:
   - Pro jakékoliv b: xb mod y ∈ {1, 2, ..., y-1}
   - Minimální hodnota xb mod y pro coprime x,y je 1
   - A toto nastává právě při b = x⁻¹ mod y

∎

---

## Spojení s lo1

Funkce `lo1` z Egyptian fractions:

```mathematica
lo1[Rational[x_, y_]] :=
  1/# Round[x/y #] &@
    If[y - x == 1, x, Mod[First@Last@ExtendedGCD[x, y] + y, y]]
```

Používá **x⁻¹ mod y** jako jmenovatel pro nejlepší aproximaci x/y!

Toto je přesně parametr, který určuje nejbližší bod v Lissajous.

---

## Geometrická interpretace

Lissajousova křivka s ω = x/y "resonuje" s modulární inverzi:

- Bod při t = x⁻¹ mod y je **speciální** - nejblíže počátku
- Toto odpovídá tomu, že x · (x⁻¹) ≡ 1 (mod y)
- Číslo 1 je "nejmenší nenulové" v modulární aritmetice
- Geometricky: sin(π/y) je "nejmenší nenulový" sinus s dělitelem y

---

## Numerická verifikace

Pro všechna nesoudělná x/y s y ∈ {5,...,13}: ✓ 100% shoda

Vzdálenost od počátku vždy = |sin(π/y)|, dosažená při t = x⁻¹ mod y.

---

## Reference

- `ppst` plot funkce (user code)
- `lo1` Egyptian fraction function (Orbit paclet)
- Egyptian fractions v Orbit: `Orbit`SquareRootRationalizations`

## Klíčová slova pro hledání

Egyptian fractions, lo1, modular inverse, Lissajous, rational approximation

