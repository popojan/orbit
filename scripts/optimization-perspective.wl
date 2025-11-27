(* Optimization Perspective: Can factoring be framed as optimization? *)

Print["═══════════════════════════════════════════════════════════════"]
Print["  FACTORING AS OPTIMIZATION"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

n = 143;
{p, q} = {11, 13};

Print["n = ", n, " = ", p, " × ", q]
Print[""]

Print["Goal: Find p, q such that p × q = n and p, q > 1"]
Print[""]

Print["1. MINIMIZE DISTANCE TO DIVISOR"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* Define: d(x) = min distance from x to a divisor of n *)
(* d(x) = min_{k: k|n, k>1} |x - k| *)

Print["d(x) = min_{d|n, d>1} |x - d|"]
Print["d(x) = 0 iff x is a non-trivial divisor of n"]
Print[""]

(* For semiprime n = pq, non-trivial divisors are {p, q} *)
(* So we're minimizing distance to {p, q} *)

Print["For n = 143, non-trivial divisors: {11, 13}"]
Print[""]

(* Can we define d(x) without knowing p, q? *)
(* d(x) = n mod x / x if x | n, else > 0 *)

Print["Alternative: f(x) = n mod x"]
Print["f(x) = 0 iff x | n"]
Print[""]

Do[
  fx = Mod[n, x];
  Print["  f(", x, ") = ", fx, If[fx == 0, " <- DIVISOR!", ""]],
  {x, 2, 20}
]
Print[""]

Print["This is just trial division in disguise!"]
Print[""]

Print["2. GRADIENT-BASED OPTIMIZATION?"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* For continuous optimization, we'd need a differentiable objective *)
(* f(x) = n mod x is not differentiable (or even continuous) *)

Print["Problem: n mod x is discrete, not continuous."]
Print["No gradient to follow."]
Print[""]

(* What about a continuous relaxation? *)
(* f(x) = n - x × floor(n/x) = n - x × (n/x - {n/x}) = x × {n/x} *)

Print["Continuous relaxation: g(x) = |n/x - round(n/x)| × x"]
Print["g(x) = 0 when x perfectly divides n"]
Print[""]

g[x_] := Abs[n/x - Round[n/x]] * x

Print["g(x) for x near factors:"]
Do[
  gx = g[x];
  Print["  g(", x, ") = ", N[gx, 6]],
  {x, 9, 15}
]
Print[""]

(* Plot structure *)
Print["g(x) has local minima at divisors."]
Print["But finding global minimum still requires search."]
Print[""]

Print["3. LATTICE OPTIMIZATION"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* Factoring can be framed as finding short vectors in lattices *)
(* This is the basis of some advanced factoring algorithms *)

Print["Lattice approach: Find short vectors satisfying constraints"]
Print["For n = pq: Find (a, b) such that a ≡ b (mod n), a × b small"]
Print[""]

Print["LLL algorithm finds short vectors in polynomial time,"]
Print["but the lattices for factoring have special structure."]
Print[""]

Print["4. SUM-PRODUCT CONSTRAINT"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* We have: p × q = n (product constraint) *)
(* We want: p + q (sum) *)
(* This is Vieta's formulas for quadratic *)

Print["Constraints:"]
Print["  p × q = n = 143"]
Print["  p + q = ??? (unknown)"]
Print[""]

Print["If we knew p + q = s, then p, q are roots of x^2 - sx + n = 0"]
Print[""]

(* What's the range of possible s = p + q? *)
(* For p <= q with pq = n: *)
(* Minimum s when p = q = sqrt(n): s_min = 2 sqrt(n) *)
(* Maximum s when p = 2, q = n/2: s_max = n/2 + 2 *)

sMin = 2 Sqrt[n];
sMax = n/2 + 2;
sActual = p + q;

Print["Range of p + q:"]
Print["  Minimum (balanced): 2√n = ", N[sMin, 6]]
Print["  Maximum (unbalanced): n/2 + 2 = ", sMax]
Print["  Actual: ", sActual]
Print[""]

Print["So s ∈ [", N[sMin, 4], ", ", sMax, "] and we need to find s = ", sActual]
Print[""]

Print["5. BINARY SEARCH?"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

(* Can we binary search for s = p + q? *)
(* Given s, check if x^2 - sx + n = 0 has integer solutions *)
(* Discriminant: s^2 - 4n must be a perfect square *)

Print["For each candidate s, check if s^2 - 4n is a perfect square."]
Print[""]

checkSum[s_, nn_] := Module[{disc, sqrtDisc},
  disc = s^2 - 4 nn;
  If[disc < 0, Return[False]];
  sqrtDisc = Sqrt[disc];
  IntegerQ[sqrtDisc]
]

Print["Testing s from ", Ceiling[sMin], " to ", Floor[sMin] + 20, ":"]
Do[
  valid = checkSum[s, n];
  If[valid,
    disc = s^2 - 4 n;
    factors = {(s - Sqrt[disc])/2, (s + Sqrt[disc])/2};
    Print["  s = ", s, ": ✓ VALID! Factors: ", factors],
    Print["  s = ", s, ": ✗"]
  ],
  {s, Ceiling[sMin], Ceiling[sMin] + 20}
]
Print[""]

Print["This is FERMAT'S FACTORIZATION METHOD!"]
Print["Complexity: O(q - sqrt(n)) in worst case"]
Print["For balanced primes: O(1), for unbalanced: O(sqrt(n))"]
Print[""]

Print["6. CONNECTION TO OUR S_∞"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["Our formula computes S_∞ = 2 - (p+q)/n"]
Print["Rearranging: p + q = n(2 - S_∞)"]
Print[""]

Print["Both approaches give p + q, then Vieta solves for p, q."]
Print["The difference is HOW we find p + q:"]
Print["  - Fermat: Search over s, check discriminant"]
Print["  - Our formula: Compute sum with Wilson detection"]
Print[""]

Print["Both are O(sqrt(n)) in worst case!"]
Print[""]

Print["7. QUANTUM PERSPECTIVE REVISITED"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["Shor's algorithm: O((log n)^3) using quantum parallelism"]
Print["It evaluates a^x mod n for ALL x simultaneously via superposition"]
Print["Then QFT extracts the period"]
Print[""]

Print["The STRUCTURE (period, x^2 ≡ 1, etc.) is same as classical"]
Print["The SPEEDUP comes from parallel evaluation"]
Print[""]

Print["A classical closed form for S_∞ would achieve O(1) evaluation"]
Print["This would be equivalent to P = NP level breakthrough"]
Print[""]

Print["═══════════════════════════════════════════════════════════════"]
Print["  FINAL SUMMARY: WHY NO SHORTCUT EXISTS (so far)"]
Print["═══════════════════════════════════════════════════════════════"]
Print[""]

Print["Every approach we've tried:"]
Print["  1. Fourier/continuous → fractional part is discrete"]
Print["  2. Hypergeometric → series diverges, needs regularization"]
Print["  3. p-adic → needs to know p to work in Q_p"]
Print["  4. Egyptian fractions → needs S_∞ first"]
Print["  5. Pell solution → solving Pell is O(√n)"]
Print["  6. Optimization → leads to Fermat or trial division"]
Print["  7. Functional equations → S is additive, but needs factors"]
Print[""]

Print["The barrier is fundamental:"]
Print["  DETECTING structure is easy (Wilson, Ramanujan, etc.)"]
Print["  ACCESSING it without knowing WHERE to look requires iteration"]
Print[""]

Print["Quantum advantage is not in better detection,"]
Print["but in PARALLEL ACCESS to all possible positions."]
