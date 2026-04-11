<< Orbit`

alpha = Sqrt[2];

(* Fixed degree finder *)
polyDeg[data_] := Module[{diffs = data, d},
  Do[
    diffs = Differences[diffs];
    If[Length[Union[diffs]] == 1, Return[d, Module]],
    {d, 1, Min[Length[data] - 1, 2000]}
  ];
  "not poly"
]

Print["=== cleanPoly[Sqrt[2], k] for increasing k ==="];
Print[""];

convs = Convergents[alpha, 15];
Print["Convergents: ", convs];
Print["Numerators (p_k): ", Numerator /@ convs];
Print["Denominators (q_k): ", Denominator /@ convs];
Print[""];

Do[
  cv = Convergents[alpha, k];
  {a, b} = Take[cv, -2];
  height = Denominator[a];
  maxPos = Numerator[b];
  prevPos = Numerator[a];

  If[maxPos > 100000,
    Print["k=", k, ": skipped (p_k=", maxPos, " too large)"];
    Continue[]
  ];

  tStart = AbsoluteTime[];
  row = BeattyBallotCount[alpha, All, {maxPos, height}];
  data = Drop[row, prevPos - 1];
  tEnd = AbsoluteTime[];

  deg = polyDeg[data];

  Print["k=", k,
    ": height=q_{", k - 2, "}=", height,
    "  range=[p_{", k - 2, "}=", prevPos, ", p_{", k - 1, "}=", maxPos, "]",
    "  #points=", Length[data],
    "  degree=", deg,
    "  (==height? ", deg === height, ")",
    "  time=", Round[tEnd - tStart, 0.1], "s"];,
  {k, 3, 14}
];
