#!/usr/bin/env wolframscript
(* Deep analysis of the cancellation mechanism at jump points *)

<< Orbit`

Print["=== JUMP MECHANISM ANALYSIS ===\n"];

(* Analyze what happens when we add term k *)
AnalyzeJumpMechanism[p_, kMax_] := Module[{states, analysis},
  Print["Analyzing prime p=", p, " up to k=", kMax, "\n"];

  (* Generate hybrid states *)
  states = NestList[
    Function[{n, a, {bn, bd}},
      Module[{factorNum, factorDen},
        factorNum = (3 + 2*n)*n + 1;
        factorDen = 3 + 2*n;
        {n + 1, bn/bd, {bn*factorDen + (a*bd - bn)*factorNum, bd*factorDen}}
      ]] @@ # &,
    {0, 0, {1, 1}},
    kMax
  ];

  (* Analyze each step where ν_p(D) increases *)
  analysis = Table[
    Module[{prevState, currState, k, prevBN, prevBD, currBN, currBD,
            prevNuD, prevNuN, currNuD, currNuN, m, nuM, nuK, a,
            term1Val, term2Val, minVal},

      prevState = states[[k]];  (* k-1 state *)
      currState = states[[k+1]]; (* k state *)

      {_, a, {prevBN, prevBD}} = prevState;
      {_, _, {currBN, currBD}} = currState;

      k = k - 1; (* Actual k index *)
      m = 2*k + 1;

      prevNuD = IntegerExponent[prevBD, p];
      prevNuN = IntegerExponent[prevBN, p];
      currNuD = IntegerExponent[currBD, p];
      currNuN = IntegerExponent[currBN, p];

      (* Only analyze jump points *)
      If[currNuD > prevNuD,
        nuM = IntegerExponent[m, p];
        nuK = IntegerExponent[k!, p];

        (* Analyze the two terms in numerator update *)
        (* N_k = N_{k-1} * m + (-1)^k * k! * D_{k-1} *)
        term1Val = prevNuN + nuM; (* ν_p(N_{k-1} * m) *)
        term2Val = nuK + prevNuD;  (* ν_p(k! * D_{k-1}) *)
        minVal = Min[term1Val, term2Val];

        <|
          "k" -> k,
          "m" -> m,
          "ν_p(m)" -> nuM,
          "ν_p(k!)" -> nuK,
          "ν_p(D_{k-1})" -> prevNuD,
          "ν_p(N_{k-1})" -> prevNuN,
          "ν_p(D_k)" -> currNuD,
          "ν_p(N_k)" -> currNuN,
          "Δ_D" -> currNuD - prevNuD,
          "Δ_N" -> currNuN - prevNuN,
          "Term1_val" -> term1Val,
          "Term2_val" -> term2Val,
          "Min_val" -> minVal,
          "N_k matches min?" -> (currNuN == minVal),
          "Synchronized?" -> (currNuN - prevNuN == currNuD - prevNuD),
          "p==m?" -> (p == m)
        |>
      ,
        Nothing
      ]
    ],
    {k, 2, kMax + 1}
  ];

  Print["Found ", Length[analysis], " jumps\n"];

  (* Show first 15 jumps *)
  Print["First 15 jumps:"];
  Print["k\tm\tν(m)\tν(k!)\tν(D-)\tν(N-)\tν(D)\tν(N)\tΔ_D\tΔ_N\tT1\tT2\tMin\tSync?\tp==m?"];
  Do[
    With[{a = analysis[[i]]},
      Print[a["k"], "\t", a["m"], "\t", a["ν_p(m)"], "\t", a["ν_p(k!)"], "\t",
            a["ν_p(D_{k-1})"], "\t", a["ν_p(N_{k-1})"], "\t",
            a["ν_p(D_k)"], "\t", a["ν_p(N_k)"], "\t",
            a["Δ_D"], "\t", a["Δ_N"], "\t",
            a["Term1_val"], "\t", a["Term2_val"], "\t", a["Min_val"], "\t",
            If[a["Synchronized?"], "Y", "N"], "\t",
            If[a["p==m?"], "Y", "N"]
      ]
    ],
    {i, 1, Min[15, Length[analysis]]}
  ];

  Print["\n=== PATTERN VERIFICATION ==="];

  (* Check if N_k always equals the minimum valuation *)
  allMatchMin = AllTrue[analysis, #["N_k matches min?"] &];
  Print["ν_p(N_k) always equals min(Term1, Term2)? ", If[allMatchMin, "✓ YES", "✗ NO"]];

  (* Check synchronization pattern *)
  unsyncCount = Count[analysis, _?(! #["Synchronized?"] &)];
  Print["Unsynchronized jumps: ", unsyncCount];

  (* Check if unsynchronized only when p==m *)
  unsyncOnlyWhenPEqualsM = AllTrue[
    Select[analysis, ! #["Synchronized?"] &],
    #["p==m?"] &
  ];
  Print["All unsynchronized jumps have p==m? ", If[unsyncOnlyWhenPEqualsM, "✓ YES", "✗ NO"]];

  syncOnlyWhenPNotEqualsM = AllTrue[
    Select[analysis, #["Synchronized?"] &],
    ! #["p==m?"] &
  ];
  Print["All synchronized jumps have p≠m? ", If[syncOnlyWhenPNotEqualsM, "✓ YES", "✗ NO"]];

  Print[];
  analysis
]

(* Run analysis *)
primes = {3, 5, 7, 11};
kMax = 200; (* Smaller for detailed analysis *)

results = Table[
  Print[">>> PRIME p=", p, " <<<"];
  result = AnalyzeJumpMechanism[p, kMax];
  Print[];
  p -> result,
  {p, primes}
] // Association;

Print["=== OVERALL SUMMARY ==="];
Print["✓ Analysis complete for primes: ", primes];
Print["✓ Key question: Does Term1 < Term2 explain synchronized jumps?"];
