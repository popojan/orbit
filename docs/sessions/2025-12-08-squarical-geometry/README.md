# Squarical Geometry: When π = 4

**Date:** December 8, 2025
**Status:** Exploratory / Fun

## The Question That Started It All

> "A kdybychom Pi položili rovnou nečemu jinému, třeba 4, kde se to rozbije?"

What if π = 4? Turns out, there's a geometry where this is exactly true!

## Taxicab Geometry (L¹)

In **taxicab geometry** (Manhattan distance), distance is measured along grid lines:

```
d(P, Q) = |x₁ - x₂| + |y₁ - y₂|
```

The "circle" (all points at distance r from center) becomes a **rotated square**:

```
        *
       /|\
      / | \
     *--+--*     |x| + |y| = r
      \ | /
       \|/
        *
```

**Circumference** = 8r, **Diameter** = 2r, therefore **π_taxicab = 4** exactly!

## The L^p Family of Geometries

The taxicab (L¹) and Euclidean (L²) are part of a family:

```
||v||_p = (|x|^p + |y|^p)^(1/p)
```

| p | Name | "Circle" Shape | π_p |
|---|------|----------------|-----|
| 1 | Taxicab | Diamond (45° square) | 4 |
| 2 | Euclidean | Circle | 3.14159... |
| 4 | — | Rounded square | 3.39... |
| ∞ | Chebyshev | Square (axis-aligned) | 4 |

### The π(p) Formula

The ratio π(p) = circumference / diameter measured in L^p metric.

**Special cases** (exact):
- π(1) = 4 (taxicab)
- π(2) = π ≈ 3.14159... (Euclidean)
- π(∞) = 4 (Chebyshev)

**General case**: Numerical integration of L^p arc length.

The Euclidean π (p = 2) is the **minimum**! Both taxicab and Chebyshev give π = 4.

## Squarical Bridge: From Square to Circle

The key insight: our **Rational Circle Algebra** works for ALL p!

### The Algebra (p-independent)

```mathematica
(* These don't change with p! *)
ρ[n, k] = 2k/n - 5/4           (* roots of unity, always ℚ *)
t₁ ⊗ t₂ = t₁ + t₂ + 5/4        (* multiplication *)
t ⊙ n = n·t + 5(n-1)/4         (* power *)
```

### The Bridge (p-dependent)

```mathematica
(* Unit "circle" in L^p geometry *)
κLp[t_, p_] := Module[{θ = Pi(t + 5/4), x, y, r},
  {x, y} = {Cos[θ], Sin[θ]};           (* direction *)
  r = (Abs[x]^p + Abs[y]^p)^(-1/p);    (* distance to L^p boundary *)
  r {x, y}
]

(* Special cases *)
κ[t] := κLp[t, 2]        (* Euclidean circle *)
κTaxi[t] := κLp[t, 1]    (* Taxicab square *)
κCheb[t] := κLp[t, ∞]    (* Chebyshev square *)
```

### Correction Factor

To transform from square (L¹) to circle (L²):

```
f(θ) = 1 / (|cos θ| + |sin θ|)

At θ = 0° (side):   f = 1
At θ = 45° (corner): f = 1/√2
```

## Visualization

```mathematica
(* Animate the transition from square to circle *)
Manipulate[
  Graphics[{
    (* L^p "circle" *)
    Line[Table[κLp[t, p], {t, 0, 2, 0.01}]],
    (* Roots of unity *)
    PointSize[0.02], Red,
    Point[κLp[#, p] & /@ ρ[8, Range[0, 7]]]
  }, PlotRange -> 1.5, Axes -> True,
  PlotLabel -> StringForm["p = ``, π ≈ ``", p, N[πLp[p], 4]]],
  {p, 1, 10, 0.1}
]

(* π as function of p - use πLp from Orbit` paclet *)
(* πLp[1] = 4, πLp[2] = Pi, πLp[∞] = 4 *)
(* General p: numerical arc length integration *)
```

## Why This Matters

1. **Rational algebra is geometry-agnostic**: The parameter t ∈ ℚ works for any L^p
2. **π is a property of the metric**: Change the metric, change π
3. **Smooth interpolation**: p continuously morphs square ↔ circle
4. **Taxicab π is exact**: π = 4, no transcendence!

## The Squarical Philosophy

```
Square (p=1)  ←——→  Circle (p=2)  ←——→  Square (p=∞)
  (rotated 45°)        π ≈ 3.14          (axis-aligned)
    π = 4                                    π = 4

         "Squarical" = the whole family
```

**Key insight:** Both extremes (p=1 and p=∞) are squares!
- p = 1: Diamond (vertices on axes) — čtverec rotovaný 45°
- p = ∞: Square (sides parallel to axes) — čtverec axis-aligned
- p = 2: Circle — jediný rotačně invariantní, minimální π

The journey is **square → circle → square**, with both squares giving π = 4.
This is not coincidence: p=1 and p=∞ are Hölder conjugates (1/1 + 1/∞ = 1).

Our rational circle algebra sits ABOVE this:

```
        Rational Algebra (t ∈ ℚ)
                 ↓
           κLp[t, p]
                 ↓
    Coordinates in L^p geometry
```

## Historical Note & References

- **Taxicab geometry**: Studied by Hermann Minkowski (~1900)
- **Name coined**: Karl Menger, "You Will Like Geometry" exhibit booklet (1952)
- **Name popularized**: Eugene Krause, "Taxicab Geometry" (1975)
- **Practical uses**: Robotics, logistics, L¹ regularization (LASSO)

### References

1. **Adler, C. L. & Tanton, J.** (2000). "π is the minimum value for Pi."
   *The College Mathematics Journal*, 31(2), 102-106.
   - Proves that p = 2 (Euclidean) minimizes π(p)

2. **Stack Exchange discussions**:
   - [π in arbitrary metric spaces](https://math.stackexchange.com/questions/254620/pi-in-arbitrary-metric-spaces)
   - [Measuring π with alternate distance metrics](https://math.stackexchange.com/questions/2044223/measuring-pi-with-alternate-distance-metrics-p-norm)

3. **Wicklin, R.** (2019). "The value of pi depends on how you measure distance."
   [SAS Blog](https://blogs.sas.com/content/iml/2019/03/13/pi-in-lp-metric.html)
   - Explicit computation showing π(1) = π(∞) = 4

4. **Lynch, P.** (2012). "Where Circles are Square."
   [ThatsMaths](https://thatsmaths.com/2012/11/29/where-circles-are-square-and-%CF%80-equals-4/)
   - Popular exposition of taxicab geometry

## Fun Fact

The famous **taxicab number 1729** (Hardy-Ramanujan) is named after a taxicab too — the one Hardy rode to visit Ramanujan in hospital. Different etymology, same vehicle!

## Open Questions

1. Can we define sensible derivatives in L^p geometry?
2. What's the "Fourier transform" on the taxicab circle?
3. Are there interesting number-theoretic properties when π = 4?

---

*"In taxicab geometry, π is exactly 4. No irrationality, no transcendence. Just clean, honest, rectangular π."*
