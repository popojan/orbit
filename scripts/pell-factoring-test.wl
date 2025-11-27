(* Pell Solution for Factoring - Systematic Test *)

<< Orbit`

Print["═══════════════════════════════════════════════════════════════"]
Print["  PELL SOLUTION FACTORING TEST"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["For Pell equation x² - ny² = 1:"]
Print["  x² ≡ 1 (mod n)"]
Print["  (x-1)(x+1) ≡ 0 (mod n)"]
Print["  gcd(x±1, n) may reveal factors"]
Print[""]

testCases = {
  {3, 5}, {3, 7}, {3, 11}, {3, 13}, {5, 7}, {5, 11}, {5, 13},
  {7, 11}, {7, 13}, {7, 17}, {11, 13}, {11, 17}, {13, 17},
  {17, 19}, {19, 23}, {23, 29}, {29, 31}
};

successCount = 0;
partialCount = 0;
failCount = 0;

Do[
  {p, q} = pq;
  n = p * q;

  (* Get Pell solution *)
  sol = PellSolution[n];
  {xPell, yPell} = {x, y} /. sol;

  (* Compute GCDs *)
  g1 = GCD[xPell - 1, n];
  g2 = GCD[xPell + 1, n];

  (* Classify result *)
  factors = Select[{g1, g2}, # > 1 && # < n &];
  foundBoth = (MemberQ[factors, p] && MemberQ[factors, q]) ||
              (MemberQ[factors, p] && n/MemberQ[factors, p] == q);

  Print["n = ", n, " = ", p, " × ", q];
  Print["  Pell: x = ", xPell, ", y = ", yPell];
  Print["  gcd(x-1, n) = ", g1, ", gcd(x+1, n) = ", g2];

  Which[
    Length[factors] == 2 || (Length[factors] == 1 && factors[[1]] != 1 && factors[[1]] != n),
      Print["  ✓ FACTORS FOUND: ", factors];
      successCount++,
    Length[factors] == 1,
      Print["  ~ PARTIAL: one factor ", factors];
      partialCount++,
    True,
      Print["  ✗ TRIVIAL (1 or n)"];
      failCount++
  ];
  Print[""],

  {pq, testCases}
]

Print["═══════════════════════════════════════════════════════════════"]
Print["  SUMMARY"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]
Print["Success (both factors): ", successCount, " / ", Length[testCases]]
Print["Partial (one factor):   ", partialCount, " / ", Length[testCases]]
Print["Trivial (no factors):   ", failCount, " / ", Length[testCases]]
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  WHY DOES THIS WORK?"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]
Print["Pell: x² - ny² = 1"]
Print["  ⇒ x² ≡ 1 (mod n)"]
Print["  ⇒ (x-1)(x+1) ≡ 0 (mod n = pq)"]
Print[""]
Print["By CRT, either:"]
Print["  - x ≡ 1 (mod p) AND x ≡ 1 (mod q)  → trivial"]
Print["  - x ≡ -1 (mod p) AND x ≡ -1 (mod q) → trivial"]
Print["  - x ≡ 1 (mod p) AND x ≡ -1 (mod q) → factors revealed!"]
Print["  - x ≡ -1 (mod p) AND x ≡ 1 (mod q) → factors revealed!"]
Print[""]
Print["When x ≡ 1 (mod p) and x ≡ -1 (mod q):"]
Print["  gcd(x-1, n) = p (since p | x-1 but q ∤ x-1)"]
Print["  gcd(x+1, n) = q (since q | x+1 but p ∤ x+1)"]
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  CONNECTION TO SHOR'S ALGORITHM"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]
Print["Shor finds r such that a^r ≡ 1 (mod n) for random a."]
Print["If r is even, then (a^{r/2})² ≡ 1 (mod n)."]
Print["Let x = a^{r/2}, then x² ≡ 1 and gcd(x±1, n) reveals factors."]
Print[""]
Print["Pell solution gives SAME structure: x² ≡ 1 (mod n)."]
Print["The difference: Pell is deterministic but requires solving Pell equation."]
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  COMPLEXITY"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]
Print["PellSolution complexity: O(√n) iterations (continued fraction)"]
Print["This is SAME as trial division!"]
Print[""]
Print["For large n, solving Pell is not easier than factoring."]
Print["Pell provides an ALTERNATIVE view, not a shortcut."]
