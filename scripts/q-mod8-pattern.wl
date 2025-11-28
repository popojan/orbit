(* Investigate the q mod 8 pattern *)

Print["=== Pattern by q mod 8 ===\n"];

epsilon[p_, q_] := If[EvenQ[PowerMod[p, -1, q]], 1, 0];

(* Collect data grouped by (p mod 8, q mod 8) *)
primes = Prime[Range[2, 300]];  (* 3 to ~2000 *)

data = Flatten[Table[
  If[p < q,
    {p, q, epsilon[p, q], Mod[p, 8], Mod[q, 8], JacobiSymbol[q, p]},
    Nothing
  ],
  {p, primes}, {q, primes}
], 1];

Print["Total pairs: ", Length[data], "\n"];

(* For each q mod 8, what's the correlation with (q|p)? *)
Print["=== By q mod 8: correlation (q|p) vs ε ===\n"];

qMod8Groups = GatherBy[data, #[[5]] &];
Print["q%8\tn\t(q|p)=-1 → ε=1%\t(q|p)=+1 → ε=1%\tΔ\tz"];
Print["---------------------------------------------------------------"];

Do[
  g = qMod8Groups[[i]];
  qMod = g[[1, 5]];

  nrData = Select[g, #[[6]] == -1 &];
  qrData = Select[g, #[[6]] == 1 &];

  nrEps1 = Count[nrData, d_ /; d[[3]] == 1];
  qrEps1 = Count[qrData, d_ /; d[[3]] == 1];

  nrPct = N[nrEps1/Length[nrData], 5];
  qrPct = N[qrEps1/Length[qrData], 5];

  delta = nrPct - qrPct;
  pooledP = (nrEps1 + qrEps1)/(Length[nrData] + Length[qrData]);
  se = Sqrt[pooledP*(1 - pooledP)*(1/Length[nrData] + 1/Length[qrData])];
  z = If[se > 0, delta/se, 0];

  Print[qMod, "\t", Length[g], "\t", NumberForm[100*nrPct, {4, 1}], "%\t\t\t",
        NumberForm[100*qrPct, {4, 1}], "%\t\t\t",
        NumberForm[100*delta, {4, 1}], "%\t",
        NumberForm[z, {4, 2}], If[Abs[z] > 2, " **", ""]],
  {i, Length[qMod8Groups]}
];

(* Now the full (p mod 8, q mod 8) breakdown *)
Print["\n=== Full (p mod 8, q mod 8) breakdown ===\n"];
Print["(p%8,q%8)\tn\t(q|p)=-1→ε=1%\t(q|p)=+1→ε=1%\tΔ%\tz"];
Print["----------------------------------------------------------------"];

fullGroups = GatherBy[data, {#[[4]], #[[5]]} &];
results = Table[
  g = fullGroups[[i]];
  pMod = g[[1, 4]]; qMod = g[[1, 5]];

  nrData = Select[g, #[[6]] == -1 &];
  qrData = Select[g, #[[6]] == 1 &];

  If[Length[nrData] > 10 && Length[qrData] > 10,
    nrEps1 = Count[nrData, d_ /; d[[3]] == 1];
    qrEps1 = Count[qrData, d_ /; d[[3]] == 1];

    nrPct = N[nrEps1/Length[nrData], 4];
    qrPct = N[qrEps1/Length[qrData], 4];

    delta = nrPct - qrPct;
    pooledP = (nrEps1 + qrEps1)/(Length[nrData] + Length[qrData]);
    se = Sqrt[pooledP*(1 - pooledP)*(1/Length[nrData] + 1/Length[qrData])];
    z = If[se > 0, delta/se, 0];

    {pMod, qMod, Length[g], nrPct, qrPct, delta, z},
    Nothing
  ],
  {i, Length[fullGroups]}
];

(* Sort by absolute z-score *)
sorted = SortBy[results, -Abs[#[[7]]] &];
Do[
  {pMod, qMod, n, nrPct, qrPct, delta, z} = sorted[[i]];
  Print["(", pMod, ",", qMod, ")\t\t", n, "\t",
        NumberForm[100*nrPct, {4, 1}], "%\t\t",
        NumberForm[100*qrPct, {4, 1}], "%\t\t",
        NumberForm[100*delta, {4, 1}], "%\t",
        NumberForm[z, {4, 2}],
        If[Abs[z] > 3, " ***", If[Abs[z] > 2, " **", ""]]],
  {i, Min[16, Length[sorted]]}
];

(* Key insight test *)
Print["\n=== Key pattern: (3,7) vs (7,3) and (5,7) vs (7,5) ===\n"];

test37 = Select[data, #[[4]] == 3 && #[[5]] == 7 &];
test73 = Select[data, #[[4]] == 7 && #[[5]] == 3 &];
test57 = Select[data, #[[4]] == 5 && #[[5]] == 7 &];
test75 = Select[data, #[[4]] == 7 && #[[5]] == 5 &];

analyze[d_, name_] := Module[{nrD, qrD},
  nrD = Select[d, #[[6]] == -1 &];
  qrD = Select[d, #[[6]] == 1 &];
  Print[name, ": NR→ε=1: ", N[100*Count[nrD, x_ /; x[[3]] == 1]/Length[nrD], 3],
        "%, QR→ε=1: ", N[100*Count[qrD, x_ /; x[[3]] == 1]/Length[qrD], 3], "%"]
];

analyze[test37, "(3,7)"];
analyze[test73, "(7,3)"];
analyze[test57, "(5,7)"];
analyze[test75, "(7,5)"];
