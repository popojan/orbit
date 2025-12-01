(* Stress test: find more conflicts with 22-bit + sd4 + fs4 *)

signSum[k_] := Module[{count = 0},
  Do[If[CoprimeQ[m-1, k] && CoprimeQ[m, k], count += If[OddQ[m], 1, -1]], {m, 2, k-1}];
  count
];

hierarchicalPattern[primes_] := Module[{omega = Length[primes], pattern = {}},
  Do[AppendTo[pattern, Mod[PowerMod[primes[[i]], -1, primes[[j]]], 2]],
     {i, 1, omega-1}, {j, i+1, omega}];
  If[omega >= 3,
    Do[Do[
      Module[{Mi}, Do[
        Mi = (Times @@ subset)/subset[[idx]];
        AppendTo[pattern, Mod[PowerMod[Mi, -1, subset[[idx]]], 2]],
        {idx, Length[subset]}]],
      {subset, Subsets[primes, {level}]}],
    {level, 3, omega}];
  ];
  Flatten[pattern]
];

signedDist[p_] := Module[{s = Floor[Sqrt[p]], d}, d = p - s^2; If[d <= s, d, d - 2*s - 1]];
sd4[ps_] := Mod[Total[signedDist /@ ps], 4];
fs4[ps_] := Mod[Total[Floor[Sqrt[#]] & /@ ps], 4];

extPattern[ps_] := {hierarchicalPattern[ps], sd4[ps], fs4[ps]};

Print["=== STRESS TEST: Looking for failures ==="];
Print["Scheme: 22-bit + signedDist4 + floorSqrt4 (26 bits)"];
Print[""];

(* Large test *)
primes = Select[Range[3, 80], PrimeQ];
Print["Primes 3-80: ", Length[primes], " primes"];

(* Random sample for speed *)
allProducts = Subsets[primes, {4}];
Print["Total 4-products: ", Length[allProducts]];

SeedRandom[42];
products = RandomSample[allProducts, Min[4000, Length[allProducts]]];
Print["Testing: ", Length[products], " products"];
Print[""];

(* Build extended patterns *)
Print["Computing patterns..."];
data = Table[{ps, extPattern[ps]}, {ps, products}];
Print["Done."];

grouped = GroupBy[data, #[[2]] &];
repeated = Select[grouped, Length[#] >= 2 &];

Print["Unique extended patterns: ", Length[grouped]];
Print["Repeated patterns: ", Length[repeated]];

(* Find SS conflicts *)
conflicts = {};
Do[
  Module[{reps = group[[All, 1]], ssVals},
    ssVals = signSum[Times @@ #] & /@ reps;
    If[Length[DeleteDuplicates[ssVals]] > 1,
      AppendTo[conflicts, <|"primes" -> reps, "ss" -> ssVals|>];
    ];
  ],
  {group, Values[repeated]}
];

Print["SS CONFLICTS: ", Length[conflicts]];
Print[""];

If[Length[conflicts] > 0,
  Print["=== NEW CONFLICTS FOUND ==="];
  Do[
    ps1 = conflicts[[i]]["primes"][[1]];
    ps2 = conflicts[[i]]["primes"][[2]];
    Print[""];
    Print["Conflict NEW-", i, ":"];
    Print["  Primes: ", {ps1, ps2}];
    Print["  SS: ", conflicts[[i]]["ss"]];
    Print["  Products: ", {Times @@ ps1, Times @@ ps2}];
    Print["  sd4: ", {sd4[ps1], sd4[ps2]}];
    Print["  fs4: ", {fs4[ps1], fs4[ps2]}];
    Print["  kMod16: ", {Mod[Times @@ ps1, 16], Mod[Times @@ ps2, 16]}];
    ,
    {i, Min[10, Length[conflicts]]}
  ];
  ,
  Print["No new conflicts found! Scheme holds."];
];
