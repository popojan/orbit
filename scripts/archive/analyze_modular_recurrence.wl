#!/usr/bin/env wolframscript
(* Can we formulate a modular recurrence that preserves the proof? *)

(* Original unreduced recurrence (from proof) *)
UnreducedState[0] = {0, 2};
UnreducedState[k_] := UnreducedState[k] = Module[{n, d},
  {n, d} = UnreducedState[k - 1];
  {
    n * (2k + 1) + (-1)^k * k! * d,  (* N_{k+1} *)
    d * (2k + 1)                      (* D_{k+1} *)
  }
];

(* Fractional part formula - direct sum *)
FractionalSum[k_] := Sum[Mod[(-1)^j * j!/(2j + 1)/2, 1], {j, 1, k}];

(* Key question: Can we track fractional parts through recurrence? *)

(* Attempt 1: Naive fractional recurrence *)
FractionalState[0] = {0, 2};
FractionalState[k_] := FractionalState[k] = Module[{n, d, newN, newD, frac},
  {n, d} = FractionalState[k - 1];

  (* Standard recurrence *)
  newN = n * (2k + 1) + (-1)^k * k! * d;
  newD = d * (2k + 1);

  (* Take fractional part of the result *)
  frac = Mod[newN / newD, 1];

  {Numerator[frac], Denominator[frac]}
];

Print["=== Testing if fractional state matches direct sum ===\n"];

comparison1 = Table[
  Module[{direct, recurse},
    direct = FractionalSum[k];
    recurse = FractionalState[k][[1]] / FractionalState[k][[2]];

    {
      "k" -> k,
      "Direct sum" -> direct,
      "Via recurrence" -> recurse,
      "Match?" -> (direct == recurse),
      "Direct denom" -> Denominator[direct],
      "Recurse denom" -> FractionalState[k][[2]]
    }
  ],
  {k, 1, 10}
];
Print[Dataset[comparison1]];

Print["\n=== The Problem: Fractional part doesn't distribute over addition ===\n"];
Print["Mod[a + b, 1] ≠ Mod[a, 1] + Mod[b, 1] in general"];
Print["Example: Mod[0.7 + 0.8, 1] = 0.5, but Mod[0.7, 1] + Mod[0.8, 1] = 1.5\n"];

Print["=== Alternative: Track state as (N_k mod D_k, D_k) ===\n"];

(* Track numerator mod denominator *)
ModularState[0] = {0, 2};
ModularState[k_] := ModularState[k] = Module[{n, d, newN, newD},
  {n, d} = ModularState[k - 1];

  newD = d * (2k + 1);
  newN = Mod[n * (2k + 1) + (-1)^k * k! * d, newD];

  {newN, newD}
];

comparison2 = Table[
  Module[{unreduced, modular, gcd},
    unreduced = UnreducedState[k];
    modular = ModularState[k];
    gcd = GCD @@ unreduced;

    {
      "k" -> k,
      "Unreduced" -> unreduced,
      "Modular" -> modular,
      "Match?" -> (Mod[unreduced[[1]], unreduced[[2]]] == Mod[modular[[1]], modular[[2]]]),
      "GCD" -> gcd
    }
  ],
  {k, 1, 8}
];
Print[Dataset[comparison2]];

Print["\n=== Key Insight: p-adic valuations ===\n"];

Print["The proof tracks ν_p(N_k) and ν_p(D_k) for unreduced representation."];
Print["If we take Mod, we lose the absolute values needed for p-adic analysis.\n"];

Print["However: the DENOMINATOR structure is preserved!"];
Print["Taking fractional parts only affects the NUMERATOR.\n"];

Print["=== Proposal: Two-level proof ===\n"];
Print["1. Original proof: establishes ν_p(D_k) - ν_p(N_k) = 1 for unreduced"];
Print["2. Reduction lemma: taking fractional parts preserves denominator"];
Print["3. Computational optimization: use fractional parts for small numerators\n"];

Print["The recurrence for proof: use unreduced (exact integers)"];
Print["The recurrence for computation: can use modular arithmetic\n"];

Print["=== Test: Do fractional parts preserve primorial denominators? ===\n"];

testFractional = Table[
  Module[{unreduced, frac, primorial},
    unreduced = UnreducedState[k][[1]] / UnreducedState[k][[2]];
    frac = FractionalSum[k];
    primorial = Product[Prime[i], {i, 1, PrimePi[2k + 1]}];

    {
      "k" -> k,
      "Unreduced denom" -> Denominator[unreduced],
      "Fractional denom" -> Denominator[frac],
      "Primorial" -> primorial,
      "Both = Prim?" -> (Denominator[unreduced] == primorial &&
                         Denominator[frac] == primorial)
    }
  ],
  {k, 1, 10}
];
Print[Dataset[testFractional]];

Print["\n=== Conclusion ==="];
Print["The fractional part formula works for computing primorials,"];
Print["but we CANNOT directly convert the proof's recurrence to use Mod[, 1]"];
Print["because p-adic valuation analysis requires exact integers.\n"];

Print["Solution: Keep the existing proof as-is (unreduced integers),"];
Print["then add a separate section on computational optimizations"];
Print["showing that fractional parts preserve the denominator structure."];
