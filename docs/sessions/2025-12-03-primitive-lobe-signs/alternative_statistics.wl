(* Try alternative statistics from √p samples *)

classNumberMinus[p_?PrimeQ] := -Sum[k * JacobiSymbol[k, p], {k, 1, p-1}]/p /; Mod[p, 4] == 3

bOrder[p_] := SortBy[Range[(p-1)/2], N[Cos[(2# - 1) Pi/p]] &]

(* Get √p samples at regular intervals in B-order *)
getSamples[p_] := Module[{sorted, legendre, cumul, step, n},
  sorted = bOrder[p];
  legendre = JacobiSymbol[#, p] & /@ sorted;
  cumul = Accumulate[legendre];
  n = Length[cumul];
  step = Max[1, Ceiling[Sqrt[n]]];
  {legendre[[Range[step, n, step]]], cumul[[Range[step, n, step]]]}
]

(* Various statistics *)
stats[p_] := Module[{h, leg, cumul, diffs},
  h = classNumberMinus[p];
  {leg, cumul} = getSamples[p];
  diffs = Differences[cumul];
  
  {p, h, Mod[h, 4],
   (* Stats on raw Legendre samples *)
   Total[leg],                          (* sum of sampled Legendre *)
   Count[leg, 1] - Count[leg, -1],     (* balance *)
   
   (* Stats on cumulative *)
   Last[cumul] - First[cumul],         (* cumulative range *)
   Max[cumul] - Min[cumul],            (* max swing *)
   
   (* Stats on differences (velocity) *)
   Total[diffs],                        (* total movement *)
   Total[Abs[diffs]],                  (* total absolute movement *)
   
   (* Sign changes *)
   Count[Partition[Sign[cumul], 2, 1], {a_, b_} /; a != b && a != 0 && b != 0]
  }
]

primes3mod4 = Select[Prime[Range[100, 2000]], Mod[#, 4] == 3 &];
Print["Computing statistics for ", Length[primes3mod4], " primes...\n"];

results = stats /@ primes3mod4;

h1 = Select[results, #[[3]] == 1 &];
h3 = Select[results, #[[3]] == 3 &];

headers = {"p", "h", "h%4", "leg_sum", "balance", "cum_range", "max_swing", 
           "movement", "abs_movement", "sign_changes"};

Print["=== Statistics Comparison ===\n"];

Table[
  Print[headers[[i+3]], ":"];
  Print["  h≡1: ", N[Mean[h1[[All, i+3]]]], " ± ", N[StandardDeviation[h1[[All, i+3]]]]];
  Print["  h≡3: ", N[Mean[h3[[All, i+3]]]], " ± ", N[StandardDeviation[h3[[All, i+3]]]]];
  Print["  t-stat: ", N[(Mean[h1[[All,i+3]]] - Mean[h3[[All,i+3]]]) / 
         Sqrt[Variance[h1[[All,i+3]]]/Length[h1] + Variance[h3[[All,i+3]]]/Length[h3]]]];
  Print[];
, {i, 1, 7}];

(* Best classifier? *)
Print["=== Finding Best Classifier ==="];
bestAcc = 0;
bestStat = 0;
Table[
  vals1 = h1[[All, i+3]];
  vals3 = h3[[All, i+3]];
  thresh = Median[Join[vals1, vals3]];
  (* Try both directions *)
  acc1 = (Count[vals1, x_ /; x > thresh] + Count[vals3, x_ /; x <= thresh]) / Length[results];
  acc2 = (Count[vals1, x_ /; x <= thresh] + Count[vals3, x_ /; x > thresh]) / Length[results];
  acc = Max[acc1, acc2];
  If[acc > bestAcc, bestAcc = acc; bestStat = i];
  Print[headers[[i+3]], ": accuracy = ", N[100*acc], "%"];
, {i, 1, 7}];

Print["\nBest: ", headers[[bestStat+3]], " with ", N[100*bestAcc], "% accuracy"];
