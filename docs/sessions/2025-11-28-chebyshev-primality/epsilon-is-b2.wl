(* Verify: Is ε_{pq} the same as b₂ in the pair's b-vector? *)

Print["=== Testing: ε = b₂ at pair level ===\n"];

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

(* For pair {p, q}: b = {b₁, b₂} where
   b₁ = q · q⁻¹ mod p mod 2
   b₂ = p · p⁻¹ mod q mod 2 *)

Print["Comparing ε_{pq} with b₂ from bVector[{p,q}]:\n"];

errors = 0;
Do[
  If[p < q,
    eps = epsilon[p, q];
    b = bVector[{p, q}];
    b2 = b[[2]];

    (* Also check: ε_{qp} should equal b₁ *)
    epsReverse = epsilon[q, p];
    b1 = b[[1]];

    If[eps != b2 || epsReverse != b1,
      errors++;
      Print["ERROR: p=", p, " q=", q, ": ε_{pq}=", eps, " b₂=", b2,
            " ε_{qp}=", epsReverse, " b₁=", b1]
    ]
  ],
  {p, Prime[Range[2, 15]]},
  {q, Prime[Range[3, 20]]}
];

Print["Errors: ", errors];

If[errors == 0,
  Print["\n✓ CONFIRMED: ε_{pq} = b₂ and ε_{qp} = b₁ for all pairs!\n"];

  Print["=== Unified notation ===\n"];
  Print["For any subset S ⊆ {p₁, ..., pω}, define b_S = bVector(S)"];
  Print[""];
  Print["Then:"];
  Print["  ε_{ij} = b_{ij}[2]  (second component of pair's b-vector)"];
  Print["  ε_{ji} = b_{ij}[1]  (first component)"];
  Print[""];
  Print["So the 'ε pattern' for ω primes is just the collection of"];
  Print["all b-vectors at level 2!"];
  Print[""];
  Print["=== Complete hierarchy ==="];
  Print[""];
  Print["ω=2: b₂ (the pair's b-vector)"];
  Print["ω=3: b₂s (all 3 pairs) + b₃"];
  Print["ω=4: b₂s (all 6 pairs) + b₃s (all 4 triples) + b₄"];
  Print["ω=5: b₂s + b₃s + b₄s + b₅"];
  Print[""];
  Print["General: All b-vectors at levels 2, 3, ..., ω"];
];
