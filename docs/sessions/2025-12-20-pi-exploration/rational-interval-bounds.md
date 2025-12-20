# Rational Interval Bounds with Unit Fraction Widths

Five functions provide the cleanest possible rational bounds for fundamental constants.

## The Minimal Basis

| Function | Constant | Value | Origin |
|----------|----------|-------|--------|
| `PiInterval[k]` | π | 3.14159... | transcendental (geometric) |
| `EInterval[k]` | e | 2.71828... | transcendental (analytic) |
| `PhiInterval[k]` | φ | 1.61803... | algebraic (golden ratio) |
| `SqrtInterval[2, k]` | √2 | 1.41421... | algebraic (diagonal) |
| `SqrtInterval[3, k]` | √3 | 1.73205... | algebraic (hexagonal) |

All produce intervals with **unit fraction width** (numerator = 1).

## Examples (k = 3)

```mathematica
<< Orbit`

PiInterval[3]      (* Width = 1/245760 *)
EInterval[3]       (* Width = 1/56059475565793 *)
PhiInterval[3]     (* Width = 1/23184 *)
SqrtInterval[2, 3] (* Width = 1/204 *)
SqrtInterval[3, 3] (* Width = 1/28 *)
```

## Full Example

```mathematica
<< Orbit`

PiInterval[3]
(* Interval[{357201535487/113700787200, 5715231970187/1819212595200}] *)
(* Width = 1/245760 *)

EInterval[3]
(* Interval[{14665106/5394991, 28245729/10391023}] *)
(* Width = 1/56059475565793 *)

PhiInterval[3]
(* Interval[{521/322, 233/144}] *)
(* Width = 1/23184 *)
(* Note: bounds are Fibonacci ratios! *)
```

## Key Property: Unit Fraction Width

All five functions produce intervals where:

$$\text{width} = \frac{1}{D}$$

The numerator is always **1**. This is the simplest possible form for an interval width.

## Underlying Methods

| Function | Method |
|----------|--------|
| **PiInterval** | BBP formula partial sums + geometric tail bound |
| **EInterval** | Continued fraction mediants (Farey sums) |
| **PhiInterval** | Derived from SqrtInterval[5, k] via φ = (1+√5)/2 |
| **SqrtInterval** | Pell equation solutions + Egyptian fraction expansion |

## Usage

```mathematica
<< Orbit`

(* Verify constant is in interval *)
IntervalMemberQ[PiInterval[5], Pi]           (* True *)
IntervalMemberQ[EInterval[5], E]             (* True *)
IntervalMemberQ[PhiInterval[5], GoldenRatio] (* True *)
IntervalMemberQ[SqrtInterval[2, 5], Sqrt[2]] (* True *)

(* Get interval width *)
width[int_] := Max[int] - Min[int]
width[PiInterval[5]]  (* 1/15728640 *)
width[PhiInterval[5]] (* 1/7465176 *)
```

## Why These Five?

This is a **minimal basis** covering the most important constants:

- **π, e**: The two fundamental transcendentals
- **φ**: The golden ratio, ubiquitous in nature and art
- **√2**: Diagonal of unit square, simplest irrational
- **√3**: Height of equilateral triangle, hexagonal geometry

Other square roots (√5, √7, ...) are available via `SqrtInterval[n, k]`.

## See Also

- `docs/sessions/2025-12-20-pi-exploration/README.md` - Full π exploration
- `Orbit/Kernel/PiConvergents.wl` - π implementation
- `Orbit/Kernel/EulerEConvergents.wl` - e implementation
- `Orbit/Kernel/SquareRootRationalizations.wl` - √n and φ implementation
