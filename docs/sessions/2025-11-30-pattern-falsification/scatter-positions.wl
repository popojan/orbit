(* Scatter plot: position between squares vs position between primes *)

(* Position between squares *)
sqPos[n_] := Module[{f = Floor[Sqrt[n]]},
  (n - f^2) / (2*f + 1)
];

(* Position between primes *)
primePos[n_] := Module[{pPrev, pNext},
  pPrev = If[PrimeQ[n], n, NextPrime[n, -1]];
  pNext = If[PrimeQ[n], n, NextPrime[n]];
  If[pPrev == pNext, 0, (n - pPrev) / (pNext - pPrev)]
];

(* Generate data for n = 2 to 1000 *)
data = Table[{sqPos[n], primePos[n]}, {n, 2, 2000}];

(* Plot *)
plot = ListPlot[data,
  PlotStyle -> {PointSize[Tiny], Blue},
  AspectRatio -> 1,
  Frame -> True,
  FrameLabel -> {"Position between squares", "Position between primes"},
  PlotLabel -> "n = 2 to 2000",
  PlotRange -> {{0, 1}, {0, 1}}
];

Export["scatter-sq-vs-prime.png", plot, ImageResolution -> 150];
Print["Exported scatter-sq-vs-prime.png"];

(* Now just for primes *)
primes = Select[Range[3, 2000], PrimeQ];
primeData = Table[{sqPos[p], 0}, {p, primes}];  (* primes have primePos = 0 *)

(* Primes colored by p mod 4 *)
primes1mod4 = Select[primes, Mod[#, 4] == 1 &];
primes3mod4 = Select[primes, Mod[#, 4] == 3 &];

data1 = Table[{sqPos[p], Mod[p, 8]}, {p, primes1mod4}];
data3 = Table[{sqPos[p], Mod[p, 8]}, {p, primes3mod4}];

plot2 = ListPlot[{data1, data3},
  PlotStyle -> {Red, Blue},
  PlotLegends -> {"p ≡ 1 (mod 4)", "p ≡ 3 (mod 4)"},
  Frame -> True,
  FrameLabel -> {"sqPos(p)", "p mod 8"},
  PlotLabel -> "Primes by square position"
];

Export["primes-sqpos-mod8.png", plot2, ImageResolution -> 150];
Print["Exported primes-sqpos-mod8.png"];

(* Distribution of sqPos for primes *)
Print[""];
Print["Distribution of sqPos(p) for primes:"];
sqPosVals = sqPos /@ primes;
Print["Mean: ", N[Mean[sqPosVals], 4]];
Print["Should be ~0.5 if uniform"];

(* Check: is sqPos correlated with signSum? *)
Print[""];
Print["sqPos vs defect (signedDist) relationship:"];
Do[
  p = primes[[i]];
  f = Floor[Sqrt[p]];
  defect = p - f^2;
  gap = 2*f + 1;
  sq = sqPos[p];
  sd = If[defect <= f, defect, defect - gap];  (* signedDist *)
  If[i <= 20,
    Print[p, ": sqPos=", N[sq, 3], " defect=", defect, " signedDist=", sd];
  ];
  ,
  {i, Length[primes]}
];
