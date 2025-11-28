(* Verify: b1 = ((r2 * r3)^{-1} mod p1) mod 2 *)

Print["=== Verifying b1 = PowerMod[r2*r3, -1, p1] mod 2 ===\n"];

Do[
  Print["p1 = ", p1x, ":"];
  errors = 0;
  total = 0;

  Do[
    If[p1x < p2 < p3,
      c1 = p2 p3 * PowerMod[p2 p3, -1, p1x];
      b1Actual = Mod[c1, 2];

      r2 = Mod[p2, p1x];
      r3 = Mod[p3, p1x];
      b1Formula = Mod[PowerMod[r2 r3, -1, p1x], 2];

      total++;
      If[b1Actual != b1Formula,
        errors++;
        If[errors <= 3,
          Print["  ERROR: p1=", p1x, " r2=", r2, " r3=", r3,
                " actual=", b1Actual, " formula=", b1Formula]
        ]
      ]
    ],
    {p2, Prime[Range[PrimePi[p1x] + 1, 20]]},
    {p3, Prime[Range[PrimePi[p1x] + 2, 25]]}
  ];

  Print["  Match: ", total - errors, "/", total];
  If[errors == 0, Print["  → PERFECT!"]];
  Print[""],
  {p1x, {3, 5, 7, 11, 13}}
];

Print["=== General formula confirmed ===\n"];
Print["b1 = PowerMod[r2 * r3, -1, p1] mod 2"];
Print["where r2 = p2 mod p1, r3 = p3 mod p1"];

Print["\n=== Now the full Σsigns formula ===\n"];
Print["Σsigns = #{odd n} - #{even n}"];
Print["where n = a1*c1 + a2*c2 + a3*c3 (mod k)"];
Print["and primitive means: ai ∈ {2, ..., pi-1} for all i"];
Print[""];
Print["The parity n mod 2 = (a1*b1 + a2*b2 + a3*b3) mod 2"];
Print["where bi = PowerMod[Mi, -1, pi] mod 2"];
Print["and Mi = k/pi = product of other primes"];

(* Show explicit lookup tables for small p1 *)
Print["\n=== Lookup tables for b1 ===\n"];

Do[
  Print["p1 = ", p1x, " (residues 1 to ", p1x - 1, "):"];
  table = Table[
    Mod[PowerMod[r2 r3, -1, p1x], 2],
    {r2, 1, p1x - 1},
    {r3, 1, p1x - 1}
  ];
  Print["  b1[r2, r3] matrix:"];
  Do[
    Print["    r2=", r2, ": ", Table[table[[r2, r3]], {r3, 1, p1x - 1}]],
    {r2, 1, p1x - 1}
  ];
  Print[""],
  {p1x, {3, 5, 7}}
];
