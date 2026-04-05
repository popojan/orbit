(* ================================================================ *)
(* SELF-SUSTAINED BOOTSTRAP v2                                      *)
(* No PrimeQ, no MangoldtLambda — pure bootstrap                   *)
(* Bracketing zero-finder instead of Newton                         *)
(* ================================================================ *)

(* === Core functions === *)
theta[T_] := N[Im[LogGamma[1/4 + I T/2]] - T Log[Pi]/2, 20];
Nsmooth[T_] := theta[T]/Pi + 1;

SprimesFrom[T_, primeList_] := -1./Pi Total[Table[
  Sum[Sin[m N[T, 20] Log[N[p, 20]]] / (m N[p]^(m/2)), {m, 1, 5}],
{p, primeList}]];

(* Calibrate from known zeros *)
calibrate[knownGammas_, knownPrimes_] := Module[{offsets},
  offsets = Table[
    (j - 0.5) - Nsmooth[knownGammas[[j]]] - SprimesFrom[knownGammas[[j]], knownPrimes],
  {j, Length[knownGammas]}];
  Mean[offsets]
];

Ncal[T_, knownGammas_, knownPrimes_] := Module[{offset},
  offset = calibrate[knownGammas, knownPrimes];
  Nsmooth[T] + SprimesFrom[T, knownPrimes] + offset
];

(* === BRACKETING zero-finder === *)
(* Find T where Ncal(T) crosses target, using bisection *)
findZeroBracket[target_, knownGammas_, knownPrimes_, startT_] := Module[
  {lo, hi, mid, nLo, nHi, nMid, tol = 0.001, maxIter = 100, iter = 0},
  (* Find bracket: Ncal(lo) < target < Ncal(hi) *)
  lo = startT;
  hi = startT + 5;
  (* Expand bracket if needed *)
  While[Ncal[hi, knownGammas, knownPrimes] < target && hi < startT + 50,
    hi += 5];
  (* Bisect *)
  While[hi - lo > tol && iter < maxIter,
    mid = (lo + hi) / 2;
    nMid = Ncal[mid, knownGammas, knownPrimes];
    If[nMid < target, lo = mid, hi = mid];
    iter++
  ];
  (lo + hi) / 2
];

(* === Prime power check using ONLY known primes === *)
(* Is n a power of a known prime? If not, it's a new prime. *)
isPrimePowerOfKnown[n_, knownPrimes_] := Module[{},
  AnyTrue[knownPrimes, IntegerQ[Log[#, n]] && Log[#, n] >= 2 &]
];

(* === Von Mangoldt score from known zeros === *)
vmScore[n_, knownGammas_] := -Mean[Cos[knownGammas Log[N[n]]]] Sqrt[N[n]];

(* === THE BOOTSTRAP === *)
bootstrapRun[gamma1_, initialPrimes_, nSteps_: 20, vmThreshold_: 0.25] := Module[
  {knownGammas, knownPrimes, nextCandidate, gammaNew, lnP, wRow,
   interval, gammaRefined, score},

  knownGammas = {gamma1};
  knownPrimes = initialPrimes;
  nextCandidate = Max[initialPrimes] + 1;

  Print["=== BOOTSTRAP v2 (no PrimeQ, bracketing) ==="];
  Print["Seed: γ₁ = ", NumberForm[gamma1, {7, 3}], ", primes = ", initialPrimes, "\n"];

  Do[
    nZero = Length[knownGammas] + 1;

    (* Find next zero via bracketing *)
    gammaNew = findZeroBracket[
      nZero - 0.5,
      knownGammas, knownPrimes,
      Last[knownGammas] + 0.5
    ];

    (* Winding row refinement *)
    lnP = Log[N[knownPrimes]];
    wRow = Floor[gammaNew lnP / (2 Pi)];
    interval = {Last[knownGammas] + 0.1, gammaNew + 5}; (* loose *)
    Do[
      interval = {Max[interval[[1]], 2 Pi wRow[[j]] / lnP[[j]]],
                  Min[interval[[2]], 2 Pi (wRow[[j]] + 1) / lnP[[j]]]},
    {j, Length[lnP]}];
    gammaRefined = Mean[interval];

    AppendTo[knownGammas, gammaRefined];

    (* Verify against exact *)
    gammaExact = N[Im[ZetaZero[nZero]], 15];
    wExact = Floor[gammaExact lnP / (2 Pi)];

    Print["ρ_", nZero, ": γ = ", NumberForm[gammaRefined, {6, 2}],
      " (exact: ", NumberForm[gammaExact, {6, 2}],
      ", err: ", NumberForm[Abs[gammaRefined - gammaExact], {4, 2}],
      ") winding ", If[wRow == wExact, "✓", "✗"]];

    (* Discover primes: scan integers up to reasonable bound *)
    While[nextCandidate <= 2 gammaRefined / Pi + 5,
      score = vmScore[nextCandidate, knownGammas];
      If[score > vmThreshold,
        If[isPrimePowerOfKnown[nextCandidate, knownPrimes],
          (* It's a power of known prime — skip *)
          Print["     (", nextCandidate, " = prime power, skip)"],
          (* New prime! *)
          AppendTo[knownPrimes, nextCandidate];
          Print["     → discovered p = ", nextCandidate,
            " (score: ", NumberForm[score, {4, 2}], ")"]
        ]
      ];
      nextCandidate++
    ],
  {nSteps}];

  Print["\n=== RESULT ==="];
  Print["Zeros found: ", Length[knownGammas]];
  Print["Primes found: ", knownPrimes];

  (* Verify primes — for DISPLAY only, not used in algorithm *)
  falseP = Select[knownPrimes, !PrimeQ[#] &];
  If[Length[falseP] > 0,
    Print["FALSE PRIMES: ", falseP, " !!!"],
    Print["All discovered primes are correct ✓"]
  ];

  <|"gammas" -> knownGammas, "primes" -> knownPrimes|>
];

(* === RUN === *)
result = bootstrapRun[
  N[Im[ZetaZero[1]], 15],  (* γ₁ *)
  {2, 3},                   (* initial primes *)
  20                         (* steps *)
];
