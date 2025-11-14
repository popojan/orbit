#!/usr/bin/env wolframscript
(* Constructive reduced recurrence derived from proof structure *)

(*
Key insight from the proof and GCD analysis:

1. GCD(N_k, D_k) = g_k tracks the "excess" factors
2. g_k only changes when there's a valuation jump
3. Between jumps, g_k is constant

The proof tells us:
  ν_p(D_k) - ν_p(N_k) = 1 for all primes p ≤ 2k+1

This means:
  g_k = ∏_{p ≤ 2k+1} p^{ν_p(D_k) - 1}

Since D_k (unreduced) = (2k+1)!!, we can compute ν_p(D_k) using Legendre's formula.
*)

(* Compute ν_p of double factorial (2k+1)!! *)
ValuationOfDoubleFact[k_, p_] := Module[{val = 0, pow = p},
  While[pow <= 2k + 1,
    val += Floor[(2k + 1)/pow];
    (* Only odd multiples contribute to (2k+1)!! *)
    val -= Floor[(2k + 1)/(2*pow)];
    pow *= p;
  ];
  val
];

(* Compute GCD from proof structure *)
ComputeGCDFromProof[k_] := Module[{primes, gcd = 1},
  primes = Select[Range[2, 2k + 1], PrimeQ];
  Do[
    (* From proof: ν_p(D_k) - ν_p(N_k) = 1 *)
    (* So GCD contains p^{ν_p(D_k) - 1} *)
    gcd *= p^(ValuationOfDoubleFact[k, p] - 1),
    {p, primes}
  ];
  gcd
];

(* Direct reduced recurrence *)
(* State: {k, A_k, B_k, g_k} where:
   - A_k/B_k is reduced form
   - g_k is the GCD we factored out
   - Unreduced: N_k = A_k * g_k, D_k = B_k * g_k
*)

ReducedStateConstructive[0] = {0, 0, 1, 1};  (* {k, A, B, g} *)

ReducedStateConstructive[k_] := ReducedStateConstructive[k] = Module[
  {prevK, a, b, g, newG, factorNum, factorDen, tempN, tempD, newA, newB, commonFactor},

  {prevK, a, b, g} = ReducedStateConstructive[k - 1];

  (* Unreduced update *)
  factorNum = (2k + 1) * k + k;  (* = (2k+1) * k + k = k(2k+2) *)
  factorDen = 2k + 1;

  (* N_{k+1} = N_k * (2k+1) + (-1)^k * k! * D_k *)
  (* D_{k+1} = D_k * (2k+1) *)

  (* In terms of A, B, g: *)
  (* N_k = A * g, D_k = B * g *)
  (* N_{k+1} = A*g*(2k+1) + (-1)^k * k! * B*g *)
  (*         = g * [A*(2k+1) + (-1)^k * k! * B] *)
  (* D_{k+1} = B*g*(2k+1) *)

  tempN = a * (2k + 1) + (-1)^k * k! * b;
  tempD = b * (2k + 1);

  (* New GCD from proof structure *)
  newG = ComputeGCDFromProof[k];

  (* Reduce *)
  commonFactor = GCD[tempN, tempD];
  newA = tempN / commonFactor;
  newB = tempD / commonFactor;

  (* Verify: newG should equal g * commonFactor *)
  If[newG != g * commonFactor,
    Print["WARNING at k=", k, ": GCD mismatch. Expected: ", newG, ", Got: ", g * commonFactor]
  ];

  {k, newA, newB, newG}
];

(* Comparison with direct GCD computation *)
CompareApproaches[kmax_] := Module[{data},
  data = Table[
    Module[{unreduced, directReduced, constructive, gcdProof, gcdDirect},
      (* Method 1: Unreduced then reduce *)
      unreduced = {
        (-1 + 2k) Pochhammer[3, k - 1, 2],  (* D_k = (2k+1)!! *)
        Sum[(-1)^j * j! * Pochhammer[3, j - 1, 2], {j, 1, k}]  (* N_k *)
      };
      gcdDirect = GCD @@ unreduced;
      directReduced = unreduced / gcdDirect;

      (* Method 2: From proof structure *)
      gcdProof = ComputeGCDFromProof[k];

      (* Method 3: Constructive recurrence *)
      constructive = ReducedStateConstructive[k];

      {
        "k" -> k,
        "A_direct" -> directReduced[[2]],
        "B_direct" -> directReduced[[1]],
        "A_constructive" -> constructive[[2]],
        "B_constructive" -> constructive[[3]],
        "GCD_direct" -> gcdDirect,
        "GCD_proof" -> gcdProof,
        "Match?" -> (directReduced[[2]] == constructive[[2]] && gcdDirect == gcdProof)
      }
    ],
    {k, 1, kmax}
  ];
  Dataset[data]
];

(* Test *)
Print["Testing constructive reduced recurrence..."];
Print[CompareApproaches[10]];

(* Derive explicit formula for g_k *)
Print["\nGCD sequence from proof:"];
gcdSeq = Table[ComputeGCDFromProof[k], {k, 1, 15}];
Print[gcdSeq];
Print["Factorizations:"];
Do[Print["k=", k, ": ", FactorInteger[gcdSeq[[k]]]], {k, 1, 10}];
