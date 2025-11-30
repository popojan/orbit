(* ::Package:: *)

(* Chebyshev Integral Theorem - Lobe Area Analysis *)

BeginPackage["Orbit`"];

ChebyshevPolygonFunction::usage = "ChebyshevPolygonFunction[x, k] computes ChebyshevT[k+1, x] - x*ChebyshevT[k, x].

Geometric Properties:

1. REGULAR POLYGON VERTICES:
   Solutions to x^2 + ChebyshevPolygonFunction[x, k]^2 == 1 give vertices of a regular (k+1)-gon
   inscribed in the unit circle.

   IMPORTANT: Exclude singularities x = ±1 to obtain the k+1 polygon vertices.
   Points must be sorted by angle (not by x-coordinate) to see regular spacing.

2. SYMMETRY:
   - k even → f(-x, k) = -f(x, k) (odd function, central symmetry)
   - k odd  → f(-x, k) = f(x, k) (even function)

3. ROTATION PROPERTY:
   Polygon is rotated such that no two vertices share the same x-coordinate,
   ensuring ChebyshevPolygonFunction is single-valued (proper function).

4. UNIT INTEGRAL IDENTITY:
   Integrate[Abs[ChebyshevPolygonFunction[x, k]], {x, -1, 1}] == 1 for k ≥ 2
   Status: PROVEN (2025-11-23) via trigonometric substitution and symmetry arguments.
   See: docs/sessions/2025-11-23-chebyshev-integral-identity/chebyshev-integral-theorem.md

Examples:
  (* k=3 gives square (4 vertices, excluding x=±1) *)
  ChebyshevPolygonFunction[0, 3]     (* → 1 *)

  (* Find square vertices *)
  sols = Solve[x^2 + ChebyshevPolygonFunction[x, 3]^2 == 1 && Abs[x] < 1, x, Reals];
  vertices = Table[{x, ChebyshevPolygonFunction[x, 3]} /. sol, {sol, sols}];
  (* Sort by angle to see 90° spacing *)

  (* Verify unit circle property *)
  Simplify[x^2 + ChebyshevPolygonFunction[x, 3]^2] (* → 1 at vertices *)
";

ChebyshevLobeArea::usage = "ChebyshevLobeArea[n, k] computes the area of the k-th lobe (k = 1, ..., n) for the Chebyshev integral identity.

This is a closed form for the integral:
  (-1)^(n-k) * Integrate[Sin[n θ] Sin[θ]^2, {θ, (n-k) π/n, (n-k+1) π/n}]

Parameters:
  n - number of lobes (corresponds to k+1 polygon, n ≥ 3)
  k - which lobe, counting from left to right in direction of increasing x-axis (1 ≤ k ≤ n)

Lobe Indexing:
  Under the substitution x = Cos[θ], increasing x corresponds to decreasing θ.
  The k-th lobe from left (in x) corresponds to θ ∈ [(n-k)π/n, (n-k+1)π/n].

Sum Property (Chebyshev Integral Theorem):
  Sum[ChebyshevLobeArea[n, k], {k, 1, n}] == 1 for all n ≥ 3

  This follows from the Unit Integral Identity:
  Integrate[Abs[ChebyshevPolygonFunction[x, n-1]], {x, -1, 1}] == 1

Lobe Classification:
  The n lobes can be classified based on divisibility properties of their boundary indices.
  For lobe k, boundaries occur at zero indices m = n-k and m = n-k+1 (where x_m = Cos[m π/n]).

  Classification of zeros:
    - Primitive zero: GCD[m, n] = 1
    - Inherited zero: GCD[m, n] > 1
    - Universal zero: m = 0 or m = n (endpoints ±1)

  Classification of lobes:
    - Primitive lobe: GCD[n-k, n] = 1 AND GCD[n-k+1, n] = 1 (both boundaries primitive)
    - Inherited lobe: at least one boundary shares a factor with n
    - Universal lobe: k = 1 or k = n (edge lobes touching ±1)

  Primality Connection:
    n is prime ⟺ Total area of inherited lobes = 0
    For primes, all interior lobes (k = 2, ..., n-1) are primitive.
    For composites, some interior area 'leaks' into inherited lobes.

  Conservation Law:
    1 = A_universal + A_primitive + A_inherited
    Factorization changes DISTRIBUTION of area, not TOTAL.

  See: docs/sessions/2025-11-28-chebyshev-primality/journey-geometry-to-algebra.md

Examples:
  (* Octagon (n=4): lobes have areas 1/12, 5/12, 5/12, 1/12 *)
  Table[ChebyshevLobeArea[4, k], {k, 1, 4}]  (* → {1/12, 5/12, 5/12, 1/12} *)
  Total[%]  (* → 1 *)

  (* Verify for hexagon *)
  Total[Table[ChebyshevLobeArea[6, k], {k, 1, 6}]] // Simplify  (* → 1 *)

Note: Formula is undefined for n = 2 (denominator vanishes).
See: docs/sessions/2025-11-23-chebyshev-integral-identity/chebyshev-integral-theorem.md";

ChebyshevLobeAreaSymbolic::usage = "ChebyshevLobeAreaSymbolic[n, k] computes lobe area symbolically (no Integer constraint).

Unlike ChebyshevLobeArea which requires integer n >= 3 and 1 <= k <= n,
this version accepts symbolic arguments for algebraic manipulation.

Continuous Integral Identity (one period):
  Integrate[ChebyshevLobeAreaSymbolic[n, k], {k, 0, n}] == 1

Extended Integral Identity (m periods):
  Integrate[ChebyshevLobeAreaSymbolic[n, k], {k, -m*n, m*n}] == 2m - σ(n) Sin[2mπ]/π

  where σ(n) = n² Cos²[π/n] / (n² - 4) is a natural damping factor.

Soft-Floor Limit (n → ∞):
  lim_{n→∞} ∫_{-mn}^{mn} LobeArea dk = 2m - Sin[2mπ]/π

  This is the classic Fourier soft-floor function! The Sin[2mπ]/π term is
  the first-harmonic residue of the Gibbs phenomenon.

Connection to Lanczos σ-factors:
  The finite-n damping factor σ(n) → 1 as n → ∞ plays the role of
  Lanczos sigma factors, which smooth Fourier truncation artifacts.
  The polygon geometry provides NATURAL regularization.

Examples:
  ChebyshevLobeAreaSymbolic[n, k]  (* returns symbolic expression *)
  Integrate[ChebyshevLobeAreaSymbolic[n, k], {k, 0, n}] // Simplify  (* -> 1 *)
  Integrate[ChebyshevLobeAreaSymbolic[n, k], {k, -n, n}] // Simplify  (* -> 2 *)
  ChebyshevLobeAreaSymbolic[5, 3] // Simplify  (* same as ChebyshevLobeArea[5, 3] *)

Note: For n = 2, the formula has a singularity (denominator = 0).

See: ChebyshevLobeAreaIntegral for the explicit formula.";

ChebyshevLobeAreaIntegral::usage = "ChebyshevLobeAreaIntegral[n, m] computes the continuous integral of lobe areas.

Formula:
  ChebyshevLobeAreaIntegral[n, m] = ∫_{-mn}^{mn} ChebyshevLobeAreaSymbolic[n, k] dk
                                  = 2m - (n² Cos²[π/n] / (n² - 4)) × Sin[2mπ]/π

Special values:
  - For integer m: result is exactly 2m (sine term vanishes)
  - For half-integer m: result is exactly 2m (sine term vanishes)
  - Maximum deviation from 2m is ±1/π ≈ ±0.318 at m = k + 1/4

Limit as n → ∞:
  lim_{n→∞} ChebyshevLobeAreaIntegral[n, m] = 2m - Sin[2mπ]/π

This is the Fourier soft-floor function - a smooth approximation to 2×Floor[m].
The correction term Sin[2mπ]/π is the Gibbs phenomenon residue.

The damping factor σ(n) = n²Cos²[π/n]/(n²-4) acts as a natural Lanczos sigma factor:
  - σ(3) ≈ 0.45  (strong damping for triangle)
  - σ(5) ≈ 0.76
  - σ(10) ≈ 0.95
  - σ(n) → 1 as n → ∞

Examples:
  ChebyshevLobeAreaIntegral[5, 1]    (* -> 2 exactly *)
  ChebyshevLobeAreaIntegral[5, 1.25] (* -> 2.24... with sine correction *)
  ChebyshevLobeAreaIntegral[100, 1]  (* -> 2 exactly *)

See: ChebyshevLobeAreaSymbolic";

ChebyshevLobeClass::usage = "ChebyshevLobeClass[n, k] returns the classification of lobe k (k = 1, ..., n).

Returns one of:
  \"Universal\"  - edge lobes (k = 1 or k = n) touching endpoints ±1
  \"Primitive\"  - both boundary zeros are primitive (uses PrimitivePairQ[n, n-k])
  \"Inherited\"  - at least one boundary shares a factor with n

Classification is based on divisibility of boundary zero indices m = n-k and m = n-k+1:
  - Universal zero: m = 0 or m = n (endpoints)
  - Primitive zero: GCD[m, n] = 1
  - Inherited zero: GCD[m, n] > 1

Primality Connection:
  n is prime iff all interior lobes (k = 2, ..., n-1) are Primitive

Examples:
  ChebyshevLobeClass[7, 1]   (* -> \"Universal\" - leftmost lobe *)
  ChebyshevLobeClass[7, 3]   (* -> \"Primitive\" - 7 is prime, interior lobe *)
  ChebyshevLobeClass[15, 3]  (* -> \"Inherited\" - boundary at m=12, GCD[12,15]=3 *)
  ChebyshevLobeClass[15, 2]  (* -> \"Primitive\" - boundary m=13, PrimitivePairQ[15,13]=True *)

See: PrimitivePairQ, docs/sessions/2025-11-28-chebyshev-primality/journey-geometry-to-algebra.md";

ChebyshevLobeSign::usage = "ChebyshevLobeSign[n, k] returns the sign (+1 or -1) of lobe k.

Formula: (-1)^(n-k)

The sign alternates due to the oscillatory nature of Sin[n*theta]:
  - Lobes with odd (n-k) have sign +1
  - Lobes with even (n-k) have sign -1

This sign is used in the Signsigns computation:
  Signsigns[n] = Sum over primitive k of ChebyshevLobeSign[n, k]

which counts the difference between positive and negative primitive lobes.

Examples:
  ChebyshevLobeSign[5, 5]  (* -> +1 - rightmost lobe *)
  ChebyshevLobeSign[5, 4]  (* -> -1 *)
  ChebyshevLobeSign[5, 3]  (* -> +1 *)

See: docs/sessions/2025-11-28-chebyshev-primality/journey-geometry-to-algebra.md";

PrimitiveLobeIndices::usage = "PrimitiveLobeIndices[n] returns the list of lobe indices k where ChebyshevLobeClass[n, k] == \"Primitive\".

Returns: List of k ∈ {1, ..., n} where both boundary zeros are coprime to n.

Primality Connection:
  n is prime ⟹ PrimitiveLobeIndices[n] == {2, 3, ..., n-1} (all interior lobes)
  n composite ⟹ some interior lobes are inherited (shared factors with n)

Examples:
  PrimitiveLobeIndices[7]   (* -> {2, 3, 4, 5, 6} - prime, all interior lobes *)
  PrimitiveLobeIndices[6]   (* -> {2, 5} - composite, only lobes with coprime boundaries *)

See: ChebyshevLobeClass";

InheritedLobeIndices::usage = "InheritedLobeIndices[n] returns the list of lobe indices k where ChebyshevLobeClass[n, k] == \"Inherited\".

Returns: List of k ∈ {1, ..., n} where at least one boundary zero shares a factor with n.

Primality Connection:
  n is prime ⟹ InheritedLobeIndices[n] == {} (no inherited lobes)
  n composite ⟹ some interior lobes are inherited

Examples:
  InheritedLobeIndices[7]   (* -> {} - prime, no inherited lobes *)
  InheritedLobeIndices[6]   (* -> {3, 4} - composite, lobes with shared factors *)

See: ChebyshevLobeClass";

UniversalLobeIndices::usage = "UniversalLobeIndices[n] returns the list of lobe indices k where ChebyshevLobeClass[n, k] == \"Universal\".

Returns: Always {1, n} - the edge lobes touching endpoints ±1.

Universal lobes are always present regardless of n being prime or composite.

Examples:
  UniversalLobeIndices[5]   (* -> {1, 5} *)
  UniversalLobeIndices[10]  (* -> {1, 10} *)

See: ChebyshevLobeClass";

Signsigns::usage = "Signsigns[n] computes the signed sum of primitive lobes (geometric perspective).

Formula (geometric):
  Signsigns[n] = Sum over k where ChebyshevLobeClass[n,k]==\"Primitive\" of ChebyshevLobeSign[n,k]

This counts the difference between positive and negative primitive lobes:
  Signsigns[n] = (# positive primitive lobes) - (# negative primitive lobes)

Algebraic Equivalence:
  Signsigns[n] == AlgebraicSignSum[n]

The geometric interpretation (lobes) and algebraic interpretation (primitive pairs in ℤ/nℤ)
are equivalent - lobes were the scaffolding that led to the algebraic object of study.

Examples:
  Signsigns[5]   (* -> 1 for prime *)
  Signsigns[6]   (* -> 0 for composite with ω=2 *)

See: AlgebraicSignSum, PrimitivePairs";

PrimitivePairs::usage = "PrimitivePairs[n] returns the list of indices m where both m and m+1 are coprime to n (algebraic perspective).

Formula:
  PrimitivePairs[n] = {m ∈ {0, ..., n-1} : PrimitivePairQ[n, m] = True}

This is the algebraic object underlying the geometric lobe classification.

Connection to Lobes:
  m ∈ PrimitivePairs[n] ⟺ lobe k = n-m is primitive
  (modulo boundary index mapping)

For primes: all pairs except m=0 and m=n-1 are primitive
For composites: depends on factor structure

Examples:
  PrimitivePairs[7]   (* -> {1, 2, 3, 4, 5} - prime *)
  PrimitivePairs[15]  (* -> {1, 7, 13} - 3*5, three primitive pairs *)
  PrimitivePairs[10]  (* -> {} - 2*5, no primitive pairs *)

See: AlgebraicSignSum, PrimitivePairQ";

AlgebraicSignSum::usage = "AlgebraicSignSum[n] computes the signed sum over primitive pairs (algebraic perspective).

Formula:
  AlgebraicSignSum[n] = Sum over m ∈ PrimitivePairs[n] of (-1)^m

This is the pure algebraic object of study in ℤ/nℤ, free from geometric lobe interpretation.

Geometric Equivalence:
  AlgebraicSignSum[n] == Signsigns[n]

The algebraic view focuses on parity of primitive elements modulo n:
  - Counts difference between even and odd primitive pairs
  - For products of primes, exhibits hierarchical b-vector structure
  - For ω ≥ 4 distinct prime factors, exhibits exponential complexity

Examples:
  AlgebraicSignSum[5]   (* -> 1 for prime *)
  AlgebraicSignSum[6]   (* -> 0 for composite with ω=2 *)

See: PrimitivePairs, LobeSignSum";

ChebyshevLobeZeros::usage = "ChebyshevLobeZeros[n] returns the n+1 zeros of the Chebyshev polygon function for n lobes.

Formula:
  ChebyshevLobeZeros[n] = {Cos[m*Pi/n] : m = 0, 1, ..., n}

These zeros divide the interval [-1, 1] into n lobes.
The function with these zeros is T_{n+1}(x) - x*T_n(x) = ChebyshevPolygonFunction[x, n].

Examples:
  ChebyshevLobeZeros[4]  (* -> {1, 1/Sqrt[2], 0, -1/Sqrt[2], -1} *)
  ChebyshevLobeZeros[6]  (* -> {1, Sqrt[3]/2, 1/2, 0, -1/2, -Sqrt[3]/2, -1} *)

See: ChebyshevPolygonVertices, ChebyshevLobeArea";

ChebyshevPolygonVertices::usage = "ChebyshevPolygonVertices[n] returns the n vertices of the regular n-gon inscribed in the unit circle.

These are the points (x, y) where x^2 + ChebyshevPolygonFunction[x, n-1]^2 == 1.
The n-gon is rotated by -Pi/(2n) so that no two vertices share the same x-coordinate.

Formula:
  ChebyshevPolygonVertices[n] = {{Cos[-Pi/(2n) + 2*Pi*j/n], Sin[-Pi/(2n) + 2*Pi*j/n]} : j = 0, ..., n-1}

Use for tick marks in visualizations of n lobes.

Examples:
  ChebyshevPolygonVertices[4]  (* -> square vertices *)
  ChebyshevPolygonVertices[7]  (* -> heptagon vertices *)

See: ChebyshevLobeZeros, ChebyshevPolygonFunction";

LobeSignSum::usage = "LobeSignSum[n] computes the signed sum of primitive lobes (geometric perspective).

Formula (geometric):
  LobeSignSum[n] = Sum over k where ChebyshevLobeClass[n,k]==\"Primitive\" of ChebyshevLobeSign[n,k]

This counts the difference between positive and negative primitive lobes:
  LobeSignSum[n] = (# positive primitive lobes) - (# negative primitive lobes)

Algebraic Equivalence:
  LobeSignSum[n] == AlgebraicSignSum[n]

The geometric interpretation (lobes) and algebraic interpretation (primitive pairs in Z/nZ)
are equivalent - lobes were the scaffolding that led to the algebraic object of study.

Examples:
  LobeSignSum[5]   (* -> -1 for prime *)
  LobeSignSum[6]   (* -> 0 for composite with omega=2 *)
  LobeSignSum[21]  (* -> 1 for 3*7, first positive! *)

See: AlgebraicSignSum, PrimitivePairs";

PrimitiveLobeAreaSum::usage = "PrimitiveLobeAreaSum[n] computes the sum of areas of primitive lobes.

Formula:
  A_n = Σ_{k: PrimitivePairQ[n, n-k]} ChebyshevLobeArea[n, k]

Properties:
  - For even n: A_n = 0 (no primitive pairs exist)
  - For odd prime p: A_p ≈ 1 - 2×(edge lobe area) → 1 as p → ∞
  - For odd composite: A_n < 1, depends on factorization

The formula involves a sum of cosines over primitive pairs:
  A_n = Σ (8 - 2n² + n²(Cos[2(k-1)π/n] + Cos[2kπ/n])) / (8n - 2n³)
       for k where both (n-k) and (n-k+1) are coprime to n

This does NOT simplify to elementary number-theoretic functions because it
depends on which consecutive pairs (m, m+1) are both coprime to n.

Normalization for Primitive Lobes Distribution:
  C = (Σ_{n odd ≥ 3} A_n/n²)⁻¹ ≈ 6.1
  Primes dominate: ~95% of weight comes from prime n

Examples:
  PrimitiveLobeAreaSum[3]   (* -> 19/30 ≈ 0.633 *)
  PrimitiveLobeAreaSum[5]   (* -> (327 + 25√5)/420 ≈ 0.912 *)
  PrimitiveLobeAreaSum[7]   (* ≈ 0.967 *)
  PrimitiveLobeAreaSum[9]   (* -> 1/3, small due to divisibility *)
  PrimitiveLobeAreaSum[11]  (* ≈ 0.991 for prime *)

See: ChebyshevLobeArea, PrimitiveLobeIndices, PrimitivePairQ";

ChebyshevLobeParity::usage = "ChebyshevLobeParity[n, k] returns the parity contribution of lobe k to the sum.

Returns:
  +1 : Primitive lobe ABOVE x-axis (f(x) > 0)
  -1 : Primitive lobe BELOW x-axis (f(x) < 0)
   0 : Universal or Inherited lobe (does not contribute)

Formula:
  For Primitive lobes: (-1)^(n-k+1) = geometric sign of f(x)
  For non-Primitive: 0

This unifies lobe classification and geometric position into a single value.
The parity corresponds to the visual position: + means above axis, - means below.

Relationship:
  LobeParitySum[n] = Sum of ChebyshevLobeParity[n, k] for k = 1..n

Examples:
  ChebyshevLobeParity[7, 4]   (* -> +1, primitive lobe above axis *)
  ChebyshevLobeParity[7, 3]   (* -> -1, primitive lobe below axis *)
  ChebyshevLobeParity[7, 1]   (* -> 0, universal lobe *)
  ChebyshevLobeParity[6, 3]   (* -> 0, inherited lobe *)

See: LobeParitySum, ChebyshevLobeClass, ChebyshevLobeSign";

LobeParitySum::usage = "LobeParitySum[n] computes the sum of parities over all lobes.

Formula:
  LobeParitySum[n] = Sum of ChebyshevLobeParity[n, k] for k = 1..n
                   = (# primitive lobes above) - (# primitive lobes below)

This uses the GEOMETRIC sign convention:
  +1 for lobes above x-axis, -1 for lobes below.

Key values:
  LobeParitySum[prime] = +1  (primes have positive parity sum!)
  LobeParitySum[p*q]   = +1 or -3 (semiprimes)

Algebraic Equivalence:
  LobeParitySum[n] == AlgebraicParitySum[n]

Examples:
  LobeParitySum[7]   (* -> +1 for prime *)
  LobeParitySum[15]  (* -> +3 for 3*5 *)
  LobeParitySum[21]  (* -> -1 for 3*7 *)

See: ChebyshevLobeParity, AlgebraicParitySum";

AlgebraicParitySum::usage = "AlgebraicParitySum[n] computes the parity sum using pure algebra.

Formula:
  AlgebraicParitySum[n] = Sum of (-1)^(m+1) for m in PrimitivePairs[n]

This is the algebraic formulation equivalent to LobeParitySum[n].
Uses geometric sign convention: (-1)^(m+1) instead of (-1)^m.

Key values:
  AlgebraicParitySum[prime] = +1
  AlgebraicParitySum[p*q]   = +1 or -3

Examples:
  AlgebraicParitySum[7]   (* -> +1 *)
  AlgebraicParitySum[15]  (* -> +3 *)
  AlgebraicParitySum[21]  (* -> -1 *)

See: LobeParitySum, PrimitivePairs";

LobeParitySumClosedForm::usage = "LobeParitySumClosedForm[n] computes LobeParitySum using closed-form formulas.

Available for n with at most 3 DISTINCT prime factors (squarefree or not).

Radical Invariance Theorem:
  LobeParitySum[n] = LobeParitySum[rad(n)]
  where rad(n) = SquarefreeRadical[n] is the product of distinct prime factors.
  This means multiplicities don't affect the parity sum!

IMPORTANT: For EVEN n, all lobes are inherited (result = 0).

Formulas (for ODD n):
  1 distinct prime (p^e):    LobeParitySumClosedForm[p^e] = +1
  2 distinct primes (p^a*q^b): LobeParitySumClosedForm = 3 - 4*b_2
                               where b_2 = (p^{-1} mod q) mod 2
  3 distinct primes:         LobeParitySumClosedForm = 1 + 4*(Σb^triple - Σb_2^pairs)

Examples:
  LobeParitySumClosedForm[7]    (* -> 1, prime *)
  LobeParitySumClosedForm[9]    (* -> 1, 3^2, same as prime 3 *)
  LobeParitySumClosedForm[45]   (* -> 3, 3^2*5, same as 3*5=15 *)
  LobeParitySumClosedForm[21]   (* -> -1, 3*7 *)
  LobeParitySumClosedForm[147]  (* -> -1, 3*7^2, same as 3*7=21 *)
  LobeParitySumClosedForm[105]  (* -> 1, 3*5*7 *)
  LobeParitySumClosedForm[6]    (* -> 0, even *)

See: LobeParitySum, SquarefreeRadical, CRTParityB2, CRTParityVector";

SquarefreeRadical::usage = "SquarefreeRadical[n] returns the product of distinct prime factors of n.

Also known as the 'radical' of n, denoted rad(n).

Formula:
  SquarefreeRadical[n] = Product of p over all primes p dividing n

Key property (Radical Invariance):
  LobeParitySum[n] = LobeParitySum[SquarefreeRadical[n]]

Examples:
  SquarefreeRadical[12]   (* -> 6, since 12 = 2^2*3 *)
  SquarefreeRadical[45]   (* -> 15, since 45 = 3^2*5 *)
  SquarefreeRadical[105]  (* -> 105, already squarefree *)

See: LobeParitySumClosedForm";

CRTParityB2::usage = "CRTParityB2[p, q] returns the CRT parity b_2 for semiprime p*q (p < q).

Formula:
  CRTParityB2[p, q] = (p^{-1} mod q) mod 2

This is the key determinant for the semiprime sign sum:
  LobeParitySum[p*q] = 3 - 4*CRTParityB2[p, q]

Examples:
  CRTParityB2[3, 5]   (* -> 0, since 3^{-1} mod 5 = 2 (even) *)
  CRTParityB2[3, 7]   (* -> 1, since 3^{-1} mod 7 = 5 (odd) *)

See: CRTParityVector, LobeParitySumClosedForm";

CRTParityVector::usage = "CRTParityVector[{p1, p2, ...}] returns the b-vector of CRT parities.

For product n = p1*p2*...*pk, the b-vector is (b_1, b_2, ..., b_k) where:
  b_i = (M_i^{-1} mod p_i) mod 2
  M_i = n / p_i

Examples:
  CRTParityVector[{3, 5}]     (* -> {1, 0} *)
  CRTParityVector[{3, 5, 7}]  (* -> b-vector for 105 *)

See: CRTParityB2, LobeParitySumClosedForm";

ChebyshevLobeDistribution::usage = "ChebyshevLobeDistribution[n] returns a ProbabilityDistribution on [-1, 1].

Parameters:
  n - lobe count parameter (n > 2), controls the number of lobes per period

The PDF on [-1, 1] is:
  f(x) = (1/2) [1 + α(n) cos(π(1/n - x))]
where α(n) = n² cos(π/n) / (n² - 4)

Properties:
  - Domain: x ∈ [-1, 1] (canonical Chebyshev interval)
  - Integral: ∫₋₁¹ f(x) dx = 1
  - Non-negative: f(x) ≥ 0 for all x ∈ [-1, 1] when n > 2
  - Symmetric center: Mean → 0 as n → ∞
  - Limit: as n → ∞, converges to Hann-like window

Forms:
  ChebyshevLobeDistribution[n]              - n lobes on [-1, 1]
  ChebyshevLobeDistribution[n, {a, b}]      - n lobes scaled to [a, b]
  ChebyshevLobeDistribution[n, {a, b}, p]   - n lobes × p periods on [a, b]

Design rationale:
  - n = shape (lobes per period)
  - {a, b} = explicit support interval
  - p = number of periods (total lobes = n × p)
  Support is always exactly what you specify.

Examples:
  dist = ChebyshevLobeDistribution[10];
  Plot[PDF[dist, x], {x, -1, 1}]

  (* 10 lobes scaled to [0, 4] *)
  dist2 = ChebyshevLobeDistribution[10, {0, 4}];
  Plot[PDF[dist2, x], {x, 0, 4}]

  (* Compare factorizations of N=12 total lobes on [-1, 1] *)
  d12 = ChebyshevLobeDistribution[12, {-1, 1}, 1];  (* 12 × 1 *)
  d6  = ChebyshevLobeDistribution[6, {-1, 1}, 2];   (* 6 × 2 *)
  d3  = ChebyshevLobeDistribution[3, {-1, 1}, 4];   (* 3 × 4 *)

See: ChebyshevLobeAreaSymbolic, ChebyshevLobeMean, ChebyshevLobeVariance";

ChebyshevLobeMean::usage = "ChebyshevLobeMean[n] returns the symbolic mean of ChebyshevLobeDistribution[n] on [-1, 1].
Formula: E[X] = n² sin(2π/n) / (2π(n²-4))";

ChebyshevLobeSecondMoment::usage = "ChebyshevLobeSecondMoment[n] returns E[X²] for ChebyshevLobeDistribution[n] on [-1, 1].
Formula: E[X²] = 1/3 - 2n²cos²(π/n) / ((n²-4)π²)";

ChebyshevLobeVariance::usage = "ChebyshevLobeVariance[n] returns the symbolic variance of ChebyshevLobeDistribution[n] on [-1, 1].
Formula: Var[X] = E[X²] - E[X]²
Limiting value: lim_{n→∞} Var[X] = 1/3 - 2/π² ≈ 0.131 (Hann window variance)";

ChebyshevLobeThirdMoment::usage = "ChebyshevLobeThirdMoment[n] returns E[X³] for ChebyshevLobeDistribution[n] on [-1, 1].
Formula: E[X³] = n²(π²-6)sin(2π/n) / (2(n²-4)π³)";

ChebyshevLobeVarianceLimit::usage = "ChebyshevLobeVarianceLimit is the limiting variance as n → ∞.
Value: 1/3 - 2/π² ≈ 0.131 (Hann window variance on [-1, 1])";

(* ===== RAISED HANN DISTRIBUTION: Direct α parameterization ===== *)

RaisedHannDistribution::usage = "RaisedHannDistribution[α] returns a probability distribution on [-1, 1].

This is a generalized Hann window with direct amplitude control:
  PDF: f(x) = (1/2)[1 + α·cos(πx)]  for x ∈ [-1, 1]

Parameters:
  α - amplitude parameter, 0 ≤ α ≤ 1
    α = 0: uniform distribution
    α = 1: exact Hann window (zeros at boundaries)
    0 < α < 1: raised Hann (positive minimum at boundaries)

Relationship to ChebyshevLobeDistribution:
  ChebyshevLobeDistribution[n] uses α(n) = n²cos(π/n)/(n²-4)
  RaisedHannDistribution[α] uses α directly

Forms:
  RaisedHannDistribution[α]              - on canonical [-1, 1]
  RaisedHannDistribution[α, {a, b}]      - scaled to [a, b]
  RaisedHannDistribution[α, {a, b}, k]   - k periods on [a, b] (high-frequency)

Adversarial uniformity attack:
  RaisedHannDistribution[1, {-1, 1}, 100] has 100 oscillations with amplitude 1.
  PDF varies between 0 and 1 (extremely non-uniform), but CDF ≈ uniform.
  Passes KS test and chi-squared with coarse binning despite 100× density variation!

Moments (on [-1, 1]):
  Mean = 0 (by symmetry)
  Variance = 1/3 - 2α/π²
  Skewness = 0 (symmetric)

Examples:
  Plot[PDF[RaisedHannDistribution[0.9], x], {x, -1, 1}]
  Mean[RaisedHannDistribution[1]]  (* -> 0 *)
  Variance[RaisedHannDistribution[1]]  (* -> 1/3 - 2/π² *)

See: ChebyshevLobeDistribution, HannWindowDistribution";

HannWindowDistribution::usage = "HannWindowDistribution[] returns the exact Hann window distribution on [-1, 1].

This is RaisedHannDistribution[1], the limiting case with:
  PDF: f(x) = (1/2)[1 + cos(πx)]  for x ∈ [-1, 1]

Properties:
  - Zeros at x = ±1 (boundaries)
  - Maximum at x = 0 (center)
  - Smooth (C∞) everywhere

Forms:
  HannWindowDistribution[]         - on canonical [-1, 1]
  HannWindowDistribution[{a, b}]   - scaled to [a, b]

Moments (on [-1, 1]):
  Mean = 0
  Variance = 1/3 - 2/π² ≈ 0.1307
  Kurtosis = 3 - 48/π⁴ ≈ 2.507

See: RaisedHannDistribution, ChebyshevLobeDistribution";

RaisedHannMean::usage = "RaisedHannMean[α] returns 0 (mean is always zero by symmetry).";
RaisedHannVariance::usage = "RaisedHannVariance[α] returns the variance 1/3 - 2α/π².";
RaisedHannSkewness::usage = "RaisedHannSkewness[α] returns 0 (distribution is symmetric).";
RaisedHannKurtosis::usage = "RaisedHannKurtosis[α] returns the excess kurtosis.";
RaisedHannSecondMoment::usage = "RaisedHannSecondMoment[α] returns E[X²] = 1/3 - 2α/π².";
RaisedHannFourthMoment::usage = "RaisedHannFourthMoment[α] returns E[X⁴] = 1/5 + 4α(π²-12)/π⁴.";

ChebyshevAmplitude::usage = "ChebyshevAmplitude[n] returns α(n) = n²cos(π/n)/(n²-4).

This is the amplitude parameter that connects ChebyshevLobeDistribution to RaisedHannDistribution:
  ChebyshevLobeDistribution[n] ≡ RaisedHannDistribution[ChebyshevAmplitude[n]]

Properties:
  ChebyshevAmplitude[3] = 0.9 (exact)
  ChebyshevAmplitude[n] → 1 as n → ∞
  ChebyshevAmplitude[n] < 1 for all finite n > 2

See: RaisedHannDistribution, ChebyshevLobeDistribution"

PrimitivePairQ::usage = "PrimitivePairQ[n, m] tests whether (m, m+1) forms a primitive pair modulo n.

A primitive pair is a pair of consecutive integers that are both coprime to n.

Formula:
  PrimitivePairQ[n, m] = (GCD[m, n] == 1) && (GCD[m + 1, n] == 1)

This is the fundamental building block for:
  - ChebyshevLobeClass: lobe k is Primitive iff PrimitivePairQ[n, n-k]
  - PrimitivePairs: {m : PrimitivePairQ[n, m]}
  - ChebyshevLobeParity: uses PrimitivePairQ to determine contribution

Examples:
  PrimitivePairQ[7, 3]   (* -> True - both 3 and 4 coprime to 7 *)
  PrimitivePairQ[15, 7]  (* -> True - both 7 and 8 coprime to 15 *)
  PrimitivePairQ[15, 2]  (* -> False - GCD[3, 15] = 3 > 1 *)
  PrimitivePairQ[10, 3]  (* -> False - GCD[4, 10] = 2 > 1 *)

See: PrimitivePairs, ChebyshevLobeClass";

Begin["`Private`"];

(* Chebyshev polygon function - unit circle polygon vertices *)
ChebyshevPolygonFunction[x_, k_Integer] := ChebyshevT[k + 1, x] - x * ChebyshevT[k, x]

(* Chebyshev lobe area - closed form for individual lobe areas
   This is a closed form of: (-1)^(n-k) * Integrate[Sin[n θ] Sin[θ]^2, {θ, (n-k) π/n, (n-k+1) π/n}]
   Sum over all k from 1 to n equals 1 (Chebyshev Integral Theorem) *)
ChebyshevLobeArea[n_Integer /; n >= 3, k_Integer /; k >= 1] /; k <= n :=
  (8 - 2 n^2 + n^2 (Cos[(2 (k - 1) Pi)/n] + Cos[(2 k Pi)/n])) / (8 n - 2 n^3)

(* Symbolic version - no Integer constraint, works for algebraic manipulation
   Continuous Integral Identity: Integrate[..., {k, 0, n}] == 1 *)
ChebyshevLobeAreaSymbolic[n_, k_] :=
  (8 - 2 n^2 + n^2 (Cos[(2 (k - 1) Pi)/n] + Cos[(2 k Pi)/n])) / (8 n - 2 n^3)

(* Continuous integral of lobe areas - soft-floor function
   ∫_{-mn}^{mn} LobeArea[n,k] dk = 2m - σ(n) Sin[2mπ]/π
   where σ(n) = n² Cos²[π/n] / (n² - 4) is the Lanczos-like damping factor.
   As n → ∞, σ(n) → 1 and the formula becomes the classic Fourier soft-floor. *)
ChebyshevLobeAreaIntegral[n_, m_] :=
  2 m - (n^2 Cos[Pi/n]^2) / ((n^2 - 4) Pi) * Sin[2 m Pi]

(* Lanczos-like damping factor σ(n) = n² Cos²[π/n] / (n² - 4)
   This naturally regularizes the Gibbs phenomenon in the continuous integral. *)
ChebyshevLobeSigma[n_] := n^2 Cos[Pi/n]^2 / (n^2 - 4)

(* Chebyshev lobe sign - alternating sign based on lobe position
   Sign is (-1)^(n-k), corresponding to the sign of Sin[n*theta] in each lobe interval *)
ChebyshevLobeSign[n_Integer /; n >= 1, k_Integer /; k >= 1] /; k <= n :=
  (-1)^(n - k)

(* Primitive pair test - fundamental building block for lobe classification *)
PrimitivePairQ[n_Integer /; n >= 1, m_Integer] :=
  GCD[m, n] == 1 && GCD[m + 1, n] == 1

(* Chebyshev lobe classification - categorize lobes by boundary divisibility
   Classification based on zero indices m = n-k and m = n-k+1:
   - Universal: edge lobes (k = 1 or k = n) touching endpoints ±1
   - Primitive: both boundaries coprime to n (uses PrimitivePairQ)
   - Inherited: at least one boundary shares a factor with n *)
ChebyshevLobeClass[n_Integer /; n >= 1, k_Integer /; k >= 1] /; k <= n :=
  Which[
    (* Edge lobes touching ±1 *)
    k == 1 || k == n, "Universal",
    (* Both boundaries primitive (coprime to n) *)
    PrimitivePairQ[n, n - k], "Primitive",
    (* At least one boundary inherited *)
    True, "Inherited"
  ]

(* ===== GEOMETRIC LAYER: Lobe-based functions ===== *)

(* Lobe indices by classification *)
PrimitiveLobeIndices[n_Integer /; n >= 1] :=
  Select[Range[n], ChebyshevLobeClass[n, #] === "Primitive" &]

InheritedLobeIndices[n_Integer /; n >= 1] :=
  Select[Range[n], ChebyshevLobeClass[n, #] === "Inherited" &]

UniversalLobeIndices[n_Integer /; n >= 1] := {1, n}

(* Signed sum over primitive lobes - geometric perspective *)
LobeSignSum[n_Integer /; n >= 1] :=
  Total[ChebyshevLobeSign[n, #] & /@ PrimitiveLobeIndices[n]]

(* Sum of primitive lobe areas - A_n = Σ_{k primitive} ChebyshevLobeArea[n, k]
   For odd n: A_n > 0; for even n: A_n = 0 (no primitive pairs)
   For prime p: A_p ≈ 1 - 2×edge_area → 1 as p → ∞
   Uses closed-form ChebyshevLobeArea, no numerical integration needed.

   The sum involves trigonometric terms over primitive pairs:
   A_n = Σ_{k: PrimitivePairQ[n, n-k]} (8 - 2n² + n²(Cos[2(k-1)π/n] + Cos[2kπ/n])) / (8n - 2n³)

   No known simplification to elementary number-theoretic functions (Ramanujan sums, etc.)
   because it depends on which consecutive pairs (m, m+1) are both coprime to n.

   See: Primitive Lobes Distribution formalization *)
PrimitiveLobeAreaSum[n_Integer /; n >= 3] :=
  Total[ChebyshevLobeArea[n, #] & /@ PrimitiveLobeIndices[n]]

(* Zeros of Chebyshev polygon function for n lobes: cos(m*Pi/n) for m = 0, ..., n *)
ChebyshevLobeZeros[n_Integer /; n >= 1] :=
  Table[Cos[m Pi / n], {m, 0, n}]

(* Vertices of regular n-gon inscribed in unit circle, rotated by -Pi/(2n) *)
ChebyshevPolygonVertices[n_Integer /; n >= 1] :=
  Table[
    {Cos[-(Pi/(2 n)) + 2 Pi j/n], Sin[-(Pi/(2 n)) + 2 Pi j/n]},
    {j, 0, n - 1}
  ]

(* ===== ALGEBRAIC LAYER: Pure ℤ/nℤ formulation ===== *)

(* Primitive pairs: indices m where gcd(m,n)=1 AND gcd(m+1,n)=1 *)
PrimitivePairs[n_Integer /; n >= 1] :=
  Select[Range[0, n - 1], PrimitivePairQ[n, #] &]

(* Algebraic sign sum: Σ_{m ∈ PrimitivePairs} (-1)^m *)
AlgebraicSignSum[n_Integer /; n >= 1] :=
  Total[(-1)^# & /@ PrimitivePairs[n]]

(* ===== PARITY LAYER: Unified geometric convention ===== *)
(* Parity uses GEOMETRIC sign: +1 above axis, -1 below axis *)
(* This is (-1)^(n-k+1) = -ChebyshevLobeSign for primitive lobes *)

(* Lobe parity: unified classification + geometric sign
   Uses PrimitivePairQ directly - Universal and Inherited lobes give 0 *)
ChebyshevLobeParity[n_Integer /; n >= 1, k_Integer /; k >= 1] /; k <= n :=
  Boole[PrimitivePairQ[n, n - k]] * (-1)^(n - k + 1)

(* Sum of parities over all lobes
   Uses Radical Invariance: LobeParitySum[n] = LobeParitySum[rad(n)]
   This reduces complexity from O(n) to O(rad(n)) *)
LobeParitySum[n_Integer /; n >= 1] :=
  Module[{rad = Times @@ FactorInteger[n][[All, 1]]},
    Total[Table[ChebyshevLobeParity[rad, k], {k, 1, rad}]]
  ]

(* Algebraic parity sum: Σ_{m ∈ PrimitivePairs} (-1)^(m+1)
   Uses Radical Invariance for O(rad(n)) complexity *)
AlgebraicParitySum[n_Integer /; n >= 1] :=
  Module[{rad = Times @@ FactorInteger[n][[All, 1]]},
    Total[(-1)^(# + 1) & /@ PrimitivePairs[rad]]
  ]

(* ===== CLOSED FORM LAYER: Explicit formulas for omega <= 3 ===== *)

(* CRT parity b_2 for semiprime pq: (p^{-1} mod q) mod 2 *)
CRTParityB2[p_Integer, q_Integer] /; PrimeQ[p] && PrimeQ[q] && p < q :=
  Mod[PowerMod[p, -1, q], 2]

(* Full b-vector for product of primes *)
CRTParityVector[primes_List] /; Length[primes] >= 2 :=
  Module[{n = Times @@ primes, Mi, ei},
    Table[
      Mi = n / primes[[i]];
      ei = PowerMod[Mi, -1, primes[[i]]];
      Mod[ei, 2],
      {i, Length[primes]}
    ]
  ]

(* Squarefree radical: product of distinct prime factors *)
SquarefreeRadical[n_Integer] := Times @@ FactorInteger[n][[All, 1]]

(* Radical Invariance Theorem: LobeParitySum[n] = LobeParitySum[rad(n)]
   This allows extending closed forms to non-squarefree numbers.
   PrimeNu[n] = ω(n) = number of distinct prime factors (built-in) *)

(* Closed form for ω = 1 (prime powers) *)
LobeParitySumClosedForm[n_Integer] /; PrimeNu[n] == 1 && OddQ[n] := 1
LobeParitySumClosedForm[n_Integer] /; PrimeNu[n] == 1 && EvenQ[n] := 0

(* Closed form for ω = 2 (two distinct primes, any multiplicities) *)
LobeParitySumClosedForm[n_Integer] /; PrimeNu[n] == 2 && OddQ[n] :=
  Module[{primes, p, q, b2},
    primes = Sort[FactorInteger[n][[All, 1]]];
    {p, q} = primes;
    b2 = CRTParityB2[p, q];
    3 - 4 * b2
  ]
LobeParitySumClosedForm[n_Integer] /; PrimeNu[n] == 2 && EvenQ[n] := 0

(* Closed form for ω = 3 (three distinct primes, any multiplicities) *)
LobeParitySumClosedForm[n_Integer] /; PrimeNu[n] == 3 && OddQ[n] :=
  Module[{primes, pairs, sumB2pairs, bTriple, sumBtriple},
    primes = Sort[FactorInteger[n][[All, 1]]];

    (* Sum of b_2 over all pairs *)
    pairs = Subsets[primes, {2}];
    sumB2pairs = Total[CRTParityB2 @@ # & /@ pairs];

    (* Sum of b_i for the triple *)
    bTriple = CRTParityVector[primes];
    sumBtriple = Total[bTriple];

    (* Formula: 1 + 4*(sumBtriple - sumB2pairs) *)
    1 + 4 * (sumBtriple - sumB2pairs)
  ]
LobeParitySumClosedForm[n_Integer] /; PrimeNu[n] == 3 && EvenQ[n] := 0

(* ===== PROBABILITY DISTRIBUTION LAYER ===== *)

(* Normalized lobe area PDF: f(t) = 1 - α(n) cos(π(1/n - 2t))
   where α(n) = n² cos(π/n) / (n² - 4)
   This is Ã(n,t) = n * A(n, n*t) from the normalization *)

(* Helper: amplitude function *)
lobeAmplitude[n_] := n^2 Cos[Pi/n] / (n^2 - 4)

(* Helper: PDF on Chebyshev domain [-1, 1]
   Symmetric form: f(x) = (1/2) * [1 + α(n) * cos(πx)]
   - Peak at x = 0 (center of support)
   - Minima at x = ±1 (boundaries)
   - Converges to Hann window as n → ∞ *)
lobePDFChebyshev[n_, x_] := (1/2) (1 + lobeAmplitude[n] Cos[Pi x])

(* Basic form: n lobes on [-1, 1] - canonical Chebyshev domain *)
ChebyshevLobeDistribution[n_ /; n > 2] :=
  ProbabilityDistribution[
    lobePDFChebyshev[n, x],
    {x, -1, 1},
    Assumptions -> n > 2
  ]

(* Two-parameter form: n lobes scaled to arbitrary interval [a, b] *)
ChebyshevLobeDistribution[n_ /; n > 2, {a_, b_}] :=
  Module[{width = b - a},
    ProbabilityDistribution[
      (2/width) lobePDFChebyshev[n, 2 (x - a)/width - 1],
      {x, a, b},
      Assumptions -> n > 2 && b > a
    ]
  ]

(* Full form: n lobes × p periods on interval [a, b] *)
(* Total lobes = n × periods, support is exactly [a, b] *)
(* Uses cos(periods × π × normalized_x) - no Mod needed, smooth high-frequency oscillation *)
ChebyshevLobeDistribution[n_ /; n > 2, {a_, b_}, periods_Integer /; periods >= 1] :=
  Module[{width = b - a},
    ProbabilityDistribution[
      (2/width) lobePDFChebyshev[n, periods (2 (x - a)/width - 1)],
      {x, a, b},
      Assumptions -> n > 2 && b > a && periods >= 1
    ]
  ]

(* ============================================================= *)
(* SYMBOLIC MOMENT FUNCTIONS *)
(* ============================================================= *)

(* Symbolic mean on [-1, 1] - zero by symmetry *)
ChebyshevLobeMean[n_] := 0

(* Symbolic variance on [-1, 1]
   For symmetric PDF f(x) = (1/2)[1 + α(n)·cos(πx)]:
   Var = E[X²] = 1/3 - 2α(n)/π² *)
ChebyshevLobeVariance[n_] := 1/3 - 2 lobeAmplitude[n] / Pi^2

(* Expanded form using α(n) = n²cos(π/n)/(n²-4) *)
ChebyshevLobeVarianceExplicit[n_] := 1/3 - 2 n^2 Cos[Pi/n] / ((n^2 - 4) Pi^2)

(* Limiting variance as n → ∞ (Hann window variance) *)
ChebyshevLobeVarianceLimit = 1/3 - 2/Pi^2;

(* ===== RAISED HANN DISTRIBUTION ===== *)
(* Direct α parameterization: f(x) = (1/2)[1 + α·cos(πx)] on [-1,1] *)

(* Helper: PDF for raised Hann *)
raisedHannPDF[alpha_, x_] := (1/2) (1 + alpha Cos[Pi x])

(* Basic form: on [-1, 1] *)
RaisedHannDistribution[alpha_ /; 0 <= alpha <= 1] :=
  ProbabilityDistribution[
    raisedHannPDF[alpha, x],
    {x, -1, 1},
    Assumptions -> 0 <= alpha <= 1
  ]

(* Two-parameter form: scaled to [a, b] *)
RaisedHannDistribution[alpha_ /; 0 <= alpha <= 1, {a_, b_}] :=
  Module[{width = b - a},
    ProbabilityDistribution[
      (2/width) raisedHannPDF[alpha, 2 (x - a)/width - 1],
      {x, a, b},
      Assumptions -> 0 <= alpha <= 1 && b > a
    ]
  ]

(* Three-parameter form: k periods on [a, b] *)
(* PDF = (1/2)[1 + α cos(k π normalized_x)] - smooth high-frequency oscillation *)
RaisedHannDistribution[alpha_ /; 0 <= alpha <= 1, {a_, b_}, periods_Integer /; periods >= 1] :=
  Module[{width = b - a},
    ProbabilityDistribution[
      (2/width) raisedHannPDF[alpha, periods (2 (x - a)/width - 1)],
      {x, a, b},
      Assumptions -> 0 <= alpha <= 1 && b > a && periods >= 1
    ]
  ]

(* Exact Hann window distribution (α = 1) *)
HannWindowDistribution[] := RaisedHannDistribution[1]
HannWindowDistribution[{a_, b_}] := RaisedHannDistribution[1, {a, b}]
HannWindowDistribution[{a_, b_}, periods_Integer] := RaisedHannDistribution[1, {a, b}, periods]

(* ===== RAISED HANN SYMBOLIC MOMENTS ===== *)
(* All moments derived from: f(x) = (1/2)[1 + α·cos(πx)] on [-1,1] *)

(* Mean = 0 by symmetry *)
RaisedHannMean[alpha_] := 0

(* Second moment E[X²] = ∫ x² · (1/2)[1 + α·cos(πx)] dx
   = (1/2)·(2/3) + (α/2)·∫ x² cos(πx) dx
   = 1/3 + (α/2)·(-4/π²) = 1/3 - 2α/π² *)
RaisedHannSecondMoment[alpha_] := 1/3 - 2 alpha/Pi^2

(* Variance = E[X²] - E[X]² = E[X²] (since mean = 0) *)
RaisedHannVariance[alpha_] := 1/3 - 2 alpha/Pi^2

(* Skewness = 0 by symmetry *)
RaisedHannSkewness[alpha_] := 0

(* Fourth moment E[X⁴] = ∫ x⁴ · (1/2)[1 + α·cos(πx)] dx
   = (1/2)·(2/5) + (α/2)·∫ x⁴ cos(πx) dx
   The integral ∫_{-1}^{1} x⁴ cos(πx) dx = 8(π²-12)/π⁴
   So E[X⁴] = 1/5 + (α/2)·8(π²-12)/π⁴ = 1/5 + 4α(π²-12)/π⁴ *)
RaisedHannFourthMoment[alpha_] := 1/5 + 4 alpha (Pi^2 - 12)/Pi^4

(* Excess kurtosis = E[X⁴]/Var² - 3 *)
RaisedHannKurtosis[alpha_] :=
  RaisedHannFourthMoment[alpha] / RaisedHannVariance[alpha]^2 - 3

(* ===== COMPARISON: Chebyshev amplitude as function of n ===== *)
(* This allows easy comparison: RaisedHannDistribution[ChebyshevAmplitude[n]] *)
ChebyshevAmplitude[n_] := n^2 Cos[Pi/n] / (n^2 - 4)

End[];

EndPackage[];
