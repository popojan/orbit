(* Deviation from limit: Does S*n^2 - 3 encode factor information? *)

Print["==============================================================="]
Print["  DEVIATION ANALYSIS: S*n^2 - 3 = ???"]
Print["==============================================================="]
Print[""]

f[n_, i_] := Product[n^2 - j^2, {j, 1, i}]
recipSum[n_, maxI_] := Sum[(2 i + 1)/f[n, i], {i, 1, maxI}]

Print["1. DEVIATION FOR SEMIPRIMES"]
Print["==============================================================="]
Print[""]

semiprimes = {{3, 5}, {3, 7}, {5, 7}, {3, 11}, {5, 11}, {7, 11}, {7, 13}, {11, 13}, {13, 17}, {17, 19}};
Do[
  {p, q} = pq;
  n = p * q;
  maxI = (p - 1)/2;
  s = recipSum[n, maxI];
  deviation = s * n^2 - 3;
  Print["n=", n, " (", p, "*", q, "): deviation = ", N[deviation, 10], "  n*dev = ", N[n * deviation, 6]],
  {pq, semiprimes}
]
Print[""]

Print["2. WHAT IS THE DEVIATION FORMULA?"]
Print["==============================================================="]
Print[""]

(* S*n^2 = 3n^2/(n^2-1) + higher terms *)
(* 3n^2/(n^2-1) - 3 = 3n^2/(n^2-1) - 3(n^2-1)/(n^2-1) = (3n^2 - 3n^2 + 3)/(n^2-1) = 3/(n^2-1) *)

Print["First term: T_1*n^2 - 3 = 3n^2/(n^2-1) - 3 = 3/(n^2-1)"]
Print[""]

Do[
  {p, q} = pq;
  n = p * q;
  firstTermDev = 3/(n^2 - 1);
  Print["n=", n, ": 3/(n^2-1) = ", N[firstTermDev, 10]],
  {pq, Take[semiprimes, 5]}
]
Print[""]

Print["3. COMPARE TO ACTUAL DEVIATION"]
Print["==============================================================="]
Print[""]

Do[
  {p, q} = pq;
  n = p * q;
  maxI = (p - 1)/2;
  s = recipSum[n, maxI];
  actualDev = s * n^2 - 3;
  firstTermDev = 3/(n^2 - 1);
  excess = actualDev - firstTermDev;
  Print["n=", n, ": actual=", N[actualDev, 8], ", first=", N[firstTermDev, 8], ", excess=", N[excess, 8]],
  {pq, semiprimes}
]
Print[""]

Print["4. SCALE THE EXCESS BY n^2"]
Print["==============================================================="]
Print[""]

(* The excess comes from higher terms *)
(* T_i for i >= 2 scales as O(1/n^(2i)) *)
(* So excess*n^2 should approach a constant... or does it depend on p? *)

Do[
  {p, q} = pq;
  n = p * q;
  maxI = (p - 1)/2;
  s = recipSum[n, maxI];
  actualDev = s * n^2 - 3;
  firstTermDev = 3/(n^2 - 1);
  excess = actualDev - firstTermDev;
  scaledExcess = excess * n^2;
  Print["n=", n, " (max_i=", maxI, "): excess*n^2 = ", N[scaledExcess, 8]],
  {pq, semiprimes}
]
Print[""]

Print["5. DOES maxI MATTER?"]
Print["==============================================================="]
Print[""]

(* maxI = (p-1)/2, so it depends on smaller factor *)
(* Does the excess encode p somehow? *)

Print["Grouping by smaller factor p:"]
Print[""]

(* Group by p *)
p3 = Select[semiprimes, #[[1]] == 3 &];
p5 = Select[semiprimes, #[[1]] == 5 &];
p7 = Select[semiprimes, #[[1]] == 7 &];

Do[
  Print["p = ", pp, " (maxI = ", (pp - 1)/2, "):"];
  cases = Select[semiprimes, #[[1]] == pp &];
  Do[
    {p, q} = pq;
    n = p * q;
    maxI = (p - 1)/2;
    s = recipSum[n, maxI];
    actualDev = s * n^2 - 3;
    firstTermDev = 3/(n^2 - 1);
    excess = actualDev - firstTermDev;
    scaledExcess = excess * n^2;
    Print["  n=", n, " (", p, "*", q, "): scaled excess = ", N[scaledExcess, 8]],
    {pq, cases}
  ];
  Print[""],
  {pp, {3, 5, 7, 11, 13, 17}}
]

Print["6. EXCESS DEPENDS ON maxI (i.e., on p)"]
Print["==============================================================="]
Print[""]

(* For maxI = 1: only T_1, so excess = 0 *)
(* For maxI = 2: excess includes T_2 contribution *)
(* etc. *)

Print["Let's compute excess for fixed p with varying q:"]
Print[""]

(* p = 5, so maxI = 2 *)
Print["p = 5 (maxI = 2):"]
Do[
  q = qq;
  n = 5 * q;
  maxI = 2;
  s = recipSum[n, maxI];
  actualDev = s * n^2 - 3;
  firstTermDev = 3/(n^2 - 1);
  excess = actualDev - firstTermDev;
  scaledByN4 = excess * n^4;
  Print["  n=", n, " (5*", q, "): excess*n^4 = ", N[scaledByN4, 8]],
  {qq, {7, 11, 13, 17, 19, 23, 29, 31}}
]
Print[""]

Print["excess*n^4 should be constant (from T_2 ~ 1/n^4)"]
Print[""]

Print["7. EXACT SECOND TERM"]
Print["==============================================================="]
Print[""]

(* T_2 = 5/f(n,2) *)
(* f(n,2) = (n^2-1)(n^2-4) *)
(* T_2 = 5/((n^2-1)(n^2-4)) *)
(* T_2 * n^4 = 5n^4/((n^2-1)(n^2-4)) -> 5 as n -> inf *)

Print["T_2 = 5/((n^2-1)(n^2-4))"]
Print["T_2 * n^4 -> 5"]
Print[""]

Do[
  n = 5 * qq;
  t2 = 5/((n^2 - 1) * (n^2 - 4));
  scaledT2 = t2 * n^4;
  Print["n=", n, ": T_2*n^4 = ", N[scaledT2, 10]],
  {qq, {7, 11, 13, 17, 19, 23}}
]
Print[""]

Print["8. CONCLUSION"]
Print["==============================================================="]
Print[""]

Print["The reciprocal sum S = Sum[(2i+1)/f(n,i)] has expansion:"]
Print[""]
Print["  S = 3/n^2 * (1 + 1/(n^2-1))"]
Print["    + 5/n^4 * (1 + O(1/n^2))"]
Print["    + 7/n^6 * (1 + O(1/n^2))"]
Print["    + ..."]
Print[""]
Print["  S * n^2 = 3 + 3/(n^2-1) + 5/n^2 + 7/n^4 + ..."]
Print[""]
Print["No factor information in the sum value itself!"]
Print["The only factor information is in WHERE we stop (maxI = (p-1)/2)."]
