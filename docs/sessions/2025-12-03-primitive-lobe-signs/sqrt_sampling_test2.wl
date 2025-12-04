(* Test: √p sampling in B-order for class number parity *)

(* Class number of Q(√-p) using Dirichlet formula *)
classNumberMinus[p_?PrimeQ] := Module[{sum},
  sum = Sum[k * JacobiSymbol[k, p], {k, 1, p-1}];
  -sum/p
] /; Mod[p, 4] == 3

(* B-ordering: sort by cos((2k-1)π/p), i.e., by B value *)
bOrder[p_] := SortBy[Range[(p-1)/2], N[Cos[(2# - 1) Pi/p]] &]

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

(* Test on primes p ≡ 3 (mod 4) *)
primes3mod4 = Select[Prime[Range[50, 500]], Mod[#, 4] == 3 &];

Print["Testing primes p ≡ 3 (mod 4)\n"];
Print["p\th(-p)\th%2\t#samp\tmax|s|\tlast_s\tfull_last"];
Print[StringJoin[Table["-", 60]]];

results = Table[
  Module[{cumul, sampleIdx, sampleVals, h, maxSamp, lastSamp},
    cumul = fullCumulative[p];
    {sampleIdx, sampleVals} = sqrtSample[cumul];
    h = classNumberMinus[p];
    maxSamp = Max[Abs[sampleVals]];
    lastSamp = Last[sampleVals];
    
    Print[p, "\t", h, "\t", Mod[h, 2], "\t", Length[sampleVals], 
          "\t", maxSamp, "\t", lastSamp, "\t", Last[cumul]];
    
    {p, h, Mod[h, 2], Length[sampleVals], maxSamp, lastSamp, Last[cumul]}
  ],
  {p, primes3mod4[[;;25]]}
];

Print["\n=== Correlation Analysis ===\n"];

(* Group by h mod 2 *)
oddH = Select[results, #[[3]] == 1 &];
evenH = Select[results, #[[3]] == 0 &];

Print["Primes with ODD h(-p): ", Length[oddH]];
Print["  p values: ", oddH[[All, 1]]];
Print["  Mean max|sample|: ", N[Mean[oddH[[All, 5]]]]];
Print["  Mean |last sample|: ", N[Mean[Abs[oddH[[All, 6]]]]]];

Print["\nPrimes with EVEN h(-p): ", Length[evenH]];
Print["  p values: ", evenH[[All, 1]]];
If[Length[evenH] > 0,
  Print["  Mean max|sample|: ", N[Mean[evenH[[All, 5]]]]];
  Print["  Mean |last sample|: ", N[Mean[Abs[evenH[[All, 6]]]]]];
];

(* Key question: can we predict h mod 2 from samples? *)
Print["\n=== Pattern Search ==="];
Print["Looking for distinguishing feature..."];

(* Check if last sample sign correlates with h mod 2 *)
Print["\nLast sample > 0 correlation with h odd:"];
Table[
  {r[[1]], If[r[[6]] > 0, "+", "-"], If[r[[3]] == 1, "odd", "even"]},
  {r, results}
] // TableForm
