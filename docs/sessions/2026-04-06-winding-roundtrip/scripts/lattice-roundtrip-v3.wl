(* ================================================================ *)
(* LATTICE ROUNDTRIP v3: W → γ, primes, R, M                       *)
(* NO PrimeQ. Primes emerge from roundtrip consistency.             *)
(*                                                                  *)
(* Θ = W + ½                                                        *)
(* ALS: ℓ ← Θᵀa/‖a‖², snap eˡ → Round, a ← Θℓ/‖ℓ‖²              *)
(* Then: roundtrip-sieve each column against nearby integers        *)
(* ================================================================ *)

generateW[nz_, np_] := Module[{g, lp},
  g = Table[N[Im[ZetaZero[n]], 15], {n, nz}];
  lp = Table[Log[N[Prime[j], 15]], {j, np}];
  Table[Floor[g[[n]] lp[[j]] / (2 Pi)], {n, nz}, {j, np}]
]

(* === Roundtrip-sieve snap === *)
(* Try ODD integers near Exp[ℓ_j] (+ 2 for first column). *)
(* Score: (mismatches, distance to ALS estimate) — lexicographic *)
(* Why odd? The matrix itself tells us p₁=2 (smallest column). *)
(* All other primes are odd — this is Mod[n,2], not PrimeQ.   *)
snapByRoundtrip[ellj_, avec_, wcol_, colIdx_] := Module[
  {nCenter, candidates, scores, best},
  nCenter = Max[2, Round[Exp[ellj]]];
  candidates = Range[Max[2, nCenter - 4], nCenter + 4];
  (* First column: allow 2. All others: odd only. *)
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

(* === Full pipeline === *)
latticeRoundtrip[w_] := Module[
  {nz, np, theta, a, ell, gammas, integers, R, M, wRecon, rt, uu},
  {nz, np} = Dimensions[w];
  theta = N[w] + 0.5;

  (* Initialize from SVD *)
  uu = First[SingularValueDecomposition[theta]];
  a = uu[[All, 1]];
  If[a[[1]] < 0, a = -a];
  a = a * Norm[theta, "Frobenius"] / Norm[a];

  (* ALS with integer snap (no PrimeQ) *)
  Do[
    ell = Transpose[theta] . a / (a . a);
    ell = ell * (Log[2.] / ell[[1]]);
    ell = Log[N[Max[2, Round[#]] & /@ Exp[ell], 15]];
    a = theta . ell / (ell . ell);
  , {10}];

  (* Roundtrip-sieve iterations: sieve → refine a → re-sieve *)
  Do[
    gammas = 2 Pi a;
    Do[
      ell[[j]] = snapByRoundtrip[ell[[j]], gammas, w[[All, j]], j],
    {j, np}];
    a = theta . ell / (ell . ell);
  , {5}];
  gammas = 2 Pi a;

  (* Extract *)
  integers = Round[Exp[ell]];
  R = Table[gammas[[n]] ell[[j]] / (2 Pi) - w[[n, j]], {n, nz}, {j, np}];
  M = Cos[2 Pi R];
  wRecon = Table[Floor[gammas[[n]] ell[[j]] / (2 Pi)], {n, nz}, {j, np}];
  rt = 100. Count[Flatten[w - wRecon], 0] / (nz np);

  <|"gammas" -> gammas, "integers" -> integers,
    "lnP" -> ell, "R" -> R, "M" -> M,
    "wRecon" -> wRecon, "roundtrip" -> rt|>
]

(* ================================================================ *)
(* TESTS                                                            *)
(* ================================================================ *)

Print["╔══════════════════════════════════════════════════════╗"];
Print["║  LATTICE ROUNDTRIP v3: NO PrimeQ                    ║"];
Print["║  Primes emerge from roundtrip consistency            ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

Do[
  w = generateW[sz, sz];
  result = latticeRoundtrip[w];

  pExact = Table[Prime[j], {j, sz}];
  gExact = Table[N[Im[ZetaZero[n]], 15], {n, sz}];
  nCorrect = Count[Table[result["integers"][[j]] == pExact[[j]], {j, sz}], True];
  gErr = Abs[result["gammas"] - gExact];

  mExact = Table[Cos[gExact[[n]] Log[N[pExact[[j]], 15]]], {n, sz}, {j, sz}];

  Print["=== ", sz, "×", sz, " ==="];
  Print["  Integers found: ", result["integers"][[1 ;; Min[10, sz]]]];
  Print["  Primes exact:   ", pExact[[1 ;; Min[10, sz]]]];
  Print["  Correct: ", nCorrect, "/", sz,
    If[nCorrect == sz, "  ✓", "  ✗"]];
  Print["  γ err: max=", NumberForm[Max[gErr], {4, 3}],
    " mean=", NumberForm[Mean[gErr], {4, 3}]];
  Print["  W roundtrip: ", NumberForm[result["roundtrip"], {5, 1}], "%"];
  Print["  M max err: ", NumberForm[Max[Abs[result["M"] - mExact]], {4, 3}]];
  If[nCorrect < sz,
    wrong = Select[Range[sz], result["integers"][[#]] != pExact[[#]] &];
    Print["  Wrong: ", Table[{j, pExact[[j]], "→", result["integers"][[j]]}, {j, wrong[[1;;Min[5, Length[wrong]]]]}]];
  ];
  Print[""],
{sz, {5, 10, 15, 20, 30, 50, 100}}];
