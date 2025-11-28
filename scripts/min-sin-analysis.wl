(* Analysis: Does min_k |sin(2 pi k f/d)| reveal structure? *)

Print["==============================================================="]
Print["  MINIMUM SIN ANALYSIS"]
Print["==============================================================="]
Print[""]

f[n_, i_] := Product[n^2 - j^2, {j, 1, i}]

n = 143;
{p, q} = {11, 13};

Print["Key insight:"]
Print["  sin(2 pi k f/d) = sin(2 pi k (f mod d)/d)"]
Print[""]
Print["  If d | f: f mod d = 0, so sin(...) = 0 for ALL k"]
Print["  If d !| f: sin(...) varies with k"]
Print[""]

Print["1. MIN |sin| FOR VARIOUS d"]
Print["==============================================================="]
Print[""]

(* For each d, find min |sin(2 pi k f/d)| over k = 1..d-1 *)
minSin[fVal_, d_] := Module[{r, vals},
  r = Mod[fVal, d];
  If[r == 0, Return[{0, "all k"}]];
  vals = Table[{Abs[Sin[2 Pi k r/d]], k}, {k, 1, d - 1}];
  First[SortBy[vals, First]]
]

i = 5;  (* Wilson point *)
fVal = f[n, i];
Print["At i = ", i, ", f = ", fVal]
Print[""]

Print["Testing d = 3 to 20:"]
Do[
  {minVal, bestK} = minSin[fVal, d];
  divides = Divisible[n, d];
  Print["  d=", d, ": min|sin| = ", N[minVal, 6], " at k=", bestK,
    If[divides, "  <- d | n", ""],
    If[minVal == 0, "  <- d | f!", ""]],
  {d, 3, 20}
]
Print[""]

Print["2. PATTERN: WHEN IS min|sin| = 0?"]
Print["==============================================================="]
Print[""]

Print["min|sin(2 pi k f/d)| = 0  iff  d | f"]
Print[""]

Print["For our f(n,i), when does d | f?"]
Print["  f(n,i) = Product[(n-j)(n+j), j=1..i]"]
Print["  d | f iff d | (n-j)(n+j) for some j <= i"]
Print[""]

Print["If d | n: then d | (n-j)(n+j) when d | j (since n = 0 mod d)")
Print["  So d | f when i >= d"]
Print[""]

Print["If d !| n: then d | (n-j)(n+j) when d | (n-j) or d | (n+j)")
Print["  i.e., when j = n mod d or j = -n mod d = d - (n mod d)")
Print[""]

Print["3. TEST THIS THEORY"]
Print["==============================================================="]
Print[""]

Print["n = ", n, " = ", p, " * ", q]
Print[""]

(* For d = 11 (divides n): *)
Print["d = 11 (divides n = 143):"]
Print["  n mod 11 = ", Mod[n, 11], " (= 0 since 11 | n)"]
Print["  So 11 | f when i >= 11 (when j = 11 enters product)"]
Print["  But at i = 5, j only goes to 5, so 11 !| f(n,5)"]
fVal5 = f[n, 5];
Print["  f(143, 5) mod 11 = ", Mod[fVal5, 11]]
Print[""]

(* For d = 7 (doesn't divide n): *)
Print["d = 7 (doesn't divide n):"]
Print["  n mod 7 = ", Mod[n, 7]]
Print["  7 | (n-j) when j = ", Mod[n, 7], " mod 7"]
Print["  7 | (n+j) when j = ", Mod[-n, 7], " mod 7 = ", 7 - Mod[n, 7]]
Print["  At i = 5: j ranges 1..5, neither 3 nor 4 in range? Let's check..."]
Print["  j = 3: (n-3)(n+3) = ", (n - 3) * (n + 3), " mod 7 = ", Mod[(n - 3) * (n + 3), 7]]
Print["  j = 4: (n-4)(n+4) = ", (n - 4) * (n + 4), " mod 7 = ", Mod[(n - 4) * (n + 4), 7]]
fVal5 = f[n, 5];
Print["  f(143, 5) mod 7 = ", Mod[fVal5, 7]]
Print[""]

Print["4. THE SMALL sin VALUES"]
Print["==============================================================="]
Print[""]

Print["When d !| f, the minimum |sin| tells us about f mod d."]
Print[""]

(* The minimum |sin(2 pi k r / d)| occurs when k*r is closest to multiple of d *)
(* This is related to continued fractions! *)

Print["If r = f mod d, then min_k |sin(2 pi k r/d)| is achieved"]
Print["when k*r mod d is closest to 0 or d."]
Print[""]

(* For r and d coprime, this is the denominator convergent question *)

Print["Example: d = 7, r = f mod 7 = ", Mod[fVal5, 7]]
r = Mod[fVal5, 7];
Print["k*r mod 7 for k = 1..6:"]
Do[
  krMod = Mod[k * r, 7];
  distTo0 = Min[krMod, 7 - krMod];
  sinVal = Abs[Sin[2 Pi k r/7]];
  Print["  k=", k, ": k*r mod 7 = ", krMod, ", dist to 0/7 = ", distTo0, ", |sin| = ", N[sinVal, 4]],
  {k, 1, 6}
]
Print[""]

Print["5. CAN WE EXTRACT r FROM min|sin|?"]
Print["==============================================================="]
Print[""]

Print["If we know min_k |sin(2 pi k r/d)| = sin(2 pi m/d) for some m,"]
Print["then we know the minimum distance of k*r from multiples of d."]
Print[""]

Print["But to find this minimum, we need to evaluate sin for k = 1..d-1."]
Print["That's O(d) operations for each d."]
Print["Testing d = 2..sqrt(n) is O(sqrt(n)^2) = O(n) total!"]
Print[""]

Print["6. QUANTUM ANGLE"]
Print["==============================================================="]
Print[""]

Print["In quantum computing, finding min is hard classically but..."]
Print["Grover search could find k minimizing |sin| in O(sqrt(d)) queries."]
Print[""]

Print["But we'd need a quantum oracle for |sin(2 pi k f/d)|."]
Print["Computing f/d mod 1 still requires knowing f."]
Print[""]

Print["7. LATTICE / SHORTEST VECTOR"]
Print["==============================================================="]
Print[""]

Print["Finding k such that k*r is close to multiple of d"]
Print["is equivalent to finding short vector in lattice."]
Print[""]

Print["Lattice: L = {(a, b) : a = k, b = k*r - m*d for integers k, m}"]
Print["Short vector: small |k| with k*r close to m*d"]
Print[""]

Print["LLL can find short vectors in poly time, but..."]
Print["We still need to know r = f mod d first!"]
Print[""]

Print["8. WHAT IF WE COULD COMPUTE sin(2 pi f/d) DIRECTLY?"]
Print["==============================================================="]
Print[""]

Print["Suppose we had oracle O(d) = sin(2 pi f(n,i)/d) for any d."]
Print[""]

Print["For d | n (prime factor):"]
Print["  f mod d = p-1 (Wilson) at i = (d-1)/2"]
Print["  sin(2 pi (d-1)/d) = sin(-2 pi/d) = -sin(2 pi/d)"]
Print[""]

d = 11;
sinAtFactor = Sin[2 Pi (d - 1)/d];
Print["For d = ", d, " (factor): sin(2 pi * 10/11) = ", N[sinAtFactor, 10]]
Print[""]

Print["For d !| n:"]
Print["  f mod d is 'random' (not Wilson-structured)"]
Print["  sin values are 'generic'"]
Print[""]

Print["Could we detect factors by looking for sin(2 pi f/d) = -sin(2 pi/d)?"]
Print["This would require computing f mod d... circular!"]
Print[""]

Print["9. CONCLUSION"]
Print["==============================================================="]
Print[""]

Print["Knowing min_k |sin(2 pi k f/d)| tells us if d | f."]
Print["But computing this minimum requires O(d) evaluations,"]
Print["each needing f mod d."]
Print[""]
Print["The information IS there, but extracting it"]
Print["still requires iteration over candidates."]
