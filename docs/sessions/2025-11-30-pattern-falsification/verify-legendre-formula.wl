(* Verify: SS(p*q) = 2*Legendre(q,p) - 1 for all semiprimes *)

signSumSemiprime[p_, q_] := Module[{k = p*q, valid},
  valid = Select[Range[k], GCD[#, k] == 1 && GCD[# - 1, k] == 1 &];
  Total[If[OddQ[#], 1, -1] & /@ valid]
];

Print["=== TESTING THEOREM: SS(p*q) = 2*Legendre(q,p) - 1 ===\n"];

(* Test for various p *)
totalTests = 0;
correct = 0;

Do[
  p = Prime[i];
  localCorrect = 0;
  localTotal = 0;
  Do[
    q = Prime[j];
    ss = signSumSemiprime[p, q];
    legendre = JacobiSymbol[q, p];
    predicted = 2*legendre - 1;

    localTotal++;
    If[predicted == ss, localCorrect++];
    totalTests++;
    If[predicted == ss, correct++],
    {j, i + 1, Min[i + 30, 50]}
  ];
  Print["p = ", p, ": ", localCorrect, "/", localTotal, " correct"],
  {i, 2, 15}
];

Print["\n=== TOTAL: ", correct, "/", totalTests, " ==="];

(* If that doesn't work, try the symmetric version *)
Print["\n=== ALTERNATIVE: SS(p*q) = 2*Legendre(p,q) - 1 ===\n"];

correct2 = 0;
Do[
  p = Prime[i]; q = Prime[j];
  ss = signSumSemiprime[p, q];
  legendre = JacobiSymbol[p, q];
  predicted = 2*legendre - 1;
  If[predicted == ss, correct2++],
  {i, 2, 15}, {j, i + 1, Min[i + 30, 50]}
];
Print["Total: ", correct2, "/", totalTests];

(* Try the product *)
Print["\n=== ALTERNATIVE: SS(p*q) = 2*Legendre(p,q)*Legendre(q,p) - 1 ===\n"];

correct3 = 0;
Do[
  p = Prime[i]; q = Prime[j];
  ss = signSumSemiprime[p, q];
  legendreProd = JacobiSymbol[p, q] * JacobiSymbol[q, p];
  predicted = 2*legendreProd - 1;
  If[predicted == ss, correct3++],
  {i, 2, 15}, {j, i + 1, Min[i + 30, 50]}
];
Print["Total: ", correct3, "/", totalTests];

(* More specific analysis - look at failures *)
Print["\n=== Detailed Analysis of Pattern ===\n"];

(* For each p, what's the pattern? *)
Do[
  p = Prime[i];
  Print["\n--- p = ", p, " ---"];
  results = Table[
    {Prime[j], signSumSemiprime[p, Prime[j]], JacobiSymbol[Prime[j], p]},
    {j, i + 1, Min[i + 15, 35]}
  ];
  (* Group by Legendre symbol *)
  leg1 = Select[results, #[[3]] == 1 &];
  legM1 = Select[results, #[[3]] == -1 &];
  Print["Legendre(q,p) = 1: SS values = ", Union[leg1[[All, 2]]]];
  Print["Legendre(q,p) = -1: SS values = ", Union[legM1[[All, 2]]]],
  {i, 2, 8}
];

(* THE TRUTH: It might be more complex *)
Print["\n=== Is it q mod p? ===\n"];

(* For p=3: q mod 3 determines SS perfectly *)
(* For p=5: does q mod 5 determine SS? *)
p = 5;
Print["p = ", p, ":"];
results5 = Table[
  {Prime[j], Mod[Prime[j], 5], signSumSemiprime[5, Prime[j]]},
  {j, 4, 50}
];
byMod5 = GroupBy[results5, #[[2]] &];
Do[
  If[KeyExistsQ[byMod5, r],
    Print["q ≡ ", r, " (mod 5): SS = ", Union[byMod5[r][[All, 3]]]]
  ],
  {r, {1, 2, 3, 4}}
];

(* For p=7 *)
p = 7;
Print["\np = ", p, ":"];
results7 = Table[
  {Prime[j], Mod[Prime[j], 7], signSumSemiprime[7, Prime[j]]},
  {j, 5, 50}
];
byMod7 = GroupBy[results7, #[[2]] &];
Do[
  If[KeyExistsQ[byMod7, r],
    Print["q ≡ ", r, " (mod 7): SS = ", Union[byMod7[r][[All, 3]]]]
  ],
  {r, Range[1, 6]}
];

(* Key insight: quadratic residues! *)
Print["\n=== QUADRATIC RESIDUE HYPOTHESIS ==="];
Print["SS(p*q) = 1 iff q is QR mod p"];
Print["SS(p*q) = -3 iff q is NQR mod p\n"];

allCorrect = True;
Do[
  p = Prime[i];
  Do[
    q = Prime[j];
    ss = signSumSemiprime[p, q];
    isQR = (JacobiSymbol[q, p] == 1);
    predicted = If[isQR, 1, -3];
    If[predicted != ss,
      Print["FAILURE at p=", p, ", q=", q, ": SS=", ss, ", QR=", isQR];
      allCorrect = False;
    ],
    {j, i + 1, Min[i + 50, 100]}
  ],
  {i, 2, 20}
];
If[allCorrect, Print["*** ALL TESTS PASSED! ***"]];
