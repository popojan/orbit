(* Euler Totient Formulas for Factoring *)

Print["==============================================================="]
Print["  EULER TOTIENT AND FACTORING"]
Print["==============================================================="]
Print[""]

Print["1. BASIC CONNECTION"]
Print["==============================================================="]
Print[""]

Print["For semiprime n = pq:"]
Print["  phi(n) = (p-1)(q-1) = pq - p - q + 1 = n - (p+q) + 1"]
Print["  Therefore: p + q = n + 1 - phi(n)"]
Print[""]

(* Verify *)
semiprimes = {{3, 5}, {5, 7}, {7, 11}, {11, 13}, {13, 17}, {17, 19}};
Do[
  {p, q} = pq;
  n = p * q;
  phi = EulerPhi[n];
  sumFromPhi = n + 1 - phi;
  Print["n=", n, ": phi=", phi, ", n+1-phi=", sumFromPhi, ", p+q=", p + q, " OK: ", sumFromPhi == p + q],
  {pq, semiprimes}
]
Print[""]

Print["IF we could compute phi(n) without factoring, we'd factor n!"]
Print["But computing phi(n) IS equivalent to factoring."]
Print[""]

Print["2. THE DIVISOR SUM FORMULA"]
Print["==============================================================="]
Print[""]

Print["Sum[mu(d)^2/phi(d), {d|n}] = n/phi(n)"]
Print[""]

Print["For n = pq, divisors are {1, p, q, pq}:"]
Print["  1/phi(1) + 1/phi(p) + 1/phi(q) + 1/phi(pq)"]
Print["  = 1 + 1/(p-1) + 1/(q-1) + 1/((p-1)(q-1))"]
Print["  = n/phi(n) = pq/((p-1)(q-1))"]
Print[""]

(* Verify *)
{p, q} = {11, 13};
n = p * q;
divisors = Divisors[n];
sumLeft = Sum[MoebiusMu[d]^2/EulerPhi[d], {d, divisors}];
sumRight = n/EulerPhi[n];
Print["n = ", n, ":"]
Print["  Left side: ", sumLeft, " = ", N[sumLeft, 10]]
Print["  Right side: ", sumRight, " = ", N[sumRight, 10]]
Print["  Equal: ", sumLeft == sumRight]
Print[""]

Print["3. CAN WE COMPUTE THE SUM WITHOUT KNOWING DIVISORS?"]
Print["==============================================================="]
Print[""]

Print["The sum is over divisors d of n."]
Print["We don't know the divisors without factoring!"]
Print[""]

Print["Alternative: Can we express n/phi(n) differently?"]
Print[""]

Print["n/phi(n) = Product[p/(p-1), {p|n, p prime}]"]
Print["         = Product[1 + 1/(p-1), {p|n}]"]
Print[""]

Print["For n = pq:"]
Print["  n/phi(n) = p/(p-1) * q/(q-1)"]
Print[""]

(* Verify *)
Do[
  {p, q} = pq;
  n = p * q;
  ratio = n/EulerPhi[n];
  expected = (p/(p - 1)) * (q/(q - 1));
  Print["n=", n, ": n/phi = ", ratio, " = ", expected],
  {pq, Take[semiprimes, 4]}
]
Print[""]

Print["4. THE FORMULA m | phi(a^m - 1)"]
Print["==============================================================="]
Print[""]

Print["This says m divides phi(a^m - 1)."]
Print["Related to the fact that ord_m(a) | phi(m)."]
Print[""]

Print["For a=2, testing small m:"]
Do[
  val = 2^m - 1;
  phi = EulerPhi[val];
  divides = Divisible[phi, m];
  Print["m=", m, ": 2^m-1=", val, ", phi=", phi, ", m|phi: ", divides],
  {m, 2, 12}
]
Print[""]

Print["5. CONNECTION TO S_inf?"]
Print["==============================================================="]
Print[""]

Print["Our S_inf formula gives: S_inf = (p-1)/p + (q-1)/q = 2 - (p+q)/n"]
Print["Rearranging: p + q = n(2 - S_inf)"]
Print[""]

Print["Also: p + q = n + 1 - phi(n)"]
Print[""]

Print["Equating: n(2 - S_inf) = n + 1 - phi(n)"]
Print["         2n - n*S_inf = n + 1 - phi(n)"]
Print["         n - n*S_inf = 1 - phi(n)"]
Print["         n(1 - S_inf) = 1 - phi(n)"]
Print["         phi(n) = 1 - n(1 - S_inf) = 1 - n + n*S_inf"]
Print[""]

(* Verify *)
signal[n_, i_] := FractionalPart[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1)]
sInf[n_] := Sum[signal[n, i], {i, 1, n}]

Do[
  {p, q} = pq;
  n = p * q;
  s = sInf[n];
  phiFromS = 1 - n + n * s;
  phiActual = EulerPhi[n];
  Print["n=", n, ": S_inf=", s, ", phi from S=", phiFromS, ", phi actual=", phiActual, " OK: ", phiFromS == phiActual],
  {pq, Take[semiprimes, 4]}
]
Print[""]

Print["6. THE RADICAL FORMULA"]
Print["==============================================================="]
Print[""]

Print["phi(n)/n = phi(rad(n))/rad(n)"]
Print[""]

Print["For squarefree n (like semiprimes), rad(n) = n."]
Print["So this is trivial: phi(n)/n = phi(n)/n."]
Print[""]

Print["But for prime powers: rad(p^k) = p"]
Print["So phi(p^k)/p^k = phi(p)/p = (p-1)/p"]
Print[""]

Print["7. SUM OF TOTATIVES"]
Print["==============================================================="]
Print[""]

Print["Sum[k, {k: 1<=k<n, gcd(k,n)=1}] = n*phi(n)/2"]
Print[""]

(* This gives us phi(n) if we can compute the sum efficiently *)
(* But computing the sum requires knowing which k are coprime to n *)
(* Which requires factoring n! *)

n = 143;
totatives = Select[Range[n - 1], GCD[#, n] == 1 &];
sumTotatives = Total[totatives];
expected = n * EulerPhi[n]/2;
Print["n = ", n, ":"]
Print["  Sum of totatives: ", sumTotatives]
Print["  n*phi(n)/2: ", expected]
Print["  Equal: ", sumTotatives == expected]
Print[""]

Print["8. ASYMPTOTIC FORMULAS"]
Print["==============================================================="]
Print[""]

Print["Sum[phi(k), k=1..n] = 3/pi^2 * n^2 + O(n log n)"]
Print[""]

Print["This is about the DISTRIBUTION of phi values, not individual phi(n)."]
Print["Doesn't help for factoring a specific n."]
Print[""]

Print["9. THE KEY INSIGHT"]
Print["==============================================================="]
Print[""]

Print["All these formulas relate phi(n) to factors of n."]
Print["But they all require KNOWING the factors first!"]
Print[""]

Print["The circularity:"]
Print["  - To compute phi(n), you need to know factors"]
Print["  - To find factors, you could use phi(n)"]
Print["  - Neither can be computed efficiently without the other"]
Print[""]

Print["This is WHY factoring is hard."]
Print["phi, divisor sums, etc. all encode factor information,"]
Print["but there's no known way to compute them without factoring."]
Print[""]

Print["10. QUANTUM NOTE"]
Print["==============================================================="]
Print[""]

Print["Shor's algorithm finds the ORDER of a mod n (period of a^x mod n)."]
Print["If gcd(a,n) = 1, the order r divides phi(n)."]
Print["Finding r gives information about phi(n), hence about p, q."]
Print[""]

Print["The quantum speedup is in finding r via QFT,"]
Print["not in any clever formula manipulation."]
