(* Explore Square-Distance Indicators + Pell Connection *)
(* Session: 2025-11-30 *)

(* Core functions *)
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

signSum[k_] := Module[{count = 0},
  Do[If[CoprimeQ[m-1, k] && CoprimeQ[m, k], count += If[OddQ[m], 1, -1]], {m, 2, k-1}];
  count
];

(* Square distance indicators *)
signedDist[p_] := Module[{s = Floor[Sqrt[p]], dBelow, dAbove},
  dBelow = p - s^2;
  dAbove = (s+1)^2 - p;
  If[dBelow <= dAbove, dBelow, -dAbove]
];

signedDist4[ps_] := Mod[Total[signedDist /@ ps], 4];
signedDist8[ps_] := Mod[Total[signedDist /@ ps], 8];

floorSqrt4[ps_] := Mod[Total[Floor[Sqrt[#]] & /@ ps], 4];
floorSqrt8[ps_] := Mod[Total[Floor[Sqrt[#]] & /@ ps], 8];

prodFloorSqrt4[ps_] := Mod[Times @@ (Floor[Sqrt[#]] & /@ ps), 4];

(* Pell-related indicators *)
(* Period length of continued fraction of sqrt(p) *)
pellPeriod[p_] := If[IntegerQ[Sqrt[p]], 0, Length[ContinuedFraction[Sqrt[p]][[2]]]];

(* Sum of Pell periods mod 4 *)
sumPellPeriod4[ps_] := Mod[Total[pellPeriod /@ ps], 4];
sumPellPeriod8[ps_] := Mod[Total[pellPeriod /@ ps], 8];

(* First quotient in CF expansion *)
cfFirstQuotient[p_] := Floor[Sqrt[p]];

(* Sum of CF periods parity *)
sumPellPeriodParity[ps_] := Mod[Total[Mod[pellPeriod[#], 2] & /@ ps], 2];

(* Number of primes with even Pell period *)
countEvenPellPeriod[ps_] := Count[pellPeriod /@ ps, _?EvenQ];

Print["=== Finding conflicts with extended pattern ==="];
Print[""];

(* Generate all 4-prime products from primes 3 to 50 (smaller set for speed) *)
primes = Select[Range[3, 50], PrimeQ];  (* 14 primes *)
products = Subsets[primes, {4}];
Print["Primes (3-50): ", primes];
Print["Total products: ", Length[products]];

(* Extended pattern: 22-bit + SignedDist4 + FloorSqrt4 *)
extendedPattern[ps_] := {hierarchicalPattern[ps], signedDist4[ps], floorSqrt4[ps]};

data = Table[{ps, extendedPattern[ps], signSum[Times @@ ps]}, {ps, products}];
grouped = GroupBy[data, #[[2]] &];
repeated = Select[grouped, Length[#] >= 2 &];

(* Find SS conflicts *)
conflicts = {};
Do[
  Module[{reps = group[[All, 1]], ssVals},
    ssVals = signSum[Times @@ #] & /@ reps;
    If[Length[DeleteDuplicates[ssVals]] > 1,
      AppendTo[conflicts, <|
        "pattern" -> group[[1, 2]],
        "primes" -> reps,
        "ssValues" -> ssVals,
        "products" -> (Times @@ # & /@ reps)
      |>];
    ];
  ],
  {group, Values[repeated]}
];

Print["Unique patterns: ", Length[grouped]];
Print["Repeated patterns: ", Length[repeated]];
Print["SS CONFLICTS: ", Length[conflicts]];
Print[""];

(* Analyze each conflict *)
Print["=== Conflict Details ==="];
Do[
  Print[""];
  Print["--- Conflict ", i, " ---"];
  Print["Products: ", conflicts[[i]]["products"]];
  Print["Primes: ", conflicts[[i]]["primes"]];
  Print["SS values: ", conflicts[[i]]["ssValues"]];

  (* Test additional indicators *)
  ps1 = conflicts[[i]]["primes"][[1]];
  ps2 = conflicts[[i]]["primes"][[2]];

  Print[""];
  Print["Square-distance indicators:"];
  Print["  signedDist per prime: ", {signedDist /@ ps1, signedDist /@ ps2}];
  Print["  signedDist8: ", {signedDist8[ps1], signedDist8[ps2]},
        If[signedDist8[ps1] != signedDist8[ps2], " <- DIST", ""]];
  Print["  floorSqrt per prime: ", {Floor[Sqrt[#]] & /@ ps1, Floor[Sqrt[#]] & /@ ps2}];
  Print["  floorSqrt8: ", {floorSqrt8[ps1], floorSqrt8[ps2]},
        If[floorSqrt8[ps1] != floorSqrt8[ps2], " <- DIST", ""]];
  Print["  prodFloorSqrt4: ", {prodFloorSqrt4[ps1], prodFloorSqrt4[ps2]},
        If[prodFloorSqrt4[ps1] != prodFloorSqrt4[ps2], " <- DIST", ""]];

  Print[""];
  Print["Pell-related indicators:"];
  Print["  Pell periods: ", {pellPeriod /@ ps1, pellPeriod /@ ps2}];
  Print["  sumPellPeriod4: ", {sumPellPeriod4[ps1], sumPellPeriod4[ps2]},
        If[sumPellPeriod4[ps1] != sumPellPeriod4[ps2], " <- DIST", ""]];
  Print["  sumPellPeriod8: ", {sumPellPeriod8[ps1], sumPellPeriod8[ps2]},
        If[sumPellPeriod8[ps1] != sumPellPeriod8[ps2], " <- DIST", ""]];
  Print["  sumPellPeriodParity: ", {sumPellPeriodParity[ps1], sumPellPeriodParity[ps2]},
        If[sumPellPeriodParity[ps1] != sumPellPeriodParity[ps2], " <- DIST", ""]];
  Print["  countEvenPellPeriod: ", {countEvenPellPeriod[ps1], countEvenPellPeriod[ps2]},
        If[countEvenPellPeriod[ps1] != countEvenPellPeriod[ps2], " <- DIST", ""]];
  ,
  {i, Length[conflicts]}
];

(* Summary *)
Print[""];
Print["=== Summary: What distinguishes each conflict? ==="];
Do[
  ps1 = conflicts[[i]]["primes"][[1]];
  ps2 = conflicts[[i]]["primes"][[2]];
  distinguishers = {};
  If[signedDist8[ps1] != signedDist8[ps2], AppendTo[distinguishers, "signedDist8"]];
  If[floorSqrt8[ps1] != floorSqrt8[ps2], AppendTo[distinguishers, "floorSqrt8"]];
  If[prodFloorSqrt4[ps1] != prodFloorSqrt4[ps2], AppendTo[distinguishers, "prodFloorSqrt4"]];
  If[sumPellPeriod4[ps1] != sumPellPeriod4[ps2], AppendTo[distinguishers, "sumPellPeriod4"]];
  If[sumPellPeriod8[ps1] != sumPellPeriod8[ps2], AppendTo[distinguishers, "sumPellPeriod8"]];
  If[sumPellPeriodParity[ps1] != sumPellPeriodParity[ps2], AppendTo[distinguishers, "pellPeriodParity"]];
  If[countEvenPellPeriod[ps1] != countEvenPellPeriod[ps2], AppendTo[distinguishers, "countEvenPell"]];
  Print["Conflict ", i, ": ", If[distinguishers == {}, "NONE FOUND!", distinguishers]];
  ,
  {i, Length[conflicts]}
];

Print[""];
Print["=== Pell Period Analysis for all primes ==="];
Print["Prime -> Period: ", Table[{p, pellPeriod[p]}, {p, primes}]];
