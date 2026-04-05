(* ================================================================ *)
(* Seed tuning exploration                                          *)
(* Find optimal k values for algebraic-near seeds                  *)
(* Study the index matrix K = k2 ⊗ k1                             *)
(* ================================================================ *)

nZ = 8; nP = 8;
gammas = Table[N[Im[ZetaZero[n]], 15], {n, nZ}];
lnP = Table[Log[N[Prime[j], 15]], {j, nP}];
primes = Prime /@ Range[nP];

(* === Find k that puts seed closest to target value === *)
bestK[alpha_, target_, kMax_: 100] := Module[{bestk = 1, bestErr = Infinity},
  Do[
    Module[{err = Abs[Cos[alpha/k] - target]},
      If[err < bestErr, bestErr = err; bestk = k]
    ],
  {k, 1, kMax}];
  {bestk, Cos[alpha/bestk], bestErr}
]

(* === Per-zero: best k2 for target seed = 1/2 === *)
Print["=== Best k₂ per zero for seed → 1/2 ==="];
Do[
  {bk, bseed, berr} = bestK[gammas[[n]], 0.5];
  Print["ρ_", n, ": k₂=", bk, ", seed=", NumberForm[bseed, {6, 4}],
    ", error=", ScientificForm[berr, 2]],
{n, nZ}]

(* === Per-prime: best k1 for target seed = 1/2 === *)
Print["\n=== Best k₁ per prime for seed → 1/2 ==="];
Do[
  {bk, bseed, berr} = bestK[lnP[[j]], 0.5];
  Print["p=", primes[[j]], ": k₁=", bk, ", seed=", NumberForm[bseed, {6, 4}],
    ", error=", ScientificForm[berr, 2]],
{j, nP}]

(* === Grid search: all targets, all criteria === *)
targets = {0 -> "period 4", 1/2 -> "period 6", 1/Sqrt[2] -> "period 8",
           Sqrt[3]/2 -> "period 12"};
Print["\n=== Best k₂ for zero 1, various targets ==="];
Do[
  {bk, bseed, berr} = bestK[gammas[[1]], target, 200];
  Print["  target ", label, " (", NumberForm[N[target], 4], "): k₂=", bk,
    ", seed=", NumberForm[bseed, {6, 4}], ", error=", ScientificForm[berr, 2]],
{target -> label, targets}]

(* === CF-based optimal k === *)
Print["\n=== CF convergents of γ₁/π ==="];
cf = ContinuedFraction[gammas[[1]]/Pi, 8];
Print["CF = ", cf];
convs = Convergents[ContinuedFraction[gammas[[1]]/Pi, 8]];
Print["Convergents: ", convs];
Do[
  p = Numerator[convs[[i]]]; q = Denominator[convs[[i]]];
  Print["  ", p, "/", q, ": seed cos(π/", q, ") = ",
    NumberForm[N[Cos[Pi/q]], {6, 4}],
    ", actual cos(γ₁/", p, ") = ", NumberForm[Cos[gammas[[1]]/p], {6, 4}]],
{i, 2, Min[6, Length[convs]]}]

(* === Build matrices for different k-criteria === *)
Print["\n=== Comparison of k-selection criteria ==="];

(* Criterion 1: minimal well-behaved *)
k2min = Table[Module[{k = 1},
  While[k < 200 && (Abs[Cos[gammas[[n]]/k]] > 0.95 || Abs[Cos[gammas[[n]]/k]] < 0.1), k++]; k],
{n, nZ}];

(* Criterion 2: closest to 1/2 *)
k2half = Table[bestK[gammas[[n]], 0.5, 100][[1]], {n, nZ}];

(* Criterion 3: closest to 0 *)
k2zero = Table[bestK[gammas[[n]], 0., 100][[1]], {n, nZ}];

Print["Zero | k₂(min) | k₂(→1/2) | k₂(→0)"];
Do[
  Print["ρ_", n, "  | ", k2min[[n]], "      | ", k2half[[n]], "       | ", k2zero[[n]]],
{n, nZ}]

(* === Symbolic matrix at smallest k values === *)
Print["\n=== Symbolic T_{K}(c) for k₂(min), k₁(min) ==="];
k1min = Table[Module[{k = 1},
  While[k < 200 && (Abs[Cos[lnP[[j]]/k]] > 0.95 || Abs[Cos[lnP[[j]]/k]] < 0.1), k++]; k],
{j, nP}];

Print["T-index matrix (k₂⊗k₁):"];
Print[MatrixForm[Outer[Times, k2min, k1min]]];

Print["\nPolynomial degrees:"];
Print[MatrixForm[Outer[Times, k2min, k1min]]];

Print["\nDistinct polynomials needed: ",
  Union[Flatten[Outer[Times, k2min, k1min]]]];
