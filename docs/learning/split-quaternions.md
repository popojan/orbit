# Split-kvaterniony (Coquaterniony)

**Datum:** 7. prosince 2025
**Kontext:** Výukový materiál vytvořený při práci s Circ funkcí

## Motivace

Při práci s komplexním rozšířením trigonometrických funkcí (cos, cosh) se přirozeně objevuje struktura split-kvaternionů. Tento dokument vysvětluje co jsou split-kvaterniony a jak se liší od standardních kvaternionů.

**Poznámka:** Split-kvaterniony jsou známá algebra od roku 1849 (Cockle). Tento dokument je výukový materiál, ne popis nového objevu.

## Srovnání: Kvaterniony vs Split-kvaterniony

### Hamiltonovy kvaterniony (1843)

Báze $\{1, i, j, k\}$ s pravidly:
$$i^2 = j^2 = k^2 = -1$$
$$ij = k, \quad jk = i, \quad ki = j$$
$$ji = -k, \quad kj = -i, \quad ik = -j$$

**Norma:** $|q|^2 = a^2 + b^2 + c^2 + d^2$ (euklidovská)

**Jednotková sféra:** $|q|^2 = 1$ je 3-sféra $S^3$

**Použití:** Rotace ve 3D prostoru, počítačová grafika, robotika

### Split-kvaterniony / Coquaterniony (Cockle, 1849)

Báze $\{1, i, j, k\}$ s pravidly:
$$i^2 = -1, \quad j^2 = +1, \quad k^2 = +1$$
$$ij = k = -ji$$ (antikomutují)

**Norma:** $N(q) = a^2 + b^2 - c^2 - d^2$ (Lorentzova signatura!)

**"Jednotková plocha":** $N(q) = 1$ je hyperboloid (ne sféra)

**Použití:** Lorentzovy transformace, speciální relativita, hyperbolická geometrie

## Klíčový rozdíl: Signatura

| Vlastnost | Kvaterniony | Split-kvaterniony |
|-----------|-------------|-------------------|
| $i^2$ | $-1$ | $-1$ |
| $j^2$ | $-1$ | $+1$ |
| $k^2$ | $-1$ | $+1$ |
| Norma | $a^2+b^2+c^2+d^2$ | $a^2+b^2-c^2-d^2$ |
| Geometrie | Euklidovská | Lorentzova |
| Inv. plocha | 3-sféra | Hyperboloid |

## Proč split-kvaterniony pro Circ?

### Kruhové vs hyperbolické funkce

**Kruhové** (kompaktní, periodické):
- $\cos(\theta), \sin(\theta)$
- Identita: $\cos^2\theta + \sin^2\theta = 1$
- Parametrizují **kružnici**

**Hyperbolické** (nekompaktní, rostoucí):
- $\cosh(y), \sinh(y)$
- Identita: $\cosh^2 y - \sinh^2 y = 1$
- Parametrizují **hyperbolu**

### Míchání obou typů

Pro $\text{Circ}(x + iy)$ máme:
- $x$-směr: $\cos(\pi x), \sin(\pi x)$ — kruhové
- $y$-směr: $\cosh(\pi y), \sinh(\pi y)$ — hyperbolické

Čtyři kombinace dávají přirozenou bázi:
- $\cos(\pi x)\cosh(\pi y)$ — kompaktní × kompaktní
- $\sin(\pi x)\cosh(\pi y)$ — kompaktní × kompaktní
- $\cos(\pi x)\sinh(\pi y)$ — kompaktní × hyperbolická
- $\sin(\pi x)\sinh(\pi y)$ — kompaktní × hyperbolická

Ta **asymetrie** (cosh² **minus** sinh² = 1) vyžaduje Lorentzovu signaturu, tedy split-kvaterniony!

## Maticová reprezentace

Split-kvaterniony jsou izomorfní $2 \times 2$ reálným maticím:

$$1 \to \begin{pmatrix} 1 & 0 \\ 0 & 1 \end{pmatrix}, \quad
i \to \begin{pmatrix} 0 & -1 \\ 1 & 0 \end{pmatrix}$$

$$j \to \begin{pmatrix} 1 & 0 \\ 0 & -1 \end{pmatrix}, \quad
k \to \begin{pmatrix} 0 & 1 \\ 1 & 0 \end{pmatrix}$$

**Ověření:**
- $i^2 = \begin{pmatrix} -1 & 0 \\ 0 & -1 \end{pmatrix} = -1$ ✓
- $j^2 = \begin{pmatrix} 1 & 0 \\ 0 & 1 \end{pmatrix} = +1$ ✓
- $ij = \begin{pmatrix} 0 & 1 \\ 1 & 0 \end{pmatrix} = k$ ✓

**Norma jako determinant:** $N(q) = \det(M_q)$

## Idempotenty a rozklad

Protože $j^2 = 1$, máme **idempotenty**:
$$e_+ = \frac{1+j}{2}, \quad e_- = \frac{1-j}{2}$$

Vlastnosti:
- $e_+^2 = e_+$, $e_-^2 = e_-$
- $e_+ \cdot e_- = 0$
- $e_+ + e_- = 1$

**Rozklad algebry:**
$$\mathbb{H}_{split} \cong \mathbb{C} \oplus \mathbb{C}$$

Každý split-kvaternion se rozloží na dvě komplexní čísla v $e_+$ a $e_-$ eigenspaces.

## Aplikace: Circ funkce

### Circ v split-kvaternionové bázi

$$\text{Circ}(x+iy) = a \cdot 1 + b \cdot i + c \cdot j + d \cdot k$$

kde:
- $a = -\cos(\pi x)\cosh(\pi y)/\sqrt{2}$
- $b = -\sin(\pi x)\cosh(\pi y)/\sqrt{2}$
- $c = -\cos(\pi x)\sinh(\pi y)/\sqrt{2}$
- $d = +\sin(\pi x)\sinh(\pi y)/\sqrt{2}$

### Konstantní Lorentzova norma

**Pozoruhodný fakt:**
$$N(\text{Circ}) = a^2 + b^2 - c^2 - d^2 = \frac{1}{2}$$

nezávisle na $x$ a $y$!

**Proč?** Fáze $3\pi/4$ splňuje $|\cos(3\pi/4)| = |\sin(3\pi/4)| = 1/\sqrt{2}$:

1. $a^2 + b^2 = (\cos^2\pi x + \sin^2\pi x)\cosh^2\pi y / 2 = \cosh^2\pi y / 2$
2. $c^2 + d^2 = (\cos^2\pi x + \sin^2\pi x)\sinh^2\pi y / 2 = \sinh^2\pi y / 2$
3. $N = \cosh^2\pi y/2 - \sinh^2\pi y/2 = 1/2$ ✓

Pythagorova identita $\cos^2 + \sin^2 = 1$ **eliminuje závislost na x**!

### CircS nemá konstantní normu

Pro CircS (fáze $\pi$): $\cos\pi = -1$, $\sin\pi = 0$

Jen diagonální komponenty přežijí ($b = c = 0$):
$$N(\text{CircS}) = \cos^2(\pi x)\cosh^2(\pi y) - \sin^2(\pi x)\sinh^2(\pi y)$$

Toto **závisí** na $x$ i $y$.

## Geometrická interpretace

### Circ jako Lorentz-invariantní křivka

V 4D split-kvaternionovém prostoru:
- Signatura $(+,+,-,-)$
- Circ leží na **hyperboloidu** $N = 1/2$
- Analogie: jednotková sféra v kvaternionech → hyperboloid v split-kvaternionech

### Souvislost se speciální relativitou

Split-kvaterniony přirozeně popisují:
- Lorentzovy boosy (hyperbolické rotace)
- Minkowského prostor-čas
- Světelné kužely ($N = 0$)

Circ s konstantní normou je jako **masivní částice** (konstantní "klidová hmotnost").

## Shrnutí

| Koncept | Význam pro Circ |
|---------|-----------------|
| $j^2 = +1$ | Hyperbolická geometrie v $y$-směru |
| Lorentzova norma | Přirozená metrika pro mix kruh/hyperbola |
| Konstantní $N = 1/2$ | Fáze $3\pi/4$ je geometricky speciální |
| Idempotenty $e_\pm$ | Balí $t$ a $\bar{t}$ dohromady |

## Reference

- Cockle, J. (1849): On certain functions resembling quaternions
- Rosenfeld, B.A. (1997): Geometry of Lie Groups
- Yaglom, I.M. (1979): A Simple Non-Euclidean Geometry and Its Physical Basis

## Viz také

- [circ-symmetries.md](../sessions/2025-12-07-chebyshev-integral-identity/circ-symmetries.md) — kde byl split-kvaternionový objev učiněn
- [CircFunctions.wl](../../Orbit/Kernel/CircFunctions.wl) — implementace v pacletu
