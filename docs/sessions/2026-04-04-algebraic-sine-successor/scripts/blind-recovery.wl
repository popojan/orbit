(* ================================================================ *)
(* BLIND RECOVERY: from winding matrix (pure integers) alone        *)
(* Recover γ_n AND ln p without knowing either                     *)
(* ================================================================ *)

(* === Generate winding matrix (for testing) === *)
generateW[nz_, np_] := Module[{g, lp},
  g = Table[N[Im[ZetaZero[n]], 15], {n, nz}];
  lp = Table[Log[N[Prime[j], 15]], {j, np}];
  Table[Floor[g[[n]] lp[[j]] / (2 Pi)], {n, nz}, {j, np}]
]

(* === Blind SVD: w ≈ σ₁ u₁ v₁ᵀ, u₁ ∝ γ, v₁ ∝ ln p === *)
blindSVD[w_] := Module[{uu, ss, vv},
  {uu, ss, vv} = SingularValueDecomposition[N[w]];
  <|"u1" -> uu[[All, 1]], "v1" -> vv[[All, 1]],
    "s1" -> ss[[1, 1]], "svd" -> Diagonal[ss]|>
]

(* === Hybrid: know γ₁, recover everything === *)
hybridFromGamma1[w_, gamma1_] := Module[
  {svd, u1, v1, s1, scaleG, gRecov, scaleP, lnPRecov, pRecov, wRecon},
  svd = blindSVD[w];
  u1 = svd["u1"]; v1 = svd["v1"]; s1 = svd["s1"];
  scaleG = gamma1 / u1[[1]];
  gRecov = scaleG u1;
  scaleP = 2 Pi s1 / scaleG;
  lnPRecov = scaleP v1;
  pRecov = Exp[lnPRecov];
  wRecon = Table[Floor[gRecov[[n]] lnPRecov[[j]] / (2 Pi)],
    {n, Length[u1]}, {j, Length[v1]}];
  <|"gammas" -> gRecov, "lnPrimes" -> lnPRecov, "primes" -> pRecov,
    "wRecon" -> wRecon,
    "roundtrip" -> 100. Count[Flatten[w - wRecon], 0] / Length[Flatten[w]]|>
]

(* === Hybrid: know ln 2, recover everything === *)
hybridFromLn2[w_] := Module[
  {svd, u1, v1, s1, scaleP, lnPRecov, scaleG, gRecov, wRecon},
  svd = blindSVD[w];
  u1 = svd["u1"]; v1 = svd["v1"]; s1 = svd["s1"];
  scaleP = Log[2.] / v1[[1]];
  lnPRecov = scaleP v1;
  scaleG = 2 Pi s1 * v1[[1]] / Log[2.]; (* from s1 u1 v1 = γ lnp/(2π) *)
  gRecov = 2 Pi s1 u1 / scaleP;
  wRecon = Table[Floor[gRecov[[n]] lnPRecov[[j]] / (2 Pi)],
    {n, Length[u1]}, {j, Length[v1]}];
  <|"gammas" -> gRecov, "lnPrimes" -> lnPRecov,
    "primes" -> Exp[lnPRecov], "wRecon" -> wRecon,
    "roundtrip" -> 100. Count[Flatten[w - wRecon], 0] / Length[Flatten[w]]|>
]

(* === Iterative refinement: SVD → round to primes → refine γ → repeat === *)
iterativeRefine[w_, gamma1_, nIter_: 5] := Module[
  {nz, np, svd, u1, v1, s1, scaleG, gRecov, lnPRecov, pCandidates,
   lnPRefined, gRefined, wRecon, rt},
  {nz, np} = Dimensions[w];

  (* Step 0: SVD seed *)
  svd = blindSVD[w];
  u1 = svd["u1"]; v1 = svd["v1"]; s1 = svd["s1"];
  scaleG = gamma1 / u1[[1]];
  gRecov = scaleG u1;
  lnPRecov = 2 Pi s1 v1 / scaleG;

  Do[
    (* Step A: round exp(lnP) to nearest prime *)
    pCandidates = Table[
      Module[{pRaw = Exp[lnPRecov[[j]]], pNear},
        pNear = Round[pRaw];
        (* Find nearest prime *)
        While[!PrimeQ[pNear] && pNear > 1, pNear--];
        If[!PrimeQ[pNear], pNear = NextPrime[Round[pRaw] - 1]];
        pNear],
    {j, np}];
    lnPRefined = Log[N[pCandidates]];

    (* Step B: with exact ln p, recover γ from multi-base intersection *)
    gRefined = Table[Module[{lo = 0., hi = 10000.},
      Do[
        lo = Max[lo, 2 Pi w[[n, j]] / lnPRefined[[j]]];
        hi = Min[hi, 2 Pi (w[[n, j]] + 1) / lnPRefined[[j]]],
      {j, np}];
      (lo + hi) / 2],
    {n, nz}];

    (* Step C: with refined γ, re-derive lnP from SVD *)
    (* Actually: once we have exact primes, just use multi-base *)
    gRecov = gRefined;
    lnPRecov = lnPRefined;

    (* Check roundtrip *)
    wRecon = Table[Floor[gRecov[[n]] lnPRecov[[j]] / (2 Pi)],
      {n, nz}, {j, np}];
    rt = 100. Count[Flatten[w - wRecon], 0] / (nz np);

    Print["  Iter ", iter, ": primes=", pCandidates[[1;;Min[5,np]]],
      "... roundtrip=", NumberForm[rt, {4, 1}], "%",
      If[rt > 99, " ★★★", ""]],
  {iter, nIter}];

  <|"gammas" -> gRecov, "primes" -> pCandidates,
    "roundtrip" -> rt|>
]

(* === TESTS === *)
Print["=== Blind SVD scaling ===\n"];
Do[
  w = generateW[sz, sz];
  svd = blindSVD[w];
  gEx = Table[N[Im[ZetaZero[n]], 15], {n, sz}];
  lnPEx = Table[Log[N[Prime[j], 15]], {j, sz}];
  ratU = svd["u1"] / svd["u1"][[1]];
  ratG = gEx / gEx[[1]];
  ratV = svd["v1"] / svd["v1"][[1]];
  ratP = lnPEx / lnPEx[[1]];
  Print[sz, "×", sz,
    ": γ ratio RMS=", NumberForm[Sqrt[Mean[(ratU - ratG)^2]], {3, 2}],
    ", lnp ratio RMS=", NumberForm[Sqrt[Mean[(ratV - ratP)^2]], {3, 2}]],
{sz, {10, 20, 50, 100}}];

Print["\n=== Iterative refinement (γ₁ known) ===\n"];
Do[
  Print["--- ", sz, "×", sz, " ---"];
  w = generateW[sz, sz];
  result = iterativeRefine[w, N[Im[ZetaZero[1]], 15], 3];
  (* Verify primes *)
  exactP = Table[Prime[j], {j, sz}];
  nCorrectP = Count[Table[result["primes"][[j]] == exactP[[j]], {j, sz}], True];
  Print["  Correct primes: ", nCorrectP, "/", sz];
  Print[""],
{sz, {10, 20, 30, 50}}];
