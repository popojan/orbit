(* Generate and save ω=4 data for experiments *)
(* This precomputes signSum values which are expensive *)

(* Core functions *)
signSumNaive[k_] := Count[#, _?OddQ] - Count[#, _?EvenQ] & @
  Select[Range[2, k-1], GCD[#-1, k] == 1 && GCD[#, k] == 1 &];

tripleB[{p1_, p2_, p3_}] := {
  Mod[PowerMod[p2 p3, -1, p1], 2],
  Mod[PowerMod[p1 p3, -1, p2], 2],
  Mod[PowerMod[p1 p2, -1, p3], 2]
};

computeHierarchicalPattern[{p1_, p2_, p3_, p4_}] := Module[
  {level2, level3, level4, t123, t124, t134, t234},

  (* Level 2: 6 pairwise inverse parities *)
  level2 = {
    Mod[PowerMod[p1, -1, p2], 2], Mod[PowerMod[p1, -1, p3], 2],
    Mod[PowerMod[p1, -1, p4], 2], Mod[PowerMod[p2, -1, p3], 2],
    Mod[PowerMod[p2, -1, p4], 2], Mod[PowerMod[p3, -1, p4], 2]
  };

  (* Level 3: 4 triple b-vectors, 12 components total *)
  t123 = tripleB[{p1, p2, p3}];
  t124 = tripleB[{p1, p2, p4}];
  t134 = tripleB[{p1, p3, p4}];
  t234 = tripleB[{p2, p3, p4}];
  level3 = Join[t123, t124, t134, t234];

  (* Level 4: quadruple b-vector, 4 components *)
  level4 = {
    Mod[PowerMod[p2 p3 p4, -1, p1], 2],
    Mod[PowerMod[p1 p3 p4, -1, p2], 2],
    Mod[PowerMod[p1 p2 p4, -1, p3], 2],
    Mod[PowerMod[p1 p2 p3, -1, p4], 2]
  };

  <|"level2" -> level2, "level3" -> level3, "level4" -> level4|>
];

(* Configuration *)
numPrimes = 15; (* Increase for more data: C(15,4) = 1365 products *)
primes = Prime[Range[2, numPrimes + 1]]; (* Odd primes starting from 3 *)

Print["Generating ω=4 data..."];
Print["Using ", Length[primes], " primes: ", primes];
Print["Expected products: ", Binomial[Length[primes], 4]];

(* Generate data *)
data = {};
counter = 0;
total = Binomial[Length[primes], 4];

Do[
  If[p1 < p2 < p3 < p4,
    counter++;
    If[Mod[counter, 100] == 0, Print["Progress: ", counter, "/", total]];

    k = p1 p2 p3 p4;
    ss = signSumNaive[k];  (* The expensive computation *)
    pattern = computeHierarchicalPattern[{p1, p2, p3, p4}];

    AppendTo[data, <|
      "primes" -> {p1, p2, p3, p4},
      "k" -> k,
      "ss" -> ss,
      "f" -> (ss - 1)/4,
      "pattern" -> pattern
    |>];
  ],
  {p1, primes}, {p2, primes}, {p3, primes}, {p4, primes}
];

Print["Generated ", Length[data], " entries"];

(* Save to file *)
outputFile = FileNameJoin[{DirectoryName[$InputFileName], "omega4-data.mx"}];
Export[outputFile, data];
Print["Saved to: ", outputFile];

(* Also save metadata *)
metadata = <|
  "numPrimes" -> numPrimes,
  "primes" -> primes,
  "numProducts" -> Length[data],
  "ssRange" -> MinMax[data[[All, "ss"]]],
  "fRange" -> MinMax[data[[All, "f"]]],
  "generated" -> DateString[]
|>;
metaFile = FileNameJoin[{DirectoryName[$InputFileName], "omega4-metadata.m"}];
Put[metadata, metaFile];
Print["Metadata saved to: ", metaFile];

Print["Done!"];
