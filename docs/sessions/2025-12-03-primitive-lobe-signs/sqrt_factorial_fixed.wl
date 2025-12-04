(* √n factorial algorithm - fixed *)

buildPolyMod[m_, p_] := Module[{poly = {1}},
  Do[
    newPoly = Append[poly, 0] + Prepend[j * poly, 0];
    poly = Mod[newPoly, p];
  , {j, 1, m}];
  poly
]

evalPolyMod[coeffs_, x_, p_] := Module[{result = 0},
  Do[result = Mod[result * x + c, p], {c, Reverse[coeffs]}];
  result
]

factorialSqrt[n_, p_] := Module[{m, poly, result, fullBlocks},
  If[n == 0, Return[1]];
  m = Ceiling[Sqrt[N[n]]];
  fullBlocks = Floor[n / m];
  poly = buildPolyMod[m, p];
  result = 1;
  Do[
    val = evalPolyMod[poly, i * m, p];
    result = Mod[result * val, p];
  , {i, 0, fullBlocks - 1}];
  Do[result = Mod[result * j, p], {j, fullBlocks * m + 1, n}];
  result
]

factorialNaive[n_, p_] := Fold[Mod[#1 * #2, p] &, 1, Range[n]]

(* Test *)
Print["=== Correctness ==="];
tests = {{1000, 10007}, {5003, 10007}, {50001, 100003}};
Do[
  n = t[[1]]; p = t[[2]];
  naive = factorialNaive[n, p];
  sqrtA = factorialSqrt[n, p];
  Print["n=", n, " p=", p, ": ", If[naive == sqrtA, "✓", "✗ naive=" <> ToString[naive] <> " sqrt=" <> ToString[sqrtA]]];
, {t, tests}];

(* Benchmark *)
Print["\n=== Benchmark ==="];
benchmarks = {{5003, 10007}, {50001, 100003}, {500001, 1000003}};
Do[
  n = b[[1]]; p = b[[2]];
  tNaive = First@AbsoluteTiming[factorialNaive[n, p];];
  tSqrt = First@AbsoluteTiming[factorialSqrt[n, p];];
  Print["n=", n, ": Naive ", Round[1000*tNaive], "ms, √n ", Round[1000*tSqrt], "ms, ratio ", N[tSqrt/tNaive, 2]];
, {b, benchmarks}];

Print["\n=== Analysis ==="];
Print["Náš √n algoritmus je stále O(n) kvůli naivní konstrukci polynomu."];
Print["S FFT by bylo O(√n · log²n)."];
Print[""];
Print["Pro p ~ 10^6: √p ~ 1000, log²p ~ 400"];
Print["Speedup: p / (√p · log²p) ~ 10^6 / 400000 ~ 2.5x"];
Print["Pro p ~ 10^9: speedup ~ 30x"];
Print["Pro p ~ 10^12: speedup ~ 300x"];
