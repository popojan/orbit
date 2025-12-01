(* Find collisions in the 26-bit scheme *)
(* 22-bit hierarchical pattern + signedDist4 + floorSqrt4 *)

(* Load existing conflict database *)
conflictDB = Import["conflict-database.json", "RawJSON"];
existingConflicts = conflictDB["conflicts"];
Print["Existing conflicts: ", Length[existingConflicts]];

(* Core functions *)
signedDist[p_] := Module[{s = Floor[Sqrt[p]], d},
  d = p - s^2;
  If[d <= s, d, d - 2*s - 1]
];

signedDist4[ps_] := Mod[Total[signedDist /@ ps], 4];
floorSqrt4[ps_] := Mod[Total[Floor[Sqrt[#]] & /@ ps], 4];

(* 22-bit hierarchical pattern *)
pattern22[ps_] := Module[{k = Times @@ ps},
  Table[Mod[PowerMod[If[p == 2, 1, 2], -1, p], 2], {p, Select[Prime[Range[22]], Function[q, Mod[k, q] != 0]]}]
];

(* SignSum computation *)
signSum[ps_] := Module[{k = Times @@ ps, valid},
  valid = Select[Range[k], GCD[#, k] == 1 && GCD[# - 1, k] == 1 &];
  Total[If[OddQ[#], 1, -1] & /@ valid]
];

(* Full 26-bit signature *)
signature26[ps_] := {pattern22[ps], signedDist4[ps], floorSqrt4[ps]};

(* Generate semiprimes and group by signature *)
Print["Generating semiprimes..."];
semiprimes = {};
Do[
  Do[
    AppendTo[semiprimes, Sort[{Prime[i], Prime[j]}]],
    {j, i + 1, PrimePi[1000]}
  ],
  {i, 1, PrimePi[500]}
];
Print["Total semiprimes: ", Length[semiprimes]];

(* Group by signature *)
Print["Computing signatures..."];
grouped = GroupBy[semiprimes, signature26];
multiGroups = Select[grouped, Length[#] > 1 &];
Print["Groups with multiple semiprimes: ", Length[multiGroups]];

(* Check for SignSum conflicts *)
Print["Checking for SignSum conflicts..."];
newConflicts = {};
cnt = 0;
Do[
  ssValues = signSum /@ group;
  If[Length[Union[ssValues]] > 1,
    (* Found a conflict! *)
    cnt++;
    pairs = {};
    uniqueSS = Union[ssValues];
    Do[
      indices = Position[ssValues, ss][[All, 1]];
      AppendTo[pairs, {ss, group[[indices]]}],
      {ss, uniqueSS}
    ];
    AppendTo[newConflicts, <|
      "signature" -> sig,
      "pairs" -> pairs,
      "signedDist4" -> sig[[2]],
      "floorSqrt4" -> sig[[3]]
    |>];
    Print["Conflict #", cnt, ": ", pairs];
  ],
  {sig, Keys[multiGroups]}, {group, {multiGroups[sig]}}
];

Print["\n=== SUMMARY ==="];
Print["Total new conflicts found: ", Length[newConflicts]];

(* Show details of first few conflicts *)
If[Length[newConflicts] > 0,
  Print["\nFirst 5 conflicts:"];
  Do[
    c = newConflicts[[i]];
    Print["\n--- Conflict ", i, " ---"];
    Print["sd4 = ", c["signedDist4"], ", fs4 = ", c["floorSqrt4"]];
    Do[Print["  SS=", p[[1]], ": ", p[[2]]], {p, c["pairs"]}],
    {i, Min[5, Length[newConflicts]]}
  ];
];
