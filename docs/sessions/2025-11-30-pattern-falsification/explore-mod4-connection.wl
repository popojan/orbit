(* Explore connection between indicators and k mod 4 *)

(* Indicators *)
signedDist[p_] := Module[{s = Floor[Sqrt[p]], dBelow, dAbove},
  dBelow = p - s^2;
  dAbove = (s+1)^2 - p;
  If[dBelow <= dAbove, dBelow, -dAbove]
];

signedDistSum[ps_] := Total[signedDist /@ ps];
floorSqrtSum[ps_] := Total[Floor[Sqrt[#]] & /@ ps];
pellPeriod[p_] := If[IntegerQ[Sqrt[p]], 0, Length[ContinuedFraction[Sqrt[p]][[2]]]];
pellPeriodSum[ps_] := Total[pellPeriod /@ ps];

(* Known conflicts *)
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

Print["=== Connection to k mod 4/8 ==="];
Print[""];

(* For product of odd primes:
   k ≡ 1 mod 4 if even number of primes ≡ 3 mod 4
   k ≡ 3 mod 4 if odd number of primes ≡ 3 mod 4 *)

countMod3of4[ps_] := Count[ps, _?(Mod[#, 4] == 3 &)];

Print["Analysis of each conflict:"];
Print[""];

Do[
  psets = conflicts[[i, 1]];
  ssVals = conflicts[[i, 2]];

  Print["--- Conflict ", i, " ---"];
  Print["SS values: ", ssVals];

  Do[
    ps = psets[[j]];
    k = Times @@ ps;
    c3 = countMod3of4[ps];

    Print["  Set ", j, ": ", ps];
    Print["    k = ", k];
    Print["    k mod 4 = ", Mod[k, 4], " (count p≡3: ", c3, ")"];
    Print["    k mod 8 = ", Mod[k, 8]];
    Print["    signedDistSum = ", signedDistSum[ps], " (mod 4: ", Mod[signedDistSum[ps], 4], ")"];
    Print["    floorSqrtSum = ", floorSqrtSum[ps], " (mod 4: ", Mod[floorSqrtSum[ps], 4], ")"];
    Print["    pellPeriodSum = ", pellPeriodSum[ps], " (mod 4: ", Mod[pellPeriodSum[ps], 4], ")"];
    ,
    {j, Length[psets]}
  ];
  Print[""];
  ,
  {i, Length[conflicts]}
];

(* Look for patterns: is there a formula? *)
Print["=== Pattern Search ==="];
Print[""];

Print["Hypothesis: Does (signedDistSum + floorSqrtSum) mod 4 relate to SS?"];
Do[
  psets = conflicts[[i, 1]];
  ssVals = conflicts[[i, 2]];

  combined = Table[
    Mod[signedDistSum[ps] + floorSqrtSum[ps], 4],
    {ps, psets}
  ];
  Print["Conflict ", i, ": SS=", ssVals, " combined=", combined];
  ,
  {i, Length[conflicts]}
];
Print[""];

Print["Hypothesis: Does signedDistSum relate to SS mod 4?"];
Do[
  psets = conflicts[[i, 1]];
  ssVals = conflicts[[i, 2]];

  sds = signedDistSum /@ psets;
  ssMod4 = Mod[#, 4] & /@ ssVals;
  Print["Conflict ", i, ": SS mod 4=", ssMod4, " signedDistSum=", sds, " (mod 4: ", Mod[sds, 4], ")"];
  ,
  {i, Length[conflicts]}
];
Print[""];

(* Key insight: for the 22-bit pattern to be the same,
   the products must have same "modular inverse structure"
   What additional info distinguishes SS? *)

Print["=== Deeper: What makes SS different? ==="];
Print[""];

(* SS counts (odd - even) among coprime residues *)
(* For k = p1*p2*p3*p4, coprime residues form group (Z/kZ)* *)
(* Size = phi(k) = (p1-1)(p2-1)(p3-1)(p4-1) *)

Print["Euler phi and SS:"];
Do[
  psets = conflicts[[i, 1]];
  ssVals = conflicts[[i, 2]];

  phiVals = EulerPhi[Times @@ #] & /@ psets;
  Print["Conflict ", i, ": SS=", ssVals, " phi(k)=", phiVals];
  ,
  {i, Length[conflicts]}
];
Print[""];

(* The signed distance to perfect square might encode
   information about quadratic residues *)

Print["=== Quadratic character connection ==="];
Print[""];

(* For p ≡ 1 mod 4: -1 is QR, so x² ≡ -1 solvable
   For p ≡ 3 mod 4: -1 is NQR *)

(* signedDist(p) is related to p - floor(sqrt(p))²
   which is the "defect" from being a perfect square *)

Print["Defect analysis (p - floor(sqrt(p))²):"];
primes = {3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47};
Print["p -> defect -> p mod 4:"];
Do[
  s = Floor[Sqrt[p]];
  defect = p - s^2;
  Print["  ", p, " -> ", defect, " (p mod 4 = ", Mod[p, 4], ", p mod 8 = ", Mod[p, 8], ")"];
  ,
  {p, primes}
];
Print[""];

(* Is there a pattern? defect = p - s² where s = floor(sqrt(p))
   s² < p < (s+1)² = s² + 2s + 1
   So 0 < defect < 2s + 1 *)

Print["=== Testing: Sum of defects mod 4 vs SS ==="];
defect[p_] := p - Floor[Sqrt[p]]^2;
defectSum[ps_] := Total[defect /@ ps];

Do[
  psets = conflicts[[i, 1]];
  ssVals = conflicts[[i, 2]];

  ds = defectSum /@ psets;
  Print["Conflict ", i, ": SS=", ssVals, " defectSum=", ds, " (mod 4: ", Mod[ds, 4], ", mod 8: ", Mod[ds, 8], ")"];
  ,
  {i, Length[conflicts]}
];
