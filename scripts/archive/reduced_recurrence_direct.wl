#!/usr/bin/env wolframscript
(* Direct recurrence for REDUCED numerators and denominators *)

(*
Key insight from the proof:
- Invariant: ν_p(D_k) - ν_p(N_k) = 1 for all primes p ≤ 2k+1
- This means: GCD(N_k, D_k) = ∏_{p≤2k+1} p^{ν_p(D_k)-1}
- Reduced forms: A_k = N_k/GCD, B_k = D_k/GCD where B_k = Primorial(2k+1)
*)

(* Unreduced recurrence (baseline) *)
UnreducedState[0] = {0, 2};  (* {N_0, D_0} *)
UnreducedState[k_] := UnreducedState[k] = Module[{n, d, newN, newD},
  {n, d} = UnreducedState[k-1];
  newD = d * (2k + 1);
  newN = n * (2k + 1) + (-1)^k * k! * d;
  {newN, newD}
];

(* Extract reduced form by actual GCD computation (for verification) *)
ReducedByGCD[k_] := Module[{n, d, g},
  {n, d} = UnreducedState[k];
  g = GCD[n, d];
  {n/g, d/g}
];

(* Direct reduced recurrence - THE GOAL *)
(*
From unreduced update:
  N_{k+1} = N_k·(2k+3) + (-1)^{k+1}·(k+1)!·D_k
  D_{k+1} = D_k·(2k+3)

Let N_k = A_k · g_k, D_k = B_k · g_k where gcd(A_k, B_k) = 1

Then:
  N_{k+1} = A_k·g_k·(2k+3) + (-1)^{k+1}·(k+1)!·B_k·g_k
          = g_k·[A_k·(2k+3) + (-1)^{k+1}·(k+1)!·B_k]

  D_{k+1} = B_k·g_k·(2k+3)

The proof tells us the NEW GCD structure. Let's extract it.
*)

(*
Key observation: The GCD cancellation depends on prime factorization of (2k+3).

When we go from k to k+1:
- New primes in 2k+3 get added to B_{k+1}
- Existing primes' valuations adjust according to the proof

Let's track g_k explicitly using the proof structure.
*)

ReducedStateDirect[0] = {0, 1};  (* {A_0, B_0} - reduced form *)

ReducedStateDirect[k_] := ReducedStateDirect[k] = Module[
  {a, b, newPrimes, term, numeratorUpdate, commonFactor},

  {a, b} = ReducedStateDirect[k-1];

  (* The proof shows D_k (reduced) is primorial up to 2k-1 *)
  (* D_{k+1} (reduced) is primorial up to 2k+1 *)

  (* New primes introduced by 2k+1 *)
  newPrimes = Select[FactorInteger[2k+1][[All, 1]], # > 2k-1 &];

  (* Update denominator: add new primes *)
  b = b * Product[p, {p, newPrimes}];

  (* Update numerator using the recurrence structure *)
  (* From: N_{k+1} = N_k·(2k+3) + (-1)^{k+1}·(k+1)!·D_k *)
  (* In reduced form, we need to account for the factorial term *)

  term = (-1)^k * k! / Product[Prime[i], {i, 1, PrimePi[2k-1]}];

  (* This is complex - the factorial interacts with reduced forms *)
  (* Let me think about this differently... *)

  Print["DEBUG k=", k, ": Need to derive the reduced update formula"];

  {a, b}
];

(* Alternative approach: Derive the reduced recurrence from first principles *)

(*
The unreduced recurrence is:
  N_{k+1}/D_{k+1} = N_k/D_k + (-1)^{k+1}·(k+1)!/(D_k·(2k+3))

In reduced form A_k/B_k:
  A_{k+1}/B_{k+1} = A_k/B_k + (-1)^{k+1}·(k+1)!/(D_k·(2k+3))

But D_k (unreduced) = (2k+1)!! and B_k (reduced) = Primorial(2k+1)

The relationship from the proof: D_k = B_k · GCD(N_k, D_k)

So: (-1)^{k+1}·(k+1)!/(D_k·(2k+3)) = (-1)^{k+1}·(k+1)!/(B_k·g_k·(2k+3))

The key is expressing g_k in terms of reduced quantities.
*)

(* Hybrid approach: Track both forms and derive relationship *)
HybridAnalysis[kmax_] := Module[{data},
  data = Table[
    Module[{unreduced, reduced, ratio, gcd},
      unreduced = UnreducedState[k];
      reduced = ReducedByGCD[k];
      gcd = GCD @@ unreduced;
      {
        "k" -> k,
        "N_unreduced" -> unreduced[[1]],
        "D_unreduced" -> unreduced[[2]],
        "A_reduced" -> reduced[[1]],
        "B_reduced" -> reduced[[2]],
        "GCD" -> gcd,
        "GCD_factored" -> FactorInteger[gcd],
        "Ratio_N/A" -> unreduced[[1]]/reduced[[1]],
        "Ratio_D/B" -> unreduced[[2]]/reduced[[2]]
      }
    ],
    {k, 1, kmax}
  ];
  Dataset[data]
];

(* Main analysis *)
Print["Analyzing reduced recurrence structure..."];
result = HybridAnalysis[10];
Print[result];

(* Try to find pattern in GCD evolution *)
Print["\nGCD evolution pattern:"];
gcdSequence = Table[GCD @@ UnreducedState[k], {k, 1, 20}];
Print["GCDs: ", gcdSequence];
Print["GCD factorizations:"];
Do[
  Print["k=", k, ": ", FactorInteger[gcdSequence[[k]]]],
  {k, 1, Min[10, Length[gcdSequence]]}
];

(* Check if there's a pattern *)
Print["\nSearching for closed form of GCD sequence..."];
findResult = Quiet[FindSequenceFunction[gcdSequence, k]];
If[findResult =!= $Failed,
  Print["Found pattern: ", findResult],
  Print["No simple pattern found"]
];
