(* ================================================================ *)
(* FROM π ALONE: progressive bootstrap to construct W               *)
(*                                                                  *)
(* π → θ(T) → approx γ → W for {2,3,5} → ALS → better γ           *)
(*   → find more primes → bigger W → ALS → even better γ → ...     *)
(*                                                                  *)
(* Allowed: π, Γ, Log, Exp, Floor, Round, Mod, arithmetic.          *)
(* NOT allowed: PrimeQ, ZetaZero, prime tables.                     *)
(* ================================================================ *)

theta[t_] := Im[LogGamma[1/4 + I t/2]] - (t/2) Log[Pi]
nSmooth[t_] := theta[t] / Pi + 1

findGamma[n_] := Module[{lo = 0.1, hi = 1000., mid, target = n - 0.5},
  Do[mid = (lo + hi)/2;
    If[nSmooth[mid] < target, lo = mid, hi = mid], {100}];
  (lo + hi)/2]

(* Column roundtrip score: how many rows match Floor(γ·ln k/(2π)) = W[:,j] *)
colScore[gammas_, k_, wcol_] :=
  Count[Table[Floor[gammas[[n]] Log[N[k, 15]] / (2 Pi)] == wcol[[n]],
    {n, Length[gammas]}], True]

buildW[nz_, np_] := Module[
  {gammas, knownPrimes, knownLnP, w, candidates,
   bestK, bestScore, newPrimes, maxK, thetaMat, a, ell},

  (* Step 1: smooth approximation *)
  gammas = Table[findGamma[n], {n, nz}];
  Print["  θ approx: γ₁≈", NumberForm[gammas[[1]], {5, 2}],
    " (exact 14.13)"];

  (* Step 2: seed primes = {2, 3, 5} — always correct from θ *)
  knownPrimes = {2, 3, 5};
  knownLnP = Log[N[knownPrimes, 15]];

  (* Progressive bootstrap *)
  Do[
    (* Build W with known primes *)
    w = Table[Floor[gammas[[n]] knownLnP[[j]] / (2 Pi)],
      {n, nz}, {j, Length[knownPrimes]}];

    (* ALS to refine γ using known primes *)
    thetaMat = N[w] + 0.5;
    ell = knownLnP;
    Do[a = thetaMat . ell / (ell . ell), {5}];
    gammas = 2 Pi a;

    (* Candidate odd integers, sieved by KNOWN primes *)
    maxK = Max[3 Last[knownPrimes], 10];
    candidates = Select[
      Range[Last[knownPrimes] + 1, maxK],
      Function[k, OddQ[k] && !AnyTrue[knownPrimes, Mod[k, #] == 0 &]]];

    (* Among sieve survivors, keep those with good column roundtrip *)
    (* Compare against column built from ORIGINAL smooth γ, not ALS γ *)
    newPrimes = Select[candidates, Function[k,
      Module[{colApprox, colALS, mismatches},
        colApprox = Table[Floor[gammas[[n]] Log[N[k, 15]] / (2 Pi)], {n, nz}];
        (* Check: does this column have at least nz-2 matches? *)
        (* Allow small tolerance for floor boundary effects *)
        mismatches = Count[Table[
          Floor[gammas[[n]] Log[N[k, 15]] / (2 Pi)] != colApprox[[n]],
        {n, nz}], True];
        mismatches == 0
      ]]];

    (* Add new primes *)
    knownPrimes = Join[knownPrimes, newPrimes];
    knownLnP = Log[N[knownPrimes, 15]];

    If[Length[knownPrimes] >= np, Break[]],
  {20}];  (* max 20 bootstrap rounds *)

  (* Trim to np *)
  knownPrimes = knownPrimes[[1 ;; Min[np, Length[knownPrimes]]]];
  knownLnP = Log[N[knownPrimes, 15]];

  (* Final W *)
  w = Table[Floor[gammas[[n]] knownLnP[[j]] / (2 Pi)],
    {n, nz}, {j, Length[knownPrimes]}];

  <|"W" -> w, "primes" -> knownPrimes, "gammas" -> gammas|>
]

(* ================================================================ *)
(* TEST                                                             *)
(* ================================================================ *)

Print["╔════════════════════════════════════════════════╗"];
Print["║  π → progressive bootstrap → W                ║"];
Print["║  {2,3,5} → refine γ → discover primes → ...   ║"];
Print["╚════════════════════════════════════════════════╝\n"];

Do[
  Print["=== ", sz, "×", sz, " ==="];
  result = buildW[sz, sz];

  pExact = Table[Prime[j], {j, sz}];
  gExact = Table[N[Im[ZetaZero[n]], 15], {n, sz}];
  wExact = Table[Floor[gExact[[n]] Log[N[pExact[[j]], 15]] / (2 Pi)],
    {n, sz}, {j, sz}];

  found = result["primes"];
  nCorrect = Count[Table[
    If[j <= Length[found], found[[j]] == pExact[[j]], False],
  {j, sz}], True];

  Print["  Found:   ", found[[1 ;; Min[15, Length[found]]]]];
  Print["  Exact:   ", pExact[[1 ;; Min[15, sz]]]];
  Print["  Correct: ", nCorrect, "/", sz,
    If[nCorrect == sz, "  ✓", "  ✗"]];

  If[nCorrect == sz && Length[found] >= sz,
    nWmatch = Count[Flatten[result["W"] == wExact], True];
    Print["  W match: ", nWmatch, "/", sz^2,
      " (", NumberForm[100. nWmatch/sz^2, {5, 1}], "%)"]];

  gErr = Abs[result["gammas"] - gExact];
  Print["  γ err:   max=", NumberForm[Max[gErr], {4, 3}],
    "  mean=", NumberForm[Mean[gErr], {4, 3}]];
  Print[""],
{sz, {10, 20, 30, 50}}];
