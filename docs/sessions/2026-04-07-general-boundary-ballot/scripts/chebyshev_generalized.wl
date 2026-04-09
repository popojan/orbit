(* Chebyshev T/U for Generalized Pell (N ≠ 1)
   ==============================================

   KEY ALGEBRA:

   For exact Pell x²-dy²=1:
     (x+y√d)^k = T_k(x) + y·U_{k-1}(x)·√d
     Norm = 1^k = 1   (always)
     EgyptSqrt: bounds (T_{k+1}-1)/(y·U_k), (T_{k+1}+1)/(y·U_k)

   For approximate Pell p²-dq²=N:
     (p+q√d)^k = p_k + q_k·√d
     Norm = N^k   (!!!)
     When |N|<1: norm → 0 exponentially → BETTER than classical!

   Question: Can we express p_k, q_k via Chebyshev of SCALED argument?

   DERIVATION:
     p²-dq² = N  →  p²/N - dq²/N = 1  →  (p/√N)² - d(q/√N)² = 1
     So (p/√N, q/√N) is an exact "Pell solution" with argument p/√N.

   Therefore:
     p_k = N^{k/2} · T_k(p/√N)
     q_k = q · N^{(k-1)/2} · U_{k-1}(p/√N)
     p_k² - d·q_k² = N^k · [T_k(p/√N)² - (p²/N-1)·U_{k-1}(p/√N)²] = N^k

   Egyptian bounds:
     √d ∈ [(p_{k+1} - |N|^{(k+1)/2})/q_{k+1}, (p_{k+1} + |N|^{(k+1)/2})/q_{k+1}]
     Width = 2|N|^{(k+1)/2} / q_{k+1}

   For |N|<1: DOUBLY EXPONENTIAL convergence (numerator shrinks, denominator grows)
*)

<< Orbit`

(* ================================================================ *)
Print["============================================================"];
Print["SECTION 1: Power recurrence verification"];
Print["  p_{k+1} = 2p·p_k - N·p_{k-1}"];
Print["  q_{k+1} = 2p·q_k - N·q_{k-1}"];
Print["============================================================"];
Print[""];

(* Power iteration: (p+q√d)^k *)
PowerIterate[p_, q_, d_, k_] := Module[
  {pk = p, qk = q, pkOld = 1, qkOld = 0, nn = p^2 - d q^2, tmp},
  If[k == 0, Return[{1, 0}]];
  If[k == 1, Return[{p, q}]];
  Do[
    tmp = 2 p pk - nn pkOld;
    pkOld = pk; pk = tmp;
    tmp = 2 p qk - nn qkOld;
    qkOld = qk; qk = tmp,
  {k - 1}];
  {pk, qk}
]

(* Test: d=2, exact Pell (3,2), norm=1 *)
Print["d=2, (3,2), N=1:"];
Do[
  Module[{pq = PowerIterate[3, 2, 2, k], tk, uk},
    tk = ChebyshevT[k, 3];
    uk = 2 ChebyshevU[k - 1, 3];
    Print["  k=", k, ": power=(", pq[[1]], ",", pq[[2]], ")",
      "  Cheb=(", tk, ",", uk, ")",
      "  norm=", pq[[1]]^2 - 2 pq[[2]]^2,
      If[pq == {tk, uk}, "  ✓ match", "  ✗ MISMATCH"]]
  ],
{k, 1, 5}];

(* Test: d=Pi, approximate Pell (39,22), norm≈0.469 *)
Print[""];
Print["d=Pi, (39,22), N≈0.469:"];
Module[{p = 39, q = 22, d = Pi, nn},
  nn = N[p^2 - d q^2, 30];
  Print["  N = ", NumberForm[nn, 10]];
  Do[
    Module[{pq = PowerIterate[p, q, d, k], normK},
      normK = N[pq[[1]]^2 - d pq[[2]]^2, 30];
      Print["  k=", k,
        ": (", pq[[1]], ",", pq[[2]], ")",
        "  norm=", NumberForm[normK, 8],
        "  N^k=", NumberForm[N[nn^k, 30], 8],
        If[Abs[normK - nn^k] < 10^-20, "  ✓", "  ✗"]]
    ],
  {k, 1, 6}]
];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 2: Scaled Chebyshev verification"];
Print["  p_k = N^{k/2} · T_k(p/√N)"];
Print["  q_k = q · N^{(k-1)/2} · U_{k-1}(p/√N)"];
Print["============================================================"];
Print[""];

Module[{p = 39, q = 22, d = Pi, nn, pSc},
  nn = N[p^2 - d q^2, 30];
  pSc = N[p / Sqrt[nn], 30];
  Print["d=π, (39,22), N=", NumberForm[nn, 8], ", p/√N=", NumberForm[pSc, 8]];
  Print[""];

  Do[
    Module[{pq = PowerIterate[p, q, d, k],
            pkCheb, qkCheb},
      pkCheb = N[nn^(k/2) ChebyshevT[k, pSc], 30];
      qkCheb = N[q nn^((k - 1)/2) ChebyshevU[k - 1, pSc], 30];
      Print["  k=", k];
      Print["    Power:     (", pq[[1]], ", ", pq[[2]], ")"];
      Print["    Scaled T/U: (", NumberForm[pkCheb, 12], ", ",
        NumberForm[qkCheb, 12], ")"];
      Print["    Match: ",
        If[Abs[N[pq[[1]]] - pkCheb] < 10^-10 &&
           Abs[N[pq[[2]]] - qkCheb] < 10^-10, "✓", "✗"],
        "  norm=", NumberForm[N[pq[[1]]^2 - d pq[[2]]^2], 8],
        "  N^k=", NumberForm[N[nn^k], 8]]
    ],
  {k, 1, 6}];
];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 3: Convergence comparison"];
Print["  A) Classical EgyptSqrt: d=2, Pell (3,2), N=1"];
Print["  B) Generalized: d=Pi, (39,22), N≈0.469 → |N|<1 !!"];
Print["  C) Generalized: d=Pi, (296,167), N≈0.122"];
Print["  D) Generalized: d=E, (61,37), N≈-0.328"];
Print["============================================================"];
Print[""];

(* Egyptian approximation from k-th power iterate *)
EgyptApprox[p_, q_, d_, k_] := Module[
  {pq, nn, nk},
  pq = PowerIterate[p, q, d, k];
  nn = N[p^2 - d q^2, 50];
  nk = nn^k;
  (* First-order: pk/qk - Nk/(2pk·qk) *)
  N[pq[[1]]/pq[[2]] - nk/(2 pq[[1]] pq[[2]]), 50]
]

(* Width of interval at k-th iterate *)
EgyptWidth[p_, q_, d_, k_] := Module[
  {pq, nn},
  pq = PowerIterate[p, q, d, k];
  nn = N[p^2 - d q^2, 50];
  N[2 Abs[nn]^(k/2) / (Abs[pq[[2]]] (Abs[pq[[1]]] + Abs[pq[[2]]] Sqrt[d])), 50]
]

Print["A) d=2, (3,2), N=1 — classical Pell:"];
Module[{sd = N[Sqrt[2], 50]},
  Do[
    Module[{approx = EgyptApprox[3, 2, 2, k], err},
      err = Abs[approx - sd];
      Print["  k=", k, "  error=", ScientificForm[err, 4],
        "  digits=", If[err > 0, Floor[-Log10[err]], ">50"]]
    ],
  {k, 1, 8}]
];

Print[""];
Print["B) d=Pi, (39,22), N≈0.469 — |N|<1:"];
Module[{sd = N[Sqrt[Pi], 50]},
  Do[
    Module[{approx = EgyptApprox[39, 22, Pi, k], err},
      err = Abs[approx - sd];
      Print["  k=", k, "  error=", ScientificForm[err, 4],
        "  digits=", If[err > 0, Floor[-Log10[err]], ">50"]]
    ],
  {k, 1, 8}]
];

Print[""];
Print["C) d=Pi, (296,167), N≈0.122 — |N|<<1:"];
Module[{sd = N[Sqrt[Pi], 50]},
  Do[
    Module[{approx = EgyptApprox[296, 167, Pi, k], err},
      err = Abs[approx - sd];
      Print["  k=", k, "  error=", ScientificForm[err, 4],
        "  digits=", If[err > 0, Floor[-Log10[err]], ">50"]]
    ],
  {k, 1, 8}]
];

Print[""];
Print["D) d=E, (61,37), N≈-0.328 — |N|<1, negative:"];
Module[{sd = N[Sqrt[E], 50]},
  Do[
    Module[{approx = EgyptApprox[61, 37, E, k], err},
      err = Abs[approx - sd];
      Print["  k=", k, "  error=", ScientificForm[err, 4],
        "  digits=", If[err > 0, Floor[-Log10[err]], ">50"]]
    ],
  {k, 1, 8}]
];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 4: Convergence RATE comparison"];
Print["  digits(k) for different starting norms"];
Print["============================================================"];
Print[""];

Print[StringForm["`1`",
  StringPadRight["k", 4] <>
  StringPadRight["d=2,N=1", 12] <>
  StringPadRight["d=π,N=.469", 14] <>
  StringPadRight["d=π,N=.122", 14] <>
  StringPadRight["d=e,N=-.328", 14]]];

Do[
  Module[{
    e1 = Abs[EgyptApprox[3, 2, 2, k] - N[Sqrt[2], 50]],
    e2 = Abs[EgyptApprox[39, 22, Pi, k] - N[Sqrt[Pi], 50]],
    e3 = Abs[EgyptApprox[296, 167, Pi, k] - N[Sqrt[Pi], 50]],
    e4 = Abs[EgyptApprox[61, 37, E, k] - N[Sqrt[E], 50]]},
    Print[StringForm["`1`",
      StringPadRight[ToString[k], 4] <>
      StringPadRight[ToString[If[e1 > 0, Floor[-Log10[e1]], ">50"]], 12] <>
      StringPadRight[ToString[If[e2 > 0, Floor[-Log10[e2]], ">50"]], 14] <>
      StringPadRight[ToString[If[e3 > 0, Floor[-Log10[e3]], ">50"]], 14] <>
      StringPadRight[ToString[If[e4 > 0, Floor[-Log10[e4]], ">50"]], 14]]]
  ],
{k, 1, 10}];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 5: Closed form — does original EgyptSqrt formula"];
Print["  work if we just SCALE the argument?"];
Print["  EgyptSqrt-like: (T_{k+1}(p/√N) - 1/√N) / (q·U_k(p/√N)/√N)"];
Print["============================================================"];
Print[""];

Module[{p = 39, q = 22, d = Pi, nn, pSc, sd},
  nn = N[p^2 - d q^2, 40];
  pSc = N[p / Sqrt[nn], 40];
  sd = N[Sqrt[d], 40];

  Print["d=π, seed (39,22), N=", NumberForm[nn, 6], ", p/√N=", NumberForm[pSc, 10]];
  Print[""];

  Do[
    Module[{
      (* Original EgyptSqrt formula with scaled argument *)
      tk1 = N[ChebyshevT[k + 1, pSc], 40],
      uk = N[ChebyshevU[k, pSc], 40],
      qSc = N[q / Sqrt[nn], 40],
      lower, upper, center, err},

      lower = (tk1 - 1) / (qSc uk);
      upper = (tk1 + 1) / (qSc uk);
      center = (lower + upper) / 2;
      err = Abs[center - sd];

      Print["  k=", k,
        "  interval=[", NumberForm[lower, 12], ", ", NumberForm[upper, 12], "]",
        "  width=", ScientificForm[upper - lower, 4],
        "  contains √π: ", lower <= sd <= upper]
    ],
  {k, 0, 8}]
];

Print[""];
Print["Done."];
