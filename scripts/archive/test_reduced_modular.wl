#!/usr/bin/env wolframscript
(* Can we do modular arithmetic using the REDUCED denominator (primorial)? *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

(* Standard unreduced recurrence *)
UnreducedState[0] = {0, 2};
UnreducedState[k_] := UnreducedState[k] = Module[{n, d},
  {n, d} = UnreducedState[k - 1];
  {n * (2k + 1) + (-1)^k * k! * d, d * (2k + 1)}
];

(* Modular with unreduced denominator (we know this works) *)
ModularUnreduced[0] = {0, 2};
ModularUnreduced[k_] := ModularUnreduced[k] = Module[{n, d, newD},
  {n, d} = ModularUnreduced[k - 1];
  newD = d * (2k + 1);
  {Mod[n * (2k + 1) + (-1)^k * k! * d, newD], newD}
];

(* Attempt: Modular with REDUCED denominator (primorial) *)
ModularReduced[0] = {0, 1};  (* Start with trivial primorial = 1 for m=1 *)
ModularReduced[k_] := ModularReduced[k] = Module[{n, dRed, prim, newPrim, newN},
  {n, dRed} = ModularReduced[k - 1];

  (* The reduced denominator at step k *)
  prim = Primorial[2k - 1];
  newPrim = Primorial[2k + 1];

  (* Try to update using reduced denominator *)
  (* Problem: the formula N * (2k+1) + (-1)^k * k! * D uses UNREDUCED D *)
  (* We need to figure out what to multiply by... *)

  (* This is the challenge - we don't know the unreduced D! *)
  {n, newPrim}
];

Print["=== Testing if we can use primorial as modulus ===\n"];

(* Test: Can we take N mod Primorial and preserve GCD? *)
testModPrimorial = Table[
  Module[{unreduced, prim, nModPrim, gcdExact, gcdMod},
    unreduced = UnreducedState[k];
    prim = Primorial[2k + 1];

    nModPrim = Mod[unreduced[[1]], prim];

    gcdExact = GCD @@ unreduced;
    gcdMod = GCD[nModPrim, prim];

    {
      "k" -> k,
      "GCD(N_unred, D_unred)" -> gcdExact,
      "GCD(N mod Prim, Prim)" -> gcdMod,
      "Match?" -> (gcdExact == gcdMod),
      "Reduced denom (exact)" -> unreduced[[2]]/gcdExact,
      "Prim / gcdMod" -> prim/gcdMod
    }
  ],
  {k, 1, 10}
];

Print[Dataset[testModPrimorial]];

Print["\n=== The Problem: ==="];
Print["GCD(N mod Primorial, Primorial) ≠ GCD(N_unreduced, D_unreduced)"];
Print["Because D_unreduced contains EXTRA prime powers beyond Primorial!\n"];

Print["Example at k=4: D_unreduced = 1890 = 2·3³·5·7, but Primorial(9) = 2·3·5·7"];
Print["The extra 3² is essential for the proper GCD computation.\n"];

Print["\n=== Ratio D_unreduced / Primorial ===\n"];
ratios = Table[
  Module[{dUnred, prim},
    dUnred = UnreducedState[k][[2]];
    prim = Primorial[2k + 1];
    {
      "k" -> k,
      "D_unreduced" -> dUnred,
      "Primorial" -> prim,
      "Ratio" -> dUnred/prim,
      "Factored" -> FactorInteger[dUnred/prim]
    }
  ],
  {k, 1, 10}
];
Print[Dataset[ratios]];

Print["\n=== Conclusion ==="];
Print["NO - we CANNOT use the reduced denominator (primorial) as modulus."];
Print["The unreduced denominator D_k = 2·3·5·...·(2k+1) contains higher"];
Print["prime powers that are ESSENTIAL for computing the correct GCD.\n"];

Print["The modular recurrence MUST use the unreduced denominator:"];
Print["  N_{k+1} = Mod[N_k·(2k+3) + (-1)^{k+1}·(k+1)!·D_k, D_{k+1}]"];
Print["  D_{k+1} = D_k·(2k+3)\n"];

Print["After computing, we extract the primorial by reducing the fraction:"];
Print["  Primorial = Denominator[N_k / D_k]  (in lowest terms)"];
