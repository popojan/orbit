#!/usr/bin/env wolframscript
(* Simple test: Does removing alternating sign make numerators predictable? *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=" ~~ StringRepeat["=", 70]];
Print["Non-Alternating Formula: Numerator Pattern Analysis"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

(* Compare alternating vs non-alternating *)
Print["Formula 1: ALTERNATING (baseline)"];
Print["  Sum[(-1)^k k!/(2k+1)] * (1/2)\n"];

alternatingData = Table[
  sum = (1/2) * Sum[(-1)^k * k!/(2k+1), {k, 1, (m-1)/2}];
  {m, Numerator[sum], Denominator[sum]},
  {m, 3, 31, 2}
];

Print["m | Numerator | Denominator | Primorial | Ratio"];
Print[StringRepeat["-", 70]];
Do[
  {m, num, denom} = data;
  prim = Primorial[m];
  Print[m, " | ", num, " | ", denom, " | ", prim, " | ", prim/denom];
  ,
  {data, Take[alternatingData, 8]}
];

Print["\nNumerators: ", alternatingData[[All, 2]]];
Print["Differences: ", Differences[alternatingData[[All, 2]]]];
Print[""];

(* Non-alternating *)
Print[StringRepeat["=", 70]];
Print["Formula 2: NON-ALTERNATING"];
Print["  Sum[k!/(2k+1)] * (1/6)  [works from m=9]\n"];

nonAlternatingData = Table[
  sum = (1/6) * Sum[k!/(2k+1), {k, 1, (m-1)/2}];
  {m, Numerator[sum], Denominator[sum]},
  {m, 9, 31, 2}
];

Print["m | Numerator | Denominator | Primorial | Ratio"];
Print[StringRepeat["-", 70]];
Do[
  {m, num, denom} = data;
  prim = Primorial[m];
  Print[m, " | ", num, " | ", denom, " | ", prim, " | ", prim/denom];
  ,
  {data, Take[nonAlternatingData, 8]}
];

Print["\nNumerators: ", nonAlternatingData[[All, 2]]];
Print["Differences: ", Differences[nonAlternatingData[[All, 2]]]];

(* Pattern analysis *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["PATTERN COMPARISON"];
Print[StringRepeat["=", 70], "\n"];

altNums = alternatingData[[All, 2]];
nonAltNums = nonAlternatingData[[All, 2]];

Print["ALTERNATING numerators:"];
Print["  Values: ", Take[altNums, 8]];
Print["  All positive? ", AllTrue[altNums, # > 0 &]];
Print["  All prime? ", AllTrue[Select[Abs[altNums], # > 1 &], PrimeQ]];
Print["  GCD: ", GCD @@ Abs[altNums]];

altDiffs = Differences[altNums];
Print["  First differences: ", Take[altDiffs, 6]];
If[Length[altDiffs] > 1,
  altDiffs2 = Differences[altDiffs];
  Print["  Second differences: ", Take[altDiffs2, 5]];
  Print["  Second diffs constant? ", Length[DeleteDuplicates[altDiffs2]] == 1];
];

Print["\nNON-ALTERNATING numerators:"];
Print["  Values: ", Take[nonAltNums, 8]];
Print["  All positive? ", AllTrue[nonAltNums, # > 0 &]];
Print["  All prime? ", AllTrue[Select[Abs[nonAltNums], # > 1 &], PrimeQ]];
Print["  GCD: ", GCD @@ Abs[nonAltNums]];

nonAltDiffs = Differences[nonAltNums];
Print["  First differences: ", Take[nonAltDiffs, 6]];
If[Length[nonAltDiffs] > 1,
  nonAltDiffs2 = Differences[nonAltDiffs];
  Print["  Second differences: ", Take[nonAltDiffs2, 5]];
  Print["  Second diffs constant? ", Length[DeleteDuplicates[nonAltDiffs2]] == 1];
];

(* Growth rates *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["GROWTH ANALYSIS"];
Print[StringRepeat["=", 70], "\n"];

altGrowth = Table[
  If[altNums[[i]] != 0 && altNums[[i+1]] != 0,
    N[altNums[[i+1]] / altNums[[i]], 3],
    Missing[]
  ],
  {i, 1, Length[altNums]-1}
];

nonAltGrowth = Table[
  If[nonAltNums[[i]] != 0 && nonAltNums[[i+1]] != 0,
    N[nonAltNums[[i+1]] / nonAltNums[[i]], 3],
    Missing[]
  ],
  {i, 1, Length[nonAltNums]-1}
];

Print["Alternating growth ratios: ", Take[DeleteMissing[altGrowth], 8]];
Print["Non-alternating growth ratios: ", Take[DeleteMissing[nonAltGrowth], 8]];

Print["\n" ~~ StringRepeat["=", 70]];
Print["CONCLUSION"];
Print[StringRepeat["=", 70], "\n"];

If[AllTrue[Select[Abs[nonAltNums], # > 1 &], PrimeQ],
  Print["*** BREAKTHROUGH: All non-alternating numerators are PRIME! ***\n"];
];

If[Length[DeleteDuplicates[nonAltDiffs2]] == 1,
  Print["*** BREAKTHROUGH: Non-alternating numerators form QUADRATIC sequence! ***"];
  Print["    Second difference = ", nonAltDiffs2[[1]]];
  Print["    Can derive closed form: a*m^2 + b*m + c\n"];
];

If[StandardDeviation[DeleteMissing[nonAltGrowth]] < 1,
  Print["*** Non-alternating has geometric-like growth (more regular) ***\n"];
];

If[!AllTrue[Select[Abs[nonAltNums], # > 1 &], PrimeQ] &&
   Length[DeleteDuplicates[nonAltDiffs2]] > 1 &&
   StandardDeviation[DeleteMissing[nonAltGrowth]] >= 1,
  Print["No clear pattern found in non-alternating numerators either.");
  Print["The complexity appears fundamental to the primorial structure.\n"];
];

Print["Done!"];
