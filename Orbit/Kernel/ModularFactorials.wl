(* ::Package:: *)

(* Efficient Modular Factorial Computation via Half-Factorial Base *)

BeginPackage["Orbit`"];

(* Usage messages *)
SqrtMod::usage = "SqrtMod[p] computes the modular square root of p-1 (i.e., sqrt(-1)) mod p. Returns {True, {r, p-r}} if the square root exists, or {False, {1, p-1}} otherwise. For odd prime p, sqrt(-1) exists iff p ≡ 1 (mod 4).";

HalfFactorialMod::usage = "HalfFactorialMod[p] computes ((p-1)/2)! mod p. For prime p, this equals ±1 if p ≡ 3 (mod 4), or ±sqrt(-1) if p ≡ 1 (mod 4).";

FactorialMod::usage = "FactorialMod[n, p] efficiently computes n! mod p for prime p, using the half-factorial as a base. Requires (p-1)/2 ≤ n < p. FactorialMod[n] uses p = NextPrime[2n, -1] and returns {p, n! mod p}.";

HalfFactorialValues::usage = "HalfFactorialValues[p] returns the possible values of ((p-1)/2)! mod p as {sqrt_exists, values}.";

VerifyFactorialMod::usage = "VerifyFactorialMod[n, p] verifies FactorialMod against naive Mod[n!, p] computation.";

(* Analysis functions *)
ClassifyPrimesByHalfFactorial::usage = "ClassifyPrimesByHalfFactorial[pmax] classifies all primes up to pmax by their half-factorial structure.";

Begin["`Private`"];

(* Check if sqrt(p-1) = sqrt(-1) exists mod p *)
SqrtMod[p_Integer?PrimeQ] := Module[{sqrt},
  Off[PowerMod::root];
  sqrt = PowerMod[p - 1, 1/2, p];
  On[PowerMod::root];
  If[IntegerQ[sqrt],
    {True, {sqrt, p - sqrt}},
    {False, {1, p - 1}}
  ]
];

(* Compute ((p-1)/2)! mod p - this is the efficient base value *)
HalfFactorialMod[p_Integer?PrimeQ] := Mod[((p - 1)/2)!, p];

(* Get the possible values for half-factorial mod p *)
HalfFactorialValues[p_Integer?PrimeQ] := Module[{sqrtResult},
  sqrtResult = SqrtMod[p];
  sqrtResult
];

(* Efficient factorial mod p using half-factorial base *)
(* For n in range (p-1)/2 <= n < p *)
FactorialMod[n_Integer, p_Integer?PrimeQ] := Module[{root, halfFact},
  root = SqrtMod[p];
  halfFact = HalfFactorialMod[p];

  (* Multiply from (p-1)/2 + 1 to n, starting from half-factorial *)
  Mod[
    Mod[Fold[Mod[#1 * #2, p] &, 1, Range[(p - 1)/2 + 1, n]], p] * halfFact,
    p
  ]
] /; (p - 1)/2 <= n < p;

(* Convenience form: use p = NextPrime[2n, -1] *)
FactorialMod[n_Integer] := Module[{p},
  p = NextPrime[2*n, -1];
  {p, FactorialMod[n, p]}
];

(* Naive computation for comparison *)
NaiveFactorialMod[n_Integer, p_Integer] := Mod[n!, p];

(* Verification *)
VerifyFactorialMod[n_Integer, p_Integer?PrimeQ] := Module[{computed, naive, match},
  computed = FactorialMod[n, p];
  naive = NaiveFactorialMod[n, p];
  match = (computed === naive);
  Association[{
    "n" -> n,
    "p" -> p,
    "FactorialMod" -> computed,
    "Naive" -> naive,
    "Match" -> match,
    "HalfFactorial" -> HalfFactorialMod[p],
    "SqrtMod" -> SqrtMod[p]
  }]
];

(* Batch verification *)
BatchVerifyFactorialMod[nValues_List, p_Integer?PrimeQ] := Module[{results},
  results = VerifyFactorialMod[#, p] & /@ Select[nValues, (p - 1)/2 <= # < p &];
  Association[{
    "p" -> p,
    "Total tested" -> Length[results],
    "All match" -> AllTrue[results, #["Match"] &],
    "Failures" -> Select[results, !#["Match"] &],
    "Results" -> results
  }]
];

(* Classify primes by their half-factorial structure *)
ClassifyPrimesByHalfFactorial[pmax_Integer] := Module[{primes, classified},
  primes = Select[Range[3, pmax], PrimeQ];
  classified = Table[
    Module[{sqrtResult, sqrtExists, halfFact, mod4},
      sqrtResult = SqrtMod[p];
      sqrtExists = sqrtResult[[1]];
      halfFact = HalfFactorialMod[p];
      mod4 = Mod[p, 4];
      {p, mod4, sqrtExists, halfFact}
    ],
    {p, primes}
  ];

  Association[{
    "Data" -> classified,
    "p==1(mod 4)" -> Select[classified, #[[2]] == 1 &],
    "p==3(mod 4)" -> Select[classified, #[[2]] == 3 &],
    "Has sqrt(-1)" -> Select[classified, #[[3]] == True &],
    "No sqrt(-1)" -> Select[classified, #[[3]] == False &]
  }]
];

(* Performance comparison *)
ComparePerformance[n_Integer, p_Integer?PrimeQ] := Module[{timeEff, timeNaive, resultEff, resultNaive},
  {timeEff, resultEff} = AbsoluteTiming[FactorialMod[n, p]];
  {timeNaive, resultNaive} = AbsoluteTiming[NaiveFactorialMod[n, p]];

  Association[{
    "n" -> n,
    "p" -> p,
    "Efficient time" -> timeEff,
    "Naive time" -> timeNaive,
    "Speedup" -> N[timeNaive/timeEff],
    "Results match" -> (resultEff === resultNaive)
  }]
];

End[];
EndPackage[];
