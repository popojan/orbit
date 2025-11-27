(* p-adic Analysis for Semiprime Factorization *)
(* In Q_p, divisibility and "closeness to 0" are related *)

Print["═══════════════════════════════════════════════════════════════"]
Print["  p-ADIC ANALYSIS: A Different Perspective"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

n = 143;
{p, q} = {11, 13};

Print["n = ", n, " = ", p, " × ", q]
Print[""]

Print["In p-adic numbers Q_p:"]
Print["  |x|_p = p^{-v_p(x)} where v_p(x) = largest k such that p^k | x"]
Print["  x is 'small' in Q_p if p divides x many times"]
Print[""]

(* p-adic valuation *)
vp[x_, pp_] := If[x == 0, Infinity, IntegerExponent[x, pp]]

Print["p-adic valuations of our product f(n,i) = Product[n^2 - j^2]:"]
Print[""]

f[nn_, i_] := Product[nn^2 - j^2, {j, 1, i}]

Print["v_11(f(143, i)) and v_13(f(143, i)):"]
Do[
  fVal = f[n, i];
  v11 = vp[fVal, 11];
  v13 = vp[fVal, 13];
  Print["  i=", i, ": f = ", fVal, ", v_11 = ", v11, ", v_13 = ", v13],
  {i, 1, 8}
]
Print[""]

Print["Observation: v_p(f(n,i)) increases at specific i values!"]
Print[""]

(* When does v_p(f) increase? *)
(* f(n,i) = Product[n^2 - j^2] = Product[(n-j)(n+j)] *)
(* v_p(f) increases when p | (n-j) or p | (n+j) for some j <= i *)

Print["When does p | (n^2 - j^2)?"]
Print["  n^2 - j^2 = (n-j)(n+j)")
Print["  p | (n-j) when j ≡ n (mod p)")
Print["  p | (n+j) when j ≡ -n (mod p)")
Print[""]

Print["For p = 11, n = 143 ≡ 0 (mod 11):"]
Print["  j ≡ 0 (mod 11): j = 0, 11, 22, ...")
Print["  So 11 | (n^2 - j^2) when j ∈ {11, 22, 33, ...}")
Print[""]

(* Wait, n ≡ 0 (mod p), so n - j ≡ -j and n + j ≡ j (mod p) *)
(* p | (n-j)(n+j) when p | j or p | -j, i.e., when p | j *)

Print["Actually, since n ≡ 0 (mod p):")
Print["  n^2 - j^2 ≡ -j^2 (mod p)")
Print["  So p | (n^2 - j^2) iff p | j")
Print[""]

Print["For p = 11: p | (n^2 - j^2) when 11 | j, i.e., j = 11, 22, ...")
Print["For p = 13: p | (n^2 - j^2) when 13 | j, i.e., j = 13, 26, ...")
Print[""]

(* But our sum goes up to i = (p-1)/2 = 5 for the first factor *)
(* At i = 5, j ranges from 1 to 5, none divisible by 11 or 13 *)

Print["Wait - for small i, NO term is divisible by p or q!")
Print["The Wilson detection happens differently...")
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  UNDERSTANDING THE WILSON MECHANISM p-ADICALLY"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* The key is that we divide by (2i+1) *)
(* At i = (p-1)/2, we have 2i+1 = p *)
(* So we're computing f(n,i) / p *)

Print["At i = (p-1)/2 = 5, we divide by 2i+1 = 11"]
Print[""]

(* f(143, 5) mod 11 *)
f5 = f[n, 5];
Print["f(143, 5) = ", f5]
Print["f(143, 5) mod 11 = ", Mod[f5, 11]]
Print[""]

(* f(143, 5) / 11 = ??? *)
Print["f(143, 5) / 11 = ", f5/11]
Print[""]

(* The fractional part {f/p} depends on f mod p *)
(* If f ≡ r (mod p), then f/p = k + r/p for some integer k *)
(* So {f/p} = r/p *)

Print["Since f(143,5) ≡ 10 (mod 11):"]
Print["  f/11 = integer + 10/11")
Print["  {f/11} = 10/11 = (p-1)/p ✓"]
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  p-ADIC VALUATION OF f(n,i)"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* Key question: what is v_p(f(n,i))? *)
(* f(n,i) = Product_{j=1}^i (n^2 - j^2) *)
(* v_p(f) = Σ_{j=1}^i v_p(n^2 - j^2) *)

Print["v_p(f(n,i)) = Σ_{j=1}^i v_p(n^2 - j^2)"]
Print[""]

(* Since n ≡ 0 (mod p): *)
(* n^2 - j^2 ≡ -j^2 (mod p) *)
(* v_p(n^2 - j^2) = v_p(-j^2) = 2 v_p(j) *)

Print["Since n ≡ 0 (mod p):")
Print["  v_p(n^2 - j^2) = v_p(-j^2) = 2 v_p(j)")
Print[""]

Print["For p = 11 and j = 1 to 10:")
Do[
  vj = vp[j, 11];
  vTerm = vp[n^2 - j^2, 11];
  expected = 2 * vj;
  Print["  j=", j, ": v_11(j) = ", vj, ", v_11(n^2-j^2) = ", vTerm, ", 2v_11(j) = ", expected],
  {j, 1, 10}
]
Print[""]

Print["Confirmed: v_p(n^2 - j^2) = 2 v_p(j) when p | n"]
Print[""]

(* So v_p(f(n,i)) = 2 Σ_{j=1}^i v_p(j) = 2 × (floor(i/p) + floor(i/p^2) + ...) *)

Print["v_p(f(n,i)) = 2 × Σ_{k=1}^∞ floor(i/p^k)"]
Print["           = 2 × Legendre's formula for v_p(i!)")
Print["           = 2 v_p(i!)")
Print[""]

Print["But wait - this counts PRODUCTS, not individual terms...")
Print["Let me recalculate:")
Print[""]

(* Actually: v_p(Product[n^2 - j^2]) = Sum[v_p(n^2 - j^2)] *)
(* And v_p(n^2 - j^2) = 2 v_p(j) + (higher terms if p^k | n for k > 1) *)

Print["═══════════════════════════════════════════════════════════════"]
Print["  THE WILSON STRUCTURE IN Q_p"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* In Q_p, Wilson's theorem says: (p-1)! ≡ -1 (mod p) *)
(* Our product at i = (p-1)/2 involves ((p-1)/2)!² in some sense *)

Print["Wilson: (p-1)! ≡ -1 (mod p)")
Print[""]

(* Product_{j=1}^{(p-1)/2} (-j^2) = (-1)^{(p-1)/2} × ((p-1)/2)!^2 *)
(* By Wilson-like: (-1)^{(p-1)/2} × ((p-1)/2)!^2 ≡ -1 (mod p) *)

Print["At i = (p-1)/2:")
Print["  f(n,i) ≡ Product(-j^2) = (-1)^i × (i!)^2 (mod p)")
Print["  By quadratic Wilson: (-1)^{(p-1)/2} × ((p-1)/2)!^2 ≡ -1 (mod p)")
Print["  So f(n,i) ≡ -1 ≡ p-1 (mod p)")
Print[""]

(* Verify *)
i5 = (p - 1)/2;
f5mod = Mod[f[n, i5], p];
Print["Verification: f(143, 5) mod 11 = ", f5mod, " = ", p - 1, " ✓"]
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  CAN p-ADIC METHODS PROVIDE A SHORTCUT?"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["The p-adic perspective EXPLAINS why our formula works:")
Print["  - f(n,i) mod p follows a predictable pattern"]
Print["  - At i = (p-1)/2, f ≡ p-1 (mod p) by Wilson")
Print["  - This gives {f/p} = (p-1)/p")
Print[""]

Print["But for a SHORTCUT, we'd need to:"]
Print["  1. Know which p to test (requires factorization!)"]
Print["  2. Or find p from the p-adic structure directly"]
Print[""]

Print["The problem: In Q_p, we work with KNOWN p.")
Print["For factoring, p is UNKNOWN.")
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  ADELIC PERSPECTIVE"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["The adeles A = R × Π_p Q_p combine all completions."]
Print["An adelic approach would work in ALL Q_p simultaneously."]
Print[""]

Print["Our formula's fractional part can be seen adelically:"]
Print["  {f/d} ≠ 0 iff d | n (prime d)")
Print["  This is detecting 'non-integrality' in Q_d"]
Print[""]

Print["But computing adelically still requires knowing primes,"]
Print["or iterating through candidates."]
Print[""]

Print["CONCLUSION: p-adic analysis ILLUMINATES but doesn't SHORTCUT."]
