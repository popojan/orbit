(* Test: √p sampling in B-order for class number parity *)

(* B-ordering: sort by cos((2k-1)π/p) *)
bOrder[p_] := SortBy[Range[(p-1)/2], Cos[(2# - 1) Pi/p] &]

(* Full cumulative Legendre in B-order *)
fullCumulative[p_] := Module[{sorted, legendre},
  sorted = bOrder[p];
  legendre = JacobiSymbol[#, p] & /@ sorted;
  Accumulate[legendre]
]

(* Sample every √n-th point *)
sqrtSample[cumul_] := Module[{n, step, indices},
  n = Length[cumul];
  step = Max[1, Ceiling[Sqrt[n]]];
  indices = Range[step, n, step];
  {indices, cumul[[indices]]}
]

(* Test on primes p ≡ 3 (mod 4) - where sign matters *)
primes3mod4 = Select[Prime[Range[50, 300]], Mod[#, 4] == 3 &];

Print["Testing ", Length[primes3mod4], " primes ≡ 3 (mod 4)\n"];
Print["p\t\th(-p)\th mod 2\t√p samples\tmax|sample|\tlast sample"];
Print[StringJoin[Table["-", 70]]];

results = Table[
  Module[{cumul, sampleIdx, sampleVals, h, maxSamp, lastSamp, n},
    cumul = fullCumulative[p];
    {sampleIdx, sampleVals} = sqrtSample[cumul];
    h = ClassNumber[-p];
    n = Length[sampleVals];
    maxSamp = Max[Abs[sampleVals]];
    lastSamp = Last[sampleVals];
    
    Print[p, "\t\t", h, "\t", Mod[h, 2], "\t", n, " samples\t", maxSamp, "\t\t", lastSamp];
    
    {p, h, Mod[h, 2], n, maxSamp, lastSamp, Last[cumul]}
  ],
  {p, primes3mod4[[;;20]]}
];

Print["\n\n=== Analysis ==="];
Print["Looking for correlation between sampled values and h(-p) mod 2..."];

(* Group by h mod 2 *)
oddH = Select[results, #[[3]] == 1 &];
evenH = Select[results, #[[3]] == 0 &];

Print["\nPrimes with odd h(-p): ", Length[oddH]];
Print["  Mean max|sample|: ", N[Mean[oddH[[All, 5]]]]];
Print["  Mean |last sample|: ", N[Mean[Abs[oddH[[All, 6]]]]]];

Print["\nPrimes with even h(-p): ", Length[evenH]];
If[Length[evenH] > 0,
  Print["  Mean max|sample|: ", N[Mean[evenH[[All, 5]]]]];
  Print["  Mean |last sample|: ", N[Mean[Abs[evenH[[All, 6]]]]]];
];

(* Also test p ≡ 1 (mod 4) for comparison *)
Print["\n\n=== p ≡ 1 (mod 4) comparison ==="];
primes1mod4 = Select[Prime[Range[50, 300]], Mod[#, 4] == 1 &];

results1 = Table[
  Module[{cumul, sampleIdx, sampleVals, maxSamp, lastSamp},
    cumul = fullCumulative[p];
    {sampleIdx, sampleVals} = sqrtSample[cumul];
    maxSamp = Max[Abs[sampleVals]];
    lastSamp = Last[sampleVals];
    {p, maxSamp, lastSamp}
  ],
  {p, primes1mod4[[;;10]]}
];

Print["p\t\tmax|sample|\tlast sample"];
Do[Print[r[[1]], "\t\t", r[[2]], "\t\t", r[[3]]], {r, results1}];

Print["\nMean max|sample| for p≡1(mod 4): ", N[Mean[results1[[All, 2]]]]];
Print["Mean max|sample| for p≡3(mod 4): ", N[Mean[results[[All, 5]]]]];
