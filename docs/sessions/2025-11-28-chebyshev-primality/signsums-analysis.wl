(* Complete Σsigns analysis *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;

signSum[k_] := Module[{primLobes},
  primLobes = Select[Range[2, k-1], isPrimitiveLobe[#, k] &];
  Total[(-1)^(# - 1) & /@ primLobes]
];

(* Classify by number of prime factors (with multiplicity) *)
omega[k_] := Total[FactorInteger[k][[All, 2]]];  (* Ω(k) - total prime factors with multiplicity *)
smallOmega[k_] := Length[FactorInteger[k]];      (* ω(k) - distinct prime factors *)

Print["=== ΣSIGNS BY NUMBER OF DISTINCT PRIME FACTORS ===\n"];

(* Collect data *)
data = Table[
  {k, smallOmega[k], omega[k], signSum[k]},
  {k, Select[Range[3, 300], OddQ]}
];

(* Group by smallOmega *)
Do[
  subset = Select[data, #[[2]] == numFactors &];
  signsValues = Tally[subset[[All, 4]]] // Sort;
  Print["ω(k) = ", numFactors, " (", Length[subset], " numbers): Σsigns values = ", signsValues],
  {numFactors, 1, 4}
];

Print["\n=== PATTERN FOR ω(k) = 3 ===\n"];
subset3 = Select[data, #[[2]] == 3 &];
Do[
  {k, w, W, ss} = row;
  Print[k, " = ", Times @@ (Power @@@ FactorInteger[k]), ": Σsigns = ", ss],
  {row, Take[subset3, 15]}
];

Print["\n=== HYPOTHESIS: Σsigns ≡ 1 - 2*ω(k) (mod 4)? ===\n"];
Do[
  subset = Select[data, #[[2]] == numFactors &];
  predicted = 1 - 2 numFactors;
  actual = Mod[#[[4]], 4] & /@ subset // Tally;
  Print["ω(k) = ", numFactors, ": predicted ≡ ", Mod[predicted, 4], " (mod 4), actual = ", actual],
  {numFactors, 1, 4}
];

Print["\n=== ΣSIGNS FOR SQUAREFREE k ===\n"];
squarefree = Select[data, #[[3]] == #[[2]] &];  (* Ω = ω means squarefree *)
Do[
  subset = Select[squarefree, #[[2]] == numFactors &];
  signsValues = Tally[subset[[All, 4]]] // Sort;
  Print["Squarefree, ω(k) = ", numFactors, " (", Length[subset], " numbers): ", signsValues],
  {numFactors, 1, 4}
];

Print["\n=== ODD/EVEN PARITY OF Σsigns ===\n"];
parityTable = Table[
  {numFactors,
   Count[Select[data, #[[2]] == numFactors &], {_, _, _, x_} /; OddQ[x]],
   Count[Select[data, #[[2]] == numFactors &], {_, _, _, x_} /; EvenQ[x]]},
  {numFactors, 1, 4}
];
Print["ω(k) | #odd Σsigns | #even Σsigns"];
Do[Print[row[[1]], "    | ", row[[2]], "          | ", row[[3]]], {row, parityTable}];
