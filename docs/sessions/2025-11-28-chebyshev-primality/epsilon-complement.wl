(* Verify: ε = 1 - b₂ (they are complements) *)

Print["=== Testing: ε + b₂ = 1 (mod 2) ===\n"];

epsilon[p_, q_] := If[EvenQ[PowerMod[p, -1, q]], 1, 0];

bVector[primes_List] := Module[{n = Length[primes]},
  Table[
    Module[{others = Delete[primes, i], prod},
      prod = Times @@ others;
      Mod[prod * PowerMod[prod, -1, primes[[i]]], 2]
    ],
    {i, n}
  ]
];

(* Why are they complements?
   ε_{pq} = 1 if p⁻¹ mod q is EVEN
   b₂ = c₂ mod 2 = (p · (p⁻¹ mod q)) mod 2

   Since p is odd:
   b₂ = (p⁻¹ mod q) mod 2

   So:
   ε = 1 if (p⁻¹ mod q) is even, i.e., (p⁻¹ mod q) mod 2 = 0
   b₂ = (p⁻¹ mod q) mod 2

   Therefore: ε = 1 - b₂ *)

Print["Verifying ε + b₂ = 1 for all pairs:\n"];

errors = 0;
Do[
  If[p < q,
    eps = epsilon[p, q];
    b = bVector[{p, q}];
    b2 = b[[2]];

    If[Mod[eps + b2, 2] != 1,
      errors++;
      Print["ERROR: p=", p, " q=", q, ": ε=", eps, " b₂=", b2, " sum=", eps + b2]
    ]
  ],
  {p, Prime[Range[2, 20]]},
  {q, Prime[Range[3, 25]]}
];

Print["Errors: ", errors];

If[errors == 0,
  Print["\n✓ CONFIRMED: ε + b₂ ≡ 1 (mod 2) for all pairs!\n"];

  Print["=== Why this happens ===\n"];
  Print["ε_{pq} = 1 iff p⁻¹ mod q is EVEN"];
  Print["b₂ = (p · (p⁻¹ mod q)) mod 2"];
  Print[""];
  Print["Since p is ODD (all primes > 2):"];
  Print["  b₂ = (p⁻¹ mod q) mod 2"];
  Print[""];
  Print["So:"];
  Print["  ε = 1 ⟺ (p⁻¹ mod q) mod 2 = 0 ⟺ b₂ = 0"];
  Print["  ε = 0 ⟺ (p⁻¹ mod q) mod 2 = 1 ⟺ b₂ = 1"];
  Print[""];
  Print["Therefore: ε = 1 - b₂"];
  Print[""];
  Print["=== Unified view ===\n"];
  Print["Both ε and b carry the SAME information (just inverted)."];
  Print[""];
  Print["We can use EITHER:"];
  Print["  • ε (inversion indicator): ε=1 means 'inverted'"];
  Print["  • b (CRT parity): b=1 means 'odd coefficient'"];
  Print[""];
  Print["The relationship ε + b = 1 means they partition the space:"];
  Print["  exactly one of {ε, b} equals 1 for each pair."];
];
