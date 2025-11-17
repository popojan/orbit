#!/usr/bin/env wolframscript
(*
Layer Summation Test - Proof of Concept for Critical Line Convergence

Tests whether layer-wise summation with sequence acceleration
can achieve better convergence than direct summation for L_M(s) on critical line.

Hypothesis: Grouping by √n layers + acceleration should handle oscillation better.
*)

Print["="*70];
Print["LAYER SUMMATION PROOF OF CONCEPT"];
Print["Testing: Does layer-wise summation improve critical line convergence?"];
Print["="*70];
Print[];

(* ========================================================================= *)
(* M(n) - Childhood function *)
(* ========================================================================= *)

M[n_Integer] := Module[{divs, sqrtN},
  If[n < 4, Return[0]];
  sqrtN = Sqrt[n];
  divs = Divisors[n];
  Count[divs, d_ /; 2 <= d <= sqrtN]
];

(* ========================================================================= *)
(* Direct Summation *)
(* ========================================================================= *)

LMDirect[s_, nMax_] := Sum[M[n]/n^s, {n, 2, nMax}];

(* ========================================================================= *)
(* Layer Summation *)
(* ========================================================================= *)

(* Layer m = {n : m² ≤ n < (m+1)²} = {m², m²+1, ..., m²+2m} *)
LayerSum[m_Integer, s_] := Module[{mSq, total},
  mSq = m^2;
  total = Sum[
    If[mSq + k >= 2, M[mSq + k]/(mSq + k)^s, 0],
    {k, 0, 2*m}
  ];
  total
];

LMLayer[s_, mMax_] := Module[{layers},
  layers = Table[LayerSum[m, s], {m, 1, mMax}];
  {Total[layers], layers}
];

(* ========================================================================= *)
(* Sequence Acceleration - Wynn Epsilon Algorithm *)
(* ========================================================================= *)

WynnEpsilon[partialSums_List] := Module[{n, eps, k, i, diff},
  n = Length[partialSums];
  If[n < 3, Return[Last[partialSums]]];

  (* Build epsilon table *)
  eps = Table[0, {n}, {n}];

  (* Initialize with partial sums *)
  Do[eps[[1, i]] = partialSums[[i]], {i, 1, n}];

  (* Fill table using Wynn's recurrence *)
  Do[
    Do[
      diff = eps[[k, i+1]] - eps[[k, i]];
      If[Abs[diff] < 10^-30,
        eps[[k+1, i]] = eps[[k, i+1]],
        (* else *)
        If[k >= 2,
          eps[[k+1, i]] = eps[[k-1, i+1]] + 1/diff,
          eps[[k+1, i]] = 1/diff
        ]
      ],
      {i, 1, n-k}
    ],
    {k, 1, n-1}
  ];

  (* Return best even diagonal element *)
  Do[
    If[Mod[k, 2] == 0 && k > 0,
      Return[eps[[k+1, 1]]]
    ],
    {k, n-1, 1, -1}
  ];

  eps[[1, 1]]
];

(* Cumulative sums *)
CumulativeSums[values_List] := Accumulate[values];

(* ========================================================================= *)
(* Test Function *)
(* ========================================================================= *)

TestConvergence[s_, nMax_:1000] := Module[
  {lDirect, mMax, lLayerResult, lLayerTotal, layerValues,
   layerCumSum, lAccelerated, recent, variation},

  Print["-"*70];
  Print["Testing L_M(s) at s = ", s];
  Print["-"*70];
  Print[];

  (* Direct summation *)
  Print["Computing direct summation (N=", nMax, ")..."];
  lDirect = LMDirect[s, nMax];
  Print["Direct Summation:"];
  Print["  L_M = ", N[lDirect, 10]];
  Print["  |L_M| = ", N[Abs[lDirect], 10]];
  Print[];

  (* Layer summation *)
  mMax = Floor[Sqrt[nMax]] + 1;
  Print["Computing layer summation (M=", mMax, ", covers n ≤ ",
        mMax^2 + 2*mMax, ")..."];
  {lLayerTotal, layerValues} = LMLayer[s, mMax];

  Print["Layer Summation:"];
  Print["  L_M = ", N[lLayerTotal, 10]];
  Print["  |L_M| = ", N[Abs[lLayerTotal], 10]];
  Print["  Difference from direct: ",
        ScientificForm[Abs[lLayerTotal - lDirect], 2]];
  Print[];

  (* Wynn acceleration *)
  Print["Applying Wynn epsilon acceleration..."];
  layerCumSum = CumulativeSums[layerValues];
  lAccelerated = WynnEpsilon[layerCumSum];

  Print["Layer + Wynn Acceleration:"];
  Print["  L_M = ", N[lAccelerated, 10]];
  Print["  |L_M| = ", N[Abs[lAccelerated], 10]];
  Print[];

  (* Convergence analysis *)
  If[Length[layerCumSum] >= 10,
    recent = Take[layerCumSum, -10];
    variation = StandardDeviation[Abs /@ recent];
    Print["Convergence Analysis (last 10 layers):"];
    Print["  Magnitudes: ", N[Abs /@ Take[recent, -5], 6]];
    Print["  Std dev: ", ScientificForm[variation, 3]];
    Print[];
  ];

  (* Verdict *)
  Print["VERDICT:"];
  Print["  Direct magnitude:      ", N[Abs[lDirect], 8]];
  Print["  Accelerated magnitude: ", N[Abs[lAccelerated], 8]];
  Module[{directMag, accelMag, improvement},
    directMag = Abs[lDirect];
    accelMag = Abs[lAccelerated];
    improvement = If[directMag > 0,
                     Abs[accelMag - directMag]/directMag * 100,
                     0];
    Print["  Change: ", N[improvement, 4], "%"];
    Which[
      improvement < 5,
        Print["  → Marginal difference (< 5%)"],
      improvement < 20,
        Print["  → Moderate improvement"],
      True,
        Print["  → Significant change (needs validation)"]
    ];
  ];
  Print[];

  <|
    "s" -> s,
    "direct" -> lDirect,
    "layer" -> lLayerTotal,
    "accelerated" -> lAccelerated,
    "mMax" -> mMax,
    "layerValues" -> layerValues
  |>
];

(* ========================================================================= *)
(* Test Battery *)
(* ========================================================================= *)

(* Convergent region validation *)
Print[];
Print["="*70];
Print["CONVERGENT REGION TESTS: Re(s) > 1 (validation)"];
Print["="*70];
Print[];

validationPoints = {2.0, 1.5 + 5*I, 3.0 + 10*I};

Do[
  result = TestConvergence[s, 1000];
  errorLayer = Abs[result["layer"] - result["direct"]] / Abs[result["direct"]] * 100;
  errorAccel = Abs[result["accelerated"] - result["direct"]] / Abs[result["direct"]] * 100;

  Print["VALIDATION:"];
  Print["  Layer vs Direct: ", N[errorLayer, 4], "% error"];
  Print["  Accel vs Direct: ", N[errorAccel, 4], "% error"];
  If[errorLayer < 1 && errorAccel < 1,
    Print["  ✓ All methods agree (< 1% error)"],
    Print["  ⚠ Discrepancy detected - check implementation!"]
  ];
  Print[];
  ,
  {s, validationPoints}
];

(* Critical line tests *)
Print[];
Print["="*70];
Print["CRITICAL LINE TESTS: Re(s) = 1/2"];
Print["="*70];
Print[];

criticalPoints = {
  0.5 + 5*I,       (* Where direct sum failed (160% oscillation) *)
  0.5 + 10*I,      (* Medium imaginary part *)
  0.5 + 14.135*I,  (* First Riemann zero *)
  0.5 + 21.022*I   (* Second Riemann zero *)
};

criticalResults = Table[
  TestConvergence[s, 1000],
  {s, criticalPoints}
];

(* Final summary *)
Print[];
Print["="*70];
Print["FINAL SUMMARY"];
Print["="*70];
Print[];
Print["Hypothesis: Layer summation + Wynn acceleration improves critical line convergence"];
Print[];
Print["Test results:"];

Do[
  s = result["s"];
  directMag = Abs[result["direct"]];
  accelMag = Abs[result["accelerated"]];
  Print["  s = ", s, ":"];
  Print["    Direct:      |L_M| = ", N[directMag, 6]];
  Print["    Accelerated: |L_M| = ", N[accelMag, 6]];
  ,
  {result, criticalResults}
];

Print[];
Print["Next steps:"];
Print["  1. If acceleration shows < 5% change: Method doesn't help numerically"];
Print["  2. If values stabilize: Promising! Increase M_max and retest"];
Print["  3. If still oscillating: Try alternative regularization (Cesàro, Abel)"];
Print[];
Print["="*70];
