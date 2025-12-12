# Egyptian Mathematics & Pyramids: Document Index

**Purpose:** Navigation guide to Egypt-related content across the Orbit repository.

---

## Core Documents

### Mathematical Foundations

| Document | Location | Content |
|----------|----------|---------|
| **Egyptian Fractions Exploration** | [2025-12-05](2025-12-05-egyptian-fractions-exploration/README.md) | Raw tuple format, CF↔Egypt equivalence |
| **CF-Egypt Equivalence** | [2025-12-10](2025-12-10-cf-egypt-equivalence/README.md) | Main theorem: Egypt = paired CF differences |
| **γ-Egypt Simplification** | [2025-12-10](2025-12-10-cf-egypt-equivalence/gamma-egypt-simplification.md) | Möbius compression, Seked-Pythagorean-γ connection |

### Pyramid Geometry

| Document | Location | Content |
|----------|----------|---------|
| **Golden Ratio Pyramid** | [2025-12-08](2025-12-08-gamma-framework/golden-ratio-pyramid.md) | Main pyramid data, 4th Dynasty table, convergent analysis |
| **Pyramid Internal Geometry** | [2025-12-08](2025-12-08-gamma-framework/pyramid-internal-geometry.md) | King's Chamber dimensions, √5 evidence |
| **Möbius Orbits** | [2025-12-12](2025-12-12-phi-pi-equation/README.md) | SC transformation connects pyramids (Cheops→Bent) |

### Historical Sources

| Document | Location | Content |
|----------|----------|---------|
| **Vymazalova Notes** | [learning](../learning/vymazalova-hieratic-notes.md) | Hieratic mathematical texts, papyri overview |
| **Flinders Petrie** | [learning](../learning/flinders-petrie.md) | Measurement methodology, cubit determination |
| **Egyptian Knowledge Transmission** | [2025-12-08](2025-12-08-gamma-framework/egyptian-knowledge-transmission.md) | How mathematical knowledge survived |

---

## Key Discoveries

### 1. CF ↔ Egypt Equivalence Theorem (Dec 10, 2025)

```
Egypt tuples = Total /@ Partition[Differences @ Convergents[q], 2]
```

Egyptian fraction decomposition is equivalent to paired differences of continued fraction convergents.

**Location:** [CF-Egypt Equivalence](2025-12-10-cf-egypt-equivalence/README.md)

### 2. Seked-Pythagorean-γ Connection (Dec 11, 2025)

```
γ(3/4) = 1/7
```

The Pythagorean ratio 3/4 (Khafra's slope) maps to 1/7 under Cayley transform — and 7 is the number of palms in a royal cubit!

**Location:** [γ-Egypt Simplification](2025-12-10-cf-egypt-equivalence/gamma-egypt-simplification.md#seked-pythagorean-γ-connection)

### 3. SC Orbit Connects Pyramids (Dec 12, 2025)

```
SC(7/11) = 7/15
Cheops → Bent Pyramid (upper section)
```

The Möbius transformation SC(x) = x/(2-x) maps between pyramid slopes while preserving the numerator 7 (seked reference height).

**Location:** [Möbius Orbits](2025-12-12-phi-pi-equation/README.md)

### 4. All Giza Pyramids Use √φ/2 Convergents

| Pyramid | Ratio | Convergent # |
|---------|-------|--------------|
| Cheops | 7/11 | 6th |
| Chephren | 2/3 | 4th |
| Menkaure | 5/8 | 5th |

**Location:** [Golden Ratio Pyramid](2025-12-08-gamma-framework/golden-ratio-pyramid.md#all-three-giza-pyramids)

---

## Fourth Dynasty Pyramid Table

| Pyramid | Builder | Seked | Angle | h/b ratio |
|---------|---------|-------|-------|-----------|
| Meidum | Sneferu | 5p+2d | 51.8° | 7/11 |
| Bent (lower) | Sneferu | 4p | 54.5° | — |
| Bent (upper) | Sneferu | 7p+2d | 43.4° | 7/15 |
| Red | Sneferu | 7p | 43.4° | 1/2 |
| Djedefra | Djedefra | 4p OR 5p+2d | 60° OR 52° | — |
| Cheops | Khufu | 5p+2d | 51.8° | 7/11 |
| Chephren | Khafre | 5p+1d | 53.1° | 2/3 |
| Menkaure | Menkaure | 5p+3d | 51.3° | 5/8 |

**Source:** [Golden Ratio Pyramid - 4th Dynasty](2025-12-08-gamma-framework/golden-ratio-pyramid.md#fourth-dynasty-pyramids-beyond-giza-added-dec-12-2025)

---

## Session Chronology

### November 2025

| Date | Session | Egypt Content |
|------|---------|---------------|
| Nov 22 | [palindromic-symmetries](2025-11-22-palindromic-symmetries/) | Egypt monotonic proof, Poincaré trajectory |
| Nov 25 | [hyperbolic-combinatorics](2025-11-25-hyperbolic-combinatorics/) | Egypt compact representation |
| Nov 27 | [semiprime-gamma-form](2025-11-27-semiprime-gamma-form/) | Unit fraction discovery |

### December 2025

| Date | Session | Egypt Content |
|------|---------|---------------|
| Dec 5 | [egyptian-fractions-exploration](2025-12-05-egyptian-fractions-exploration/) | **Core:** Raw tuple format, Egypt↔Chebyshev↔Pythagorean |
| Dec 5 | [L-function-egypt-bridge](2025-12-05-L-function-egypt-bridge/) | L-function connection |
| Dec 8 | [gamma-framework](2025-12-08-gamma-framework/) | **Core:** Golden ratio, pyramid geometry, Ankh |
| Dec 10 | [cf-egypt-equivalence](2025-12-10-cf-egypt-equivalence/) | **Core:** Main theorem, γ-simplification |
| Dec 11 | [archimedes-palimpsest](2025-12-11-archimedes-palimpsest/) | Greek mathematical heritage |
| Dec 12 | [vymazalova-reflections](2025-12-12-vymazalova-reflections/) | Papyri analysis, scribal practice |
| Dec 12 | [phi-pi-equation](2025-12-12-phi-pi-equation/) | **Core:** Möbius orbits, SC transformation |

---

## Open Questions

1. **Did Egyptians know continued fractions?** Or found optimal ratios empirically?
2. **Why 7 palms per cubit?** γ(3/4) = 1/7 suggests deliberate choice
3. **Djedefra asymmetry:** Construction accident or intentional design?
4. **Internal passages:** Do passage angles follow same rational patterns?
5. **Knowledge transmission:** How did Egyptian mathematics reach Greece?

---

## Related Learning Documents

- [290-Theorem](../learning/290-theorem.md) — Quadratic forms (unrelated but often confused)
- [Lychrel-196](../learning/lychrel-196.md) — Base-10 curiosity (not Egyptian)
- [Archimedes](../learning/archimedes-life.md) — Greek mathematics post-Egypt
- [Eratosthenes](../learning/eratosthenes-life.md) — Alexandria library

---

## Code Implementation

The Orbit paclet provides:

```mathematica
<< Orbit`

(* Egyptian fraction decomposition *)
EgyptianFractions[7/11]              (* {1/2, 1/6, 1/22} *)
EgyptianFractions[7/11, Method->"Raw"]  (* {{1,1,1,1}, {2,3,1,3}} *)

(* γ-transform (Cayley) *)
γ[3/4]  (* 1/7 — Pythagorean to unit fraction *)

(* Möbius involutions *)
silver[x_] := (1 - x)/(1 + x)
copper[x_] := 1 - x
SC[x_] := x/(2 - x)  (* silver ∘ copper *)
```

---

*Last updated: 2025-12-12*
