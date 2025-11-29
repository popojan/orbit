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
  \"Primitive\"  - both boundary zeros are primitive (coprime to n)
  \"Inherited\"  - at least one boundary shares a factor with n

Classification is based on divisibility of boundary zero indices m = n-k and m = n-k+1:
  - Universal zero: m = 0 or m = n (endpoints)
  - Primitive zero: GCD[m, n] = 1
  - Inherited zero: GCD[m, n] > 1

Primality Connection:
  n is prime iff all interior lobes (k = 2, ..., n-1) are Primitive

Examples:
  ChebyshevLobeClass[6, 1]   (* -> \"Universal\" - leftmost lobe *)
  ChebyshevLobeClass[6, 3]   (* -> \"Inherited\" - boundary at π/2 shared with n=6 *)
  ChebyshevLobeClass[7, 3]   (* -> \"Primitive\" - 7 is prime, interior lobe *)

See: docs/sessions/2025-11-28-chebyshev-primality/journey-geometry-to-algebra.md";

ChebyshevLobeSign::usage = "ChebyshevLobeSign[n, k] returns the sign (+1 or -1) of lobe k.

Formula: (-1)^(n-k)

The sign alternates due to the oscillatory nature of Sin[n*theta]:
  - Lobes with odd (n-k) have sign +1
  - Lobes with even (n-k) have sign -1

This sign is used in the Signsigns computation:
  Signsigns(n) = Sum over primitive k of ChebyshevLobeSign[n, k]

which counts the difference between positive and negative primitive lobes.

Examples:
  ChebyshevLobeSign[5, 5]  (* -> +1 - rightmost lobe *)
  ChebyshevLobeSign[5, 4]  (* -> -1 *)
  ChebyshevLobeSign[5, 3]  (* -> +1 *)

See: docs/sessions/2025-11-28-chebyshev-primality/journey-geometry-to-algebra.md";

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

(* Chebyshev lobe classification - categorize lobes by boundary divisibility
   Classification based on zero indices m = n-k and m = n-k+1:
   - Universal: edge lobes (k = 1 or k = n) touching endpoints ±1
   - Primitive: both boundaries coprime to n (GCD = 1)
   - Inherited: at least one boundary shares a factor with n *)
ChebyshevLobeClass[n_Integer /; n >= 1, k_Integer /; k >= 1] /; k <= n :=
  Module[{m1, m2},
    (* Boundary zero indices *)
    m1 = n - k;      (* left boundary in theta *)
    m2 = n - k + 1;  (* right boundary in theta *)

    Which[
      (* Edge lobes touching ±1 *)
      k == 1 || k == n, "Universal",
      (* Both boundaries primitive (coprime to n) *)
      GCD[m1, n] == 1 && GCD[m2, n] == 1, "Primitive",
      (* At least one boundary inherited *)
      True, "Inherited"
    ]
  ]

End[];

EndPackage[];
