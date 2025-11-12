# Mathematical Visualizations

## 1. Chebyshev Curves: "Infinite Interference"

### Files

- **infinite_interference.glsl** - Shadertoy GLSL implementation
- **regular-235.png** - Static visualization showing curves for k=2, 3, 5
- **chebyshev_star_animation.wl** - Animation generator

### Live Demo

Interactive animation: https://www.shadertoy.com/view/MXc3Rj

## Description

Visualization of the family of curves:

```mathematica
subnrefu[x_, k_] := ChebyshevT[k + 1, x] - x ChebyshevT[k, x]
```

Each curve inscribes perfectly within the unit circle, touching at the vertices of a regular (k+1)-gon.

## Key Properties

- **Unit integral norm**: ∫|f_k| dθ = 1 for all k
- **Regular polygon contact**: k+1 points where curve touches unit circle
- **Smooth closed curves**: Despite discrete contact points
- **Rotation symmetry**: [rotation angle formula - TBD]

## Mathematical Details

See: `../docs/chebyshev-visualization.md`

## Complex Number Formulation

The GLSL implementation expresses the function using complex arithmetic:

```
f_k(x) = (-1)^k · i√(1-x²)/2 · [(1-2x² - 2i·x√(1-x²))^k - (1-2x² + 2i·x√(1-x²))^k]
```

This Binet-like formula using conjugate differences automatically produces the Chebyshev polynomial relationship.

### Connection to Main Research

Emerged from exploration of Chebyshev polynomials for:
- Square root rationalization (see `../docs/chebyshev-pell-sqrt-framework.md`)
- Egyptian fraction decompositions
- Optimal polynomial approximation

The shared mathematical structure connects orthogonal polynomial systems to rational approximation and unit norm preservation.

---

## 2. Primal Forest: Geometric Prime Sieve

### Files

- **prime-grid-demo.png** ⭐ **PRIMARY EDUCATIONAL VERSION** - Clean grid visualization (recommended for teaching)
- **prime-grid-demo.wl** - Code to generate the educational version
- **prime-grid-black.webp** - Fan intersection version (red/white lines on black)
- **prime-grid-square.webp** - Parabolic parallel lines version (scaled circles)

### Description

Geometric visualization of the Sieve of Eratosthenes where:
- **Orange squares** = Primes (the "trees" in the forest)
- **Blue circles** = Composites
- **Orange vertical lines** = Drop lines emphasizing prime positions
- **Grid cells** = Clear visual separation at half-integer boundaries

### Primary Educational Version (prime-grid-demo.png)

**The formula**: Points plotted at `{kx + x², kx + 1}` for various k, x

**Why this version is superior for teaching:**
1. **Grid cells**: Each number gets its own clearly defined box
2. **Color coding**: Instant visual distinction (orange = prime, blue = composite)
3. **Vertical emphasis**: Orange lines make primes "stand out" from the parabola
4. **Perfect range**: Shows primes up to 31 (ideal classroom demonstration)
5. **Parabolic structure**: Natural quadratic curve reveals prime distribution

**Complete annotated code** (see `prime-grid-demo.wl`):

```mathematica
(* Generate composite positions via parabolic formula kx + x²

   Parameters:
     m = minimum value for x (determines starting point on parabola)
     n = maximum value for kx + x² (upper bound for numbers to show)

   The x limits are derived from solving: kx + x² = m (lower) and kx + x² = n (upper)
   Solving x² + kx - m = 0 gives: x = (-k + √(k² + 4m)) / 2

   For each k (offset parameter), we generate points:
     x-coordinate: kx + x² (position along parabola)
     y-coordinate: kx + 1 (vertical offset, purely for visualization spacing)
*)
comp1[m_, n_] := Join @@ Table[
  {k x + x^2, k x + 1},
  {k, 0, n},
  {x,
   Max[1, Ceiling[1/2 (-k + Sqrt[k^2 + 4 m])]],   (* x lower bound *)
   Floor[1/2 (-k + Sqrt[k^2 + 4 n])]}             (* x upper bound *)
]

(* ListPlot wrapper with educational formatting *)
lpl[hi_] :=
 ListPlot[
   GatherBy[#, PrimeQ@*First],  (* Separate by primality *)
   PlotRange -> {Automatic, {-1/2, Automatic}},
   AxesOrigin -> {0, 0},
   AspectRatio -> 1,
   PlotMarkers -> {Automatic, Large},
   GridLines -> {Range@hi - 1/2, Range[0, hi] - 1/2},  (* Half-integer grid *)
   Epilog -> {
     Thick,
     ColorData[97, "ColorList"][[2]],  (* Orange *)
     Line[{#, {First@#, 0}}] & /@ Select[#, PrimeQ@*First]  (* Prime drop lines *)
   }
 ] &@ comp1[1, hi]

(* Generate visualization up to 31 *)
lpl@31
```

**Key insight**: The parabolic limits `x = (-k + √(k² + 4n)) / 2` ensure we only plot numbers ≤ n, while the formula `kx + x²` naturally creates geometric clustering of composites.

### Alternative Versions

**Version 1 (prime-grid-black.webp):** Fan intersection
- Negative slope fan: $y = -k + x/k$
- Positive slope fan: $y = k - x/k$
- Artistic black background with red/white elimination lines

**Version 2 (prime-grid-square.webp):** Parabolic arrangement
- Parallel lines with positions: $\{k \cdot x, x^2 + k \cdot x\}$
- Variable circle sizes showing prime "density"
- More abstract, less immediately intuitive

### Educational Value

Makes abstract sieve concepts visually intuitive:
- **Composites cluster geometrically** along the parabolic curve
- **Primes are isolated** (orange squares standing alone)
- **Prime gaps grow visibly** with increasing size
- **Shows structure, not randomness** in prime distribution

**See:** `../docs/primal-forest-visualization.md` for complete mathematical explanation

### Connection to Main Research

Educational component showing geometric number theory. Complements the computational prime structure work in the Prime DAG module.
