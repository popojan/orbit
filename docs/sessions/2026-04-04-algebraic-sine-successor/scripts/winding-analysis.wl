(* ================================================================ *)
(* Winding matrix analysis — core computations from the session     *)
(* ================================================================ *)

(* === Build matrices === *)
buildW[nz_, np_] := Table[
  Floor[N[Im[ZetaZero[n]], 15] Log[N[Prime[j]]] / (2 Pi)],
{n, nz}, {j, np}]

buildM[nz_, np_] := Table[
  Cos[N[Im[ZetaZero[n]], 15] Log[N[Prime[j]]]],
{n, nz}, {j, np}]

(* === SVD scaling of winding matrix === *)
windingSVDScaling[szMax_: 50] := Do[
  w = buildW[sz, sz];
  svd = SingularValueList[N[w]];
  Print[sz, "×", sz,
    ": σ₁=", NumberForm[svd[[1]], {6, 1}],
    ", σ₁/σ₂=", NumberForm[svd[[1]]/svd[[2]], {5, 1}],
    ", rank-1: ", NumberForm[100 svd[[1]]^2/Total[svd^2], {6, 3}], "%"],
{sz, {4, 6, 8, 10, 15, 20, 30, 40, szMax}}]

(* === Pair correlation function === *)
pairCorrelation[alpha_, nz_: 500] := Module[{gammas},
  gammas = Table[N[Im[ZetaZero[n]], 12], {n, nz}];
  Mean[Cos[gammas alpha]]
]

(* === Von Mangoldt detection via pair correlation === *)
vonMangoldtDetection[nMax_: 40, nz_: 500] := Module[{gammas, cf},
  gammas = Table[N[Im[ZetaZero[n]], 12], {n, nz}];
  cf[alpha_] := Mean[Cos[gammas alpha]];
  Print["n  | Λ(n)      | -C(ln n)√n | prime power?"];
  Do[
    c = cf[Log[N[n]]];
    lambda = MangoldtLambda[n] // N;
    Print[n, If[n < 10, "  ", " "],
      "| ", NumberForm[lambda, {5, 2}],
      "   | ", NumberForm[-c Sqrt[N[n]], {6, 3}],
      "    | ", If[lambda > 0, If[PrimeQ[n], "prime",
        "p^" <> ToString[Round[Log[FactorInteger[n][[1, 1]], n]]]], ""]],
  {n, 2, nMax}]
]

(* === M^T M and MM^T correlation matrices === *)
correlationMatrices[nz_: 30, np_: 100] := Module[{gammas, lnP, m, mtm, mmt},
  gammas = Table[N[Im[ZetaZero[n]], 12], {n, nz}];
  lnP = Table[Log[N[Prime[j]]], {j, np}];
  m = Table[Cos[gammas[[n]] lnP[[j]]], {n, nz}, {j, np}];
  mtm = Transpose[m] . m / nz;  (* prime × prime *)
  mmt = m . Transpose[m] / np;  (* zero × zero *)
  <|"MtM" -> mtm, "MMt" -> mmt,
    "MtM_eigs" -> Sort[Eigenvalues[N[mtm]], Greater],
    "MMt_eigs" -> Sort[Eigenvalues[N[mmt]], Greater]|>
]

(* === Smith decomposition analysis === *)
smithAnalysis[szMax_: 25] := Do[
  w = buildW[sz, sz];
  {ss, dd, tt} = SmithDecomposition[w];
  diag = Table[dd[[i, i]], {i, sz}];
  lastNonzero = Select[diag, # != 0 &][[-1]];
  Print[sz, "×", sz,
    ": last inv. factor = ", lastNonzero,
    ", det = ", Det[w],
    ", max|S| = ", Max[Abs[Flatten[ss]]],
    ", max|T| = ", Max[Abs[Flatten[tt]]]],
{sz, Range[4, szMax]}]

(* === Winding matrix reconstruction from rows === *)
reconstructGamma[nn_, nPrimes_: 200] := Module[
  {gammaExact, wRow, interval, lp},
  gammaExact = N[Im[ZetaZero[nn]], 15];
  wRow = Table[Floor[gammaExact Log[N[Prime[j]]] / (2 Pi)], {j, nPrimes}];
  interval = {0., 100.};
  Do[
    lp = Log[N[Prime[j]]];
    interval = {Max[interval[[1]], wRow[[j]]/lp],
                Min[interval[[2]], (wRow[[j]] + 1)/lp]},
  {j, nPrimes}];
  <|"exact" -> gammaExact / (2 Pi),
    "interval" -> interval,
    "width" -> interval[[2]] - interval[[1]],
    "midpoint" -> Mean[interval],
    "error" -> Abs[Mean[interval] - gammaExact/(2 Pi)]|>
]

(* === Usage === *)
(*
windingSVDScaling[50]
vonMangoldtDetection[40, 500]
smithAnalysis[20]
reconstructGamma[1, 200]
*)
