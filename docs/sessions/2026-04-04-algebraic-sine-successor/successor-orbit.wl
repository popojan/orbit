(* SuccessorOrbit: algebraic sine from one recurrence *)
(* next = (current² − seed) / previous *)
(*
   Usage:
     SuccessorMatrix[a, b, λ]        — integer transfer matrix N
     SuccessorOrbit[a, b, λ, k]      — exact f[k] ∈ Q
     SuccessorOrbitList[a, b, λ, kMax] — list {f[0], ..., f[kMax]}
     SuccessorTrace[a, b, λ, k]      — integer trace tr(N^k)
     SuccessorOrbitMod[a, b, λ, kMax, m] — orbit of (N^k w₀) mod m
     SuccessorPeriodMod[a, b, λ, m]  — period of N^k mod m
     SuccessorInfo[a, b, λ]          — summary of all parameters

   Parameters:
     a/b = seed o (rational, 0 < a/b for oscillatory: 1/(λ+1)² < a/b < 1/(λ-1)²)
     λ   = scale (positive integer, default 2)

   The recurrence:
     f[0] = a/b, f[1] = λa/b, f[k+1] = (f[k]² − a/b) / f[k−1]

   Matrix form:
     N = {{(λ²+1)a−b, −λa}, {λa, 0}},  det N = (λa)²
     f[k] = (N^k · {λa, a})₂ / ((λa)^k · b)
*)

(* === CORE === *)

SuccessorMatrix[a_Integer, b_Integer, \[Lambda]_Integer: 2] :=
  {{(\[Lambda]^2 + 1) a - b, -\[Lambda] a}, {\[Lambda] a, 0}}

SuccessorOrbit[a_Integer, b_Integer, \[Lambda]_Integer: 2, k_Integer] :=
  Module[{w0 = {\[Lambda] a, a}},
    (MatrixPower[SuccessorMatrix[a, b, \[Lambda]], k] . w0)[[2]] / ((\[Lambda] a)^k b)
  ]

SuccessorOrbitList[a_Integer, b_Integer, \[Lambda]_Integer: 2, kMax_Integer: 20] :=
  Table[SuccessorOrbit[a, b, \[Lambda], k], {k, 0, kMax}]

(* === INTEGER TRACE === *)

SuccessorTrace[a_Integer, b_Integer, \[Lambda]_Integer: 2, k_Integer] :=
  Tr[MatrixPower[SuccessorMatrix[a, b, \[Lambda]], k]]

(* Trace sequence via recurrence (faster for sequential access) *)
SuccessorTraceList[a_Integer, b_Integer, \[Lambda]_Integer: 2, kMax_Integer: 20] :=
  Module[{s, trN, detN},
    trN = (\[Lambda]^2 + 1) a - b;  (* = tr(N) *)
    detN = (\[Lambda] a)^2;          (* = det(N) *)
    s = {2, trN};
    Do[AppendTo[s, trN s[[-1]] - detN s[[-2]]], {kMax - 1}];
    s
  ]

(* === MODULAR ORBIT === *)

SuccessorOrbitMod[a_Integer, b_Integer, \[Lambda]_Integer: 2, kMax_Integer, m_Integer] :=
  Module[{NN, v, results},
    NN = Mod[SuccessorMatrix[a, b, \[Lambda]], m];
    v = Mod[{\[Lambda] a, a}, m];
    results = {v};
    Do[v = Mod[NN . v, m]; AppendTo[results, v], {kMax}];
    results
  ]

SuccessorPeriodMod[a_Integer, b_Integer, \[Lambda]_Integer: 2, m_Integer] :=
  Module[{NN, v, v0, k = 0},
    NN = Mod[SuccessorMatrix[a, b, \[Lambda]], m];
    v0 = Mod[{\[Lambda] a, a}, m];
    v = Mod[NN . v0, m];
    k = 1;
    While[v =!= v0 && k < m^2, v = Mod[NN . v, m]; k++];
    If[v === v0, k, None]
  ]

(* === ANALYSIS === *)

SuccessorInfo[a_Integer, b_Integer, \[Lambda]_Integer: 2] :=
  Module[{o, c, disc, theta, T, amp, phase, osc},
    o = a/b;
    c = ((\[Lambda]^2 + 1) o - 1) / (2 \[Lambda] o);
    disc = (b - (\[Lambda] - 1)^2 a) ((\[Lambda] + 1)^2 a - b);
    osc = 1/(\[Lambda] + 1)^2 < o < 1/(\[Lambda] - 1)^2;

    Print["Seed o = ", a, "/", b];
    Print["Scale λ = ", \[Lambda]];
    Print["Matrix N = ", SuccessorMatrix[a, b, \[Lambda]] // MatrixForm];
    Print["det N = ", (\[Lambda] a)^2];
    Print["Chebyshev c = ", c, " ≈ ", N[c]];
    Print["Discriminant D = ", disc,
      " = ", If[disc != 0, FactorInteger[Abs[disc]], 0]];
    Print["Oscillatory: ", osc,
      "  (range: ", 1/(\[Lambda]+1)^2, " < o < ", 1/(\[Lambda]-1)^2, ")"];

    If[osc && Abs[N[c]] < 1,
      theta = ArcCos[N[c]];
      T = 2 Pi / theta;
      amp = 4 o^(3/2) / Sqrt[(1 - o)(9 o^2/1 - 1)] // Quiet;
      Print["Quasi-period T ≈ ", Round[T, 0.001]];
      Print["CF of T: ", ContinuedFraction[T, 6] // Quiet];
    ];
  ]
