(* Derive explicit formula for signSum(p1*p2*p3) with p1=3 *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Compute signature *)
sig[p1_, p2_, p3_] := Module[
  {M1, M2, M3, e1, e2, e3, c1, c2, c3, inv12, inv13, inv23, r2, r3},
  M1 = p2 p3; M2 = p1 p3; M3 = p1 p2;
  e1 = PowerMod[M1, -1, p1];
  e2 = PowerMod[M2, -1, p2];
  e3 = PowerMod[M3, -1, p3];
  c1 = Mod[M1 e1, 2];
  c2 = Mod[M2 e2, 2];
  c3 = Mod[M3 e3, 2];
  inv12 = Mod[PowerMod[p1, -1, p2], 2];
  inv13 = Mod[PowerMod[p1, -1, p3], 2];
  inv23 = Mod[PowerMod[p2, -1, p3], 2];
  r2 = Mod[p2, p1];
  r3 = Mod[p3, p1];
  {c1, c2, c3, inv12, inv13, inv23, r2, r3}
];

(* Build lookup table *)
Print["=== Building formula lookup table ==="];
table = <||>;
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    s = sig[p1, p2, p3];
    key = s;
    If[KeyExistsQ[table, key],
      If[table[key] != ss, Print["CONFLICT: ", key, " has ", table[key], " and ", ss]],
      table[key] = ss
    ];
  ],
  {p1, {3}},
  {p2, Prime[Range[3, 15]]},
  {p3, Prime[Range[4, 25]]}
];
Print["Table has ", Length[table], " entries, no conflicts"];

(* Try to find simpler formula *)
(* Observation: c1 = Mod[p2*p3 * (p2*p3)^-1 mod 3, 2]
   Since 3 is small, (p2*p3)^-1 mod 3 = (p2*p3 mod 3)^-1 mod 3
   And p2*p3 mod 3 = (p2 mod 3)*(p3 mod 3) mod 3 = r2*r3 mod 3
*)

Print["\n=== Verify c1 formula ==="];
Do[
  If[p2 > 3 && PrimeQ[p2],
    If[p3 > p2 && PrimeQ[p3],
      M1 = p2 p3;
      e1 = PowerMod[M1, -1, 3];
      c1 = Mod[M1 e1, 2];
      r2 = Mod[p2, 3]; r3 = Mod[p3, 3];
      prod = Mod[r2 r3, 3];
      If[prod == 0, Continue[]];
      invProd = PowerMod[prod, -1, 3];
      (* M1 e1 mod 2: M1 is odd, so M1 e1 mod 2 = e1 mod 2 *)
      If[c1 != Mod[invProd, 2],
        Print["c1 mismatch: p2=", p2, " p3=", p3, " c1=", c1, " invProd mod 2=", Mod[invProd, 2]]
      ]
    ]
  ],
  {p2, Prime[Range[3, 15]]}, {p3, Prime[Range[4, 25]]}
];
Print["c1 = ((r2*r3)^-1 mod 3) mod 2 ✓"];

(* For p1=3: r2*r3 ∈ {1, 2, 4 mod 3} = {1, 2, 1}
   - If r2*r3 ≡ 1 (mod 3): inverse is 1, c1 = 1
   - If r2*r3 ≡ 2 (mod 3): inverse is 2, c1 = 0
*)

Print["\n=== Simpler signature: (r2, r3, c2+c3, inv12+inv13+inv23) ==="];
table2 = <||>;
Do[
  If[p1 < p2 < p3,
    ss = signSum[p1 p2 p3];
    s = sig[p1, p2, p3];
    {c1, c2, c3, inv12, inv13, inv23, r2, r3} = s;
    key2 = {r2, r3, c2 + c3, inv12 + inv13 + inv23};
    If[KeyExistsQ[table2, key2],
      If[table2[key2] != ss,
        Print["CONFLICT: ", key2, " has ", table2[key2], " and ", ss]
      ]
      ,
      table2[key2] = ss
    ];
  ],
  {p1, {3}}, {p2, Prime[Range[3, 15]]}, {p3, Prime[Range[4, 25]]}
];
Print["Simplified table has ", Length[table2], " entries"];
Print["Entries:"];
Do[Print["  ", key, " → ", table2[key]], {key, Sort[Keys[table2]]}];
