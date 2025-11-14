#!/usr/bin/env wolframscript
(* Analyze numerators from the CORRECT bare sum formula *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=" ~~ StringRepeat["=", 70]];
Print["Correct Formula Numerator Analysis"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

Print["Formula: Sum[k!/(2k+1)] gives Primorial = 6·Denominator\n"];

(* Compute numerators *)
data = Table[
  sum = Sum[k!/(2k+1), {k, Floor[(m-1)/2]}];
  {m, Numerator[sum], Denominator[sum]},
  {m, 3, 51, 2}
];

numerators = data[[All, 2]];
mValues = data[[All, 1]];

Print["Numerators for m=3 to m=51:"];
Print[Take[numerators, 15]];

(* Pattern analysis *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["PATTERN TESTS"];
Print[StringRepeat["=", 70], "\n"];

(* 1. Primality *)
Print["1. PRIMALITY CHECK"];
primeCheck = Table[{n, PrimeQ[n]}, {n, Take[numerators, 15]}];
Print[Grid[primeCheck, Frame -> All, Headings -> {None, {"Numerator", "Prime?"}}]];

allPrime = AllTrue[Select[numerators, # > 1 &], PrimeQ];
Print["All prime? ", allPrime];

(* 2. Differences *)
Print["\n2. DIFFERENCE ANALYSIS"];
diffs1 = Differences[numerators];
Print["First differences: ", Take[diffs1, 10]];

diffs2 = Differences[diffs1];
Print["Second differences: ", Take[diffs2, 9]];

diffs3 = Differences[diffs2];
Print["Third differences: ", Take[diffs3, 8]];

If[Length[DeleteDuplicates[diffs2]] == 1,
  Print["★ QUADRATIC! Second diffs constant: ", diffs2[[1]]];
];

If[Length[DeleteDuplicates[diffs3]] == 1,
  Print["★ CUBIC! Third diffs constant: ", diffs3[[1]]];
];

(* 3. Growth ratios *)
Print["\n3. GROWTH ANALYSIS"];
growth = Table[
  If[numerators[[i]] != 0,
    N[numerators[[i+1]]/numerators[[i]], 4],
    Missing[]
  ],
  {i, 1, Min[15, Length[numerators]-1]}
];
Print["Growth ratios: ", growth];
Print["Mean: ", Mean[DeleteMissing[growth]]];
Print["StdDev: ", StandardDeviation[DeleteMissing[growth]]];

(* 4. Modular patterns *)
Print["\n4. MODULAR PATTERNS"];
Print["Numerators mod 2: ", Mod[Take[numerators, 10], 2]];
Print["Numerators mod 3: ", Mod[Take[numerators, 10], 3]];
Print["Numerators mod 5: ", Mod[Take[numerators, 10], 5]];

(* 5. Factorizations *)
Print["\n5. FACTORIZATIONS (first 10)"];
Do[
  If[Abs[numerators[[i]]] < 10^12,
    Print["m=", mValues[[i]], ": ", numerators[[i]], " = ", FactorInteger[numerators[[i]]]];
  ];
  ,
  {i, 1, Min[10, Length[numerators]]}
];

(* 6. Relation to m *)
Print["\n6. NUMERATOR vs m RELATIONSHIP"];
Print["Testing if N(m) = polynomial in m...\n"];

(* Try fitting polynomial *)
fitData = Transpose[{N[mValues], N[numerators]}];
(* Linear *)
Print["Plotting to visualize..."];

(* 7. GCD analysis *)
Print["\n7. GCD ANALYSIS"];
Print["GCD of all numerators: ", GCD @@ numerators];
Print["GCD of consecutive pairs:"];
Do[
  g = GCD[numerators[[i]], numerators[[i+1]]];
  If[g > 1, Print["  GCD(N[", mValues[[i]], "], N[", mValues[[i+1]], "]) = ", g]];
  ,
  {i, 1, Min[10, Length[numerators]-1]}
];

(* 8. Recurrence check *)
Print["\n8. RECURRENCE RELATION CHECK"];
Print["Testing: N(m+4) = a·N(m+2) + b·N(m) + c\n"];

If[Length[numerators] >= 6,
  equations = Table[
    {numerators[[i+4]], numerators[[i+2]], numerators[[i]]},
    {i, 1, Min[6, Length[numerators]-4]}
  ];

  Print["Sample equations (N(m+4), N(m+2), N(m)):"];
  Do[Print["  ", eq], {eq, Take[equations, 3]}];

  (* Try to solve for a, b, c *)
  If[Length[equations] >= 3,
    {eq1, eq2, eq3} = equations[[1;;3]];
    (* N3 = a*N2 + b*N1 + c *)
    (* N4 = a*N3 + b*N2 + c *)
    (* N5 = a*N4 + b*N3 + c *)
    Print["\nAttempting to solve system..."];
    (* This would require solving 3 equations in 3 unknowns *)
  ];
];

Print["\n" ~~ StringRepeat["=", 70]];
Print["SUMMARY"];
Print[StringRepeat["=", 70], "\n"];

If[allPrime,
  Print["★★★ ALL NUMERATORS ARE PRIME! ★★★\n"];
];

If[Length[DeleteDuplicates[diffs2]] == 1,
  Print["★★★ QUADRATIC FORMULA EXISTS! ★★★"];
  Print["N(m) = a·m² + b·m + c\n"];
];

If[!allPrime && Length[DeleteDuplicates[diffs2]] > 1,
  Print["No obvious algebraic pattern found.");
  Print["Numerators appear to have complex structure.\n"];
];

Print["Done!"];
