(* Deep analysis of odd semiprimes pq *)

Print["=== Odd Semiprimes: What determines Σsigns? ===\n"];

signSum[k_] := Module[{prims},
  prims = Select[Range[2, k-1], GCD[#-1, k] == 1 && GCD[#, k] == 1 &];
  Total[(-1)^(# - 1) & /@ prims]
];

(* CRT parities *)
bVector[{p_, q_}] := {
  Mod[q * PowerMod[q, -1, p], 2],
  Mod[p * PowerMod[p, -1, q], 2]
};

(* Collect data for odd semiprimes *)
oddSemiprimes = Select[Range[15, 500, 2],
  PrimeNu[#] == 2 && OddQ[#] && SquareFreeQ[#] &];

Print["Analyzing ", Length[oddSemiprimes], " odd semiprimes\n"];

data = Table[
  {p, q} = FactorInteger[k][[All, 1]];
  b = bVector[{p, q}];
  ss = signSum[k];
  pMod4 = Mod[p, 4];
  qMod4 = Mod[q, 4];
  {k, p, q, pMod4, qMod4, b[[1]], b[[2]], ss},
  {k, oddSemiprimes}
];

(* Group by (p mod 4, q mod 4) *)
Print["=== By (p mod 4, q mod 4) ===\n"];

groups = GatherBy[data, {#[[4]], #[[5]]} &];
Do[
  g = groups[[i]];
  pMod = g[[1, 4]];
  qMod = g[[1, 5]];
  ssVals = g[[All, 8]];
  Print["(p≡", pMod, ", q≡", qMod, ") mod 4: ",
        Length[g], " cases, Σsigns ∈ ", Union[ssVals]],
  {i, Length[groups]}
];

(* Group by b-vector *)
Print["\n=== By b-vector (b₁, b₂) ===\n"];

bGroups = GatherBy[data, {#[[6]], #[[7]]} &];
Do[
  g = bGroups[[i]];
  b1 = g[[1, 6]];
  b2 = g[[1, 7]];
  ssVals = g[[All, 8]];
  Print["b = (", b1, ", ", b2, "): ",
        Length[g], " cases, Σsigns ∈ ", Union[ssVals]],
  {i, Length[bGroups]}
];

(* Combined: (p mod 4, q mod 4, b) *)
Print["\n=== Full pattern: (p mod 4, q mod 4, b₁, b₂) → Σsigns ===\n"];

fullGroups = GatherBy[data, {#[[4]], #[[5]], #[[6]], #[[7]]} &];
Print["Pattern\t\t\t\tCases\tΣsigns"];
Print["(p%4, q%4, b₁, b₂)"];
Print["----------------------------------------"];
Do[
  g = fullGroups[[i]];
  key = {g[[1, 4]], g[[1, 5]], g[[1, 6]], g[[1, 7]]};
  ssVals = Union[g[[All, 8]]];
  Print[key, "\t\t", Length[g], "\t", ssVals],
  {i, Length[fullGroups]}
];

(* Check: does b alone determine Σsigns? *)
Print["\n=== Does b-vector alone determine Σsigns? ===\n"];

uniqueB = Length[bGroups];
constantB = Count[bGroups, g_ /; Length[Union[g[[All, 8]]]] == 1];
Print["b-patterns: ", uniqueB];
Print["Constant Σsigns: ", constantB, "/", uniqueB];

If[constantB == uniqueB,
  Print["\n*** YES! b-vector determines Σsigns for odd semiprimes! ***\n"];
  Print["Formula:"];
  Do[
    g = bGroups[[i]];
    Print["  b = (", g[[1, 6]], ", ", g[[1, 7]], ") → Σsigns = ", g[[1, 8]]],
    {i, Length[bGroups]}
  ],
  Print["\nNO - need more than b-vector."]
];

(* Simpler formula? *)
Print["\n=== Looking for closed form ===\n"];
Print["Testing: Σsigns = a + 4*(b₁*x + b₂*y + b₁*b₂*z)\n"];

(* Extract unique patterns *)
patterns = Table[
  g = bGroups[[i]];
  {g[[1, 6]], g[[1, 7]], g[[1, 8]]},
  {i, Length[bGroups]}
];

Print["Patterns: ", patterns];

(* Solve for coefficients if possible *)
(* Σsigns = a - 4*b₁ - 4*b₂? *)
Print["\nTrying Σsigns = 1 - 4*b₂:"];
Do[
  {b1, b2, ss} = patterns[[i]];
  pred = 1 - 4*b2;
  Print["  b=(", b1, ",", b2, "): predicted ", pred, ", actual ", ss,
        If[pred == ss, " ✓", " ✗"]],
  {i, Length[patterns]}
];

Print["\nTrying Σsigns = 1 - 4*b₁:"];
Do[
  {b1, b2, ss} = patterns[[i]];
  pred = 1 - 4*b1;
  Print["  b=(", b1, ",", b2, "): predicted ", pred, ", actual ", ss,
        If[pred == ss, " ✓", " ✗"]],
  {i, Length[patterns]}
];

Print["\nTrying Σsigns = -1 - 2*b₁ - 2*b₂ + 4*b₁*b₂:"];
Do[
  {b1, b2, ss} = patterns[[i]];
  pred = -1 - 2*b1 - 2*b2 + 4*b1*b2;
  Print["  b=(", b1, ",", b2, "): predicted ", pred, ", actual ", ss,
        If[pred == ss, " ✓", " ✗"]],
  {i, Length[patterns]}
];
