#!/usr/bin/env wolframscript
(* Detailed analysis of CF auxiliary sequences for p=89 *)

(* Compute full CF expansion with P_k, Q_k sequences *)
CFSequences[D_, maxSteps_: 1000] := Module[{
    a0 = Floor[Sqrt[D]],
    P = {0}, Q = {1}, a = {Floor[Sqrt[D]]},
    Pk, Qk, ak, k = 0
  },
  While[k < maxSteps,
    Pk = a[[k+1]] * Q[[k+1]] - P[[k+1]];
    Qk = (D - Pk^2) / Q[[k+1]];
    ak = Floor[(Sqrt[D] + Pk) / Qk];

    AppendTo[P, Pk];
    AppendTo[Q, Qk];
    AppendTo[a, ak];

    (* Check for period *)
    If[k > 0 && Pk == 0 && Qk == 1, Break[]];
    k++;
  ];

  <|"P" -> P, "Q" -> Q, "a" -> a, "period" -> Length[a] - 1|>
];

(* Compute convergents *)
Convergents[a_List] := Module[{
    p = {1, a[[1]]},
    q = {0, 1},
    k
  },
  Do[
    AppendTo[p, a[[k]] * p[[k]] + p[[k-1]]];
    AppendTo[q, a[[k]] * q[[k]] + q[[k-1]]],
    {k, 3, Length[a]}
  ];
  {p, q}
];

(* Analyze for prime p *)
AnalyzePrime[p_Integer] := Module[{
    seq, convergents, pk, qk, tau, m,
    pm, qm, Qm, Pm,
    pminus1Factors
  },

  Print["=== Analysis for p = ", p, " ==="];
  Print["p - 1 = ", p - 1, " = ", FactorInteger[p - 1]];
  Print[];

  seq = CFSequences[p];
  tau = seq["period"];
  Print["Period length τ = ", tau];
  Print["τ = p - 1? ", tau == p - 1];
  Print[];

  If[EvenQ[tau],
    m = tau / 2;
    Print["Center position m = ", m];
    Print[];

    (* Get center values *)
    Pm = seq["P"][[m + 1]]; (* +1 because of indexing *)
    Qm = seq["Q"][[m + 1]];
    Print["At center (k = ", m, "):"];
    Print["  P_m = ", Pm];
    Print["  Q_m = ", Qm];
    Print["  Q_m factorization: ", FactorInteger[Qm]];
    Print[];

    (* Compute convergents *)
    {pk, qk} = Convergents[seq["a"]];
    pm = pk[[m + 1]];
    qm = qk[[m + 1]];

    Print["Center convergent p_m / q_m:"];
    Print["  p_m = ", pm];
    Print["  q_m = ", qm];
    Print[];

    (* Verify Pell equation *)
    Print["Pell equation check: p_m^2 - p * q_m^2 = (-1)^m * Q_{m+1}"];
    Print["  LHS = ", pm^2 - p * qm^2];
    Print["  RHS = ", (-1)^m * seq["Q"][[m + 2]]];
    Print["  Match? ", pm^2 - p * qm^2 == (-1)^m * seq["Q"][[m + 2]]];
    Print[];

    (* Divisor analysis *)
    pminus1Factors = Divisors[p - 1];
    Print["Divisor analysis for p - 1 = ", p - 1, ":"];
    Print["  gcd(q_m, p-1) = ", GCD[qm, p - 1], " = ", FactorInteger[GCD[qm, p - 1]]];
    Print["  gcd(q_m - 1, p-1) = ", GCD[qm - 1, p - 1], " = ", FactorInteger[GCD[qm - 1, p - 1]]];
    Print["  gcd(q_m + 1, p-1) = ", GCD[qm + 1, p - 1], " = ", FactorInteger[GCD[qm + 1, p - 1]]];
    Print["  max = ", Max[GCD[qm, p - 1], GCD[qm - 1, p - 1], GCD[qm + 1, p - 1]]];
    Print[];

    (* Check Q_m divisibility *)
    Print["Q_m divisibility by factors of p - 1:"];
    Do[
      If[Mod[Qm, d] == 0,
        Print["  ", d, " | Q_m"]
      ],
      {d, pminus1Factors}
    ];
    Print[];

    (* Analyze Q_k sequence near center *)
    Print["Q_k sequence around center:"];
    Do[
      Print["  Q_", k, " = ", seq["Q"][[k + 1]], " (factors: ", FactorInteger[seq["Q"][[k + 1]]], ")"],
      {k, Max[1, m - 5], Min[tau, m + 5]}
    ];
    Print[];

    (* Look for patterns in Q_k mod (p-1) *)
    Print["Q_k mod (p-1) near center:"];
    Do[
      Print["  Q_", k, " ≡ ", Mod[seq["Q"][[k + 1]], p - 1], " (mod ", p - 1, ")"],
      {k, Max[1, m - 5], Min[tau, m + 5]}
    ];
  ,
    Print["Period is odd - no center convergent"];
  ];
];

(* Run analysis *)
Print["CENTER CONVERGENT DEEP ANALYSIS"];
Print["================================"];
Print[];

(* p = 89 as primary example *)
AnalyzePrime[89];

Print[];
Print["================================"];
Print[];

(* Also check p = 113 *)
AnalyzePrime[113];
