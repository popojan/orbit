(* Test different aggregations and bit counts *)

signedDist[p_] := Module[{s = Floor[Sqrt[p]], d},
  d = p - s^2;
  If[d <= s, d, d - 2*s - 1]
];

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

Print["=== PELL CLARIFICATION ==="];
Print[""];

(* Show CF structure for small primes *)
Print["Continued fraction structure:"];
Do[
  cf = ContinuedFraction[Sqrt[p]];
  a0 = cf[[1]];  (* = floor(sqrt(p)) *)
  period = cf[[2]];
  convs = Convergents[Sqrt[p], Length[period] + 2];

  (* Fundamental solution comes from convergent at end of first period *)
  (* For x² - py² = 1: use convergent p_{r-1}/q_{r-1} where r = period length *)
  Print["√", p, " = [", a0, "; ", period, "]"];
  Print["  floor(√p) = ", a0];
  Print["  Period length = ", Length[period]];
  Print["  Convergents: ", Take[convs, Min[4, Length[convs]]]];

  (* Check Pell equation *)
  If[Length[period] > 0,
    fundConv = convs[[Length[period]]];
    x1 = Numerator[fundConv];
    y1 = Denominator[fundConv];
    pellVal = x1^2 - p * y1^2;
    Print["  Fundamental: x=", x1, ", y=", y1, ", x²-", p, "y²=", pellVal];
  ];
  Print[""];
  ,
  {p, {2, 3, 5, 7, 11, 13}}
];

Print["=== AGGREGATION TESTS ==="];
Print[""];

(* Different aggregations to test *)
(* 1. Sum mod 4 (current) *)
sumMod4[ps_, f_] := Mod[Total[f /@ ps], 4];
sumMod8[ps_, f_] := Mod[Total[f /@ ps], 8];

(* 2. Product mod 4 *)
prodMod4[ps_, f_] := Mod[Times @@ (f /@ ps), 4];

(* 3. XOR of individual values mod 4 *)
xorMod4[ps_, f_] := BitXor @@ (Mod[f /@ ps, 4]);

(* 4. Sorted tuple (more bits but exact) *)
sortedTuple[ps_, f_] := Sort[f /@ ps];

(* 5. Count by residue class *)
countByResidue[ps_, f_, m_] := Table[Count[Mod[f /@ ps, m], r], {r, 0, m-1}];

Print["Testing aggregations for signedDist:"];
Print[""];

testAggregation[name_, agg_] := Module[{covered = 0},
  Print[name, ":"];
  Do[
    psets = conflicts[[i, 1]];
    vals = agg /@ psets;
    dist = Length[DeleteDuplicates[vals]] > 1;
    If[dist, covered++];
    Print["  ", i, ": ", vals, If[dist, " ✓", ""]];
    ,
    {i, Length[conflicts]}
  ];
  Print["  Covered: ", covered, "/10"];
  Print[""];
];

testAggregation["Sum mod 4", sumMod4[#, signedDist] &];
testAggregation["Sum mod 8", sumMod8[#, signedDist] &];
testAggregation["Product mod 4", prodMod4[#, signedDist] &];
testAggregation["XOR mod 4", xorMod4[#, signedDist] &];
testAggregation["Count by residue mod 4", countByResidue[#, signedDist, 4] &];

Print["Testing aggregations for floor(√p):"];
Print[""];

floorSqrt[p_] := Floor[Sqrt[p]];

testAggregation["Sum mod 4", sumMod4[#, floorSqrt] &];
testAggregation["Sum mod 8", sumMod8[#, floorSqrt] &];
testAggregation["Product mod 4", prodMod4[#, floorSqrt] &];
testAggregation["XOR mod 4", xorMod4[#, floorSqrt] &];

Print["=== BIT COUNT ANALYSIS ==="];
Print[""];

Print["Current scheme:"];
Print["  22-bit hierarchical pattern"];
Print["  + signedDist4 (2 bits: mod 4)"];
Print["  + floorSqrt4 (2 bits: mod 4)"];
Print["  = 26 bits total"];
Print[""];

Print["With mod 8:"];
Print["  22-bit + signedDist8 (3 bits) + floorSqrt8 (3 bits) = 28 bits"];
Print[""];

(* Test if mod 8 helps *)
Print["Does mod 8 help?"];
signedDist8[ps_] := Mod[Total[signedDist /@ ps], 8];
floorSqrt8[ps_] := Mod[Total[Floor[Sqrt[#]] & /@ ps], 8];

Print["Conflicts where mod 4 fails but mod 8 might help:"];
Do[
  psets = conflicts[[i, 1]];
  sd4 = Mod[Total[signedDist /@ #], 4] & /@ psets;
  fs4 = Mod[Total[Floor[Sqrt[#]] & /@ #], 4] & /@ psets;
  sd8 = signedDist8 /@ psets;
  fs8 = floorSqrt8 /@ psets;

  sd4Dist = Length[DeleteDuplicates[sd4]] > 1;
  fs4Dist = Length[DeleteDuplicates[fs4]] > 1;
  sd8Dist = Length[DeleteDuplicates[sd8]] > 1;
  fs8Dist = Length[DeleteDuplicates[fs8]] > 1;

  If[!sd4Dist && !fs4Dist,
    Print["Conflict ", i, " (not covered by mod 4):"];
    Print["  sd4=", sd4, " fs4=", fs4];
    Print["  sd8=", sd8, If[sd8Dist, " ✓", ""], " fs8=", fs8, If[fs8Dist, " ✓", ""]];
  ];
  ,
  {i, Length[conflicts]}
];
Print[""];

(* Optimal bit allocation? *)
Print["=== SEARCHING FOR MINIMAL BIT SCHEME ==="];
Print[""];

(* What's the minimum we need? *)
(* Test: just signedDist with different moduli *)
Print["signedDist alone with various moduli:"];
Do[
  covered = 0;
  Do[
    psets = conflicts[[i, 1]];
    vals = Mod[Total[signedDist /@ #], m] & /@ psets;
    If[Length[DeleteDuplicates[vals]] > 1, covered++];
    ,
    {i, Length[conflicts]}
  ];
  Print["  mod ", m, " (", Ceiling[Log2[m]], " bits): ", covered, "/10"];
  ,
  {m, {2, 4, 8, 16, 32}}
];
Print[""];

Print["floorSqrt alone with various moduli:"];
Do[
  covered = 0;
  Do[
    psets = conflicts[[i, 1]];
    vals = Mod[Total[Floor[Sqrt[#]] & /@ #], m] & /@ psets;
    If[Length[DeleteDuplicates[vals]] > 1, covered++];
    ,
    {i, Length[conflicts]}
  ];
  Print["  mod ", m, " (", Ceiling[Log2[m]], " bits): ", covered, "/10"];
  ,
  {m, {2, 4, 8, 16, 32}}
];
