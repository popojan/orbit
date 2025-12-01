(* Test: Can floorSqrt8 ALONE replace the 22-bit pattern? *)

signSum[k_] := Module[{count = 0},
  Do[If[CoprimeQ[m-1, k] && CoprimeQ[m, k], count += If[OddQ[m], 1, -1]], {m, 2, k-1}];
  count
];

floorSqrt8[ps_] := Mod[Total[Floor[Sqrt[#]] & /@ ps], 8];
floorSqrt16[ps_] := Mod[Total[Floor[Sqrt[#]] & /@ ps], 16];
floorSqrt32[ps_] := Mod[Total[Floor[Sqrt[#]] & /@ ps], 32];

signedDist[p_] := Module[{s = Floor[Sqrt[p]], d}, d = p - s^2; If[d <= s, d, d - 2*s - 1]];
signedDist16[ps_] := Mod[Total[signedDist /@ ps], 16];

Print["=== TEST: floorSqrt as REPLACEMENT for 22-bit ==="];
Print[""];

(* Use smaller prime set for speed *)
primes = Select[Range[3, 40], PrimeQ];  (* 12 primes *)
products = Subsets[primes, {4}];
Print["Primes: ", primes];
Print["Products: ", Length[products]];
Print[""];

(* Test floorSqrt8 alone *)
Print["--- floorSqrt8 alone (3 bits) ---"];
data8 = Table[{ps, floorSqrt8[ps]}, {ps, products}];
grouped8 = GroupBy[data8, #[[2]] &];
repeated8 = Select[grouped8, Length[#] >= 2 &];

(* Check for SS conflicts *)
conflicts8 = 0;
Do[
  reps = group[[All, 1]];
  ssVals = signSum[Times @@ #] & /@ reps;
  If[Length[DeleteDuplicates[ssVals]] > 1, conflicts8++];
  ,
  {group, Values[repeated8]}
];

Print["Unique patterns: ", Length[grouped8], " (max 8)"];
Print["Repeated patterns: ", Length[repeated8]];
Print["SS CONFLICTS: ", conflicts8];
Print[""];

(* Test floorSqrt16 alone *)
Print["--- floorSqrt16 alone (4 bits) ---"];
data16 = Table[{ps, floorSqrt16[ps]}, {ps, products}];
grouped16 = GroupBy[data16, #[[2]] &];
repeated16 = Select[grouped16, Length[#] >= 2 &];

conflicts16 = 0;
Do[
  reps = group[[All, 1]];
  ssVals = signSum[Times @@ #] & /@ reps;
  If[Length[DeleteDuplicates[ssVals]] > 1, conflicts16++];
  ,
  {group, Values[repeated16]}
];

Print["Unique patterns: ", Length[grouped16], " (max 16)"];
Print["Repeated patterns: ", Length[repeated16]];
Print["SS CONFLICTS: ", conflicts16];
Print[""];

(* Test floorSqrt32 alone *)
Print["--- floorSqrt32 alone (5 bits) ---"];
data32 = Table[{ps, floorSqrt32[ps]}, {ps, products}];
grouped32 = GroupBy[data32, #[[2]] &];
repeated32 = Select[grouped32, Length[#] >= 2 &];

conflicts32 = 0;
Do[
  reps = group[[All, 1]];
  ssVals = signSum[Times @@ #] & /@ reps;
  If[Length[DeleteDuplicates[ssVals]] > 1, conflicts32++];
  ,
  {group, Values[repeated32]}
];

Print["Unique patterns: ", Length[grouped32], " (max 32)"];
Print["Repeated patterns: ", Length[repeated32]];
Print["SS CONFLICTS: ", conflicts32];
Print[""];

(* Test combination: floorSqrt16 + signedDist16 *)
Print["--- floorSqrt16 + signedDist16 (8 bits) ---"];
combined[ps_] := {floorSqrt16[ps], signedDist16[ps]};
dataC = Table[{ps, combined[ps]}, {ps, products}];
groupedC = GroupBy[dataC, #[[2]] &];
repeatedC = Select[groupedC, Length[#] >= 2 &];

conflictsC = 0;
Do[
  reps = group[[All, 1]];
  ssVals = signSum[Times @@ #] & /@ reps;
  If[Length[DeleteDuplicates[ssVals]] > 1, conflictsC++];
  ,
  {group, Values[repeatedC]}
];

Print["Unique patterns: ", Length[groupedC], " (max 256)"];
Print["Repeated patterns: ", Length[repeatedC]];
Print["SS CONFLICTS: ", conflictsC];
Print[""];

(* Compare with 22-bit *)
Print["--- 22-bit pattern alone ---"];

hierarchicalPattern[primes_] := Module[{omega = Length[primes], pattern = {}},
  Do[AppendTo[pattern, Mod[PowerMod[primes[[i]], -1, primes[[j]]], 2]],
     {i, 1, omega-1}, {j, i+1, omega}];
  Do[Do[
    Module[{Mi}, Do[
      Mi = (Times @@ subset)/subset[[idx]];
      AppendTo[pattern, Mod[PowerMod[Mi, -1, subset[[idx]]], 2]],
      {idx, Length[subset]}]],
    {subset, Subsets[primes, {level}]}],
  {level, 3, omega}];
  Flatten[pattern]
];

data22 = Table[{ps, hierarchicalPattern[ps]}, {ps, products}];
grouped22 = GroupBy[data22, #[[2]] &];
repeated22 = Select[grouped22, Length[#] >= 2 &];

conflicts22 = 0;
Do[
  reps = group[[All, 1]];
  ssVals = signSum[Times @@ #] & /@ reps;
  If[Length[DeleteDuplicates[ssVals]] > 1, conflicts22++];
  ,
  {group, Values[repeated22]}
];

Print["Unique patterns: ", Length[grouped22]];
Print["Repeated patterns: ", Length[repeated22]];
Print["SS CONFLICTS: ", conflicts22];
Print[""];

Print["=== SUMMARY ==="];
Print[""];
Print["Indicator      | Bits | Conflicts"];
Print["---------------|------|----------"];
Print["floorSqrt8     |   3  | ", conflicts8];
Print["floorSqrt16    |   4  | ", conflicts16];
Print["floorSqrt32    |   5  | ", conflicts32];
Print["fs16+sd16      |   8  | ", conflictsC];
Print["22-bit         |  22  | ", conflicts22];
