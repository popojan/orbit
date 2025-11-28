(* Analysis of reciprocal sum: Why does S * n^2 -> 3? *)

Print["==============================================================="]
Print["  RECIPROCAL SUM ANALYSIS: S * n^2 -> 3"]
Print["==============================================================="]
Print[""]

f[n_, i_] := Product[n^2 - j^2, {j, 1, i}]

(* Reciprocal sum up to limit *)
recipSum[n_, maxI_] := Sum[(2 i + 1)/f[n, i], {i, 1, maxI}]

Print["1. VERIFY PATTERN FOR SEMIPRIMES"]
Print["==============================================================="]
Print[""]

semiprimes = {{3, 5}, {3, 7}, {5, 7}, {3, 11}, {5, 11}, {7, 11}, {7, 13}, {11, 13}, {13, 17}, {17, 19}};
Do[
  {p, q} = pq;
  n = p * q;
  maxI = (p - 1)/2;  (* Sum up to first singularity *)
  s = recipSum[n, maxI];
  product = s * n^2;
  Print["n=", n, " (", p, "*", q, "): S*n^2 = ", N[product, 10]],
  {pq, semiprimes}
]
Print[""]

Print["2. ANALYZE FIRST TERM DOMINANCE"]
Print["==============================================================="]
Print[""]

(* First term: (2*1+1)/f(n,1) = 3/(n^2-1) *)
(* First term * n^2 = 3n^2/(n^2-1) -> 3 as n -> inf *)

Print["First term: T_1 = 3/(n^2 - 1)"]
Print["T_1 * n^2 = 3n^2/(n^2-1) -> 3 as n -> infinity"]
Print[""]

Do[
  {p, q} = pq;
  n = p * q;
  t1 = 3/(n^2 - 1);
  firstTermProd = t1 * n^2;
  Print["n=", n, ": T_1*n^2 = ", N[firstTermProd, 10]],
  {pq, Take[semiprimes, 5]}
]
Print[""]

Print["3. HIGHER TERMS CONTRIBUTION"]
Print["==============================================================="]
Print[""]

(* How much do terms beyond i=1 contribute? *)
Do[
  {p, q} = pq;
  n = p * q;
  maxI = (p - 1)/2;
  fullSum = recipSum[n, maxI];
  firstTerm = 3/(n^2 - 1);
  higherTerms = fullSum - firstTerm;
  Print["n=", n, ": Full*n^2 = ", N[fullSum * n^2, 8], ", Higher*n^2 = ", N[higherTerms * n^2, 8]],
  {pq, Take[semiprimes, 5]}
]
Print[""]

Print["4. ASYMPTOTIC ANALYSIS"]
Print["==============================================================="]
Print[""]

(* f(n,i) = Product[(n-j)(n+j)] = Product[n^2(1 - j^2/n^2)] *)
(* For n >> i: f(n,i) ~ n^(2i) * Product[1 - j^2/n^2] ~ n^(2i) *)
(* So T_i = (2i+1)/f(n,i) ~ (2i+1)/n^(2i) *)
(* T_i * n^2 ~ (2i+1) * n^(2-2i) *)
(* For i >= 2: n^(2-2i) -> 0 as n -> inf *)

Print["Asymptotic: T_i ~ (2i+1)/n^(2i)"]
Print["T_i * n^2 ~ (2i+1) * n^(2-2i)"]
Print[""]
Print["For i=1: n^(2-2) = n^0 = 1, so T_1*n^2 -> 3"]
Print["For i=2: n^(2-4) = n^(-2) -> 0"]
Print["For i>=2: all terms vanish as n -> infinity"]
Print[""]

Print["5. EXACT FORMULA FOR FIRST TERM"]
Print["==============================================================="]
Print[""]

(* T_1 = 3/(n^2-1) = 3/((n-1)(n+1)) *)
(* Partial fractions: 3/((n-1)(n+1)) = A/(n-1) + B/(n+1) *)
(* 3 = A(n+1) + B(n-1) *)
(* n=1: 3 = 2A, A = 3/2 *)
(* n=-1: 3 = -2B, B = -3/2 *)
(* T_1 = (3/2)/(n-1) - (3/2)/(n+1) = (3/2)[1/(n-1) - 1/(n+1)] *)

Print["T_1 = 3/(n^2-1) = (3/2)[1/(n-1) - 1/(n+1)]"]
Print[""]

(* Verify *)
Do[
  n = nn;
  t1Direct = 3/(n^2 - 1);
  t1Partial = (3/2) * (1/(n - 1) - 1/(n + 1));
  Print["n=", n, ": Direct = ", t1Direct, ", Partial = ", t1Partial, ", Match: ", t1Direct == t1Partial],
  {nn, {15, 21, 35, 77, 143}}
]
Print[""]

Print["6. TELESCOPING?"]
Print["==============================================================="]
Print[""]

(* Does the full sum telescope? *)
(* T_i = (2i+1)/f(n,i) *)
(* f(n,i) = f(n,i-1) * (n^2 - i^2) *)
(* So T_i = (2i+1)/(f(n,i-1) * (n^2 - i^2)) *)

Print["Recurrence: f(n,i) = f(n,i-1) * (n^2 - i^2)"]
Print[""]

(* Let's check if there's a telescoping pattern *)
(* Define: g(n,i) such that T_i = g(n,i) - g(n,i+1) *)
(* Then Sum[T_i] = g(n,1) - g(n,maxI+1) *)

Print["Looking for g(n,i) such that T_i = g(n,i) - g(n,i+1)..."]
Print[""]

(* Explicit terms *)
n = 15;
Print["For n=15:"]
Do[
  ti = (2 i + 1)/f[n, i];
  Print["  T_", i, " = ", ti, " = ", N[ti, 10]],
  {i, 1, 5}
]
Print[""]

Print["7. PARTIAL FRACTION DECOMPOSITION"]
Print["==============================================================="]
Print[""]

(* f(n,i) = Product[(n-j)(n+j), {j,1,i}] *)
(* = (n-1)(n+1)(n-2)(n+2)...(n-i)(n+i) *)
(* = Product[n-j, {j,1,i}] * Product[n+j, {j,1,i}] *)
(* = (n-1)!/(n-i-1)! * (n+i)!/n! *)

Print["f(n,i) = [(n-1)!/(n-i-1)!] * [(n+i)!/n!]"]
Print[""]

(* Verify *)
n = 15;
Do[
  fDirect = f[n, i];
  fFormula = (Factorial[n - 1]/Factorial[n - i - 1]) * (Factorial[n + i]/Factorial[n]);
  Print["i=", i, ": Direct=", fDirect, ", Formula=", fFormula, ", Match: ", fDirect == fFormula],
  {i, 1, 5}
]
Print[""]

Print["8. POCHHAMMER FORM"]
Print["==============================================================="]
Print[""]

(* (n-1)!/(n-i-1)! = (n-i)(n-i+1)...(n-1) = Pochhammer[n-i, i] *)
(* (n+i)!/n! = (n+1)(n+2)...(n+i) = Pochhammer[n+1, i] *)

Print["f(n,i) = Pochhammer[n-i, i] * Pochhammer[n+1, i]"]
Print[""]

(* Verify *)
n = 15;
Do[
  fDirect = f[n, i];
  fPoch = Pochhammer[n - i, i] * Pochhammer[n + 1, i];
  Print["i=", i, ": Direct=", fDirect, ", Pochhammer=", fPoch, ", Match: ", fDirect == fPoch],
  {i, 1, 5}
]
Print[""]

Print["9. FORMULA: T_1 DOMINATES"]
Print["==============================================================="]
Print[""]

Print["CONCLUSION:"]
Print["  S = Sum[(2i+1)/f(n,i), {i,1,maxI}]"]
Print["  S * n^2 -> 3 because:"]
Print["    - T_1 = 3/(n^2-1), and T_1 * n^2 -> 3"]
Print["    - All other terms T_i * n^2 -> 0 (scale as n^(2-2i))"]
Print[""]
Print["  This is NOT related to the factors p, q!"]
Print["  It's purely asymptotic behavior of the first term."]
Print[""]

Print["10. WHAT ABOUT FACTOR INFORMATION?"]
Print["==============================================================="]
Print[""]

(* The sum stops at i = (p-1)/2 because f(n,p) = 0 *)
(* But for large n, higher terms don't contribute anyway *)
(* So the stopping point doesn't encode factor information in the limit *)

Print["The sum stops at i = (p-1)/2 (singularity at f(n,p) = 0)"]
Print["But higher terms contribute O(1/n^2) anyway"]
Print["So the cutoff position encodes factor info, not the sum value"]
Print[""]

(* Can we extract p from WHERE the sum diverges? *)
Print["Factor detection: WHERE does the sum diverge?"]
Print[""]

n = 143;
Print["For n = 143 = 11 * 13:"]
Do[
  If[f[n, i] == 0,
    Print["  i=", i, ": f(n,i) = 0 <- SINGULARITY! 2i+1 = ", 2 i + 1],
    ti = (2 i + 1)/f[n, i];
    Print["  i=", i, ": T_i = ", N[ti, 6]]
  ],
  {i, 1, 15}
]
