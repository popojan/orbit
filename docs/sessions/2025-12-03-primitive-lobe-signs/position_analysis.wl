(* Maybe specific POSITIONS in B-order matter? *)

classNumberMinus[p_?PrimeQ] := -Sum[k * JacobiSymbol[k, p], {k, 1, p-1}]/p /; Mod[p, 4] == 3

bOrder[p_] := SortBy[Range[(p-1)/2], N[Cos[(2# - 1) Pi/p]] &]

(* Get Legendre at specific fractions of B-order *)
getLegendreAtPositions[p_, fracs_] := Module[{sorted, n, positions},
  sorted = bOrder[p];
  n = Length[sorted];
  positions = Ceiling[fracs * n];
  JacobiSymbol[#, p] & /@ sorted[[positions]]
]

fractions = {0.1, 0.25, 0.5, 0.75, 0.9};

primes3mod4 = Select[Prime[Range[200, 3000]], Mod[#, 4] == 3 &];

Print["Analyzing Legendre symbols at specific B-order positions\n"];
Print["Positions: ", fractions, " (as fractions of sorted list)\n"];

results = Table[
  {p, Mod[classNumberMinus[p], 4], getLegendreAtPositions[p, fractions]},
  {p, primes3mod4}
];

h1 = Select[results, #[[2]] == 1 &];
h3 = Select[results, #[[2]] == 3 &];

Print["=== Legendre at each position by h mod 4 ===\n"];
Table[
  pos = fractions[[i]];
  val1 = h1[[All, 3, i]];
  val3 = h3[[All, 3, i]];
  Print["Position ", pos, ":"];
  Print["  h≡1: +1:", Count[val1, 1], " -1:", Count[val1, -1], 
        " ratio:", N[Count[val1, 1]/Length[val1]]];
  Print["  h≡3: +1:", Count[val3, 1], " -1:", Count[val3, -1],
        " ratio:", N[Count[val3, 1]/Length[val3]]];
  Print[];
, {i, Length[fractions]}];

(* Combined pattern *)
Print["=== Pattern matching ==="];
patterns1 = Tally[h1[[All, 3]]];
patterns3 = Tally[h3[[All, 3]]];

Print["Most common patterns for h≡1:"];
Print[Take[SortBy[patterns1, -Last[#] &], 5]];

Print["\nMost common patterns for h≡3:"];
Print[Take[SortBy[patterns3, -Last[#] &], 5]];

(* Are any patterns exclusive? *)
pats1 = patterns1[[All, 1]];
pats3 = patterns3[[All, 1]];
exclusive1 = Complement[pats1, pats3];
exclusive3 = Complement[pats3, pats1];

Print["\nPatterns exclusive to h≡1: ", Length[exclusive1]];
Print["Patterns exclusive to h≡3: ", Length[exclusive3]];
