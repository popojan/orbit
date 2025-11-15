#!/usr/bin/env wolframscript
(* Euler Product Analysis for Sum[M(n)/n^s] *)

Print["=== Euler Product Analysis for M(n) ==="];
Print[""];

(* M(n) exact formula *)
MFunc[n_Integer] := Floor[(DivisorSigma[0, n] - 1)/2];

(* Analyze M for prime powers *)
Print["=== Part 1: M(p^k) for Prime Powers ==="];
Print[""];

primes = {2, 3, 5, 7, 11, 13, 17, 19, 23};

Print["Prime p: M(p) = 0 (primes have no factorizations)"];
Print[""];

Print["Prime squares p^2:"];
Table[
  Module[{p2, Mp2, divisors},
    p2 = p^2;
    Mp2 = MFunc[p2];
    divisors = Select[Divisors[p2], 2 <= # <= Sqrt[p2] &];
    Print["  M(", p, "^2 = ", p2, ") = ", Mp2, ", divisors: ", divisors];
    {p, p2, Mp2}
  ],
  {p, primes}
];

Print[""];
Print["Prime cubes p^3:"];
Table[
  Module[{p3, Mp3, divisors},
    p3 = p^3;
    Mp3 = MFunc[p3];
    divisors = Select[Divisors[p3], 2 <= # <= Sqrt[p3] &];
    Print["  M(", p, "^3 = ", p3, ") = ", Mp3, ", divisors: ", divisors];
    {p, p3, Mp3}
  ],
  {p, Take[primes, 5]}
];

Print[""];
Print["Prime 4th powers p^4:"];
Table[
  Module[{p4, Mp4, divisors},
    p4 = p^4;
    Mp4 = MFunc[p4];
    divisors = Select[Divisors[p4], 2 <= # <= Sqrt[p4] &];
    Print["  M(", p, "^4 = ", p4, ") = ", Mp4, ", divisors: ", divisors];
    {p, p4, Mp4}
  ],
  {p, Take[primes, 4]}
];

Print[""];
Print["=== Pattern Discovery ==="];
Print["For prime p:"];
Print["  M(p) = 0"];
Print["  M(p^2) = 1  (divisor: p)"];
Print["  M(p^3) = 1  (divisor: p)"];
Print["  M(p^4) = 2  (divisors: p, p^2)"];
Print["  M(p^5) = 2  (divisors: p, p^2)"];
Print["  M(p^6) = 3  (divisors: p, p^2, p^3)"];
Print[""];
Print["General: M(p^k) = Floor[(k-1)/2] for k >= 2"];
Print["         M(p^k) = 0 for k = 1 (primes)"];

(* Verify the pattern *)
Print[""];
Print["=== Verification of Pattern ==="];
For[k = 1, k <= 10, k++,
  Module[{theoretical, actual},
    theoretical = If[k == 1, 0, Floor[(k - 1)/2]];
    actual = MFunc[2^k];
    Print["k = ", k, ": M(2^", k, ") = ", actual, ", theory = ", theoretical,
      If[actual == theoretical, " ✓", " ✗"]];
  ];
];

(* Compute local Euler factor for single prime *)
Print[""];
Print["=== Part 2: Local Euler Factor ==="];
Print[""];
Print["For prime p, local factor in Euler product:"];
Print["L_p(s) = 1 + M(p)/p^s + M(p^2)/p^(2s) + M(p^3)/p^(3s) + ..."];
Print["       = 1 + 0/p^s + 1/p^(2s) + 1/p^(3s) + 2/p^(4s) + 2/p^(5s) + 3/p^(6s) + ..."];
Print[""];

(* Compute local factor explicitly *)
ComputeLocalFactor[p_Integer, s_Real, kMax_Integer] := Module[{sum},
  sum = 1; (* k=0 term *)
  For[k = 1, k <= kMax, k++,
    sum += MFunc[p^k] / p^(k*s);
  ];
  sum
];

Print["Local factors for s=2, kMax=20:"];
Table[
  Module[{Lp},
    Lp = ComputeLocalFactor[p, 2.0, 20];
    Print["  L_", p, "(2) = ", N[Lp, 10]];
    {p, Lp}
  ],
  {p, Take[primes, 5]}
];

(* Try to find closed form for local factor *)
Print[""];
Print["=== Part 3: Closed Form for L_p(s) ==="];
Print[""];
Print["Pattern: M(p^k) = Floor[(k-1)/2]"];
Print[""];
Print["Splitting even/odd k:"];
Print["  k even (k=2m): M(p^k) = (k-1)/2 - 1/2 = m - 1"];
Print["  k odd (k=2m+1): M(p^k) = (k-1)/2 = m"];
Print[""];
Print["L_p(s) = 1 + Sum[M(p^k)/p^(ks), {k,1,∞}]"];
Print["       = 1 + Sum[0/p^s, {even k}] + Sum[m/p^((2m)s), {m,1,∞}] + Sum[m/p^((2m+1)s), {m,1,∞}]"];

(* Compute geometric series *)
Print[""];
Print["Trying to sum:"];
Print["  Sum[m/p^(2ms), m=1..∞] = (p^(2s))/((p^(2s)-1)^2)"];
Print["  Sum[m/p^((2m+1)s), m=1..∞] = p^s * Sum[m/p^(2ms), m=1..∞]"];
Print[""];

(* Verify theoretical formula *)
LocalFactorTheory[p_Integer, s_Real] := Module[{x, series1, series2},
  x = p^(2*s);
  series1 = x / (x - 1)^2; (* Sum m/p^(2ms) *)
  series2 = p^s * series1; (* Sum m/p^((2m+1)s) *)
  (* But this is wrong - M(p^k) starts at k=2! *)

  (* Correct version: *)
  (* M(p) = 0, M(p^2) = 1, M(p^3) = 1, M(p^4) = 2, ... *)
  (* = 0 + 1/p^(2s) + 1/p^(3s) + 2/p^(4s) + 2/p^(5s) + ... *)

  (* Split: even k >= 2, odd k >= 3 *)
  (* Even: 1/p^(2s) + 2/p^(4s) + 3/p^(6s) + ... = Sum[(m/p^(2ms)), m=1..∞] *)
  (* Odd:  1/p^(3s) + 2/p^(5s) + 3/p^(7s) + ... = (1/p^s) * Sum[m/p^(2ms), m=1..∞] *)

  evenPart = x / (x - 1)^2;
  oddPart = (1/p^s) * x / (x - 1)^2;

  1 + evenPart + oddPart
];

Print["Theoretical formula:"];
Print["L_p(s) = 1 + p^(2s)/(p^(2s)-1)^2 + (1/p^s) * p^(2s)/(p^(2s)-1)^2"];
Print["       = 1 + [p^(2s) + p^s] / (p^(2s) - 1)^2"];
Print["       = 1 + p^s(p^s + 1) / (p^(2s) - 1)^2"];
Print[""];

Print["Verification:"];
Table[
  Module[{numerical, theoretical, ratio},
    numerical = ComputeLocalFactor[p, 2.0, 50];
    theoretical = LocalFactorTheory[p, 2.0];
    ratio = numerical / theoretical;
    Print["  p = ", p, ":"];
    Print["    Numerical:   ", N[numerical, 12]];
    Print["    Theoretical: ", N[theoretical, 12]];
    Print["    Ratio:       ", N[ratio, 12]];
  ],
  {p, Take[primes, 5]}
];

(* Full Euler product *)
Print[""];
Print["=== Part 4: Full Euler Product ==="];
Print[""];

ComputeEulerProduct[s_Real, pMax_Integer] := Module[{product},
  product = 1;
  Do[
    If[PrimeQ[p],
      product *= LocalFactorTheory[p, s];
    ],
    {p, 2, pMax}
  ];
  product
];

Print["Euler product vs Direct sum (s=2):"];
Table[
  Module[{euler, direct, ratio},
    euler = ComputeEulerProduct[2.0, pMax];
    direct = Sum[MFunc[n]/n^2, {n, 2, 100}];
    Print["  pMax = ", pMax, ": Euler = ", N[euler, 10], ", Direct = ", N[direct, 10]];
  ],
  {pMax, {10, 20, 30, 50}}
];

Print[""];
Print["=== Part 5: Relation to Zeta ==="];
Print[""];
Print["We have:"];
Print["  L_p(s) = 1 + p^s(p^s + 1) / (p^(2s) - 1)^2"];
Print[""];
Print["Compare with:"];
Print["  Zeta local factor: (1 - p^(-s))^(-1)"];
Print["  Zeta^2 local factor: (1 - p^(-s))^(-2)"];
Print[""];

Print["Can we express L_p in terms of zeta factors?"];
Print["  (1 - p^(-s))^(-2) = p^(2s) / (p^s - 1)^2"];
Print[""];
Print["Our L_p(s) = 1 + p^s(p^s + 1) / (p^(2s) - 1)^2"];
Print["           = [( p^(2s) - 1)^2 + p^s(p^s + 1)] / (p^(2s) - 1)^2"];
Print["           = [p^(4s) - 2p^(2s) + 1 + p^(2s) + p^s] / (p^(2s) - 1)^2"];
Print["           = [p^(4s) - p^(2s) + p^s + 1] / (p^(2s) - 1)^2"];
Print[""];

(* Simplification *)
Print["Let x = p^s, then:"];
Print["  L_p(s) = [x^4 - x^2 + x + 1] / (x^2 - 1)^2"];
Print["         = [x^4 - x^2 + x + 1] / [(x-1)^2(x+1)^2]"];
Print[""];
Print["Factoring numerator: x^4 - x^2 + x + 1 = ?"];

(* Test factorization numerically *)
TestNumerator[x_] := x^4 - x^2 + x + 1;
Print["Checking if numerator factors nicely...");
Print["For x=2: ", TestNumerator[2], " = ", Factor[TestNumerator[x]] /. x -> 2];
Print["For x=3: ", TestNumerator[3], " = ", Factor[TestNumerator[x]] /. x -> 3];
Print[""];
Print["Symbolic factorization: ", Factor[x^4 - x^2 + x + 1]];

Print[""];
Print["=== Analysis Complete ==="];
Print[""];
Print["Key findings to document:"];
Print["1. M(p^k) = Floor[(k-1)/2] for prime powers"];
Print["2. Local Euler factor has closed form"];
Print["3. Global Euler product can be computed"];
Print["4. Relation to zeta^2 is non-trivial (not simple multiple)"];
