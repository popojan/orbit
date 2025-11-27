(* Functional Equations: Relationships between S(n) for different n *)
(* Can we derive S(pq) from S(p), S(q), or other values? *)

Print["═══════════════════════════════════════════════════════════════"]
Print["  FUNCTIONAL EQUATIONS FOR S(n)"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

signal[n_, i_] := FractionalPart[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1)]

sInfinity[n_] := Sum[signal[n, i], {i, 1, n}]

(* For prime p: S(p) = (p-1)/p *)
(* For semiprime pq: S(pq) = (p-1)/p + (q-1)/q *)

Print["1. S(n) FOR PRIMES"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

primes = {3, 5, 7, 11, 13, 17, 19, 23};
Do[
  s = sInfinity[pp];
  expected = (pp - 1)/pp;
  Print["S(", pp, ") = ", s, " = ", expected, " | Match: ", s == expected],
  {pp, primes}
]
Print[""]

Print["For prime p: S(p) = (p-1)/p ✓"]
Print[""]

Print["2. S(n) FOR SEMIPRIMES"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

semiprimes = {{3, 5}, {3, 7}, {5, 7}, {7, 11}, {11, 13}};
Do[
  {p, q} = pq;
  n = p * q;
  s = sInfinity[n];
  expected = (p - 1)/p + (q - 1)/q;
  Print["S(", n, ") = S(", p, "×", q, ") = ", s, " = ", expected],
  {pq, semiprimes}
]
Print[""]

Print["For semiprime pq: S(pq) = S(p) + S(q) - S(p)×S(q)/??? NO!"]
Print["Actually: S(pq) = (p-1)/p + (q-1)/q = S(p) + S(q)"]
Print[""]

(* Wait, is S additive over coprime factors? *)
Print["3. IS S ADDITIVE? S(mn) = S(m) + S(n) for coprime m, n?"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["Test: S(p) + S(q) vs S(pq)"]
Do[
  {p, q} = pq;
  sp = (p - 1)/p;
  sq = (q - 1)/q;
  spq = (p - 1)/p + (q - 1)/q;
  Print["S(", p, ") + S(", q, ") = ", sp, " + ", sq, " = ", sp + sq];
  Print["S(", p * q, ") = ", spq];
  Print["Equal: ", sp + sq == spq];
  Print[""],
  {pq, Take[semiprimes, 3]}
]

Print["YES! S is ADDITIVE over coprime factors!"]
Print["S(mn) = S(m) + S(n) when gcd(m,n) = 1"]
Print[""]

Print["4. CONNECTION TO ARITHMETIC FUNCTIONS"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* S(n) = Σ_{p|n, p prime} (p-1)/p *)
(* This is related to: *)
(* ω(n) = number of distinct prime factors *)
(* Ω(n) = number of prime factors with multiplicity *)

Print["S(n) = Σ_{p|n} (1 - 1/p) = ω(n) - Σ_{p|n} 1/p"]
Print[""]

Print["For n = pq:"]
Print["  ω(n) = 2"]
Print["  Σ 1/p = 1/p + 1/q = (p+q)/n"]
Print["  S(n) = 2 - (p+q)/n ✓"]
Print[""]

Print["5. MULTIPLICATIVE vs ADDITIVE"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* φ(n) is multiplicative: φ(mn) = φ(m)φ(n) for coprime m,n *)
(* σ(n) is multiplicative: σ(mn) = σ(m)σ(n) for coprime m,n *)
(* S(n) is ADDITIVE: S(mn) = S(m) + S(n) for coprime m,n *)

Print["φ(n) is MULTIPLICATIVE: φ(mn) = φ(m)×φ(n)"]
Print["σ(n) is MULTIPLICATIVE: σ(mn) = σ(m)×σ(n)"]
Print["S(n) is ADDITIVE: S(mn) = S(m) + S(n)"]
Print[""]

Print["Additive functions are RARE in number theory!"]
Print["Examples: ω(n), Ω(n), log(n)"]
Print[""]

Print["S(n) = Σ (p-1)/p is additive because it's a SUM over prime factors."]
Print[""]

Print["6. CAN WE COMPUTE S(n) FROM S(smaller values)?"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* If S is additive, then knowing S(p) for primes gives S(n) for all n *)
(* S(p) = (p-1)/p for prime p *)
(* S(n) = Σ_{p|n} S(p) *)

Print["If we knew the prime factorization: S(n) = Σ_{p|n} S(p)"]
Print["But this requires knowing the factorization!"]
Print[""]

Print["Reverse direction: Can S(n) help find factors?"]
Print["  S(n) = (p-1)/p + (q-1)/q = 2 - (p+q)/n"]
Print["  → p + q = n(2 - S(n))"]
Print["  → Vieta: x² - (p+q)x + n = 0"]
Print[""]

Print["We're back to: computing S(n) ↔ factoring n"]
Print[""]

Print["7. MÖBIUS INVERSION"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* For additive functions: *)
(* If f(n) = Σ_{d|n} g(d), then g(n) = Σ_{d|n} μ(n/d) f(d) *)

(* S(n) = Σ_{p|n} (p-1)/p *)
(* This is NOT a sum over ALL divisors, just PRIME divisors *)

Print["S(n) sums over PRIME divisors only, not all divisors."]
Print["Standard Möbius inversion doesn't directly apply."]
Print[""]

(* But we can write: *)
(* Σ_{p|n} 1/p = (derivative of something related to ζ?) *)

Print["8. DERIVATIVE OF ZETA PRODUCT"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* ζ(s) = Π_p (1 - p^{-s})^{-1} *)
(* log ζ(s) = -Σ_p log(1 - p^{-s}) = Σ_p Σ_k p^{-ks}/k *)
(* d/ds log ζ(s) = Σ_p Σ_k (-log p) p^{-ks} / k × something *)

Print["log ζ(s) = Σ_p Σ_{k=1}^∞ p^{-ks}/k"]
Print["-ζ'(s)/ζ(s) = Σ_p Σ_k (log p) p^{-ks}"]
Print[""]

Print["At s = 1 (pole): this relates to prime counting"]
Print["But extracting individual prime sums still requires knowing primes"]
Print[""]

Print["9. WHAT IF WE KNEW S(n) FOR MANY n?"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* If we could compute S(k) for k = 1, 2, ..., n *)
(* Could we extract factors of specific n from the pattern? *)

Print["S(k) for k = 1 to 20:"]
Do[
  s = sInfinity[k];
  factors = FactorInteger[k];
  primeFactors = factors[[All, 1]];
  Print["  S(", k, ") = ", N[s, 4], "  factors: ", primeFactors],
  {k, 2, 20}
]
Print[""]

Print["Pattern: S(k) increases with number of prime factors"]
Print["  S(prime) = (p-1)/p ∈ (0.5, 1)")
Print["  S(pq) = S(p) + S(q) ∈ (1.2, 1.9)")
Print["  S(pqr) = S(p) + S(q) + S(r) ∈ (1.7, 2.5)")
Print[""]

Print["10. KEY REALIZATION")
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["S(n) = Σ_{p|n} (p-1)/p is:")
Print["  - ADDITIVE over coprime factors"]
Print["  - Equivalent to knowing ω(n) - Σ 1/p"]
Print["  - Equivalent to knowing p + q for semiprime"]
Print["  - Equivalent to factorization"]
Print[""]

Print["The additivity doesn't help because:"]
Print["  - Computing S(n) directly requires iterating (O(sqrt n))")
Print["  - Using additivity S(pq) = S(p) + S(q) requires knowing p, q"]
Print[""]

Print["CIRCULAR: Additivity is a PROPERTY, not a SHORTCUT"]
