(* Analyze h(-p) mod 4 and sign correlation *)

classNumberMinus[p_?PrimeQ] := -Sum[k * JacobiSymbol[k, p], {k, 1, p-1}]/p /; Mod[p, 4] == 3

(* Half factorial mod p *)
halfFactorial[p_] := Mod[Times @@ Range[(p-1)/2], p]

(* B-ordering functions *)
bOrder[p_] := SortBy[Range[(p-1)/2], N[Cos[(2# - 1) Pi/p]] &]

fullCumulative[p_] := Module[{sorted, legendre},
  sorted = bOrder[p];
  legendre = JacobiSymbol[#, p] & /@ sorted;
  Accumulate[legendre]
]

sqrtSample[cumul_] := Module[{n, step},
  n = Length[cumul];
  step = Max[1, Ceiling[Sqrt[n]]];
  cumul[[Range[step, n, step]]]
]

(* Test *)
primes3mod4 = Select[Prime[Range[50, 1000]], Mod[#, 4] == 3 &];

Print["p\th(-p)\th%4\tpredicted\tactual\tmatch?\tsamples_sum"];
Print[StringJoin[Table["-", 70]]];

results = Table[
  Module[{h, predictedSign, hf, actualSign, cumul, samples, sampSum},
    h = classNumberMinus[p];
    predictedSign = (-1)^((h + 1)/2);
    hf = halfFactorial[p];
    actualSign = If[hf == 1, 1, If[hf == p - 1, -1, "?"]];
    
    cumul = fullCumulative[p];
    samples = sqrtSample[cumul];
    sampSum = Total[samples];
    
    Print[p, "\t", h, "\t", Mod[h, 4], "\t", predictedSign, "\t\t", 
          actualSign, "\t", If[predictedSign == actualSign, "✓", "✗"], 
          "\t", sampSum];
    
    {p, h, Mod[h, 4], predictedSign, actualSign, sampSum, Last[cumul]}
  ],
  {p, primes3mod4[[;;30]]}
];

(* Correlation between samples and h mod 4 *)
Print["\n=== Correlation: sample statistics vs h mod 4 ===\n"];

hMod4Groups = GroupBy[results, #[[3]] &];

Do[
  group = hMod4Groups[m];
  If[group =!= Missing["KeyAbsent", m],
    Print["h ≡ ", m, " (mod 4): ", Length[group], " primes"];
    Print["  Mean sample sum: ", N[Mean[group[[All, 6]]]]];
    Print["  Mean final cumul: ", N[Mean[group[[All, 7]]]]];
    Print["  Sign: ", If[m == 1, "-1", "+1"]];
  ],
  {m, {1, 3}}
];

Print["\n=== Key Question: Can √p samples distinguish h≡1 vs h≡3 (mod 4)? ==="];
