<< Orbit`

(* ============================================================ *)
(* PART 1: Confirm growing correction order at j=q1+1,+2,+3... *)
(* For [3; 7, a2] vs Pi at heights 8,9,10,...                   *)
(* ============================================================ *)

polyRational[alpha_Rational, j_, windowSize_: 300] := Module[
  {maxN, row, firstNZ, pts},
  maxN = Ceiling[j * alpha] + windowSize;
  row = BeattyBallotCount[alpha, All, {maxN, j}];
  firstNZ = FirstPosition[row, _?(# > 0 &)];
  If[MissingQ[firstNZ], Return[$Failed]];
  firstNZ = firstNZ[[1]];
  pts = Table[{nn, row[[nn]]}, {nn, firstNZ, Min[firstNZ + 2 j + 10, maxN]}];
  InterpolatingPolynomial[pts, n] // Expand
]

polyIrrational[alpha_, j_] := Module[
  {convs, maxK, cv, a, b, maxPos, prevPos, row, pts},
  convs = Convergents[alpha, 25];
  maxK = First@FirstPosition[Denominator /@ convs, _?(# > 2 j &)] + 1;
  cv = Convergents[alpha, maxK];
  {a, b} = Take[cv, -2];
  maxPos = Numerator[b];
  prevPos = Numerator[a];
  row = BeattyBallotCount[alpha, All, {maxPos, j}];
  pts = Table[{nn, row[[nn]]}, {nn, prevPos, maxPos}];
  InterpolatingPolynomial[pts, n] // Expand
]

Print["=== PART 1: Correction order for [3;7,1]=25/8 vs Pi ==="];
Print[""];

Do[
  polyPi = polyIrrational[Pi, j];
  polyR = polyRational[25/8, j, 500];
  If[polyR === $Failed, Print["j=", j, ": FAILED"]; Continue[]];
  diff = Expand[polyPi - polyR];
  deg = If[diff === 0, -1, Exponent[diff, n]];
  Print["j=", j, " (q1+", j-7, "): correction degree = ", deg,
    "  correction = ", Factor[diff]];,
  {j, 7, 14}
];

Print[""];
Print["=== Also [3;7,2]=47/15 vs Pi (q2=15, diverge at j=15) ==="];
Print[""];

Do[
  polyPi = polyIrrational[Pi, j];
  polyR = polyRational[47/15, j, 500];
  If[polyR === $Failed, Print["j=", j, ": FAILED"]; Continue[]];
  diff = Expand[polyPi - polyR];
  deg = If[diff === 0, -1, Exponent[diff, n]];
  Print["j=", j, ": ", If[diff === 0, "IDENTICAL", "correction deg=" <> ToString[deg]]];,
  {j, 13, 18}
];

(* ============================================================ *)
(* PART 2: Re-examine prime factorization of P(p/q)             *)
(* Check: primes with exponent > 1 — are they always 2?         *)
(*        and do they always divide p?                           *)
(* ============================================================ *)

Print[""];
Print["=== PART 2: Detailed prime factorization analysis ==="];
Print[""];

poly3 = x (x + 22) (x + 23) (x + 24) (x + 25) (x + 26) (x + 27) / 5040;

(* For each p/q with q>1, find primes with exp>1 *)
Print["Non-squarefree cases — which primes have exp>1?"];
Print["Format: p/q: {prime, exp} pairs with exp>1, divides_p?"];
Print[""];

violations = 0; onlyTwoCount = 0; totalNonSqf = 0;
Do[
  If[GCD[p, q] > 1, Continue[]];
  val = poly3 /. x -> p/q;
  num = Numerator[val];
  If[num == 0, Continue[]];
  factors = FactorInteger[Abs[num]];
  highPowers = Select[factors, #[[2]] > 1 &];
  If[Length[highPowers] == 0, Continue[]];  (* squarefree, skip *)
  totalNonSqf++;

  onlyTwo = AllTrue[highPowers, #[[1]] == 2 &];
  If[onlyTwo, onlyTwoCount++];

  divP = AllTrue[highPowers, Divisible[p, #[[1]]] &];
  If[!divP || !onlyTwo,
    violations++;
    If[violations <= 30,
      Print["  ", p, "/", q, ": high powers=", highPowers,
        "  only2=", onlyTwo, "  all|p=", divP];
    ];
  ];,
  {q, 2, 50}, {p, 1, 100}
];

Print[""];
Print["Total non-squarefree: ", totalNonSqf];
Print["  of which only-2 has exp>1: ", onlyTwoCount,
  " (", N[100 onlyTwoCount/totalNonSqf, 4], "%)"];
Print["  violations (not only-2 OR not all|p): ", violations];

Print[""];
Print["=== Refined check: for primes other than {2,3,5,7} (dividing 5040) ==="];
Print["=== does any prime > 7 appear with exp > 1? ==="];
Print[""];

bigPrimeSquare = 0; totalChecked = 0;
Do[
  If[GCD[p, q] > 1, Continue[]];
  val = poly3 /. x -> p/q;
  num = Numerator[val];
  If[num == 0, Continue[]];
  totalChecked++;
  factors = FactorInteger[Abs[num]];
  bigHigh = Select[factors, #[[1]] > 7 && #[[2]] > 1 &];
  If[Length[bigHigh] > 0,
    bigPrimeSquare++;
    If[bigPrimeSquare <= 15,
      Print["  ", p, "/", q, ": ", bigHigh,
        "  divides p? ", AllTrue[bigHigh, Divisible[p, #[[1]]] &]];
    ];
  ];,
  {q, 2, 50}, {p, 1, 100}
];

Print[""];
Print["Primes > 7 with exp > 1: ", bigPrimeSquare, " out of ", totalChecked];
If[bigPrimeSquare > 0,
  Print["So large primes CAN appear squared."];
  Print["But: do they always divide p?"];
  Print[""];

  (* recheck: for primes > 7 with exp > 1, do they always divide p? *)
  divPcount = 0; notDivP = 0;
  Do[
    If[GCD[p, q] > 1, Continue[]];
    val = poly3 /. x -> p/q;
    num = Numerator[val];
    If[num == 0, Continue[]];
    factors = FactorInteger[Abs[num]];
    bigHigh = Select[factors, #[[1]] > 7 && #[[2]] > 1 &];
    Do[
      If[Divisible[p, bh[[1]]], divPcount++, notDivP++];,
      {bh, bigHigh}
    ];,
    {q, 2, 50}, {p, 1, 100}
  ];
  Print["Primes>7 with exp>1: divides p: ", divPcount, ", NOT divides p: ", notDivP];
];
