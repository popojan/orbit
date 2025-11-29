(* ::Package:: *)

(* Square Root Rationalizations via Chebyshev Polynomials and Pell Equations *)

BeginPackage["Orbit`"];

SqrtRationalization::usage = "SqrtRationalization[n] computes a rational approximation to Sqrt[n] using Pell equation solutions and Chebyshev polynomial refinement.

Options:
  Method -> \"Rational\" | \"List\" | \"Expression\"
  Accuracy -> integer (number of Chebyshev terms, default 8)

The method uses the fundamental solution to x² - n·y² = 1, then refines using Chebyshev-based terms.

IMPORTANT: The Chebyshev series yields exact rational results ONLY when evaluated at x-1 where (x,y) is the Pell solution. This is a characterization property - the Pell solution is the unique point where the rationalization is perfectly rational.";

PellSolution::usage = "PellSolution[d] finds the fundamental solution {x, y} to the Pell equation x² - d·y² = 1.

Returns: {x -> value, y -> value}

Uses Wildberger's efficient algorithm from:
https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf";

ChebyshevTerm::usage = "ChebyshevTerm[x, k] computes the k-th term in the Chebyshev-based rational approximation series.

Formula:
  1 / (ChebyshevT[⌈k/2⌉, x+1] · (ChebyshevU[⌊k/2⌋, x+1] - ChebyshevU[⌊k/2⌋-1, x+1]))

where T is Chebyshev polynomial of the first kind, U is second kind.

NOTE: ChebyshevTerm is conjectured to be algebraically equivalent to FactorialTerm (see docs/egypt-chebyshev-equivalence.md).";

HyperbolicTerm::usage = "HyperbolicTerm[x, k] computes the k-th term using hyperbolic functions.

Formula:
  1 / (1/2 + Cosh[(1+2k)·ArcSinh[√(x/2)]] / (√2·√(2+x)))

Triple Identity (Discovered 2025-11-22):
  HyperbolicTerm[x, k] = FactorialTerm[x, k] = ChebyshevTerm[x, k]  (numerically verified)

This provides a closed-form expression without summation or Chebyshev polynomial evaluation.
See: docs/sessions/2025-11-22-palindromic-symmetries/triple-identity-factorial-chebyshev-hyperbolic.md";

AlgebraicCirclePoint::usage = "AlgebraicCirclePoint[k, a] returns {x, y} point on unit circle using algebraic parameter a.

Parameters:
  k - integer index (step around circle)
  a - algebraic parameter defining the angular step

Formula:
  x = Re[(a - I)^(4k) / (1 + a^2)^(2k)]
  y = Im[(a - I)^(4k) / (1 + a^2)^(2k)]

For regular n-gon, use a = RegularPolygonParameter[n].

Properties:
  - x^2 + y^2 == 1 (always on unit circle)
  - Period T = π/(2 ArcCot[a])
  - Returns exact algebraic coordinates

Examples:
  (* Regular 12-gon *)
  a = RegularPolygonParameter[12];
  AlgebraicCirclePoint[0, a]  (* → {1, 0} *)
  AlgebraicCirclePoint[1, a]  (* → {√3/2, 1/2} *)

  (* General algebraic parameter *)
  AlgebraicCirclePoint[k, 2 + Sqrt[2]]
";

RegularPolygonParameter::usage = "RegularPolygonParameter[n] returns the algebraic parameter a for a regular n-gon inscribed in the unit circle.

Parameter: n - number of vertices (n ≥ 3)

Returns: a = Cot[π/(2n)]

This parameter can be used with AlgebraicCirclePoint to generate exact algebraic coordinates of regular polygon vertices.

The period is T = 2n, meaning AlgebraicCirclePoint[k, a] cycles through n distinct points as k goes from 0 to n-1.

Examples:
  RegularPolygonParameter[3]   (* → Cot[π/6] = √3 *)
  RegularPolygonParameter[4]   (* → Cot[π/8] = 1 + √2 *)
  RegularPolygonParameter[12]  (* → Cot[π/24] = 2 + √2 + √3 + √6 *)

  (* Generate regular hexagon vertices *)
  a = RegularPolygonParameter[6];
  Table[AlgebraicCirclePoint[k, a], {k, 0, 5}]
";

FactorialTerm::usage = "FactorialTerm[x, j] computes the j-th term using the factorial-based formula from the Egypt repository.

Formula:
  1 / (1 + Sum[2^(i-1) x^i (j+i)! / ((j-i)! (2i)!), {i,1,j}])

CONJECTURE: FactorialTerm[x,j] = ChebyshevTerm[x,j] for all x,j (numerically verified, not proven).

This formula comes from the Egypt repository's closed-form representation of sqrt via Egyptian fractions.
For details see: https://github.com/popojan/egypt and docs/egypt-chebyshev-equivalence.md";

NestedChebyshevSqrt::usage = "NestedChebyshevSqrt[nn, start, {m1, m2}] computes ultra-high precision rational sqrt approximation bounds using nested Chebyshev iterations.

Parameters:
  nn    - the number whose square root to approximate
  start - starting approximation to Sqrt[nn] (use Pell solution for fastest convergence)
  {m1, m2} - iteration parameters (must be integers):
    m1 = Chebyshev order per iteration (1, 2, or 3 recommended)
    m2 = number of nesting iterations

Returns: Interval[{lower, upper}] bracketing Sqrt[nn] using reciprocal bounds

Precision scaling:
  - Each iteration roughly squares or cubes the precision (depending on m1)
  - m1=1: ~6x precision per iteration (optimized: 20x faster than general formula)
  - m1=2: ~8x precision per iteration (optimized: 20x faster than general formula)
  - m1=3: ~10x precision per iteration (uses general ChebyshevU formula)

Performance:
  - m1=1 and m1=2 use pre-simplified formulas (no ChebyshevU evaluation)
  - Crossover vs Babylonian method: ~4000 digits
  - Speedup grows with precision: 1.7x at 4k digits → 2.7x at 871k digits

Starting point selection:
  - Pell solution: sol = PellSolution[nn]; start = (x-1)/y /. sol  (recommended)
  - Crude approximation: start = Floor[Sqrt[N[nn]]]
  - Custom: any rational approximation

Examples:
  sol = PellSolution[13]; NestedChebyshevSqrt[13, (x-1)/y /. sol, {3, 3}] → ~3000 digits
  NestedChebyshevSqrt[13, 1, {1, 7}] → ~871k digits (using trivial start)

This is the most powerful method for extreme precision, far exceeding continued fractions in speed at high precision.";

BinetSqrt::usage = "BinetSqrt[nn, n, k] computes rational sqrt approximation bounds using Binet-style formula.

Parameters:
  nn - the number whose square root to approximate
  n  - starting approximation to Sqrt[nn]
  k  - number of iterations

Returns: Interval[{lower, upper}] bracketing Sqrt[nn]

Formula: Sqrt[nn] * {(p^k - q^k)/(p^k + q^k), (p^k + q^k)/(p^k - q^k)}
where p = n + Sqrt[nn], q = n - Sqrt[nn]

The bounds converge exponentially fast to Sqrt[nn] from both sides.
Use Normal[result] to extract {lower, upper} list for numeric operations.";

BabylonianSqrt::usage = "BabylonianSqrt[nn, n, k] computes rational sqrt approximation bounds using iterated Babylonian (Newton) method.

Parameters:
  nn - the number whose square root to approximate
  n  - starting approximation to Sqrt[nn]
  k  - number of iterations

Returns: Interval[{lower, upper}] bracketing Sqrt[nn]

Starting bounds: {2*n*nn/(n^2 + nn), (n^2 + nn)/(2*n)}
Iteration: {nn/Mean[bounds], Mean[bounds]}

The bounds converge quadratically to Sqrt[nn] from both sides.
Use Normal[result] to extract {lower, upper} list for numeric operations.";

EgyptSqrt::usage = "EgyptSqrt[n, {x, y}, k] computes rational sqrt approximation bounds using Egypt method with Pell solution.

Parameters:
  n     - the number whose square root to approximate
  {x,y} - Pell solution to x^2 - n*y^2 = 1 (use PellSolution[n])
  k     - number of terms in factorial series

Returns: Interval[{lower, upper}] bracketing Sqrt[n]

Uses factorial-based series expansion: ((x-1)/y) * (1 + Sum[FactorialTerm[x-1, j], {j,1,k}])
Then constructs bounds as {r, n/r} where r is the approximation.
Use Normal[result] to extract {lower, upper} list for numeric operations.";

BinetError::usage = "BinetError[n, k, x] computes the error in Binet approximation using direct formula.

Parameters:
  n - the number whose square root is being approximated
  k - number of iterations
  x - parameter for Binet formula

Returns: Error term (n - BinetSqrt[n, ...]^2)

Useful for analyzing convergence rates and error bounds.";

BinetErrorChebyshev::usage = "BinetErrorChebyshev[n, k, x] computes the error in Binet approximation using simplified Chebyshev formula.

Parameters:
  n - the number whose square root is being approximated
  k - number of iterations
  x - parameter for Binet formula

Returns: (-1)^k * (4*n)/(x^2 - 1) * ChebyshevT[k,x] / ChebyshevU[k-1,x]^2

This is the closed-form simplification of BinetError, revealing the Chebyshev structure.";

MakeBounds::usage = "MakeBounds[n, r] converts a single rational sqrt approximation to lower/upper bounds.

Parameters:
  n - the number whose square root r approximates
  r - rational approximation to Sqrt[n]

Returns: Interval[{lower, upper}] where lower < Sqrt[n] < upper

Formula: Interval[{Min[r, n/r], Max[r, n/r]}]

This works because if r < Sqrt[n] then n/r > Sqrt[n], and vice versa.
Use Normal[result] to extract {lower, upper} list for numeric operations.";

EquivalentIterations::usage = "EquivalentIterations[methodFrom, methodTo, k] computes the number of iterations needed for methodTo to achieve the same precision as methodFrom with k iterations.

Based on empirically-derived closed-form relationships (verified 2025-11-21):
  Babylonian (quadratic convergence) ↔ Linear methods (Binet, Egypt, SqrtRat)

Relationships:
  k_binet   = 2^(k_babylon + 1)
  k_egypt   = 2^(k_babylon + 1) - 1
  k_sqrtrat = 2^(k_babylon + 2) - 1

Examples:
  EquivalentIterations[\"Babylonian\", \"Egypt\", 3]   → 15
  EquivalentIterations[\"Egypt\", \"Babylonian\", 15]  → 3

Supported methods: \"Babylonian\", \"Binet\", \"Egypt\", \"SqrtRat\"

PRECISION GUARANTEE:
  This function guarantees EQUIVALENT PRECISION (within tolerance 0.5 log10 digits),
  NOT identical rational approximations.

  Different methods produce different convergent sequences - they approach Sqrt[n]
  from different paths with different rational values at each iteration.

  Tolerance 0.5 means the log10 quadratic error differs by at most 0.5, which
  corresponds to up to 10^0.5 ≈ 2× difference in absolute error.

  Use case: Benchmarking convergence rates and comparing algorithmic efficiency.
  NOT for obtaining specific rational approximations.

Note: Relationships are exponential due to quadratic vs linear convergence.
For high precision requirements, Babylonian is exponentially more efficient.

Future work: NestedChebyshev equivalence relationships require more data points.";

BabylonianToNestedChebyshev::usage = "BabylonianToNestedChebyshev[k_babylon] computes the optimal {m1, m2} parameters for NestedChebyshevSqrt to achieve equivalent precision as BabylonianSqrt with k iterations.

BabylonianToNestedChebyshev[k_babylon, m1] allows specifying the Chebyshev order.

Closed-form relationship (verified 2025-11-21):
  k_babylon = 4^(m2 - 1)  with m2 = Ceiling[Log[4, k] + 1]

Precision guarantee:
  - m1=2: EXACT match (deviation < 1e-50)
  - m1=1: APPROXIMATE match (deviation ~1.5 log10 units)
  - m1=3: APPROXIMATE match (deviation ~1.5-27 log10 units)

Default m1=2 (optimal):
  - Uses pre-simplified Chebyshev formula (20× faster than general case)
  - ~8× precision gain per iteration (vs ~6× for m1=1, ~10× for m1=3)
  - Balance between speed and convergence rate

Examples:
  BabylonianToNestedChebyshev[1]      → {2, 1}  (k = 4^0 = 1)
  BabylonianToNestedChebyshev[4]      → {2, 2}  (k = 4^1 = 4)
  BabylonianToNestedChebyshev[16]     → {2, 3}  (k = 4^2 = 16)
  BabylonianToNestedChebyshev[4, 1]   → {1, 2}  (approximate)

Inverse relationship:
  Use NestedChebyshevToBabylonian[{m1, m2}] to convert back

Note: This relationship is exponential - NestedChebyshev needs logarithmically
      fewer iterations than Babylonian due to higher-order convergence.
";

BabylonianToNestedChebyshev::iter = "Iteration count `1` must be positive integer";

NestedChebyshevToBabylonian::usage = "NestedChebyshevToBabylonian[{m1, m2}] computes the number of Babylonian iterations equivalent to NestedChebyshevSqrt[n, {m1, m2}].

For ALL m1 values:
  k_babylon = 4^(m2 - 1)

Precision note:
  - m1=2: EXACT equivalence
  - m1≠2: APPROXIMATE equivalence (same formula, larger deviation)

Examples:
  NestedChebyshevToBabylonian[{2, 1}] → 1
  NestedChebyshevToBabylonian[{2, 2}] → 4
  NestedChebyshevToBabylonian[{1, 2}] → 4 (approximate)
  NestedChebyshevToBabylonian[{3, 3}] → 16 (approximate)

Note: Formula is same for all m1, but precision match quality varies.
";

NestedChebyshevToBabylonian::approx = "Equivalence for m1=`1` is approximate. Exact match only for m1=2.";

TangentMultiplication::usage = "TangentMultiplication[k, a] computes tan(k·arctan(a)) using algebraic operations only.

Parameters:
  k - integer multiplier
  a - tangent value (algebraic number)

Returns: tan(k·arctan(a)) as an algebraic expression

Formula:
  Uses complex power construction with (±I ± a)^k terms to extract tangent ratio.
  Result is purely algebraic - no transcendental functions.

Polynomial Structure:
  For rational a, result tan(kθ) = P_k(a)/Q_k(a) where:
  - P_k and Q_k are polynomials in a
  - Coefficients exhibit palindromic symmetry
  - P_k(a)/a and Q_k(a) have reversed coefficient patterns

Connection to AlgebraicCirclePoint:
  If z = AlgebraicCirclePoint[k, a], then TangentMultiplication[k, a] = Im[z]/Re[z]
  Both use same (a-I)^(4k) construction with exponent 4k.

Examples:
  TangentMultiplication[1, 1/2]  (* → 1/2 *)
  TangentMultiplication[2, 1/2]  (* → 4/3 *)
  TangentMultiplication[3, 1/2]  (* → 11/2 *)

  (* Verify identity *)
  TangentMultiplication[2, a] == (2a)/(1-a^2) // Simplify  (* → True *)

Note: This is equivalent to Chebyshev polynomial parametrization of tan(nθ).
See docs/reference/algebraic-circle-parametrizations.md for theory.";

GammaPalindromicSqrt::usage = "GammaPalindromicSqrt[nn, n, k] computes rational sqrt approximation using Gamma function weights with palindromic structure.

Parameters:
  nn - the number whose square root to approximate
  n  - starting approximation to Sqrt[nn]
  k  - order parameter (higher k → more terms, better precision)

Returns: rational approximation to Sqrt[nn]

Method:
  Uses weighted sum with weights w[i] = n^(2-2i+2⌈k/2⌉) · nn^i / (Γ[-1+2i] · Γ[4-2i+k])

Palindromic Structure:
  Gamma arguments sum to constant: (-1+2i) + (4-2i+k) = 3+k
  As i increases: first Gamma arg increases, second decreases
  This creates mirror symmetry in weight distribution

  Example (k=5):
    i=1: Γ(1)·Γ(7)
    i=2: Γ(3)·Γ(5)
    i=3: Γ(5)·Γ(3)  ← palindrome
    i=4: Γ(7)·Γ(1)

Connection to Other Methods:
  Related to Beta function symmetry B(a,b) = B(b,a)
  Gamma product Γ(a)Γ(b) with constant sum exhibits palindromic coefficients
  Similar palindromic structure appears in Chebyshev tan multiplication polynomials

Examples:
  sol = PellSolution[13];
  GammaPalindromicSqrt[13, (x-1)/y /. sol, 3]

Status: Experimental method, convergence properties under investigation.";

Begin["`Private`"];

(* ===================================================================
   EQUIVALENT FORMULATIONS - Egypt vs Chebyshev

   CONJECTURE: FactorialTerm[x,j] == ChebyshevTerm[x,j] for all x,j

   Status: Numerically verified (Egypt repo), algebraically unproven
   See: docs/egypt-chebyshev-equivalence.md for details
   =================================================================== *)

(* Factorial-based term from Egypt repository *)
FactorialTerm[x_, j_] :=
    1 / (1 + Sum[2^(i-1) * x^i * Factorial[j+i] /
                 (Factorial[j-i] * Factorial[2*i]), {i, 1, j}])

(* Chebyshev-based term for rational approximation *)
ChebyshevTerm[x_, k_] :=
    1 / (     ChebyshevT[Ceiling[k/2],     x + 1]
          (   ChebyshevU[  Floor[k/2],     x + 1]
            - ChebyshevU[  Floor[k/2] - 1, x + 1]))

(* Hyperbolic-based term - closed form discovered 2025-11-22 *)
HyperbolicTerm[x_, k_] :=
    1 / (1/2 + Cosh[(1 + 2*k)*ArcSinh[Sqrt[x]/Sqrt[2]]] /
                (Sqrt[2]*Sqrt[2 + x]))

(* ===================================================================
   ALGEBRAIC CIRCLE CONSTRUCTIONS - Regular polygons via Cot[π/n]
   =================================================================== *)

(* Regular polygon parameter: a = Cot[π/(2n)] *)
RegularPolygonParameter[n_Integer /; n >= 3] := Cot[Pi/(2*n)]

(* Algebraic circle point construction via complex powers *)
AlgebraicCirclePoint[k_Integer, a_] := Module[{z},
  (* z = (a - I)^(4k) / (1 + a^2)^(2k) *)
  z = (a - I)^(4*k) / (1 + a^2)^(2*k);
  {Re[z], Im[z]} // Simplify
]

(* Sum of Chebyshev terms *)
sqrtTerms[x_, n_] :=
    1 + Sum[ChebyshevTerm[x, j], {j, 1, n}]

(* Held form for symbolic display *)
sqrtTermsHeld[x_, n_] :=
    1 + Sum[HoldForm[#]& @ ChebyshevTerm[x, j], {j, 1, n}]

(* List form *)
sqrtTermsList[x_, n_] :=
    Join[{1}, Table[ChebyshevTerm[x, j], {j, 1, n}]]

(* Pell equation solver - Wildberger's algorithm
   https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf *)
PellSolution[d_] := Module[
  { a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
  While[t = a + b + b + c; If[t > 0,
    a = t; b += c; u += v; r += s,
    b += a; c = t; v += u; s += r];
    Not[a == 1 && b == 0 && c == -d]
  ]; {Global`x -> u, Global`y -> r} ]

(* Main rationalization function *)
SqrtRationalization[n_, OptionsPattern[]] :=
    Module[{sol, acc = OptionValue[Accuracy]},
        sol = PellSolution[n];
        Switch[OptionValue[Method],
            "List",
                {(x - 1) / y, sqrtTermsList[x - 1, acc]} /. sol
            ,
            "Rational",
                (x - 1) / y sqrtTerms[x - 1, acc] /. sol
            ,
            "Expression",
                (x - 1) / y sqrtTermsHeld[x - 1, acc] /. sol
        ]
    ]

Options[SqrtRationalization] = {Method -> "List", Accuracy -> 8}

(* ===================================================================
   NESTED CHEBYSHEV METHODS - Ultra-high precision
   =================================================================== *)

(* OPTIMIZED SPECIALIZATIONS: Pre-simplified formulas for m=1 and m=2
   These eliminate expensive ChebyshevU evaluations and Simplify calls,
   providing ~20x speedup per iteration.

   Derivation: For m=1, ChebyshevU[0,x]=1 and ChebyshevU[2,x]=4x²-1
   simplify externally to eliminate symbolic computation from hot loop.

   Performance: Optimized m=1 achieves 2.7x speedup over Babylonian method
   at 871k digit precision, with 6x convergence rate per iteration.
*)

(* m=1 optimized: features factor of 3 in numerator and denominator *)
sqrttrfOpt1[nn_, n_] := (nn*(3*n^2 + nn))/(n*(n^2 + 3*nn))

(* m=2 optimized: features factor of 6 in numerator *)
sqrttrfOpt2[nn_, n_] := (n^4 + 6*n^2*nn + nn^2)/(4*n*(n^2 + nn))

(* Core Chebyshev-U based single refinement step - with smart dispatch *)
sqrttrf[nn_, n_, 1] := sqrttrfOpt1[nn, n]
sqrttrf[nn_, n_, 2] := sqrttrfOpt2[nn, n]
sqrttrf[nn_, n_, m_] :=
  (n^2 + nn)/(2 n) + (n^2 - nn)/(2 n) *
    ChebyshevU[m - 1, Sqrt[nn/(-n^2 + nn)]] /
    ChebyshevU[m + 1, Sqrt[nn/(-n^2 + nn)]] // Simplify

(* Symmetrization step - applies sqrttrf then averages *)
sym[nn_, n_, m_] := Module[{x = sqrttrf[nn, n, m]}, nn/(2 x) + x/2]

(* Nested iteration - the power method *)
nestqrt[nn_, n_, {m1_, m2_}] := Nest[sym[nn, #, m1] &, n, m2]

(* User-facing function - returns Interval bounds *)
NestedChebyshevSqrt[nn_, start_, {m1_Integer, m2_Integer}] :=
  Module[{approx, lower, upper},
    approx = nestqrt[nn, start, {m1, m2}];
    (* Return reciprocal bounds like EgyptSqrt *)
    (* Use TrueQ to handle symbolic expressions gracefully *)
    If[TrueQ[approx^2 < nn],
      Interval[{approx, nn/approx}],      (* approx < Sqrt[nn] < nn/approx *)
      Interval[{nn/approx, approx}]       (* nn/approx < Sqrt[nn] < approx *)
    ]
  ]

(* ===================================================================
   BINET-STYLE METHODS - Bounds via exponential convergence
   =================================================================== *)

(* Binet formula - returns sorted Interval *)
BinetSqrt[nn_, n_, k_] := Module[{val1, val2, p, q},
  p = (n + Sqrt[nn])^k;
  q = (n - Sqrt[nn])^k;
  val1 = Sqrt[nn] * (p - q)/(p + q) // FullSimplify;
  val2 = Sqrt[nn] * (p + q)/(p - q) // FullSimplify;
  Interval[{Min[val1, val2], Max[val1, val2]}]
]

(* ===================================================================
   BABYLONIAN (NEWTON) METHOD - Bounds via quadratic convergence
   =================================================================== *)

(* Helper: single iteration step for bounds pair *)
babylonianStep[nn_, n_, x_] := Module[{avg, val1, val2},
  avg = Mean[x];
  val1 = nn/avg;
  val2 = avg;
  {Min[val1, val2], Max[val1, val2]}
]

(* Babylonian method - returns sorted Interval *)
BabylonianSqrt[nn_, n_, k_] := Module[{bounds},
  bounds = Nest[babylonianStep[nn, n, #] &,
                {(2*n*nn)/(n^2 + nn), (n^2 + nn)/(2*n)},
                k];
  Interval[bounds]
]

(* ===================================================================
   EGYPT METHOD - Bounds via factorial series
   =================================================================== *)

(* Helper: factorial-based sum of terms (explicit version) *)
sqrtTermsFactorial[x_, n_] := 1 + Sum[FactorialTerm[x, j], {j, 1, n}]

(* Egypt method - returns sorted Interval using smart comparison *)
EgyptSqrt[n_, {x_, y_}, k_] := Module[{r},
  r = (x - 1)/y * sqrtTermsFactorial[x - 1, k];
  (* Smart sort: if r^2 < n then r < sqrt(n) < n/r, else n/r < sqrt(n) < r *)
  If[r^2 < n,
    Interval[{r, n/r}],
    Interval[{n/r, r}]
  ]
]

(* ===================================================================
   ERROR ANALYSIS - Binet convergence tracking
   =================================================================== *)

(* Error formula - computational version *)
BinetError[n_, k_, x_] :=
  Subtract @@ (n - BinetSqrt[n, Sqrt[n]*(x - 1)/Sqrt[x^2 - 1], k]^2)

(* Error formula - Chebyshev closed form *)
BinetErrorChebyshev[n_, k_, x_] :=
  (-1)^k * (4*n)/(x^2 - 1) * ChebyshevT[k, x]/ChebyshevU[k - 1, x]^2

(* ===================================================================
   HELPER UTILITIES
   =================================================================== *)

(* Convert single approximation to sorted Interval using smart comparison *)
MakeBounds[n_, r_] := If[r^2 < n,
  Interval[{r, n/r}],
  Interval[{n/r, r}]
]

(* ===================================================================
   METHOD EQUIVALENCE UTILITIES
   =================================================================== *)

(* Empirically-derived conversion formulas (verified 2025-11-21 via high-precision analysis) *)
equivalentIterations["Babylonian", "Binet", k_Integer] := 2^(k + 1)
equivalentIterations["Babylonian", "Egypt", k_Integer] := 2^(k + 1) - 1
equivalentIterations["Babylonian", "SqrtRat", k_Integer] := 2^(k + 2) - 1
equivalentIterations["Babylonian", "Babylonian", k_Integer] := k

(* Inverse transformations (approximate - use Log2) *)
equivalentIterations["Binet", "Babylonian", k_Integer] := Floor[Log2[k]] - 1
equivalentIterations["Egypt", "Babylonian", k_Integer] := Floor[Log2[k + 1]] - 1
equivalentIterations["SqrtRat", "Babylonian", k_Integer] := Floor[Log2[k + 1]] - 2

(* Cross-conversions (compose via Babylonian) *)
equivalentIterations[from_String, to_String, k_Integer] :=
  equivalentIterations[to, "Babylonian",
    equivalentIterations[from, "Babylonian", k]]

(* Public API wrapper with error checking *)
EquivalentIterations[from_String, to_String, k_Integer] :=
  Module[{validMethods, result},
    validMethods = {"Babylonian", "Binet", "Egypt", "SqrtRat"};

    If[!MemberQ[validMethods, from],
      Message[EquivalentIterations::method, from, validMethods];
      Return[$Failed]
    ];

    If[!MemberQ[validMethods, to],
      Message[EquivalentIterations::method, to, validMethods];
      Return[$Failed]
    ];

    If[k < 1,
      Message[EquivalentIterations::iter, k];
      Return[$Failed]
    ];

    result = equivalentIterations[from, to, k];

    (* Ensure result is at least 1 *)
    Max[1, result]
  ]

EquivalentIterations::method = "Method `1` not recognized. Valid methods: `2`";
EquivalentIterations::iter = "Iteration count `1` must be positive integer";

(* ========================================================================
   NestedChebyshev ↔ Babylonian Equivalence
   ======================================================================== *)

BabylonianToNestedChebyshev[k_Integer /; k >= 1, m1_Integer: 2] :=
  Module[{m2},
    (* Solve: k = 4^(m2-1) → m2 = Log[4, k] + 1 *)
    m2 = Ceiling[Log[4, k] + 1];
    {m1, m2}
  ]

NestedChebyshevToBabylonian[{m1_Integer, m2_Integer}] :=
  Module[{k},
    k = 4^(m2 - 1);
    If[m1 =!= 2,
      Message[NestedChebyshevToBabylonian::approx, m1]
    ];
    k
  ]

(* ===================================================================
   TANGENT MULTIPLICATION - Algebraic tan(k·arctan(a))
   =================================================================== *)

(* Algebraic tangent multiplication using complex powers *)
TangentMultiplication[k_Integer, a_] := Module[{num, den, kexp},
  (* Use 4k exponent to match AlgebraicCirclePoint construction *)
  kexp = 4*k;
  (* Numerator: I(-I-a)^kexp - (I-a)^kexp - I(-I+a)^kexp + (I+a)^kexp *)
  num = I*(-I - a)^kexp - (I - a)^kexp - I*(-I + a)^kexp + (I + a)^kexp;
  (* Denominator: (-I-a)^kexp - I(I-a)^kexp + (-I+a)^kexp - I(I+a)^kexp *)
  den = (-I - a)^kexp - I*(I - a)^kexp + (-I + a)^kexp - I*(I + a)^kexp;
  Simplify[num/den]
]

(* ===================================================================
   GAMMA PALINDROMIC SQRT - Weighted approximation with mirror symmetry
   =================================================================== *)

(* Helper: reconstruct term with Gamma palindromic weights *)
gammaPalindromicReconstruct[nn_, n_, k_] := Module[{lim, weights, nums},
  lim = 1 + 1/2 (1 - (-1)^k) + Floor[k/2];

  (* Palindromic weights: Gamma args sum to constant 3+k *)
  weights = Table[
    (n^(2 - 2*i + 2*Ceiling[k/2]) * nn^i) / (Gamma[-1 + 2*i] * Gamma[4 - 2*i + k]),
    {i, 1, lim}
  ];

  (* Numerator coefficients *)
  nums = Table[
    (-24 + 16*i^2*(1 + k) + 4*i*(1 + k)*(2 + k) - k*(24 + k*(7 + k))) / (-1 + 4*i^2),
    {i, 1, lim}
  ];

  (* Weighted sum *)
  nn * Sum[weights[[i]] * nums[[i]], {i, 1, lim}] / Sum[weights[[i]], {i, 1, lim}]
]

(* Main Gamma palindromic sqrt function - complete Egypt formulation *)
GammaPalindromicSqrt[nn_, n_, k_Integer] := Module[{recon},
  recon = gammaPalindromicReconstruct[nn, n, k];

  (* Full sqrt formula *)
  (nn/n) * ((1 + k)*n^2 - (3 + 5*k)*nn + recon) / (n^2 - 3*nn)
]

End[];

EndPackage[];
