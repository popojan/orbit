(* Deep study: Distribution of ε (parity of modular inverse) *)

Print["=== Distribution of ε = parity(p⁻¹ mod q) ===\n"];

epsilon[p_, q_] := If[EvenQ[PowerMod[p, -1, q]], 1, 0];

(* Collect data for odd primes p < q *)
primes = Prime[Range[2, 50]];  (* 3 to 229 *)
Print["Primes: ", First[primes], " to ", Last[primes], "\n"];

data = Flatten[Table[
  If[p < q,
    {p, q, epsilon[p, q], Mod[p, 4], Mod[q, 4], Mod[p, 8], Mod[q, 8],
     JacobiSymbol[p, q], JacobiSymbol[q, p]},
    Nothing
  ],
  {p, primes}, {q, primes}
], 1];

Print["Total pairs: ", Length[data], "\n"];

(* Overall distribution *)
eps0 = Count[data, d_ /; d[[3]] == 0];
eps1 = Count[data, d_ /; d[[3]] == 1];
Print["ε = 0 (odd inverse): ", eps0, " (", N[100 eps0/Length[data], 4], "%)"];
Print["ε = 1 (even inverse): ", eps1, " (", N[100 eps1/Length[data], 4], "%)\n"];

(* By (p mod 4, q mod 4) *)
Print["=== By (p mod 4, q mod 4) ===\n"];
groups = GatherBy[data, {#[[4]], #[[5]]} &];
Do[
  g = groups[[i]];
  pMod = g[[1, 4]]; qMod = g[[1, 5]];
  e0 = Count[g, d_ /; d[[3]] == 0];
  e1 = Count[g, d_ /; d[[3]] == 1];
  Print["(", pMod, ", ", qMod, "): ε=0: ", e0, ", ε=1: ", e1,
        " (ratio: ", N[e1/(e0 + e1), 3], ")"],
  {i, Length[groups]}
];

(* By (p mod 8, q mod 8) *)
Print["\n=== By (p mod 8, q mod 8) - looking for finer structure ===\n"];
groups8 = GatherBy[data, {#[[6]], #[[7]]} &];
Print["(p%8, q%8)\tε=0\tε=1\tratio"];
Do[
  g = groups8[[i]];
  pMod = g[[1, 6]]; qMod = g[[1, 7]];
  e0 = Count[g, d_ /; d[[3]] == 0];
  e1 = Count[g, d_ /; d[[3]] == 1];
  If[e0 + e1 > 10,  (* only show groups with enough data *)
    Print["(", pMod, ", ", qMod, ")\t\t", e0, "\t", e1, "\t",
          NumberForm[N[e1/(e0 + e1)], {3, 2}]]
  ],
  {i, Length[groups8]}
];

(* Connection to Jacobi symbols *)
Print["\n=== Connection to Jacobi symbols ===\n"];
Print["Testing: ε vs (p|q), (q|p), and their product\n"];

(* By (p|q) *)
jacobiP = GatherBy[data, #[[8]] &];
Print["By (p|q):"];
Do[
  g = jacobiP[[i]];
  jp = g[[1, 8]];
  e0 = Count[g, d_ /; d[[3]] == 0];
  e1 = Count[g, d_ /; d[[3]] == 1];
  Print["  (p|q) = ", jp, ": ε=0: ", e0, ", ε=1: ", e1,
        " (ratio: ", N[e1/(e0 + e1), 3], ")"],
  {i, Length[jacobiP]}
];

(* By (q|p) *)
jacobiQ = GatherBy[data, #[[9]] &];
Print["\nBy (q|p):"];
Do[
  g = jacobiQ[[i]];
  jq = g[[1, 9]];
  e0 = Count[g, d_ /; d[[3]] == 0];
  e1 = Count[g, d_ /; d[[3]] == 1];
  Print["  (q|p) = ", jq, ": ε=0: ", e0, ", ε=1: ", e1,
        " (ratio: ", N[e1/(e0 + e1), 3], ")"],
  {i, Length[jacobiQ]}
];

(* By product (p|q)(q|p) = (-1)^{(p-1)(q-1)/4} *)
Print["\nBy (p|q)(q|p):"];
jacobiProd = GatherBy[data, #[[8]] * #[[9]] &];
Do[
  g = jacobiProd[[i]];
  prod = g[[1, 8]] * g[[1, 9]];
  e0 = Count[g, d_ /; d[[3]] == 0];
  e1 = Count[g, d_ /; d[[3]] == 1];
  Print["  (p|q)(q|p) = ", prod, ": ε=0: ", e0, ", ε=1: ", e1,
        " (ratio: ", N[e1/(e0 + e1), 3], ")"],
  {i, Length[jacobiProd]}
];

(* Look for exact formula *)
Print["\n=== Looking for exact patterns ===\n"];

(* Test: ε = f(p mod 8, q mod 8) *)
Print["Testing if ε is determined by (p mod 8, q mod 8, (p|q), (q|p))...\n"];

fullGroups = GatherBy[data, {#[[6]], #[[7]], #[[8]], #[[9]]} &];
constantCount = 0;
nonConstant = {};
Do[
  g = fullGroups[[i]];
  epsVals = Union[g[[All, 3]]];
  If[Length[epsVals] == 1,
    constantCount++,
    AppendTo[nonConstant, {g[[1, 6]], g[[1, 7]], g[[1, 8]], g[[1, 9]], epsVals, Length[g]}]
  ],
  {i, Length[fullGroups]}
];

Print["Total patterns: ", Length[fullGroups]];
Print["Constant ε: ", constantCount];
Print["Non-constant: ", Length[nonConstant]];

If[Length[nonConstant] > 0,
  Print["\nNon-constant patterns (p%8, q%8, (p|q), (q|p)):"];
  Do[Print["  ", nonConstant[[i]]], {i, Min[10, Length[nonConstant]]}]
];

(* Is there ANY deterministic pattern? *)
Print["\n=== Statistical summary ===\n"];
Print["If ε were truly random, we'd expect 50% each."];
Print["Observed: ", N[100 eps1/Length[data], 4], "% have ε=1"];

(* Chi-square test *)
expected = Length[data]/2;
chiSq = (eps0 - expected)^2/expected + (eps1 - expected)^2/expected;
Print["χ² statistic: ", N[chiSq, 4], " (>3.84 significant at p=0.05)"];
