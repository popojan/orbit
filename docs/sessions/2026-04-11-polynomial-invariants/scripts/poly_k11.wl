<< Orbit`

alpha = Sqrt[2];

polyDeg[data_, maxD_: 5000] := Module[{diffs = data, d},
  Do[
    diffs = Differences[diffs];
    If[Length[Union[diffs]] == 1, Return[d, Module]],
    {d, 1, Min[Length[data] - 1, maxD]}
  ];
  "not poly (checked up to " <> ToString[Min[Length[data] - 1, maxD]] <> ")"
]

(* k=11: height=2378, #points=4757 *)
Print["k=11: computing BeattyBallotCount[Sqrt[2], All, {8119, 2378}]..."];
tStart = AbsoluteTime[];
cv = Convergents[alpha, 11];
{a, b} = Take[cv, -2];
height = Denominator[a];  (* 2378 *)
maxPos = Numerator[b];    (* 8119 *)
prevPos = Numerator[a];   (* 3363 *)

row = BeattyBallotCount[alpha, All, {maxPos, height}];
data = Drop[row, prevPos - 1];
tDP = AbsoluteTime[];
Print["  DP done in ", Round[tDP - tStart, 0.1], "s, #points=", Length[data]];

Print["  Checking polynomial degree (limit 4800)..."];
deg = polyDeg[data, 4800];
tDeg = AbsoluteTime[];
Print["  degree=", deg, "  (==height=", height, "? ", deg === height, ")"];
Print["  Degree check took ", Round[tDeg - tDP, 0.1], "s"];
