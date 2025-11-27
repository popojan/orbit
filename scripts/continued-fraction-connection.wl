(* Continued Fraction Connection to Semiprime Formula *)
(* Is there a link between our S_∞ and CF expansion of sqrt(n)? *)

Print["=== Continued Fraction Factoring ==="]
Print[""]

(* Classical method: CF expansion of sqrt(n) *)
(* If n = pq, the period of CF(sqrt(n)) relates to class number *)
(* Convergents p_k/q_k may satisfy p_k² - n*q_k² = ±1 (Pell) *)

n = 143;
{p, q} = {11, 13};

Print["n = ", n, " = ", p, " × ", q]
Print[""]

(* CF expansion of sqrt(n) *)
cf = ContinuedFraction[Sqrt[n], 30];
Print["CF(√143) = ", cf]
Print[""]

(* Period of CF *)
(* For sqrt(n), CF has the form [a0; {a1, a2, ..., period}] *)

Print["First 20 convergents:"]
convs = Table[FromContinuedFraction[Take[cf, k]], {k, 1, 20}];
Do[
  {pk, qk} = {Numerator[convs[[k]]], Denominator[convs[[k]]]};
  val = pk^2 - n * qk^2;
  Print["  k=", k, ": ", pk, "/", qk, ", p² - nq² = ", val],
  {k, 1, 15}
]
Print[""]

(* Look for cases where p² - nq² factors nicely *)
Print["=== Fermat-like Detection ==="]
Print[""]

(* If p² - nq² = m where m is small, then *)
(* p² ≡ nq² (mod m) and we might find factor via gcd *)

Do[
  {pk, qk} = {Numerator[convs[[k]]], Denominator[convs[[k]]]};
  m = pk^2 - n * qk^2;
  If[Abs[m] < 100 && m != 0,
    gcdP = GCD[pk - 1, n];
    gcdQ = GCD[qk, n];
    Print["  k=", k, ": p² - nq² = ", m,
          ", gcd(p-1,n) = ", gcdP, ", gcd(q,n) = ", gcdQ]
  ],
  {k, 1, 15}
]
Print[""]

(* The classical CF method finds x² ≡ y² (mod n) to factor *)
(* Our formula is different: it uses Wilson's theorem *)

Print["=== Connection to Our Formula? ==="]
Print[""]

(* Our S_∞ = (p-1)/p + (q-1)/q *)
(* CF convergents: p_k/q_k → sqrt(n) *)

(* Is there a relation between S_∞ and CF period? *)

(* Period length of CF(sqrt(n)) *)
cfFull = ContinuedFraction[Sqrt[n]];
period = If[Length[cfFull] > 1, Length[cfFull[[2]]], 0];
Print["CF period length for √143: ", period]
Print[""]

(* Test several semiprimes *)
Print["CF period vs factors for various semiprimes:"]
testCases = {{3,5}, {3,7}, {5,7}, {3,11}, {5,11}, {7,11}, {3,13}, {5,13}, {7,13}, {11,13}};

Do[
  nn = pp * qq;
  cfnn = ContinuedFraction[Sqrt[nn]];
  per = If[Length[cfnn] > 1, Length[cfnn[[2]]], 0];
  sInf = (pp - 1)/pp + (qq - 1)/qq;
  Print["  n = ", nn, " = ", pp, "×", qq,
        ": period = ", per, ", S_∞ = ", N[sInf, 4]],
  {pp, qq} = pq,
  {pq, testCases}
]
Print[""]

(* No obvious pattern between period and S_∞ *)

Print["=== Quadratic Forms Connection ==="]
Print[""]

(* CF expansion relates to binary quadratic forms ax² + bxy + cy² *)
(* Discriminant D = b² - 4ac *)
(* For n = pq, D = 4n has class number h(D) *)

Print["For n = pq (odd primes):"]
Print["  Form: x² - ny² (discriminant 4n)"]
Print["  CF period relates to fundamental solution of Pell equation"]
Print[""]

(* The fundamental unit ε = (x + y√n)/2 where x² - ny² = ±4 *)
(* Class number h(4n) = 2 for n = pq (both ≡ 3 mod 4)? *)

Print["=== Key Difference ==="]
Print[""]
Print["CF factoring: Uses x² ≡ y² (mod n) to find gcd(x-y, n)"]
Print["Our formula: Uses Wilson's theorem to detect prime divisors"]
Print[""]
Print["Both exploit NUMBER-THEORETIC STRUCTURE of n"]
Print["But the structures are DIFFERENT:"]
Print["  - CF: quadratic residue structure (multiplicative group order)"]
Print["  - Ours: factorial/Wilson structure (additive detection)"]
Print[""]

(* Is there a deeper connection via class groups? *)
Print["=== Class Group Speculation ==="]
Print[""]

(* For n = pq: *)
(* - Class group of Q(√n) has order h = 1 or 2 typically *)
(* - S_∞ = 2 - (p+q)/n involves p + q *)
(* - p + q = Tr(ideal (p)) in some sense *)

Print["Class number h(4n) for semiprimes:"]
Do[
  nn = pp * qq;
  (* Class number of quadratic field Q(√n) *)
  h = Length[NumberFieldClassGroup[nn]];
  Print["  n = ", nn, " = ", pp, "×", qq, ": h = ", h],
  {pp, qq} = pq,
  {pq, Take[testCases, 5]}
]
Print[""]

Print["=== Product Formula for S_∞ ==="]
Print[""]

(* S_∞ = Σ (p-1)/p over prime p | n *)
(* This is related to: *)
(* ∏ (1 - 1/p) = φ(n)/n *)

Print["φ(n)/n = ∏ (1 - 1/p) = ", (p-1)/p * (q-1)/q, " for n = ", n]
Print["S_∞ = Σ (1 - 1/p) = ", (p-1)/p + (q-1)/q]
Print[""]

(* Euler product: *)
(* ζ(s)^{-1} = ∏ (1 - p^{-s}) *)
(* log ζ(s) = -Σ log(1 - p^{-s}) ≈ Σ p^{-s} for large s *)

Print["At s = 1:"]
Print["  φ(n)/n = ∏_{p|n} (1 - 1/p)"]
Print["  S_∞ = Σ_{p|n} (1 - 1/p)"]
Print[""]

Print["Relation: log(n/φ(n)) = -Σ log(1 - 1/p)"]
Print["        = Σ (1/p + 1/2p² + 1/3p³ + ...)")
Print["        ≈ Σ 1/p = (p+q)/n  (dominant term)"]
Print[""]

Print["So: S_∞ ≈ 2 - log(n/φ(n)) + O(1/p²)"]
Print[""]

(* Verify *)
exact = (p-1)/p + (q-1)/q;
approx = 2 - Log[n/EulerPhi[n]];
Print["For n = 143:"]
Print["  Exact S_∞ = ", N[exact, 10]]
Print["  Approx (2 - log(n/φ)) = ", N[approx, 10]]
Print["  Error = ", N[exact - approx, 10]]
Print[""]

Print["=== Conclusion ==="]
Print[""]
Print["No direct connection found between CF expansion and S_∞."]
Print["Both exploit n's structure but via different mechanisms:"]
Print["  - CF: quadratic residues, Pell equation, group order"]
Print["  - S_∞: Wilson's theorem, fractional parts, additive sum"]
Print[""]
Print["The equivalence class remains:"]
Print["  S_∞ ↔ φ(n) ↔ p+q ↔ factoring"]
Print["CF provides another equivalent view, not a shortcut."]
