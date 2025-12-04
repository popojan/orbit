(* Statistical analysis: can √p samples predict h mod 4? *)

classNumberMinus[p_?PrimeQ] := -Sum[k * JacobiSymbol[k, p], {k, 1, p-1}]/p /; Mod[p, 4] == 3

bOrder[p_] := SortBy[Range[(p-1)/2], N[Cos[(2# - 1) Pi/p]] &]

fullCumulative[p_] := Accumulate[JacobiSymbol[#, p] & /@ bOrder[p]]

sqrtSample[cumul_] := Module[{n, step},
  n = Length[cumul];
  step = Max[1, Ceiling[Sqrt[n]]];
  cumul[[Range[step, n, step]]]
]

(* Larger test *)
primes3mod4 = Select[Prime[Range[50, 3000]], Mod[#, 4] == 3 &];
Print["Testing ", Length[primes3mod4], " primes...\n"];

results = Table[
  Module[{h, cumul, samples},
    h = classNumberMinus[p];
    cumul = fullCumulative[p];
    samples = sqrtSample[cumul];
    {p, h, Mod[h, 4], Total[samples], Mean[samples], Last[cumul], Max[Abs[samples]]}
  ],
  {p, primes3mod4}
];

(* Separate by h mod 4 *)
h1 = Select[results, #[[3]] == 1 &];
h3 = Select[results, #[[3]] == 3 &];

Print["=== Distribution of h mod 4 ==="];
Print["h ≡ 1 (mod 4): ", Length[h1], " primes (", N[100*Length[h1]/Length[results]], "%)"];
Print["h ≡ 3 (mod 4): ", Length[h3], " primes (", N[100*Length[h3]/Length[results]], "%)"];

Print["\n=== Statistics by h mod 4 ===\n"];

(* Sample sum *)
Print["Sample Sum:"];
Print["  h≡1: mean=", N[Mean[h1[[All,4]]]], " std=", N[StandardDeviation[h1[[All,4]]]]];
Print["  h≡3: mean=", N[Mean[h3[[All,4]]]], " std=", N[StandardDeviation[h3[[All,4]]]]];

(* Sample mean *)
Print["\nSample Mean:"];
Print["  h≡1: mean=", N[Mean[h1[[All,5]]]], " std=", N[StandardDeviation[h1[[All,5]]]]];
Print["  h≡3: mean=", N[Mean[h3[[All,5]]]], " std=", N[StandardDeviation[h3[[All,5]]]]];

(* Final cumulative *)
Print["\nFinal Cumulative:"];
Print["  h≡1: mean=", N[Mean[h1[[All,6]]]], " std=", N[StandardDeviation[h1[[All,6]]]]];
Print["  h≡3: mean=", N[Mean[h3[[All,6]]]], " std=", N[StandardDeviation[h3[[All,6]]]]];

(* Max absolute sample *)
Print["\nMax |sample|:"];
Print["  h≡1: mean=", N[Mean[h1[[All,7]]]], " std=", N[StandardDeviation[h1[[All,7]]]]];
Print["  h≡3: mean=", N[Mean[h3[[All,7]]]], " std=", N[StandardDeviation[h3[[All,7]]]]];

(* Simple classifier: predict h≡1 if sample_sum > threshold *)
Print["\n=== Simple Classifier Test ==="];
allSums = Join[h1[[All, 4]], h3[[All, 4]]];
threshold = Median[allSums];
Print["Threshold (median): ", N[threshold]];

correct1 = Count[h1, x_ /; x[[4]] > threshold];
correct3 = Count[h3, x_ /; x[[4]] <= threshold];
accuracy = N[(correct1 + correct3) / Length[results]];

Print["Accuracy: ", accuracy * 100, "%"];
Print["  h≡1 correct: ", correct1, "/", Length[h1]];
Print["  h≡3 correct: ", correct3, "/", Length[h3]];

(* Better classifier? Try normalized by sqrt(p) *)
Print["\n=== Normalized Classifier ==="];
normalized1 = {#[[4]]/Sqrt[#[[1]]], #[[3]]} & /@ h1;
normalized3 = {#[[4]]/Sqrt[#[[1]]], #[[3]]} & /@ h3;

Print["Normalized sample_sum/√p:"];
Print["  h≡1: mean=", N[Mean[normalized1[[All,1]]]], " std=", N[StandardDeviation[normalized1[[All,1]]]]];
Print["  h≡3: mean=", N[Mean[normalized3[[All,1]]]], " std=", N[StandardDeviation[normalized3[[All,1]]]]];
