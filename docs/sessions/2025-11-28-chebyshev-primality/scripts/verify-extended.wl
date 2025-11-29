(* Extended verification of the formula with random primes *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Formula *)
predictedSignSum[p1_, p2_, p3_] := Module[
  {M2, M3, e2, e3, c2, c3, inv12, inv13, inv23,
   r2, r3, delta, invSum},

  M2 = p1 p3; M3 = p1 p2;
  e2 = PowerMod[M2, -1, p2];
  e3 = PowerMod[M3, -1, p3];
  c2 = Mod[M2 e2, 2];
  c3 = Mod[M3 e3, 2];

  inv12 = Mod[PowerMod[p1, -1, p2], 2];
  inv13 = Mod[PowerMod[p1, -1, p3], 2];
  inv23 = Mod[PowerMod[p2, -1, p3], 2];
  invSum = inv12 + inv13 + inv23;

  r2 = Mod[p2, p1];
  r3 = Mod[p3, p1];

  delta = Mod[c2 + c3 + invSum, 2];

  Which[
    r2 == 1 && r3 == 1, 3 - 4 delta,
    (r2 == 1 && r3 == 2) || (r2 == 2 && r3 == 1), -1 + 4 delta,
    r2 == 2 && r3 == 2, -5 - 4 delta
  ]
];

(* Systematic test on larger range *)
Print["=== Systematic test: p1=3, p2 up to 200, p3 up to 500 ==="];
errors = 0;
total = 0;
Do[
  If[p2 > 3 && p3 > p2,
    k = 3 p2 p3;
    actual = signSum[k];
    predicted = predictedSignSum[3, p2, p3];
    total++;
    If[actual != predicted,
      Print["ERROR: k=", k, " actual=", actual, " predicted=", predicted];
      errors++
    ]
  ],
  {p2, Prime[Range[3, 50]]},  (* primes up to ~229 *)
  {p3, Prime[Range[4, 100]]}  (* primes up to ~541 *)
];
Print["Systematic: Tested ", total, " cases, errors: ", errors];

(* Random test with larger primes *)
Print["\n=== Random test: primes in range 100-1000 ==="];
SeedRandom[12345];
errors2 = 0;
total2 = 0;
primesInRange = Select[Range[100, 1000], PrimeQ];
Print["Available primes: ", Length[primesInRange]];

Do[
  (* Pick 3 random distinct primes, sort them *)
  primes = Sort[RandomSample[primesInRange, 3]];
  {p1, p2, p3} = primes;

  (* Only test if p1 = 3... but these are all > 100, so use smallest *)
  (* Actually, our formula is for p1=3. Let's test differently: *)
  (* Use p1=3 with random large p2, p3 *)
  {p2, p3} = Sort[RandomSample[primesInRange, 2]];
  k = 3 p2 p3;
  actual = signSum[k];
  predicted = predictedSignSum[3, p2, p3];
  total2++;
  If[actual != predicted,
    Print["ERROR: k=", k, " = 3×", p2, "×", p3, " actual=", actual, " predicted=", predicted];
    errors2++
  ],
  {200}
];
Print["Random (3 × large × large): Tested ", total2, " cases, errors: ", errors2];

(* Random test with very large primes *)
Print["\n=== Random test: primes in range 1000-5000 ==="];
primesLarge = Select[Range[1000, 5000], PrimeQ];
errors3 = 0;
total3 = 0;

Do[
  {p2, p3} = Sort[RandomSample[primesLarge, 2]];
  k = 3 p2 p3;
  actual = signSum[k];
  predicted = predictedSignSum[3, p2, p3];
  total3++;
  If[actual != predicted,
    Print["ERROR: k=", k, " actual=", actual, " predicted=", predicted];
    errors3++
  ],
  {50}  (* fewer due to computation time *)
];
Print["Random (3 × very large × very large): Tested ", total3, " cases, errors: ", errors3];

Print["\n=== TOTAL ==="];
Print["Total tested: ", total + total2 + total3, " cases"];
Print["Total errors: ", errors + errors2 + errors3];
If[errors + errors2 + errors3 == 0,
  Print["FORMULA VERIFIED on all ", total + total2 + total3, " cases!"]
];
