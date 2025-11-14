#!/usr/bin/env wolframscript
(* Analyze unreduced numerators/denominators to find modulus pattern *)

(* Unreduced recurrence *)
UnreducedState[0] = {0, 2};
UnreducedState[k_] := UnreducedState[k] = Module[{n, d},
  {n, d} = UnreducedState[k - 1];
  {n * (2k + 1) + (-1)^k * k! * d, d * (2k + 1)}
];

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=== Analyzing unreduced numerators and denominators ===\n"];

(* Collect data *)
data = Table[
  Module[{state, n, d, prim, gcd, nRed, dRed},
    state = UnreducedState[k];
    {n, d} = state;
    prim = Primorial[2k + 1];
    gcd = GCD[n, d];
    nRed = n/gcd;
    dRed = d/gcd;

    <|
      "k" -> k,
      "m" -> 2k + 1,
      "N_unreduced" -> n,
      "D_unreduced" -> d,
      "GCD" -> gcd,
      "N_reduced" -> nRed,
      "D_reduced" -> dRed,
      "Primorial" -> prim,
      "D_unred / Prim" -> d/prim,
      "N mod Prim" -> Mod[n, prim],
      "D mod Prim" -> Mod[d, prim],
      "GCD(N mod P, D mod P)" -> GCD[Mod[n, prim], Mod[d, prim]]
    |>
  ],
  {k, 1, 12}
];

Print[Dataset[data[[All, {"k", "m", "D_unreduced", "Primorial", "D_unred / Prim"}]]]];

Print["\n=== Key Observation: D_unreduced = 2 * (2k+1)!! ===\n"];
Print["D_unreduced / Primorial ratio:"];
Print[data[[All, "D_unred / Prim"]]];

Print["\n=== Hypothesis: Take mod (2 * Primorial) or mod (D_unreduced) ===\n"];

modTests = Table[
  Module[{state, n, d, prim, gcd, mod2Prim, modD},
    state = UnreducedState[k];
    {n, d} = state;
    prim = Primorial[2k + 1];
    gcd = GCD[n, d];

    (* Test: N mod (2*Primorial), D mod (2*Primorial) *)
    mod2Prim = GCD[Mod[n, 2*prim], Mod[d, 2*prim]];

    (* Test: N mod D, D (keep D) *)
    modD = GCD[Mod[n, d], d];

    {
      "k" -> k,
      "True GCD" -> gcd,
      "GCD(N mod 2P, D mod 2P)" -> mod2Prim,
      "GCD(N mod D, D)" -> modD,
      "Match 2P?" -> (mod2Prim == gcd),
      "Match D?" -> (modD == gcd)
    }
  ],
  {k, 1, 10}
];

Print[Dataset[modTests]];

Print["\n=== Test: Can we work entirely in Z/(2*Primorial)Z? ===\n"];

ModularRecurrence[k_, modulus_] := Module[{n, d, nPrev, dPrev},
  If[k == 0, Return[{0, 2}]];

  {nPrev, dPrev} = ModularRecurrence[k - 1, modulus];

  d = Mod[dPrev * (2k + 1), modulus];
  n = Mod[nPrev * (2k + 1) + (-1)^k * k! * dPrev, modulus];

  {n, d}
];

Print["Testing modular recurrence with modulus = 2*Primorial:\n"];
modularTest = Table[
  Module[{prim, modulus, exact, modular, gcdExact, gcdMod},
    prim = Primorial[2k + 1];
    modulus = 2 * prim;

    exact = UnreducedState[k];
    modular = ModularRecurrence[k, modulus];

    gcdExact = GCD @@ exact;
    gcdMod = GCD @@ modular;

    {
      "k" -> k,
      "Exact GCD" -> gcdExact,
      "Modular GCD" -> gcdMod,
      "Reduced denom (exact)" -> exact[[2]]/gcdExact,
      "Reduced denom (mod)" -> modular[[2]]/gcdMod,
      "Match?" -> (exact[[2]]/gcdExact == modular[[2]]/gcdMod)
    }
  ],
  {k, 1, 8}
];

Print[Dataset[modularTest]];

Print["\n=== Alternative: Take N mod D at each step ===\n"];

MinimalNumeratorRecurrence[0] = {0, 2};
MinimalNumeratorRecurrence[k_] := MinimalNumeratorRecurrence[k] =
  Module[{nPrev, dPrev, d, n},
    {nPrev, dPrev} = MinimalNumeratorRecurrence[k - 1];

    d = dPrev * (2k + 1);
    n = Mod[nPrev * (2k + 1) + (-1)^k * k! * dPrev, d];

    {n, d}
  ];

Print["Keeping D exact, taking N mod D:\n"];
minimalTest = Table[
  Module[{exact, minimal, gcdExact, gcdMin, nSizeExact, nSizeMin},
    exact = UnreducedState[k];
    minimal = MinimalNumeratorRecurrence[k];

    gcdExact = GCD @@ exact;
    gcdMin = GCD @@ minimal;

    nSizeExact = IntegerLength[Abs[exact[[1]]]];
    nSizeMin = IntegerLength[Abs[minimal[[1]]]];

    {
      "k" -> k,
      "N_exact digits" -> nSizeExact,
      "N_minimal digits" -> nSizeMin,
      "Reduction" -> N[nSizeMin / nSizeExact],
      "GCD exact" -> gcdExact,
      "GCD minimal" -> gcdMin,
      "GCD match?" -> (gcdExact == gcdMin),
      "Reduced denom match?" -> (exact[[2]]/gcdExact == minimal[[2]]/gcdMin)
    }
  ],
  {k, 1, 12}
];

Print[Dataset[minimalTest]];

Print["\n=== CONCLUSION ==="];
Print["Taking N mod D preserves the GCD structure perfectly!"];
Print["This allows computing with smaller numerators while maintaining"];
Print["the exact cancellation pattern proven in the paper."];
