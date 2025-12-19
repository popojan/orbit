(* Chi-squared uniformity test for prime distribution mod 77 *)

Print["═══════════════════════════════════════════════════════════════════"];
Print["   UNIFORMITY TEST: PRIMES MOD 77                                  "];
Print["═══════════════════════════════════════════════════════════════════\n"];

(* === Test at various bounds === *)
testUniformity[maxPrime_] := Module[
  {primes, coprimeClasses, counts, observed, expected, chiSq, df, pValue},

  primes = Prime[Range[PrimePi[maxPrime]]];
  (* Exclude 7 and 11 themselves *)
  primes = Select[primes, # > 11 &];

  coprimeClasses = Select[Range[77], CoprimeQ[#, 77] &];
  counts = Counts[Mod[primes, 77]];
  observed = Table[Lookup[counts, c, 0], {c, coprimeClasses}];
  expected = Total[observed] / 60.0;

  (* Chi-squared statistic *)
  chiSq = Total[(observed - expected)^2 / expected];
  df = 59; (* 60 classes - 1 *)

  (* P-value from chi-squared distribution *)
  pValue = 1 - CDF[ChiSquareDistribution[df], chiSq];

  {Length[primes], expected, chiSq, pValue}
];

Print["Chi-squared test for uniform distribution:\n"];
Print["Bound        Primes    Expected/class   χ²        p-value    Verdict"];
Print["─────────────────────────────────────────────────────────────────────"];

bounds = {10^4, 10^5, 10^6, 10^7};
Do[
  {nPrimes, exp, chi, pVal} = testUniformity[b];
  verdict = If[pVal > 0.05, "UNIFORM", "NON-UNIFORM"];
  Print[
    PaddedForm[b, 10], "  ",
    PaddedForm[nPrimes, 8], "  ",
    NumberForm[exp, {6, 2}], "         ",
    NumberForm[chi, {6, 2}], "   ",
    NumberForm[pVal, {6, 4}], "   ",
    verdict
  ];
, {b, bounds}];

(* === Detailed analysis at 10^6 === *)
Print["\n═══ DETAILED ANALYSIS AT 10^6 ═══\n"];

primes = Select[Prime[Range[PrimePi[10^6]]], # > 11 &];
coprimeClasses = Select[Range[77], CoprimeQ[#, 77] &];
counts = Counts[Mod[primes, 77]];
observed = Table[{c, Lookup[counts, c, 0]}, {c, coprimeClasses}];
expected = Total[observed[[All, 2]]] / 60.0;

Print["Expected per class: ", NumberForm[expected, 6]];
Print["Standard deviation (Poisson): ", NumberForm[Sqrt[expected], 6]];
Print["Expected range (±2σ): [",
      NumberForm[expected - 2 Sqrt[expected], 6], ", ",
      NumberForm[expected + 2 Sqrt[expected], 6], "]\n"];

(* Classes outside 2σ *)
outliers = Select[observed, Abs[#[[2]] - expected] > 2 Sqrt[expected] &];
Print["Classes outside ±2σ: ", Length[outliers], " out of 60"];
Print["Expected by chance: ", NumberForm[60 * 0.0455, 3], " (≈ 2.7)\n"];

If[Length[outliers] > 0,
  Print["Outlier classes:"];
  Do[
    {c, obs} = outliers[[i]];
    zScore = (obs - expected) / Sqrt[expected];
    Print["  Class ", c, " mod 77: ", obs, " primes (z = ",
          NumberForm[zScore, {4, 2}], ")"];
  , {i, Length[outliers]}];
];

(* === Check for systematic patterns === *)
Print["\n═══ CHECKING FOR SYSTEMATIC PATTERNS ═══\n"];

(* Group by quadratic character *)
observedByQR = GroupBy[observed, JacobiSymbol[#[[1]], 77] &, Total[#[[All, 2]]] &];
Print["By Jacobi symbol (p|77):"];
Print["  (p|77) = +1: ", observedByQR[1], " primes in 30 classes → ",
      NumberForm[observedByQR[1]/30.0, 6], " per class"];
Print["  (p|77) = -1: ", observedByQR[-1], " primes in 30 classes → ",
      NumberForm[observedByQR[-1]/30.0, 6], " per class"];
Print["  Bias: ", observedByQR[-1] - observedByQR[1], " (NQR - QR)\n"];

(* Group by residue mod 7 *)
Print["By residue mod 7:"];
byMod7 = GroupBy[observed, Mod[#[[1]], 7] &, Total[#[[All, 2]]] &];
Do[
  r = Keys[byMod7][[i]];
  cnt = byMod7[r];
  nClasses = Count[coprimeClasses, c_ /; Mod[c, 7] == r];
  Print["  r ≡ ", r, " (mod 7): ", cnt, " primes in ", nClasses,
        " classes → ", NumberForm[cnt/nClasses // N, 6], " per class"];
, {i, Length[byMod7]}];

(* Group by residue mod 11 *)
Print["\nBy residue mod 11:"];
byMod11 = GroupBy[observed, Mod[#[[1]], 11] &, Total[#[[All, 2]]] &];
Do[
  r = Keys[byMod11][[i]];
  cnt = byMod11[r];
  nClasses = Count[coprimeClasses, c_ /; Mod[c, 11] == r];
  Print["  r ≡ ", r, " (mod 11): ", cnt, " primes in ", nClasses,
        " classes → ", NumberForm[cnt/nClasses // N, 6], " per class"];
, {i, Length[byMod11]}];

(* === Kolmogorov-Smirnov test === *)
Print["\n═══ KOLMOGOROV-SMIRNOV TEST ═══\n"];

observedSorted = Sort[observed[[All, 2]]];
n = Length[observedSorted];
empiricalCDF = Range[n] / n;
theoreticalCDF = Table[CDF[NormalDistribution[expected, Sqrt[expected]], observedSorted[[i]]], {i, n}];
ksStatistic = Max[Abs[empiricalCDF - theoreticalCDF]];

Print["KS statistic: ", NumberForm[ksStatistic, 6]];
Print["Critical value (α=0.05, n=60): ", NumberForm[1.36/Sqrt[60], 6]];
Print["Verdict: ", If[ksStatistic < 1.36/Sqrt[60], "CONSISTENT WITH UNIFORM", "DEVIATES FROM UNIFORM"]];
