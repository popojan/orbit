(* Analyze r via modular sum classes - using cached data *)

(* Load cached data *)
data = Import[FileNameJoin[{DirectoryName[$InputFileName], "omega4-data.mx"}]];
Print["Loaded ", Length[data], " entries"];

(* Compute ss for pairs and triples from formula *)
signSumPair[p_, q_] := 1 - 4*Mod[PowerMod[p, -1, q], 2];

signSumTriple[{p1_, p2_, p3_}] := Module[
  {b12, b13, b23, b1, b2, b3},
  b12 = Mod[PowerMod[p1, -1, p2], 2];
  b13 = Mod[PowerMod[p1, -1, p3], 2];
  b23 = Mod[PowerMod[p2, -1, p3], 2];
  b1 = Mod[PowerMod[p2 p3, -1, p1], 2];
  b2 = Mod[PowerMod[p1 p3, -1, p2], 2];
  b3 = Mod[PowerMod[p1 p2, -1, p3], 2];
  -1 + 4*(b12 + b13 + b23 - b1 - b2 - b3)
];

(* Compute derived quantities *)
computeR[d_] := Module[
  {ss, primes, p1, p2, p3, p4, sumPairs, sumTriples, sumBquad, residual, r},
  ss = d["ss"];
  primes = d["primes"];
  {p1, p2, p3, p4} = primes;

  sumPairs = signSumPair[p1,p2] + signSumPair[p1,p3] + signSumPair[p1,p4] +
             signSumPair[p2,p3] + signSumPair[p2,p4] + signSumPair[p3,p4];
  sumTriples = signSumTriple[{p1,p2,p3}] + signSumTriple[{p1,p2,p4}] +
               signSumTriple[{p1,p3,p4}] + signSumTriple[{p2,p3,p4}];
  sumBquad = Total[d["pattern"]["level4"]];

  residual = ss - (-10 + sumPairs + sumTriples + 4*sumBquad);
  r = (residual - 5)/4;

  <|"r" -> r,
    "lowBit" -> Mod[r, 2],
    "highBit" -> Quotient[r, 2],
    "sumL2" -> Total[d["pattern"]["level2"]],
    "sumL3" -> Total[d["pattern"]["level3"]],
    "sumL4" -> sumBquad,
    "level2" -> d["pattern"]["level2"],
    "level3" -> d["pattern"]["level3"],
    "level4" -> d["pattern"]["level4"]
  |>
];

derived = Table[computeR[d], {d, data}];
Print["r distribution: ", Tally[Sort[derived[[All, "r"]]]]];

(* Check if (sumL2 mod 4, sumL3 mod 4, sumL4 mod 4) determines r *)
modTriples = Table[{Mod[d["sumL2"], 4], Mod[d["sumL3"], 4], Mod[d["sumL4"], 4]}, {d, derived}];
rValues = derived[[All, "r"]];

groupedByModTriple = GroupBy[Transpose[{modTriples, rValues}], First -> Last];
conflicts = Select[groupedByModTriple, Length[DeleteDuplicates[#]] > 1 &];
Print["Unique (mod 4) triple patterns: ", Length[groupedByModTriple]];
Print["Conflicts: ", Length[conflicts]];

(* Try with (sumL2 mod 2, sumL3 mod 2, sumL4 mod 2) = XOR patterns *)
Print["\n=== XOR patterns (= sum mod 2) ==="];
xorTriples = Table[
  {Mod[d["sumL2"], 2], Mod[d["sumL3"], 2], Mod[d["sumL4"], 2]},
  {d, derived}
];
groupedByXor = GroupBy[Transpose[{xorTriples, rValues}], First -> Last];
conflictsXor = Select[groupedByXor, Length[DeleteDuplicates[#]] > 1 &];
Print["Unique XOR patterns: ", Length[groupedByXor]];
Print["Conflicts: ", Length[conflictsXor]];

Do[
  rDist = Tally[Sort[groupedByXor[key]]];
  Print[key, " -> r: ", rDist];
, {key, Sort[Keys[groupedByXor]]}];

(* Check if r = f(sumL2 mod 4, sumL4) *)
Print["\n=== r vs (sumL2 mod 4, sumL4) ==="];
pairs = Table[{Mod[d["sumL2"], 4], d["sumL4"]}, {d, derived}];
groupedByPair = GroupBy[Transpose[{pairs, rValues}], First -> Last];
conflictsPair = Select[groupedByPair, Length[DeleteDuplicates[#]] > 1 &];
Print["Unique pairs: ", Length[groupedByPair]];
Print["Conflicts: ", Length[conflictsPair]];

(* Try arithmetic formula: r = Floor[(sumL2 + offset) / 2] mod 2 + 2*Floor[...] *)
Print["\n=== Searching for quotient-based formula ==="];
Do[
  lowBitFormula = Table[Mod[Quotient[d["sumL2"] + a, 2] + Quotient[d["sumL4"] + b, 2], 2], {d, derived}];
  If[lowBitFormula == derived[[All, "lowBit"]],
    Print["FOUND lowBit = (Floor[(sumL2+", a, ")/2] + Floor[(sumL4+", b, ")/2]) mod 2"];
  ];
, {a, 0, 3}, {b, 0, 3}];

Do[
  highBitFormula = Table[Mod[Quotient[d["sumL2"] + a, 2] + Quotient[d["sumL4"] + b, 2], 2], {d, derived}];
  If[highBitFormula == derived[[All, "highBit"]],
    Print["FOUND highBit = (Floor[(sumL2+", a, ")/2] + Floor[(sumL4+", b, ")/2]) mod 2"];
  ];
, {a, 0, 3}, {b, 0, 3}];

Print["\nDone."];
