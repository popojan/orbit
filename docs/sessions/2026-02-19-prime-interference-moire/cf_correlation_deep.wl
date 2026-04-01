(* Deep dive: CF period vs minFrac correlation *)

iStar[x_, y_] := (y + Sqrt[y^2 + 4 x])/2;

(* minFrac over full interior range *)
minFrac[p_] := Min @ Table[
  With[{f = FractionalPart[N[iStar[p, y], 20]]}, Min[f, 1 - f]],
  {y, 0, p - 2}
];

(* minFrac restricted to "inner" region y in [0, Sqrt[p]] *)
(* Here i* ranges from Sqrt[p] to ~1.6*Sqrt[p] — the "balanced" zone *)
innerMinFrac[p_] := Min @ Table[
  With[{f = FractionalPart[N[iStar[p, y], 20]]}, Min[f, 1 - f]],
  {y, 0, Ceiling[Sqrt[N @ p]]}
];

cfPeriod[n_] := Length[ContinuedFraction[Sqrt[n]][[2]]];
cfData[n_] := ContinuedFraction[Sqrt[n]][[2]];

Print["=== CF Period vs minFrac: Deep Dive ===\n"];

primes = Select[Range[5, 500], PrimeQ];
Print["Computing for ", Length[primes], " primes up to 500...\n"];

data = {};
Do[
  mf = minFrac[p];
  imf = innerMinFrac[p];
  cf = cfData[p];
  cfLen = Length[cf];
  cfMax = Max[cf];
  AppendTo[data, <|
    "p" -> p, "mf" -> mf, "imf" -> imf,
    "cfLen" -> cfLen, "cfMax" -> cfMax,
    "pmf" -> p * mf,          (* normalized: remove 1/p trend *)
    "pimf" -> Sqrt[p] * imf   (* inner: expected scaling ~1/Sqrt[p] *)
  |>],
  {p, primes}
];

(* === 1. Raw correlation with more data === *)
Print["=== 1. Raw correlations (", Length[data], " primes) ==="];
logMF = Log[#["mf"]] & /@ data;
logIMF = Log[#["imf"]] & /@ data;
cfLens = N[#["cfLen"]] & /@ data;
cfMaxs = N[#["cfMax"]] & /@ data;

Print["corr(log(minFrac), cfPeriod)      = ",
  Correlation[logMF, cfLens] // NumberForm[#, 4] &];
Print["corr(log(innerMinFrac), cfPeriod) = ",
  Correlation[logIMF, cfLens] // NumberForm[#, 4] &];

(* === 2. Remove 1/p trend === *)
Print["\n=== 2. After removing 1/p trend ==="];
Print["p*minFrac should be ~constant if minFrac ~ C/p\n"];

pmfs = #["pmf"] & /@ data;
logPMF = Log /@ pmfs;
logP = Log[N[#["p"]]] & /@ data;

Print["corr(log(p*minFrac), cfPeriod)    = ",
  Correlation[logPMF, cfLens] // NumberForm[#, 4] &];
Print["corr(log(p*minFrac), cfMax)       = ",
  Correlation[logPMF, cfMaxs] // NumberForm[#, 4] &];
Print["corr(log(p*minFrac), log(p))      = ",
  Correlation[logPMF, logP] // NumberForm[#, 4] &,
  "  (sanity: residual vs p)"];

(* === 3. Inner region correlations === *)
Print["\n=== 3. Inner region (y in [0, Sqrt[p]]) ==="];
Print["Here i* ~ Sqrt[p], governed by CF of Sqrt[p]\n"];

pimfs = #["pimf"] & /@ data;
logPIMF = Log /@ pimfs;

Print["corr(log(Sqrt[p]*innerMinFrac), cfPeriod) = ",
  Correlation[logPIMF, cfLens] // NumberForm[#, 4] &];
Print["corr(log(Sqrt[p]*innerMinFrac), cfMax)    = ",
  Correlation[logPIMF, cfMaxs] // NumberForm[#, 4] &];

(* === 4. p*minFrac grouped by CF period === *)
Print["\n=== 4. p*minFrac grouped by CF period ==="];
groups = GroupBy[Normal @ data, #["cfLen"] &];
Print[StringPadRight["cfPer", 7], StringPadRight["count", 7],
  StringPadRight["mean(p*mF)", 12], "stdDev"];
Print[StringJoin @ Table["-", 40]];
Do[
  If[KeyExistsQ[groups, k],
    g = groups[k];
    vals = #["pmf"] & /@ g;
    Print[StringPadRight[ToString[k], 7],
      StringPadRight[ToString[Length[g]], 7],
      StringPadRight[ToString @ NumberForm[Mean[vals], {5, 3}], 12],
      If[Length[g] > 1,
        ToString @ NumberForm[StandardDeviation[vals], {5, 3}], "-"]]
  ],
  {k, Sort @ Keys[groups]}
];

(* === 5. Detailed scatter: print normalized data === *)
Print["\n=== 5. Scatter: cfPeriod vs p*minFrac ==="];
Print["(sorted by cfPeriod)\n"];
sorted = SortBy[Normal @ data, #["cfLen"] &];
Print[StringPadRight["p", 6], StringPadRight["cfPer", 7],
  StringPadRight["cfMax", 7], StringPadRight["p*mF", 10],
  "CF partial quotients"];
Print[StringJoin @ Table["-", 70]];
Do[
  d = sorted[[i]];
  cf = cfData[d["p"]];
  Print[StringPadRight[ToString[d["p"]], 6],
    StringPadRight[ToString[d["cfLen"]], 7],
    StringPadRight[ToString[d["cfMax"]], 7],
    StringPadRight[ToString @ NumberForm[d["pmf"], {5, 3}], 10],
    If[Length[cf] <= 20, ToString[cf], ToString[cf[[;; 20]]] <> "..."]],
  {i, 1, Length[sorted]}
];

(* === 6. Is cfMax more predictive than cfLen? === *)
Print["\n=== 6. cfMax vs cfLen as predictor ==="];

(* Partial correlations *)
(* corr(log(p*mf), cfLen | cfMax) via residuals *)
fitLen = LinearModelFit[
  Transpose[{cfMaxs, logPMF}], x, x];
residLogPMF = fitLen["FitResiduals"];
fitLen2 = LinearModelFit[
  Transpose[{cfMaxs, cfLens}], x, x];
residCfLen = fitLen2["FitResiduals"];
Print["Partial corr(log(p*mf), cfLen | cfMax) = ",
  Correlation[residLogPMF, residCfLen] // NumberForm[#, 4] &];

fitMax = LinearModelFit[
  Transpose[{cfLens, logPMF}], x, x];
residLogPMF2 = fitMax["FitResiduals"];
fitMax2 = LinearModelFit[
  Transpose[{cfLens, cfMaxs}], x, x];
residCfMax = fitMax2["FitResiduals"];
Print["Partial corr(log(p*mf), cfMax | cfLen) = ",
  Correlation[residLogPMF2, residCfMax] // NumberForm[#, 4] &];

(* === 7. Direct test: does the CF predict WHERE minFrac occurs? === *)
Print["\n=== 7. Best rational approx of Sqrt[p] vs minFrac ==="];
Print["Convergents of Sqrt[p] should predict the closest i* to integer\n"];

Do[
  p = d["p"];
  sqp = Sqrt[p];
  convs = Convergents[sqp, 8];
  (* For each convergent h/k, the "distance" is |sqrt(p) - h/k| *)
  (* The relevant quantity is the fractional part of the convergent itself *)
  bestConv = MinimalBy[convs, Abs[N[sqp - #, 20]] &, 1][[1]];
  bestDist = Abs[N[sqp - bestConv, 20]];
  (* minFrac at y=0 is {Sqrt[p]} *)
  sqpFrac = With[{f = FractionalPart[N[sqp, 20]]}, Min[f, 1 - f]];
  Print["  p=", StringPadRight[ToString[p], 6],
    " {Sqrt[p]}=", NumberForm[sqpFrac, {5, 4}],
    " best conv=", bestConv,
    " |Sqrt[p]-conv|=", ScientificForm[bestDist, 3],
    " minFrac=", NumberForm[d["mf"], {5, 4}]],
  {d, Select[Normal @ data, #["p"] < 60 &]}
];
