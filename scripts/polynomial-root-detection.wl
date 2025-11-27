(* Polynomial Root Detection Approach *)
(* Can we find where (2i+1) | n without testing all i? *)

Print["=== The Core Detection Problem ==="]
Print[""]

(* We want to find i such that (2i+1) is a prime factor of n *)
(* Equivalently: find odd prime p | n, then i = (p-1)/2 *)

(* Our sum detects these i values via Wilson's theorem *)
(* But can we detect them without iteration? *)

Print["Key observation: We're solving 2i + 1 ≡ 0 (mod p) for unknown p | n"]
Print["This is: 2i ≡ -1 (mod p)"]
Print["       : i ≡ -1/2 ≡ (p-1)/2 (mod p)"]
Print[""]

(* What if we consider the polynomial P(x) = n mod (2x+1)? *)
(* P(x) = 0 when (2x+1) | n *)

Print["=== Polynomial Perspective ==="]
Print[""]

(* Define P(x) = n - (2x+1) * floor(n/(2x+1)) *)
(* P(x) = 0 iff (2x+1) | n *)

P[n_, x_] := Mod[n, 2 x + 1]

n = 143;
Print["For n = 143 = 11 × 13:"]
Print["P(x) = n mod (2x+1)"]
Print[""]

Do[
  val = P[n, i];
  note = If[val == 0, " ← FACTOR!", ""];
  Print["  P(", i, ") = ", val, note],
  {i, 1, 10}
]
Print[""]

(* P(5) = 0 because 2*5+1 = 11 | 143 *)
(* P(6) = 0 because 2*6+1 = 13 | 143 *)

Print["=== Resultant Approach ==="]
Print[""]

(* If we could compute Res(n - (2x+1)y, f(x)) for clever f(x), *)
(* we might extract factor information *)

(* Actually, let's think about this differently: *)
(* The divisors of n are the solutions to n ≡ 0 (mod d) *)
(* For odd d = 2i+1, this becomes a polynomial equation *)

Print["Consider the polynomial:"]
Print["  Q(d) = n mod d"]
Print["  Q(d) = 0 for divisors d | n"]
Print[""]

(* For d = 2i+1, we have a polynomial in i *)
(* But evaluating Q requires knowing d, not i *)

Print["=== Möbius Function Connection ==="]
Print[""]

(* Σ_{d|n} μ(d) = 1 if n=1, else 0 *)
(* Σ_{d|n} φ(d) = n *)
(* Σ_{d|n} 1 = τ(n) (number of divisors) *)

(* For semiprime n = pq: *)
(* τ(n) = 4 (divisors: 1, p, q, pq) *)
(* Σ_{d|n} μ(d) = 0 *)

Print["For semiprime n = pq:"]
Print["  Divisors: 1, p, q, pq"]
Print["  τ(n) = 4"]
Print["  Σ μ(d) = 1 - 1 - 1 + 1 = 0"]
Print[""]

(* The Ramanujan sum c_q(n) detects prime divisors: *)
(* c_q(n) = q - 1 if prime q | n *)
(* c_q(n) = -1 if prime q ∤ n *)

Print["=== Ramanujan Sum Detection ==="]
Print[""]

(* c_k(n) = Σ_{gcd(j,k)=1, 1≤j≤k} e^{2πijn/k} *)
(* For prime k: c_k(n) = k-1 if k|n, else -1 *)

n = 143;
ramanujan[k_, n_] := Sum[If[GCD[j, k] == 1, Exp[2 Pi I j n/k], 0], {j, 1, k}]

Print["Ramanujan sums c_k(143) for small primes k:"]
Do[
  If[PrimeQ[k],
    c = Simplify[ramanujan[k, n]];
    note = If[Mod[n, k] == 0, " ← FACTOR!", ""];
    Print["  c_", k, "(143) = ", c, note]
  ],
  {k, 2, 20}
]
Print[""]

Print["Pattern: c_p(n) = p-1 if p|n, else -1 for odd primes"]
Print[""]

Print["=== The Iteration Problem (Again) ==="]
Print[""]
Print["To compute c_p(n), we need to:"]
Print["1. Choose a prime p to test"]
Print["2. Compute the sum over primitive k-th roots"]
Print[""]
Print["This is O(p) work per prime tested."]
Print["Testing all primes up to sqrt(n) is O(sqrt(n)) primes."]
Print["Total: O(sqrt(n) × sqrt(n)) = O(n) naive."]
Print[""]
Print["With prime testing (Miller-Rabin), O(sqrt(n) × log n)."]
Print["Still requires ITERATING through candidate primes."]
Print[""]

Print["=== What Would a Closed Form Look Like? ==="]
Print[""]

(* A truly closed-form solution would be: *)
(* F(n) = expression involving only n, no iteration *)
(* where F(n) directly gives p or q *)

Print["For S_∞ = (p-1)/p + (q-1)/q:"]
Print[""]
Print["If S_∞ = f(n) for some f without iteration,"]
Print["then p + q = n(2 - f(n))"]
Print["and p, q = roots of x² - n(2-f(n))x + n = 0"]
Print[""]

(* Known candidates for f(n): *)
Print["Known number-theoretic functions of n:"]
Print["  φ(n) = (p-1)(q-1) ← requires factorization"]
Print["  σ(n) = (1+p)(1+q) ← requires factorization"]
Print["  ω(n) = 2 (number of prime factors) ← known"]
Print["  μ(n) = 1 (Möbius, squarefree) ← known"]
Print["  Λ(n) = 0 (von Mangoldt) ← known"]
Print[""]

Print["None of these directly give p + q without knowing p, q."]
Print[""]

Print["=== Information-Theoretic View ==="]
Print[""]

(* n = pq contains information about both p and q *)
(* But extracting this information seems to require iteration *)

Print["Information in n = pq:"]
Print["  n has log₂(n) bits"]
Print["  p has log₂(p) ≈ log₂(sqrt(n)) = log₂(n)/2 bits"]
Print["  q has log₂(q) ≈ log₂(n)/2 bits"]
Print[""]
Print["The multiplication n = p × q 'mixes' this information."]
Print["Unmixing it (factoring) is believed to require ~exp(√log n) steps."]
Print[""]

Print["=== Quantum vs Classical ==="]
Print[""]
Print["Shor's algorithm: O((log n)³) quantum gates"]
Print["  Uses quantum parallelism to evaluate a^x mod n for ALL x"]
Print["  Then QFT extracts period"]
Print[""]
Print["Our formula: O(sqrt(n)) classical operations"]
Print["  Must evaluate each position i = 1, ..., sqrt(n)/2"]
Print["  Detects factors via Wilson's theorem"]
Print[""]
Print["Gap: quantum = polynomial, classical = subexponential"]
Print[""]
Print["A closed-form S_∞ would bridge this gap."]
Print["Current state: no such form known, not proven impossible."]
