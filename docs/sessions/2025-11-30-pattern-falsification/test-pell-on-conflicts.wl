(* Test Pell-related indicators on known conflicts *)
(* Fast script - no signSum computation needed *)

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
pellPeriod[p_] := If[IntegerQ[Sqrt[p]], 0, Length[ContinuedFraction[Sqrt[p]][[2]]]];
sumPellPeriod4[ps_] := Mod[Total[pellPeriod /@ ps], 4];
sumPellPeriod8[ps_] := Mod[Total[pellPeriod /@ ps], 8];
sumPellPeriodParity[ps_] := Mod[Total[Mod[pellPeriod[#], 2] & /@ ps], 2];
countEvenPellPeriod[ps_] := Count[pellPeriod /@ ps, _?EvenQ];

(* Load conflicts from database *)
conflicts = {
  {{{3, 5, 11, 19}, {13, 17, 23, 79}}, {1, 5}},
  {{{3, 7, 11, 29}, {3, 31, 47, 71}}, {1, 9}},
  {{{7, 13, 23, 71}, {7, 13, 37, 71}}, {-7, 5}},
  {{{3, 13, 79, 181}, {7, 29, 59, 197}}, {-7, -11}},
  {{{3, 5, 11, 17}, {3, 29, 59, 89}, {7, 41, 83, 97}}, {-11, -11, -15}},
  {{{3, 7, 11, 17}, {7, 71, 83, 97}}, {1, 5}},
  {{{3, 13, 17, 53}, {5, 11, 29, 89}}, {1, 5}},
  {{{3, 19, 29, 43}, {5, 47, 59, 71}}, {1, 5}},
  {{{3, 29, 31, 97}, {7, 41, 47, 73}}, {1, -3}},
  {{{5, 7, 11, 41}, {7, 17, 29, 43}}, {5, 13}}
};

Print["=== Pell-Related Indicators on Known Conflicts ==="];
Print[""];

(* Show Pell periods for common primes *)
primes = Union[Flatten[conflicts[[All, 1]]]];
Print["Pell periods for primes used:"];
Print["p -> period: ", Table[{p, pellPeriod[p]}, {p, Take[primes, 20]}]];
Print[""];

Do[
  Print["--- Conflict ", i, " (SS: ", conflicts[[i, 2]], ") ---"];
  psets = conflicts[[i, 1]];

  Print["Prime sets: ", psets];
  Print[""];

  (* Show individual distances and periods *)
  Do[
    ps = psets[[j]];
    Print["  Set ", j, ": ", ps];
    Print["    signedDist: ", signedDist /@ ps, " -> sum4=", signedDist4[ps], " sum8=", signedDist8[ps]];
    Print["    floorSqrt:  ", Floor[Sqrt[#]] & /@ ps, " -> sum4=", floorSqrt4[ps], " sum8=", floorSqrt8[ps]];
    Print["    pellPeriod: ", pellPeriod /@ ps, " -> sum4=", sumPellPeriod4[ps], " sum8=", sumPellPeriod8[ps]];
    Print["    countEvenPell: ", countEvenPellPeriod[ps]];
    ,
    {j, Length[psets]}
  ];

  (* Check what distinguishes *)
  ps1 = psets[[1]];
  ps2 = psets[[2]];
  distinguishers = {};
  If[signedDist4[ps1] != signedDist4[ps2], AppendTo[distinguishers, "signedDist4"]];
  If[signedDist8[ps1] != signedDist8[ps2], AppendTo[distinguishers, "signedDist8"]];
  If[floorSqrt4[ps1] != floorSqrt4[ps2], AppendTo[distinguishers, "floorSqrt4"]];
  If[floorSqrt8[ps1] != floorSqrt8[ps2], AppendTo[distinguishers, "floorSqrt8"]];
  If[prodFloorSqrt4[ps1] != prodFloorSqrt4[ps2], AppendTo[distinguishers, "prodFloorSqrt4"]];
  If[sumPellPeriod4[ps1] != sumPellPeriod4[ps2], AppendTo[distinguishers, "sumPellPeriod4"]];
  If[sumPellPeriod8[ps1] != sumPellPeriod8[ps2], AppendTo[distinguishers, "sumPellPeriod8"]];
  If[sumPellPeriodParity[ps1] != sumPellPeriodParity[ps2], AppendTo[distinguishers, "pellParity"]];
  If[countEvenPellPeriod[ps1] != countEvenPellPeriod[ps2], AppendTo[distinguishers, "countEvenPell"]];

  Print[""];
  Print["  Distinguishers: ", If[distinguishers == {}, "NONE", distinguishers]];
  Print[""];
  ,
  {i, Length[conflicts]}
];

(* Summary table *)
Print["=== SUMMARY TABLE ==="];
Print[""];
Print["ID | SS values | signedDist4 | floorSqrt4 | sumPellPeriod4 | COVERED?"];
Print["-" ~~ Table["-", 80]];
Do[
  psets = conflicts[[i, 1]];
  ssVals = conflicts[[i, 2]];
  sd4 = signedDist4 /@ psets;
  fs4 = floorSqrt4 /@ psets;
  pp4 = sumPellPeriod4 /@ psets;
  covered = (Length[DeleteDuplicates[sd4]] > 1) || (Length[DeleteDuplicates[fs4]] > 1) || (Length[DeleteDuplicates[pp4]] > 1);
  Print[i, " | ", ssVals, " | ", sd4, " | ", fs4, " | ", pp4, " | ", If[covered, "YES", "NO"]];
  ,
  {i, Length[conflicts]}
];

(* Try more Pell-related ideas *)
Print[""];
Print["=== ADDITIONAL PELL ANALYSIS ==="];
Print[""];

(* Regulator-related: norm of fundamental unit *)
(* For prime p ≡ 1 mod 4: p = a² + b² and fundamental unit related *)
(* For prime p ≡ 3 mod 4: different structure *)

Print["Prime classification by p mod 4:"];
Print["p ≡ 1 (mod 4): ", Select[primes, Mod[#, 4] == 1 &]];
Print["p ≡ 3 (mod 4): ", Select[primes, Mod[#, 4] == 3 &]];
Print[""];

(* Count primes ≡ 1 mod 4 *)
countPrimes1Mod4[ps_] := Count[ps, _?(Mod[#, 4] == 1 &)];
countPrimes3Mod4[ps_] := Count[ps, _?(Mod[#, 4] == 3 &)];

Print["Test countPrimes1Mod4 on conflicts:"];
Do[
  psets = conflicts[[i, 1]];
  c1 = countPrimes1Mod4 /@ psets;
  c3 = countPrimes3Mod4 /@ psets;
  Print["  Conflict ", i, ": count1mod4=", c1, " count3mod4=", c3,
        If[Length[DeleteDuplicates[c1]] > 1, " <- count1mod4 DIST", ""],
        If[Length[DeleteDuplicates[c3]] > 1, " <- count3mod4 DIST", ""]];
  ,
  {i, Length[conflicts]}
];
