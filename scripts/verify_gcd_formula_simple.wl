#!/usr/bin/env wolframscript
(* Verify GCD = 6 * Product[odd composites <= m] *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["======================================================================"];
Print["GCD CLOSED FORM FORMULA"];
Print["======================================================================\n"];

Print["FORMULA: For m >= 9,"];
Print["  GCD = 6 * Product[all odd composite numbers <= m]\n"];

(* Define formula *)
OddComposites[n_] := Select[Range[9, n, 2], CompositeQ];

GCDFormula[m_] := Module[{composites},
  If[m < 9,
    2,  (* Special case for m=3,5,7 *)
    composites = OddComposites[m];
    If[Length[composites] == 0, 6, 6 * Times @@ composites]
  ]
];

(* Compute actual GCD from recurrence *)
UnreducedState[0] = {0, 2};
UnreducedState[k_] := UnreducedState[k] = Module[{n, d},
  {n, d} = UnreducedState[k - 1];
  {n * (2k + 1) + k! * d, d * (2k + 1)}
];

ComputedGCD[m_] := Module[{k, state},
  k = Floor[(m-1)/2];
  state = UnreducedState[k];
  GCD[state[[1]], state[[2]]]
];

(* Test *)
Print["VERIFICATION TABLE\n"];
Print["m | Odd Composites | Formula | Computed | Match?"];
Print["------------------------------------------------------------------"];

results = Table[
  Module[{composites, formulaVal, computedVal, match},
    composites = If[m >= 9, OddComposites[m], {}];
    formulaVal = GCDFormula[m];
    computedVal = ComputedGCD[m];
    match = (formulaVal == computedVal);

    Print[StringPadRight[ToString[m], 2], " | ",
          StringPadRight[ToString[composites], 18], " | ",
          StringPadRight[ToString[formulaVal], 7], " | ",
          StringPadRight[ToString[computedVal], 8], " | ",
          If[match, "YES", "NO"]];

    match
  ],
  {m, 3, 41, 2}
];

Print["\n======================================================================"];
If[AllTrue[results, # &],
  Print["SUCCESS! ALL VALUES MATCH!\n"];
  Print["The closed form is VERIFIED:\n"];
  Print["  GCD(m) = 6 * Product[odd composites <= m]  for m >= 9"];
  Print["  GCD(m) = 2                                  for m = 3,5,7\n"];

  Print["ALTERNATIVE FORMULATION:"];
  Print["  GCD = 12 * (2k+1)!! / Primorial(2k+1)"];
  Print["where (2k+1)!! = 1*3*5*7*9*..*(2k+1) is the odd double factorial\n"];

  Print["SIGNIFICANCE:");
  Print["  - GCD is completely predictable (closed form!)"];
  Print["  - D_reduced = Primorial/6 is predictable");
  Print["  - Therefore ALL complexity is in N_reduced (numerator)");
  Print["  - The 'primal chaos' is isolated to the numerator alone!");
  ,
  Print["FAILURE - Formula needs refinement"];
];

Print["\n======================================================================"];
Print["EXPLICIT EXAMPLES\n"];

Do[
  composites = OddComposites[m];
  gcd = GCDFormula[m];

  Print["m=", m, ": Composites = ", composites];
  Print["      GCD = 6"];
  If[Length[composites] > 0,
    Do[Print["          * ", c], {c, composites}];
    Print["          = ", gcd];
  ];
  Print[""];
  ,
  {m, {9, 15, 21, 27}}
];

Print["Done!"];
