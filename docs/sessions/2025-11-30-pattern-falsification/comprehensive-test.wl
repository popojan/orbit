(* Comprehensive test: 22-bit + floorSqrt8 across all omega *)

signSum[k_] := Module[{count = 0},
  Do[If[CoprimeQ[m-1, k] && CoprimeQ[m, k], count += If[OddQ[m], 1, -1]], {m, 2, k-1}];
  count
];

(* Hierarchical pattern - works for any omega >= 2 *)
hierarchicalPattern[primes_] := Module[{omega = Length[primes], pattern = {}},
  (* Level 2: pairwise *)
  Do[AppendTo[pattern, Mod[PowerMod[primes[[i]], -1, primes[[j]]], 2]],
     {i, 1, omega-1}, {j, i+1, omega}];
  (* Level 3+: CRT *)
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

floorSqrt8[ps_] := Mod[Total[Floor[Sqrt[#]] & /@ ps], 8];

(* Extended pattern *)
extPattern[ps_] := {hierarchicalPattern[ps], floorSqrt8[ps]};

Print["=== COMPREHENSIVE TEST: 22-bit + floorSqrt8 ==="];
Print[""];

(* Test function *)
testOmega[omega_, maxPrime_, maxProducts_] := Module[
  {primes, products, data, grouped, repeated, conflicts22, conflictsExt},

  primes = Select[Range[3, maxPrime], PrimeQ];
  products = Subsets[primes, {omega}];
  If[Length[products] > maxProducts, products = Take[products, maxProducts]];

  Print["--- Omega = ", omega, " ---"];
  Print["Primes (3-", maxPrime, "): ", Length[primes], " primes"];
  Print["Products tested: ", Length[products]];

  (* Bit count for this omega *)
  pairwiseBits = Binomial[omega, 2];
  crtBits = Sum[level * Binomial[omega, level], {level, 3, omega}];
  totalBits = pairwiseBits + crtBits;
  Print["Pattern bits: ", pairwiseBits, " (pairwise) + ", crtBits, " (CRT) = ", totalBits];

  (* Test 22-bit alone *)
  data = Table[{ps, hierarchicalPattern[ps]}, {ps, products}];
  grouped = GroupBy[data, #[[2]] &];
  repeated = Select[grouped, Length[#] >= 2 &];

  conflicts22 = 0;
  Do[
    Module[{reps = group[[All, 1]], ssVals},
      ssVals = signSum[Times @@ #] & /@ reps;
      If[Length[DeleteDuplicates[ssVals]] > 1, conflicts22++];
    ],
    {group, Values[repeated]}
  ];

  Print["Bits alone: ", Length[grouped], " unique, ", Length[repeated], " repeated, ", conflicts22, " SS conflicts"];

  (* Test with floorSqrt8 *)
  dataExt = Table[{ps, extPattern[ps]}, {ps, products}];
  groupedExt = GroupBy[dataExt, #[[2]] &];
  repeatedExt = Select[groupedExt, Length[#] >= 2 &];

  conflictsExt = 0;
  conflictDetails = {};
  Do[
    Module[{reps = group[[All, 1]], ssVals},
      ssVals = signSum[Times @@ #] & /@ reps;
      If[Length[DeleteDuplicates[ssVals]] > 1,
        conflictsExt++;
        AppendTo[conflictDetails, {reps, ssVals}];
      ];
    ],
    {group, Values[repeatedExt]}
  ];

  Print["+ floorSqrt8: ", Length[groupedExt], " unique, ", Length[repeatedExt], " repeated, ", conflictsExt, " SS conflicts"];

  If[conflictsExt > 0 && conflictsExt <= 3,
    Print["  Remaining conflicts:"];
    Do[
      Print["    ", conflictDetails[[i, 1]], " -> SS=", conflictDetails[[i, 2]]];
      ,
      {i, Min[3, Length[conflictDetails]]}
    ];
  ];

  Print[""];
  {conflicts22, conflictsExt}
];

(* Test omega = 2 *)
testOmega[2, 100, 2000];

(* Test omega = 3 *)
testOmega[3, 60, 2000];

(* Test omega = 4 - small *)
testOmega[4, 50, 1500];

(* Test omega = 4 - larger to find more collisions *)
Print["=== LARGER TEST FOR MORE COLLISIONS ==="];
Print[""];

primes = Select[Range[3, 70], PrimeQ];  (* 19 primes *)
products = Subsets[primes, {4}];
Print["Omega = 4, primes 3-70: ", Length[products], " products"];

(* Sample to keep computation manageable *)
If[Length[products] > 3000,
  products = RandomSample[products, 3000];
  Print["Sampled to 3000 products"];
];

data = Table[{ps, extPattern[ps]}, {ps, products}];
grouped = GroupBy[data, #[[2]] &];
repeated = Select[grouped, Length[#] >= 2 &];

conflicts = 0;
conflictList = {};
Do[
  Module[{reps = group[[All, 1]], ssVals},
    ssVals = signSum[Times @@ #] & /@ reps;
    If[Length[DeleteDuplicates[ssVals]] > 1,
      conflicts++;
      AppendTo[conflictList, <|"primes" -> reps, "ss" -> ssVals|>];
    ];
  ],
  {group, Values[repeated]}
];

Print["Extended pattern (22-bit + floorSqrt8):"];
Print["  Unique: ", Length[grouped]];
Print["  Repeated: ", Length[repeated]];
Print["  SS CONFLICTS: ", conflicts];
Print[""];

If[conflicts > 0,
  Print["=== CONFLICT DETAILS ==="];
  Do[
    Print["Conflict ", i, ":"];
    Print["  Primes: ", conflictList[[i]]["primes"]];
    Print["  SS: ", conflictList[[i]]["ss"]];
    (* Test additional indicators *)
    ps1 = conflictList[[i]]["primes"][[1]];
    ps2 = conflictList[[i]]["primes"][[2]];
    Print["  floorSqrt16: ", {Mod[Total[Floor[Sqrt[#]] & /@ ps1], 16],
                              Mod[Total[Floor[Sqrt[#]] & /@ ps2], 16]}];
    Print[""];
    ,
    {i, Min[5, Length[conflictList]]}
  ];
];

Print["=== SUMMARY ==="];
Print[""];
Print["22-bit + floorSqrt8 (25 bits total)"];
Print["Should handle omega 2, 3, 4 with minimal/zero conflicts"];
