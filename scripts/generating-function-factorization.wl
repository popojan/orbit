(* Generating Function for Factorization *)
(* Can we encode factorization in a power series with closed form? *)

Print["=== Dirichlet Series Connection ==="]
Print[""]

(* The Dirichlet series: *)
(* ζ(s) = Σ n^{-s} = Π_p (1 - p^{-s})^{-1} *)

(* For a single n = pq: *)
(* The "local zeta" is: (1 - p^{-s})^{-1} × (1 - q^{-s})^{-1} *)

Print["For n = pq, the 'local factor' at n in ζ(s):"]
Print["  (1 - p^{-s})^{-1} × (1 - q^{-s})^{-1}"]
Print[""]

(* At s = 1 (the pole): *)
(* (1 - 1/p)^{-1} × (1 - 1/q)^{-1} = p/(p-1) × q/(q-1) = n/φ(n) *)

{p, q} = {11, 13};
n = p * q;

Print["At s = 1:"]
Print["  (1 - 1/p)^{-1} × (1 - 1/q)^{-1} = ", p/(p-1) * q/(q-1)]
Print["  n/φ(n) = ", n/EulerPhi[n]]
Print["  Match: ", p/(p-1) * q/(q-1) == n/EulerPhi[n]]
Print[""]

(* But n/φ(n) doesn't separate p and q *)

Print["=== Logarithmic Derivative ==="]
Print[""]

(* d/ds log[(1-p^{-s})^{-1}(1-q^{-s})^{-1}] *)
(* = log(p)·p^{-s}/(1-p^{-s}) + log(q)·q^{-s}/(1-q^{-s}) *)

Print["d/ds log(local factor) = log(p)·p^{-s}/(1-p^{-s}) + log(q)·q^{-s}/(1-q^{-s})"]
Print[""]

(* At s = 0: *)
Print["At s = 0:"]
logDeriv0 = Log[p]/(1 - p) + Log[q]/(1 - q);
Print["  = log(p)/(1-p) + log(q)/(1-q) = ", N[logDeriv0]]
Print[""]

(* At s = 1 (has singularity, take limit): *)
(* p^{-s}/(1-p^{-s}) → 1/(p-1) as regularized *)

Print["=== Our S_∞ as Dirichlet Coefficient? ==="]
Print[""]

(* S_∞ = (p-1)/p + (q-1)/q = 2 - 1/p - 1/q *)

(* Is there a Dirichlet series D(s) such that *)
(* coefficient of n^{-s} in D(s) equals S_∞(n)? *)

Print["S_∞ = 2 - 1/p - 1/q"]
Print[""]

(* Consider: Σ_n (2 - Σ_{p|n} 1/p) n^{-s} *)
(* = 2ζ(s) - Σ_p Σ_{p|n} n^{-s}/p *)
(* = 2ζ(s) - Σ_p p^{-1} Σ_{k=1}^∞ (pk)^{-s} *)
(* = 2ζ(s) - Σ_p p^{-1-s} ζ(s) *)
(* = 2ζ(s) - ζ(s) × P(1+s) where P(s) = Σ_p p^{-s} *)

Print["D(s) = Σ_n S_∞(n) n^{-s}"]
Print["     = 2ζ(s) - ζ(s) × P(1+s)"]
Print["     where P(s) = prime zeta = Σ_p p^{-s}"]
Print[""]

(* But this doesn't help us compute S_∞ for specific n *)

Print["=== Möbius Inversion ==="]
Print[""]

(* If f(n) = Σ_{d|n} g(d), then g(n) = Σ_{d|n} μ(n/d) f(d) *)

(* For S_∞: *)
(* S_∞(n) = Σ_{p|n, p prime} (p-1)/p *)

(* Can we write this as a Möbius sum? *)

Print["S_∞(n) = Σ_{p|n} (1 - 1/p)"]
Print["       = ω(n) - Σ_{p|n} 1/p"]
Print[""]

(* ω(n) = number of distinct prime factors = 2 for semiprime *)
(* Σ_{p|n} 1/p = ??? *)

Print["For n = pq:"]
Print["  ω(n) = 2"]
Print["  Σ 1/p = 1/p + 1/q = (p+q)/n"]
Print[""]

Print["So S_∞ = 2 - (p+q)/n"]
Print["And p+q = n(2 - S_∞) ← Vieta!"]
Print[""]

Print["=== Searching for Non-Iterative Σ 1/p ==="]
Print[""]

(* The key is Σ_{p|n} 1/p *)
(* Is there a closed form for this? *)

Print["Σ_{p|n} 1/p for various n:"]
testN = {15, 21, 33, 35, 77, 91, 143, 221, 323};
Do[
  factors = FactorInteger[nn][[All, 1]];
  sumInvP = Total[1/factors];
  Print["  n = ", nn, " = ", Times @@ factors, ": Σ1/p = ", sumInvP, " = ", N[sumInvP, 6]],
  {nn, testN}
]
Print[""]

(* Is there a pattern? *)
Print["=== Pattern Search ==="]
Print[""]

(* For n = pq with p < q: *)
(* 1/p + 1/q = (p+q)/n *)
(* We know p < sqrt(n) < q *)
(* So 1/p > 1/sqrt(n) > 1/q *)

Print["Bounds on Σ1/p for semiprime n = pq:"]
Print["  Since p ≤ sqrt(n) ≤ q:"]
Print["  1/q ≤ 1/sqrt(n) ≤ 1/p"]
Print["  2/sqrt(n) ≤ 1/p + 1/q ≤ 2/p"]
Print[""]

(* For balanced semiprime (p ≈ q ≈ sqrt(n)): *)
(* 1/p + 1/q ≈ 2/sqrt(n) *)

Print["For balanced n = 143 = 11 × 13:"]
Print["  sqrt(143) ≈ ", N[Sqrt[143], 6]]
Print["  1/11 + 1/13 = ", 1/11 + 1/13, " ≈ ", N[1/11 + 1/13, 6]]
Print["  2/sqrt(143) ≈ ", N[2/Sqrt[143], 6]]
Print[""]

Print["=== Connection to φ(n)/n ==="]
Print[""]

(* φ(n)/n = Π_{p|n} (1 - 1/p) *)
(* For semiprime: φ(n)/n = (1 - 1/p)(1 - 1/q) *)

(* log(φ(n)/n) = log(1 - 1/p) + log(1 - 1/q) *)
(*             ≈ -1/p - 1/q  for large p, q *)

Print["φ(n)/n = (1 - 1/p)(1 - 1/q)"]
Print["log(φ(n)/n) ≈ -1/p - 1/q = -(p+q)/n"]
Print[""]

Print["For n = 143:"]
Print["  φ(143)/143 = ", EulerPhi[143]/143, " = ", N[EulerPhi[143]/143, 6]]
Print["  log(φ(143)/143) = ", N[Log[EulerPhi[143]/143], 6]]
Print["  -(1/11 + 1/13) = ", N[-(1/11 + 1/13), 6]]
Print["  Approximation error: ", N[Log[EulerPhi[143]/143] + (1/11 + 1/13), 6]]
Print[""]

(* The approximation is decent but not exact *)
(* And computing log(φ(n)/n) still requires φ(n) which requires factorization! *)

Print["=== The Circle Closes ==="]
Print[""]
Print["Every path leads back to the same equivalence:"]
Print[""]
Print["  S_∞ ↔ Σ1/p ↔ φ(n)/n ↔ p+q ↔ factorization"]
Print[""]
Print["Computing ANY of these in closed form would solve factoring."]
Print["No closed form is known for any of them."]
Print[""]

Print["=== What Makes This Hard? ==="]
Print[""]
Print["1. MULTIPLICATION is a one-way function (believed):"]
Print["   n = p × q is easy to compute"]
Print["   p, q from n is hard"]
Print[""]
Print["2. ADDITION mixes information:"]
Print["   p + q = n(2 - S_∞) requires S_∞"]
Print["   S_∞ requires knowing which i give nonzero contributions"]
Print[""]
Print["3. DETECTION requires testing:"]
Print["   Wilson detects p | n at i = (p-1)/2"]
Print["   But we must TEST position i to trigger detection"]
Print[""]
Print["4. NO KNOWN SHORTCUT to identify 'special' positions without iteration"]
