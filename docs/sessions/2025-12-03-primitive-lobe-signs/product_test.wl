(* Maybe PRODUCT of Legendre symbols matters, not sum? *)

classNumberMinus[p_?PrimeQ] := -Sum[k * JacobiSymbol[k, p], {k, 1, p-1}]/p /; Mod[p, 4] == 3

bOrder[p_] := SortBy[Range[(p-1)/2], N[Cos[(2# - 1) Pi/p]] &]

(* Product of Legendre symbols over √p samples in B-order *)
legendreProduct[p_] := Module[{sorted, step, n, samples},
  sorted = bOrder[p];
  n = Length[sorted];
  step = Max[1, Ceiling[Sqrt[n]]];
  samples = sorted[[Range[step, n, step]]];
  Times @@ (JacobiSymbol[#, p] & /@ samples)
]

(* Also try: product over first √p in B-order (smallest B values) *)
legendreProductFirst[p_] := Module[{sorted, m},
  sorted = bOrder[p];
  m = Ceiling[Sqrt[Length[sorted]]];
  Times @@ (JacobiSymbol[#, p] & /@ sorted[[;;m]])
]

(* Product over last √p in B-order (largest B values) *)
legendreProductLast[p_] := Module[{sorted, m},
  sorted = bOrder[p];
  m = Ceiling[Sqrt[Length[sorted]]];
  Times @@ (JacobiSymbol[#, p] & /@ sorted[[-m;;]])
]

primes3mod4 = Select[Prime[Range[100, 2000]], Mod[#, 4] == 3 &];

Print["Testing product-based classifiers on ", Length[primes3mod4], " primes\n"];

results = Table[
  {p, classNumberMinus[p], legendreProduct[p], legendreProductFirst[p], legendreProductLast[p]},
  {p, primes3mod4}
];

h1 = Select[results, Mod[#[[2]], 4] == 1 &];
h3 = Select[results, Mod[#[[2]], 4] == 3 &];

Print["=== Product at √p intervals ==="];
Print["h≡1: product=+1: ", Count[h1, x_ /; x[[3]] == 1], "/", Length[h1]];
Print["h≡1: product=-1: ", Count[h1, x_ /; x[[3]] == -1], "/", Length[h1]];
Print["h≡3: product=+1: ", Count[h3, x_ /; x[[3]] == 1], "/", Length[h3]];
Print["h≡3: product=-1: ", Count[h3, x_ /; x[[3]] == -1], "/", Length[h3]];

(* Can product predict sign? sign = (-1)^((h+1)/2) *)
(* h≡1(mod 4): sign=-1, h≡3(mod 4): sign=+1 *)
Print["\nCorrelation with sign:"];
correct1 = Count[h1, x_ /; x[[3]] == -1];  (* h≡1 should have sign=-1 *)
correct3 = Count[h3, x_ /; x[[3]] == 1];   (* h≡3 should have sign=+1 *)
Print["Accuracy (product = sign): ", N[100*(correct1 + correct3)/Length[results]], "%"];

Print["\n=== Product over FIRST √p (smallest B) ==="];
Print["h≡1: +1:", Count[h1, x_ /; x[[4]] == 1], " -1:", Count[h1, x_ /; x[[4]] == -1]];
Print["h≡3: +1:", Count[h3, x_ /; x[[4]] == 1], " -1:", Count[h3, x_ /; x[[4]] == -1]];

Print["\n=== Product over LAST √p (largest B) ==="];
Print["h≡1: +1:", Count[h1, x_ /; x[[5]] == 1], " -1:", Count[h1, x_ /; x[[5]] == -1]];
Print["h≡3: +1:", Count[h3, x_ /; x[[5]] == 1], " -1:", Count[h3, x_ /; x[[5]] == -1]];

(* What about XOR of multiple products? *)
Print["\n=== Combined: first XOR last ==="];
xorProduct = Table[r[[4]] * r[[5]], {r, results}];
h1xor = Select[Range[Length[results]], Mod[results[[#, 2]], 4] == 1 &];
h3xor = Select[Range[Length[results]], Mod[results[[#, 2]], 4] == 3 &];
Print["h≡1 XOR=+1: ", Count[xorProduct[[h1xor]], 1], "/", Length[h1xor]];
Print["h≡3 XOR=+1: ", Count[xorProduct[[h3xor]], 1], "/", Length[h3xor]];
