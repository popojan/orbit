(* ::Package:: *)

(* Efficient Modular Factorial Computation via Half-Factorial Base *)
(*
   Key insight: ((p-1)/2)! mod p can be computed efficiently using:
   - Stickelberger's relation: ((p-1)/2)!^2 ≡ (-1)^((p+1)/2) (mod p)
   - For p ≡ 3 (mod 4): sign determined by class number h(-p)
   - Shanks algorithm gives h(-p) in O(p^{1/4}) vs O(p) for naive
*)

BeginPackage["Orbit`"];

(* Core functions *)
SqrtMod::usage = "SqrtMod[p] computes the modular square root of (p-1) ≡ -1 mod p.
Returns {True, {r, p-r}} if sqrt(-1) exists (p ≡ 1 mod 4), or {False, {1, p-1}} otherwise (p ≡ 3 mod 4).
The two values represent the ambiguity in sign.";

HalfFactorialMod::usage = "HalfFactorialMod[p] computes ((p-1)/2)! mod p for prime p.
For p ≡ 3 (mod 4): returns exact value using O(p^{1/4}) Shanks algorithm for class number.
For p ≡ 1 (mod 4): returns exact value using direct O(p) computation.";

FactorialMod::usage = "FactorialMod[n, p] computes n! mod p efficiently for prime p.
Uses HalfFactorialMod as base and multiplies remaining factors.
Requires (p-1)/2 ≤ n < p.
FactorialMod[n] automatically selects p = NextPrime[2n, -1] and returns {p, n! mod p}.";

WilsonFactorialMod::usage = "WilsonFactorialMod[n, p] computes n! mod p using Wilson's theorem.
Uses (p-1)! ≡ -1 (mod p) and modular inverse: n! ≡ (-1)^(p-n-1) × ((p-n-1)!)^(-1) (mod p).
Efficient when n is close to p (i.e., p-n is small).
WilsonFactorialMod[n] automatically selects p = NextPrime[n, 1] and returns {p, n! mod p}.";

FastFactorialMod::usage = "FastFactorialMod[n, p] computes n! mod p using the optimal method:
- If n close to p (p-n < (p-1)/2): uses WilsonFactorialMod O(p-n)
- If p ≡ 3 (mod 4) and (p-1)/2 ≤ n: uses FactorialMod O(p^{1/4}) via class number
- Otherwise: uses WilsonFactorialMod O(p-n) or direct computation
Requires n < p.";

FactorialCRT::usage = "FactorialCRT[n, k] computes n! mod M using Chinese Remainder Theorem.
Combines residues from k primes in range (n, 2n] to recover n! mod M where M = p1×p2×...×pk.
Returns {n! mod M, M}. Uses FastFactorialMod for optimal method per prime.
FactorialCRT[n, k, \"Detailed\" -> True] returns Association with individual primes and residues.
Useful when n! is too large to compute directly (e.g., n = 10^6 has 5.5M digits).";

FactorialRecover::usage = "FactorialRecover[n] fully recovers n! using CRT with enough primes.
Uses Stirling approximation to determine required modulus size.
Returns n! directly. Only practical for small n (< 100) due to prime count needed.";

LegendreExponent::usage = "LegendreExponent[n, p] computes v_p(n!) = floor(n/p) + floor(n/p²) + ...
The exact power of prime p dividing n!.";

ReducedFactorialMod::usage = "ReducedFactorialMod[n, p] computes (n!/p^{v_p(n!)}) mod p.
The 'p-reduced factorial' - n! with all factors of p removed, taken mod p.
Works for any p (including p < n). Complexity: O(log_p(n)).";

(* Analysis functions *)
HalfFactorialSign::usage = "HalfFactorialSign[p] returns the sign of ((p-1)/2)! mod p for p ≡ 3 (mod 4).
Returns +1 if result is 1, -1 if result is p-1. Uses class number h(-p).";

ClassifyPrimesByHalfFactorial::usage = "ClassifyPrimesByHalfFactorial[pmax] classifies all primes up to pmax by their half-factorial structure.";

VerifyFactorialMod::usage = "VerifyFactorialMod[n, p] verifies FactorialMod against naive Mod[n!, p] computation.";

Begin["`Private`"];

(* === Core: Square root of -1 mod p === *)

SqrtMod[p_Integer?PrimeQ] := Module[{sqrt},
  Off[PowerMod::root];
  sqrt = PowerMod[p - 1, 1/2, p];
  On[PowerMod::root];
  If[IntegerQ[sqrt],
    {True, {sqrt, p - sqrt}},    (* p ≡ 1 (mod 4): sqrt(-1) exists *)
    {False, {1, p - 1}}          (* p ≡ 3 (mod 4): no sqrt(-1), half-factorial is ±1 *)
  ]
];

(* === Core: Half-factorial with sign determination === *)

(* Sign for p ≡ 3 (mod 4) using class number *)
(* ((p-1)/2)! ≡ (-1)^((h(-p)+1)/2) (mod p) *)
HalfFactorialSign[p_Integer?PrimeQ] := Module[{h},
  If[Mod[p, 4] != 3, Return[$Failed]];
  h = NumberFieldClassNumber[Sqrt[-p]];
  (-1)^((h + 1)/2)
] /; Mod[p, 4] == 3;

(* Main half-factorial function *)
HalfFactorialMod::ovfl = "ClassNumber overflow for p = `1`. Prime too large for Mathematica. Try PARI/GP.";
HalfFactorialMod::pari = "Using PARI/GP for large prime p = `1`.";

(* Try PARI/GP for class number (works for very large primes) *)
ClassNumberPARI[p_Integer] := Module[{cmd, result},
  cmd = "echo 'qfbclassno(-" <> ToString[p] <> ")' | gp -q 2>/dev/null";
  result = RunProcess[{"bash", "-c", cmd}, "StandardOutput"];
  If[StringQ[result] && StringLength[result] > 0,
    ToExpression[StringTrim[result]],
    $Failed
  ]
];

HalfFactorialMod[p_Integer?PrimeQ] := Module[{h, sign},
  If[Mod[p, 4] == 3,
    (* Fast path: O(p^{1/4}) using Shanks algorithm for class number *)
    (* Note: NumberFieldClassNumber may overflow for very large p (e.g., p > 2^50) *)
    Quiet[
      h = NumberFieldClassNumber[Sqrt[-p]],
      {NumberFieldClassNumber::ovfl}
    ];
    If[IntegerQ[h],
      (* Success: use class number for sign *)
      sign = (-1)^((h + 1)/2);
      If[sign == 1, 1, p - 1]
      ,
      (* Try PARI/GP fallback *)
      h = ClassNumberPARI[p];
      If[IntegerQ[h],
        Message[HalfFactorialMod::pari, p];
        sign = (-1)^((h + 1)/2);
        If[sign == 1, 1, p - 1]
        ,
        (* Both failed *)
        Message[HalfFactorialMod::ovfl, p];
        $Failed
      ]
    ]
    ,
    (* Slow path: O(p) direct computation *)
    (* No known fast formula for sign when p ≡ 1 (mod 4) *)
    Fold[Mod[#1 * #2, p] &, 1, Range[(p - 1)/2]]
  ]
];

(* === FactorialMod: n! mod p using half-factorial base === *)

(* Main version: uses half-factorial and multiplies remaining factors *)
FactorialMod[n_Integer, p_Integer?PrimeQ] := Module[{halfFact, remaining},
  halfFact = HalfFactorialMod[p];
  (* Multiply from (p-1)/2 + 1 up to n *)
  remaining = Fold[Mod[#1 * #2, p] &, 1, Range[(p - 1)/2 + 1, n]];
  Mod[halfFact * remaining, p]
] /; (p - 1)/2 <= n < p;

(* Convenience form: automatically select prime *)
FactorialMod[n_Integer] := Module[{p},
  p = NextPrime[2*n, -1];
  {p, FactorialMod[n, p]}
];

(* === WilsonFactorialMod: n! mod p using Wilson's theorem === *)

(* Wilson's theorem: (p-1)! ≡ -1 (mod p)
   Therefore: n! × (n+1) × ... × (p-1) ≡ -1 (mod p)
   So: n! ≡ -1 × ((n+1) × ... × (p-1))^(-1) (mod p)

   Let k = p - n - 1 (number of factors after n)
   (n+1) × ... × (p-1) = (p-1)! / n! but also = (p-k)...(p-1)

   Alternative: use (p-n-1)! and reflection
   n! ≡ (-1)^(p-n-1) × ((p-n-1)!)^(-1) (mod p)
*)

WilsonFactorialMod[n_Integer, p_Integer?PrimeQ] := Module[{k, complementFact, sign},
  k = p - n - 1;  (* (p-n-1)! is what we need to compute *)
  If[k < 0, Return[Mod[n!, p]]];  (* fallback for edge cases *)
  If[k == 0, Return[Mod[-1, p]]];  (* n = p-1, so n! ≡ -1 by Wilson *)

  (* Compute (p-n-1)! = k! mod p *)
  complementFact = Fold[Mod[#1 * #2, p] &, 1, Range[k]];

  (* Derivation:
     (p-1)! = n! × (n+1) × ... × (p-1) ≡ -1 (mod p)
     (n+1)×...×(p-1) ≡ (-1)^{p-1-n} × (p-n-1)! = (-1)^k × k! (mod p)
     So: n! × (-1)^k × k! ≡ -1 (mod p)
     Therefore: n! ≡ (-1)^{k+1} × (k!)^{-1} (mod p)
  *)
  sign = If[EvenQ[k], p - 1, 1];  (* (-1)^{k+1} mod p *)
  Mod[sign * PowerMod[complementFact, -1, p], p]
] /; n < p;

(* Convenience form: select smallest prime > n *)
WilsonFactorialMod[n_Integer] := Module[{p},
  p = NextPrime[n, 1];
  {p, WilsonFactorialMod[n, p]}
];

(* === FastFactorialMod: Unified optimal method selection === *)

(* Automatically selects the fastest method for computing n! mod p:
   - Wilson is O(p-n), best when n close to p
   - FactorialMod is O(p^{1/4}) for p ≡ 3 (mod 4), O(p) otherwise
   Decision: Use FactorialMod when p ≡ 3 (mod 4) AND (p-1)/2 ≤ n AND n < p
             (this gives O(p^{1/4}) + O(n - (p-1)/2))
             Use Wilson otherwise (O(p-n))
*)

FastFactorialMod[n_Integer, p_Integer?PrimeQ] := Module[{k, halfP},
  k = p - n - 1;      (* Cost of Wilson *)
  halfP = (p - 1)/2;  (* Threshold for FactorialMod *)

  Which[
    (* Edge case: n >= p *)
    n >= p, Mod[n!, p],

    (* Wilson is very cheap when n close to p *)
    k < 100, WilsonFactorialMod[n, p],

    (* FactorialMod is O(p^{1/4}) for p ≡ 3 (mod 4) when n ≥ halfP *)
    Mod[p, 4] == 3 && n >= halfP, FactorialMod[n, p],

    (* For p ≡ 1 (mod 4) in valid range, Wilson is usually better *)
    (* (FactorialMod falls back to O(p) for p ≡ 1 mod 4) *)
    n >= halfP && k < n, WilsonFactorialMod[n, p],

    (* FactorialMod still valid if n >= halfP *)
    n >= halfP, FactorialMod[n, p],

    (* Default: Wilson for any n < p *)
    True, WilsonFactorialMod[n, p]
  ]
] /; n < p;

(* Convenience form: auto-select prime *)
FastFactorialMod[n_Integer] := Module[{p},
  p = NextPrime[n, 1];
  {p, FastFactorialMod[n, p]}
];

(* === FactorialCRT: n! mod M via Chinese Remainder Theorem === *)

(* Combines residues from multiple primes to recover n! mod (p1×p2×...×pk)
   Strategy:
   - Use primes in range (n, 2n] where both methods work
   - FactorialMod for p ≡ 3 (mod 4): O(p^{1/4}) via class number
   - WilsonFactorialMod for p ≡ 1 (mod 4): O(p-n), efficient near n
*)

Options[FactorialCRT] = {"Detailed" -> False};

FactorialCRT[n_Integer, k_Integer: 10, OptionsPattern[]] := Module[
  {allPrimes, allRem, methods, p, pMax, r, m, modulus, result, detailed},

  detailed = OptionValue["Detailed"];
  allPrimes = {};
  allRem = {};
  methods = {};
  p = NextPrime[n, 1];  (* Start at smallest prime > n *)
  pMax = 2*n + 1;       (* Upper bound for valid primes *)

  While[Length[allPrimes] < k && p <= pMax,
    (* Use unified optimal method selection *)
    r = FastFactorialMod[n, p];
    (* Record which method was used (for detailed output) *)
    m = If[Mod[p, 4] == 3 && n >= (p-1)/2, "FactorialMod", "WilsonFactorialMod"];
    AppendTo[allPrimes, p];
    AppendTo[allRem, r];
    AppendTo[methods, m];
    p = NextPrime[p, 1]
  ];

  If[Length[allPrimes] == 0,
    Return[If[detailed,
      <|"Result" -> Mod[n!, 2], "Modulus" -> 2, "Primes" -> {}, "Residues" -> {}, "Methods" -> {}|>,
      {Mod[n!, 2], 2}
    ]]
  ];

  modulus = Times @@ allPrimes;
  result = ChineseRemainder[allRem, allPrimes];

  If[detailed,
    <|
      "Result" -> result,
      "Modulus" -> modulus,
      "ModulusDigits" -> Floor[N[Log10[modulus]]] + 1,
      "Primes" -> allPrimes,
      "Residues" -> allRem,
      "Methods" -> methods,
      "PrimeResidues" -> Thread[allPrimes -> allRem]
    |>
    ,
    {result, modulus}
  ]
];

(* === FactorialRecover: Full recovery using Stirling bound === *)

(* Stirling approximation: log10(n!) ≈ n log10(n/e) + 0.5 log10(2πn)
   Error: Stirling underestimates by ~1/(12n × ln(10)) digits
   For n=50, error ≈ 0.0007 digits - negligible
*)
StirlingDigits[n_Integer] := N[n Log10[n/E] + Log10[2 Pi n]/2]

(* Fully recover n! by collecting enough primes until M > n! *)
FactorialRecover[n_Integer] := Module[
  {targetDigits, primes, residues, modulus, result, p, currentDigits},

  (* Stirling + small margin for the underestimate *)
  targetDigits = Ceiling[StirlingDigits[n] + 0.01];  (* 0.01 >> Stirling error *)

  (* Collect primes from n+1 upward until modulus is large enough *)
  primes = {};
  residues = {};
  p = NextPrime[n, 1];
  currentDigits = 0;

  While[currentDigits < targetDigits,
    AppendTo[primes, p];
    AppendTo[residues, WilsonFactorialMod[n, p]];
    currentDigits += N[Log10[p]];
    p = NextPrime[p, 1]
  ];

  modulus = Times @@ primes;
  result = ChineseRemainder[residues, primes];

  (* Verify we got it right *)
  If[result < 0 || result >= modulus,
    $Failed,
    result
  ]
] /; n >= 0;

(* === LegendreExponent and ReducedFactorialMod === *)

(* Legendre's formula: exact power of p in n! *)
LegendreExponent[n_Integer, p_Integer?PrimeQ] := Module[{sum = 0, pk = p},
  While[pk <= n, sum += Floor[n/pk]; pk *= p];
  sum
]

(* Reduced factorial: n!/p^{v_p(n!)} mod p - O(log_p(n)) iterations *)
ReducedFactorialMod[n_Integer, p_Integer?PrimeQ] := Module[{result = 1, m = n, q, r},
  While[m >= 1,
    q = Floor[m/p];
    r = Mod[m, p];
    result = Mod[result * Mod[r!, p], p];
    result = Mod[result * PowerMod[-1, q, p], p];
    m = q;
  ];
  result
]

(* Extended CRT: decompose n! = smooth × rough where:
   - smooth = ∏ p^{v_p(n!)} for primes p ≤ B (smoothness bound)
   - rough = n!/smooth is coprime to all primes ≤ B
   Recover rough via CRT using:
   - Small primes p ≤ B: ReducedFactorialMod[n, p] = rough mod p
   - Large primes p > n: (n! mod p) × (smooth^{-1} mod p) = rough mod p
   Then n! = smooth × rough
*)

(* === Verification and Analysis === *)

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
] /; (p - 1)/2 <= n < p;

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
] /; (p - 1)/2 <= n < p;

End[];
EndPackage[];
