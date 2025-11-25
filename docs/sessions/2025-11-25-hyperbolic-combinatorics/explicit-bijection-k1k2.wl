(* Explicit bijection for k=1, k=2 *)

Print["=== EXPLICIT BIJECTION: k=1, k=2 ===\n"];

(* Lobb number *)
lobbT[n_, k_] := (2*k + 1) * Binomial[2*n, n - k] / (n + k + 1)

(* Our coefficient *)
ourCoeff[kVal_, i_] := 2^(i-1) * Pochhammer[kVal-i+1, 2*i] / Factorial[2*i]

(* === k=1 CASE === *)
Print["=== CASE k=1 ===\n"];

k = 1;
coeffs1 = Table[ourCoeff[k, i], {i, 1, k}];
Print["Our coefficients: ", coeffs1];
Print["  = {1}\n"];

Print["Combinatorial interpretation:"];
Print["  2^(i-1) * Poch[k-i+1, 2i] / (2i)!"];
Print["  = 2^0 * Poch[1, 2] / 2!"];
Print["  = 1 * (1*2) / 2"];
Print["  = 1\n"];

Print["Pochhammer[1, 2] = 1*2 = product of 2 consecutive integers starting at 1"];
Print["(2i)! = 2! = 2 (central binomial normalization)"];
Print["Result: 1 object\n"];

Print["Lobb connection:"];
Print["  T(1,0) = Catalan_1 = 1 (1 Dyck path of semilength 1)"];
Print["  T(1,1) = 1 (1 path touching x-y=1)\n"];

Print["Bijection: Single trivial path"];
Print["  Path: (0,0) → (1,1) via UP then RIGHT"];
Print["  Weight: 2^0 * x^1 = x"];
Print["  Count: 1\n"];

(* === k=2 CASE === *)
Print["=== CASE k=2 ===\n"];

k = 2;
coeffs2 = Table[ourCoeff[k, i], {i, 1, k}];
Print["Our coefficients: ", coeffs2];
Print["  = {3, 2}\n"];

Print["i=1: coefficient = 3"];
Print["  2^0 * Poch[2, 2] / 2! = 1 * 6 / 2 = 3"];
Print["  Poch[2,2] = 2*3 = 6"];
Print["  Interpretation: 3 paths of length 1\n"];

Print["i=2: coefficient = 2"];
Print["  2^1 * Poch[1, 4] / 4! = 2 * 24 / 24 = 2"];
Print["  Poch[1,4] = 1*2*3*4 = 24"];
Print["  Interpretation: 2 paths of length 2\n"];

Print["Lobb triangle rows containing 3:"];
Do[
  row = Table[lobbT[n, kVal], {kVal, 0, n}];
  If[MemberQ[row, 3],
    Print["  n=", n, ": ", row]
  ],
  {n, 0, 6}
];

Print["\nLobb(2,1) = 3: Paths from (0,0) to (2,2) touching x-y=1"];
Print["  = Grand Dyck paths with 1 downward return\n"];

Print["Explicit enumeration for k=2:"];
Print["\nLevel i=1 (3 paths):"];
Print["  Path type 1: Short excursion"];
Print["  Path type 2: Medium excursion"];  
Print["  Path type 3: Long excursion"];
Print["  Each weighted by x^1\n"];

Print["Level i=2 (2 paths):"];
Print["  Path type 1: Double excursion A"];
Print["  Path type 2: Double excursion B"];
Print["  Each weighted by 2*x^2 (factor 2 from 2^(i-1))\n"];

Print["Total generating function:"];
Print["  3*x + 2*2*x^2 = 3x + 4x^2"];
Print["  Matches: 1 + 3x + 4x^2? (with constant term)\n"];

(* Test the GF *)
testSum = 1 + Sum[coeffs2[[i]] * 2^(i-1) * x^i, {i, 1, 2}];
Print["Our sum: ", testSum, "\n"];

(* === PATTERN ANALYSIS === *)
Print["=== PATTERN: First Coefficient ===\n"];

Print["First coefficient for each k:"];
Do[
  c1 = ourCoeff[kVal, 1];
  tri = kVal*(kVal+1)/2;
  Print["k=", kVal, ": c_1 = ", c1, " = ", tri, " (triangular)"],
  {kVal, 1, 6}
];

Print["\nTriangular numbers = k(k+1)/2 = 1, 3, 6, 10, 15, 21, ...");
Print["These are also: C(k+1, 2) = number of pairs from k+1 objects\n"];

Print["Combinatorial: Selecting 2 from k+1 objects"];
Print["Or: Lattice paths with 1 rise and k falls?\n"];

(* === GENERATING FUNCTION === *)
Print["=== GENERATING FUNCTION STRUCTURE ===\n"];

Print["For k=2: sum = 1 + 3x + 2(2x)^2 = 1 + 3x + 4x^2"];
Print["Factor out powers of 2:"];
Print["  = 1 + 3x + 2·2x·x = ...\n"];

Print["Hypothesis: Related to (1+2x)^n or (1-4x)^(-1/2)?"];
Print["  (1-4x)^(-1/2) = Σ C(2n,n) x^n (central binomials)"];
Print["  Our sequence not exactly matching\n"];

Print["Alternative: Riordan array structure (like Lobb)?"];
Print["  Lobb is Riordan(c(x), x*c(x)^2) where c(x) = Catalan GF\n"];

(* === NEXT STEPS === *)
Print["=== NEXT: EXPLICIT PATH ENUMERATION ===\n"];

Print["To verify bijection, enumerate:"];
Print["1. All Grand Dyck paths with specific returns (Lobb)"];
Print["2. All lattice paths (0,0) → (2i,i) (Binomial)"];
Print["3. Map to our coefficient structure via weights\n"];

Print["For k=2, i=1:"];
Print["  Need 3 distinct Dyck-like paths"];
Print["  Each contributes x^1 to GF"];
Print["  Verify via direct graph traversal\n"];

Print["Tools needed:"];
Print["- Dyck path generator (standard algorithm)");
Print["- Path weight assignment (Pochhammer)");
Print["- Bijection verification (count match)"];

