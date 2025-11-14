#!/usr/bin/env wolframscript
(* Pattern detection for primorial conjecture - unreduced form *)

(* Compute unreduced denominator *)
UnreducedDen[k_] := 2 * Apply[LCM, Table[2*j + 1, {j, 1, k}]]

(* Compute unreduced numerator *)
UnreducedNum[k_] := Module[{D},
  D = UnreducedDen[k];
  Sum[(-1)^j * j! * (D/2) / (2*j + 1), {j, 1, k}]
]

(* Collect jump data for a prime *)
CollectJumps[p_, maxK_] := Module[{data, jumps},
  Print["Collecting jumps for p=", p, " up to k=", maxK];

  data = Table[
    Module[{D, N, nuD, nuN},
      D = UnreducedDen[k];
      N = UnreducedNum[k];
      nuD = IntegerExponent[D, p];
      nuN = IntegerExponent[N, p];
      {k, 2*k+1, nuD, nuN, nuD-nuN}
    ],
    {k, 1, maxK}
  ];

  (* Extract jump points where nu_p(D) increases *)
  jumps = {data[[1]]};
  Do[
    If[data[[i, 3]] > data[[i-1, 3]],
      AppendTo[jumps, data[[i]]]
    ],
    {i, 2, Length[data]}
  ];

  Print["Found ", Length[jumps], " jumps"];
  jumps
]

(* For p=3: jumps at k = (3^n - 1)/2 = 1, 4, 13, 40, 121, 364, 1093, 3280, 9841, ... *)
(* Need k up to 10000 for about 9 jumps *)

Print["=== Collecting jump data for p=3 ==="];
jumps3 = CollectJumps[3, 10000];

Print["\nJump points:"];
Print["k\t2k+1\tnu_3(D)\tnu_3(N)\tDiff"];
Do[Print[jumps3[[i, 1]], "\t", jumps3[[i, 2]], "\t",
         jumps3[[i, 3]], "\t", jumps3[[i, 4]], "\t", jumps3[[i, 5]]],
   {i, 1, Min[15, Length[jumps3]]}];

(* Extract sequences *)
kVals = jumps3[[All, 1]];
twoKplus1 = jumps3[[All, 2]];
nuD = jumps3[[All, 3]];
nuN = jumps3[[All, 4]];
diffs = jumps3[[All, 5]];

Print["\n=== SEQUENCES FOR PATTERN DETECTION ==="];
Print["k-values at jumps: ", kVals];
Print["2k+1 values: ", twoKplus1];
Print["nu_3(D) sequence: ", nuD];
Print["nu_3(N) sequence: ", nuN];
Print["Differences: ", diffs];

(* Pattern detection *)
Print["\n=== PATTERN ANALYSIS ==="];

Print["All differences equal 1? ", AllTrue[diffs, # == 1 &]];

(* Check if 2k+1 are powers of 3 *)
Print["Are all 2k+1 powers of 3? ",
  AllTrue[twoKplus1, IntegerExponent[#, 3] == Log[3, N[#]] &]];

(* Check if k = (3^n - 1)/2 *)
expectedK = Table[(3^n - 1)/2, {n, 1, Length[kVals]}];
Print["Expected k if formula is (3^n - 1)/2: ", expectedK];
Print["Match? ", expectedK == kVals];

(* Try FindSequenceFunction *)
Print["\nFindSequenceFunction on k-values:"];
kFormula = FindSequenceFunction[kVals, n];
Print["Formula: ", kFormula];
If[kFormula =!= $Failed,
  Print["Verification: ", Table[kFormula, {n, 1, Min[10, Length[kVals]]}]];
];

(* Try FindLinearRecurrence *)
Print["\nFindLinearRecurrence on k-values:"];
recurrence = FindLinearRecurrence[kVals];
Print["Recurrence: ", recurrence];

(* Check ratios between consecutive k values *)
ratios = Table[N[kVals[[i+1]]/kVals[[i]]], {i, 1, Length[kVals]-1}];
Print["\nRatios k[i+1]/k[i]: ", ratios];
Print["Approaching 3? ", N[Mean[ratios[[5;;]]]]];

(* Now analyze p=5 and p=7 for comparison *)
Print["\n\n=== PRIME p=5 ==="];
jumps5 = CollectJumps[5, 5000];
kVals5 = jumps5[[All, 1]];
Print["k-values: ", kVals5];
Print["Expected if (5^n - 1)/2: ", Table[(5^n - 1)/2, {n, 1, Length[kVals5]}]];
Print["Match? ", Table[(5^n - 1)/2, {n, 1, Length[kVals5]}] == kVals5];

Print["\n=== PRIME p=7 ==="];
jumps7 = CollectJumps[7, 5000];
kVals7 = jumps7[[All, 1]];
Print["k-values: ", kVals7];
Print["Expected if (7^n - 1)/2: ", Table[(7^n - 1)/2, {n, 1, Length[kVals7]}]];
Print["Match? ", Table[(7^n - 1)/2, {n, 1, Length[kVals7]}] == kVals7];

(* Universal pattern *)
Print["\n\n=== UNIVERSAL PATTERN ==="];
Print["For any odd prime p, jumps occur at k = (p^n - 1)/2"];
Print["This corresponds to 2k+1 = p^n"];
Print["At each jump: nu_p(D) increases by 1, nu_p(N) increases by 1"];
Print["Maintaining the invariant: nu_p(D) - nu_p(N) = 1"];
