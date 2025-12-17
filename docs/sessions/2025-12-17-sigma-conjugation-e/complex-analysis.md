# Complex Analysis of Euler E Analytic Terms

## Functions Analyzed

### EulerEAlternatingTermAnalytic
```
f(z) = (-1)^(z+1) · 2 / (s(z) · s(z+1))
```

### EulerEMonotoneTermAnalytic
```
g(t) = 4(4t+3) / (s(2t-1) · s(2t+1))
```

where `s(n) = (-1)^(n+1) · y_{n+1}(-2)` via BesselK continuation.

## Comparison Table

| Property | Alternating f(z) | Monotone g(t) |
|----------|------------------|---------------|
| Decay rate | e^(-6.4n) | e^(-14.5n) |
| (-1)^n factor | YES → complex off ℤ | NO → real on ℝ |
| Typical \|Residue\| | ~0.3-0.4 | ~10⁻³ to 10⁻⁶ |
| Poles visible | Clearly | Barely |
| Schwarz symmetric | NO | YES on ℝ |

## Poles

Both functions have poles where `s(z) = 0`.

The function `s(z) = (-1)^(z+1) · √(2/(πz)) · e^(1/z) · BesselK[z+3/2, -1/2]` has zeros in the complex plane.

### First zeros of s(z):
- z ≈ -0.350 - 0.346i
- z ≈ 0.468 - 1.138i
- z ≈ 1.122 - 1.865i
- z ≈ 1.698 - 2.560i

### Alternating term poles
Direct poles at zeros of s(z) and s(z+1).

Sample residues:
- At z ≈ -0.35 - 0.35i: Res ≈ -0.37 - 0.42i
- At z ≈ 0.47 - 1.14i: Res ≈ -0.32 - 0.31i

### Monotone term poles
Poles at t where s(2t-1)=0 or s(2t+1)=0.

Much smaller residues (10⁻³ to 10⁻⁶) due to the product s(2t-1)·s(2t+1) in denominator.

## Special Values

### Alternating
- f(0) = -2/7 ≈ -0.286 (real)
- f(1) = 2/497 ≈ 0.004 (real)
- f(1/2) ≈ 0.0005 - 0.036i (complex due to (-1)^(3/2) = -i)
- f(i) ≈ 0.017 - 0.011i

### Monotone
- g(0) = 12/7 ≈ 1.714 (real)
- g(1) = 4/1001 ≈ 0.004 (real)
- g(-1) = 4 (real)
- g(i) ≈ 152 + 93i (large!)

## Key Insight

The **alternating term has the (-1)^(z+1) factor** which:
1. Makes it complex for non-integer z
2. Creates the beautiful phase structure in complex plots
3. Results in larger residues at poles

The **monotone term lacks this factor**, so:
1. It's real-valued on the real axis
2. Has much smaller residues
3. Decays ~2× faster (exponent 14.5 vs 6.4)

## Figures

- `figures/alternating-term-abs.png` - |f(z)| showing pole locations
- `figures/alternating-term-phase.png` - Arg[f(z)] showing branch structure
- `figures/monotone-term-abs.png` - |g(t)| showing rapid decay
