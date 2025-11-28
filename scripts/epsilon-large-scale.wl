(* Large-scale study: Distribution of ε (parity of modular inverse) *)

Print["=== LARGE SCALE: Distribution of ε = parity(p⁻¹ mod q) ===\n"];

epsilon[p_, q_] := If[EvenQ[PowerMod[p, -1, q]], 1, 0];

(* Use first 500 odd primes (3 to 3571) *)
primes = Prime[Range[2, 501]];
Print["Primes: ", First[primes], " to ", Last[primes], " (", Length[primes], " primes)\n"];

(* Collect data for odd primes p < q *)
Print["Computing ", Length[primes]*(Length[primes]-1)/2, " pairs..."];
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
Print["ε = 0 (odd inverse): ", eps0, " (", N[100 eps0/Length[data], 5], "%)"];
Print["ε = 1 (even inverse): ", eps1, " (", N[100 eps1/Length[data], 5], "%)"];

expected = Length[data]/2;
chiSq = (eps0 - expected)^2/expected + (eps1 - expected)^2/expected;
Print["χ² = ", N[chiSq, 4], " (p<0.05 if >3.84)\n"];

(* By (p mod 4, q mod 4) *)
Print["=== By (p mod 4, q mod 4) ===\n"];
groups = GatherBy[data, {#[[4]], #[[5]]} &];
Do[
  g = groups[[i]];
  pMod = g[[1, 4]]; qMod = g[[1, 5]];
  e0 = Count[g, d_ /; d[[3]] == 0];
  e1 = Count[g, d_ /; d[[3]] == 1];
  n = e0 + e1;
  ratio = N[e1/n, 5];
  se = N[Sqrt[0.25/n], 5];  (* standard error for proportion *)
  zscore = N[(ratio - 0.5)/se, 3];
  Print["(", pMod, ", ", qMod, "): n=", n, ", ε=1: ", NumberForm[100*ratio, {5,2}],
        "%, z=", zscore, If[Abs[zscore] > 2, " **", ""]],
  {i, Length[groups]}
];

(* By Jacobi (q|p) - the interesting one *)
Print["\n=== By (q|p) - Quadratic character ===\n"];
jacobiQ = GatherBy[data, #[[9]] &];
Do[
  g = jacobiQ[[i]];
  jq = g[[1, 9]];
  e0 = Count[g, d_ /; d[[3]] == 0];
  e1 = Count[g, d_ /; d[[3]] == 1];
  n = e0 + e1;
  ratio = N[e1/n, 5];
  se = N[Sqrt[0.25/n], 5];
  zscore = N[(ratio - 0.5)/se, 3];
  Print["(q|p) = ", If[jq == 1, "+1", "-1"], ": n=", n,
        ", ε=1: ", NumberForm[100*ratio, {5,2}], "%, z=", zscore,
        If[Abs[zscore] > 2, " **", ""]],
  {i, Length[jacobiQ]}
];

(* By (p|q) *)
Print["\n=== By (p|q) ===\n"];
jacobiP = GatherBy[data, #[[8]] &];
Do[
  g = jacobiP[[i]];
  jp = g[[1, 8]];
  e0 = Count[g, d_ /; d[[3]] == 0];
  e1 = Count[g, d_ /; d[[3]] == 1];
  n = e0 + e1;
  ratio = N[e1/n, 5];
  se = N[Sqrt[0.25/n], 5];
  zscore = N[(ratio - 0.5)/se, 3];
  Print["(p|q) = ", If[jp == 1, "+1", "-1"], ": n=", n,
        ", ε=1: ", NumberForm[100*ratio, {5,2}], "%, z=", zscore,
        If[Abs[zscore] > 2, " **", ""]],
  {i, Length[jacobiP]}
];

(* Combined Jacobi product *)
Print["\n=== By (p|q)(q|p) = (-1)^{(p-1)(q-1)/4} ===\n"];
jacobiProd = GatherBy[data, #[[8]] * #[[9]] &];
Do[
  g = jacobiProd[[i]];
  prod = g[[1, 8]] * g[[1, 9]];
  e0 = Count[g, d_ /; d[[3]] == 0];
  e1 = Count[g, d_ /; d[[3]] == 1];
  n = e0 + e1;
  ratio = N[e1/n, 5];
  se = N[Sqrt[0.25/n], 5];
  zscore = N[(ratio - 0.5)/se, 3];
  Print["(p|q)(q|p) = ", If[prod == 1, "+1", "-1"], ": n=", n,
        ", ε=1: ", NumberForm[100*ratio, {5,2}], "%, z=", zscore,
        If[Abs[zscore] > 2, " **", ""]],
  {i, Length[jacobiProd]}
];

(* Deeper: by (p mod 8, q mod 8) *)
Print["\n=== By (p mod 8, q mod 8) - Top deviations ===\n"];
groups8 = GatherBy[data, {#[[6]], #[[7]]} &];
deviations = Table[
  g = groups8[[i]];
  pMod = g[[1, 6]]; qMod = g[[1, 7]];
  e0 = Count[g, d_ /; d[[3]] == 0];
  e1 = Count[g, d_ /; d[[3]] == 1];
  n = e0 + e1;
  ratio = N[e1/n, 5];
  se = N[Sqrt[0.25/n], 5];
  zscore = N[(ratio - 0.5)/se, 4];
  {pMod, qMod, n, ratio, zscore},
  {i, Length[groups8]}
];

sorted = SortBy[deviations, -Abs[#[[5]]] &];
Print["(p%8, q%8)\tn\tε=1%\tz-score"];
Do[
  {pMod, qMod, n, ratio, z} = sorted[[i]];
  Print["(", pMod, ", ", qMod, ")\t\t", n, "\t",
        NumberForm[100*ratio, {4, 1}], "%\t", NumberForm[z, {4, 2}],
        If[Abs[z] > 3, " ***", If[Abs[z] > 2, " **", ""]]],
  {i, Min[16, Length[sorted]]}
];

(* Test for systematic pattern *)
Print["\n=== Correlation test ===\n"];

(* Compute point-biserial correlation between ε and (q|p) *)
epsVals = data[[All, 3]];
qpVals = data[[All, 9]];
corr = Correlation[N[epsVals], N[qpVals]];
Print["Correlation(ε, (q|p)): r = ", NumberForm[corr, 4]];

(* Expected vs observed *)
Print["\n=== Chi-square for (q|p) vs ε ===\n"];
contingency = {{
  Count[data, d_ /; d[[9]] == -1 && d[[3]] == 0],
  Count[data, d_ /; d[[9]] == -1 && d[[3]] == 1]
}, {
  Count[data, d_ /; d[[9]] == 1 && d[[3]] == 0],
  Count[data, d_ /; d[[9]] == 1 && d[[3]] == 1]
}};
Print["Contingency table:"];
Print["           ε=0    ε=1"];
Print["(q|p)=-1  ", contingency[[1, 1]], "   ", contingency[[1, 2]]];
Print["(q|p)=+1  ", contingency[[2, 1]], "   ", contingency[[2, 2]]];

total = Total[Flatten[contingency]];
rowSums = Total /@ contingency;
colSums = Total[contingency];
expected2 = Outer[Times, rowSums, colSums]/total;
chiSq2 = Total[Flatten[(contingency - expected2)^2/expected2]];
Print["\nχ² = ", NumberForm[chiSq2, 5], " (df=1, p<0.001 if >10.83)"];
