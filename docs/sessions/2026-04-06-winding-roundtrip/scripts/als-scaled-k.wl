(* ================================================================ *)
(* ALS ROUNDTRIP with scaled winding matrix W^(k)                  *)
(* W^(k)_{np} = Floor[k γ_n ln(p_j) / (2π)]                      *)
(* Recovery: γ_n = 2π a_n / k                                     *)
(* ================================================================ *)

generateWScaled[nz_, np_, k_] := Module[{g, lp},
  g = Table[N[Im[ZetaZero[n]], 15], {n, nz}];
  lp = Table[Log[N[Prime[j], 15]], {j, np}];
  Table[Floor[k g[[n]] lp[[j]] / (2 Pi)], {n, nz}, {j, np}]
]

(* Roundtrip-sieve snap: identical logic, but a-vector is scaled by k *)
snapByRoundtripK[ellj_, avec_, wcol_, colIdx_] := Module[
  {nCenter, candidates, scores, best},
  nCenter = Max[2, Round[Exp[ellj]]];
  candidates = Range[Max[2, nCenter - 4], nCenter + 4];
  If[colIdx > 1,
    candidates = Select[candidates, OddQ]];
  candidates = Select[candidates, # >= 2 &];
  scores = Table[
    {Count[Table[
      Floor[avec[[n]] Log[N[k, 15]] / (2 Pi)] != wcol[[n]],
     {n, Length[avec]}], True],
     Abs[Log[N[k, 15]] - ellj]},
  {k, candidates}];
  best = candidates[[First[Ordering[scores]]]];
  Log[N[best, 15]]
]

(* Full pipeline for scaled W *)
latticeRoundtripScaled[w_, kScale_] := Module[
  {nz, np, theta, a, ell, gammas, integers, R, wRecon, rt, uu,
   nALS = 10, nSieve = 5},
  {nz, np} = Dimensions[w];
  theta = N[w] + 0.5;

  (* Initialize from SVD *)
  uu = First[SingularValueDecomposition[theta]];
  a = uu[[All, 1]];
  If[a[[1]] < 0, a = -a];
  a = a * Norm[theta, "Frobenius"] / Norm[a];

  (* ALS with integer snap *)
  Do[
    ell = Transpose[theta] . a / (a . a);
    ell = ell * (Log[2.] / ell[[1]]);
    ell = Log[N[Max[2, Round[#]] & /@ Exp[ell], 15]];
    a = theta . ell / (ell . ell);
  , {nALS}];

  (* Roundtrip sieve — use SCALED a for floor check *)
  Do[
    (* a-vector from ALS corresponds to k·γ/(2π), so
       floor check uses a·ln(p), matching W^(k) construction *)
    gammas = 2 Pi a;  (* this is k·γ, used for floor checking *)
    Do[
      ell[[j]] = snapByRoundtripK[ell[[j]], gammas, w[[All, j]], j],
    {j, np}];
    a = theta . ell / (ell . ell);
  , {nSieve}];

  (* Extract: γ_n = 2π a_n / k *)
  gammas = 2 Pi a / kScale;
  integers = Round[Exp[ell]];
  wRecon = Table[Floor[kScale gammas[[n]] ell[[j]] / (2 Pi)],
    {n, nz}, {j, np}];
  rt = 100. Count[Flatten[w - wRecon], 0] / (nz np);

  <|"gammas" -> gammas, "integers" -> integers,
    "lnP" -> ell, "roundtrip" -> rt|>
]

(* ================================================================ *)
(* BENCHMARK: k=1 vs k=11/4 vs k=2π                                *)
(* ================================================================ *)

Print["╔══════════════════════════════════════════════════════╗"];
Print["║  ALS ROUNDTRIP: Scaling comparison                   ║"];
Print["║  k=1 (standard) vs k=11/4 vs k=2π                   ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

kValues = {1, 11/4, 2 Pi};
kLabels = {"k=1", "k=11/4", "k=2π"};

sizes = {5, 10, 15, 20, 30, 50, 100};

Do[
  Print["═══ ", sz, "×", sz, " ═══"];
  pExact = Table[Prime[j], {j, sz}];
  gExact = Table[N[Im[ZetaZero[n]], 15], {n, sz}];

  Do[
    {kv, kl} = {kValues[[ki]], kLabels[[ki]]};
    w = generateWScaled[sz, sz, kv];

    (* Check singularity *)
    isSing = If[sz <= 35, Det[w] == 0, "—"];

    result = latticeRoundtripScaled[w, kv];

    nCorrect = Count[
      Table[result["integers"][[j]] == pExact[[j]], {j, sz}], True];
    gErr = Abs[result["gammas"] - gExact];

    Print["  ", kl, ": primes=", nCorrect, "/", sz,
      If[nCorrect == sz, " ✓", " ✗"],
      "  γ_max=", NumberForm[Max[gErr], {4, 3}],
      "  γ_mean=", NumberForm[Mean[gErr], {4, 3}],
      "  W_rt=", NumberForm[result["roundtrip"], {5, 1}], "%",
      "  det=0: ", isSing],
  {ki, Length[kValues]}];
  Print[""],
{sz, sizes}];
