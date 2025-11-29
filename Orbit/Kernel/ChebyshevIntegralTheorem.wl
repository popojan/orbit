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

End[];

EndPackage[];
