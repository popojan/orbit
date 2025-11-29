(* Verify the formula for Σsigns(3*p2*p3) *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Formula *)
predictedSignSum[p1_, p2_, p3_] := Module[
  {M2, M3, e2, e3, c2, c3, inv12, inv13, inv23,
   r2, r3, delta, invSum},

  M2 = p1 p3; M3 = p1 p2;
  e2 = PowerMod[M2, -1, p2];
  e3 = PowerMod[M3, -1, p3];
  c2 = Mod[M2 e2, 2];
  c3 = Mod[M3 e3, 2];

  inv12 = Mod[PowerMod[p1, -1, p2], 2];
  inv13 = Mod[PowerMod[p1, -1, p3], 2];
  inv23 = Mod[PowerMod[p2, -1, p3], 2];
  invSum = inv12 + inv13 + inv23;

  r2 = Mod[p2, p1];
  r3 = Mod[p3, p1];

  delta = Mod[(c2 + c3) + invSum, 2];  (* XOR for mod 2 *)

  Which[
    r2 == 1 && r3 == 1, 3 - 4 delta,
    (r2 == 1 && r3 == 2) || (r2 == 2 && r3 == 1), -1 + 4 delta,
    r2 == 2 && r3 == 2, -5 - 4 delta
  ]
];

(* Test on extended range *)
Print["=== Verifying formula for p1=3 ==="];
errors = 0;
total = 0;
Do[
  If[p2 > 3 && p3 > p2,
    k = 3 p2 p3;
    actual = signSum[k];
    predicted = predictedSignSum[3, p2, p3];
    total++;
    If[actual != predicted,
      Print["ERROR: k=", k, " actual=", actual, " predicted=", predicted];
      errors++
    ]
  ],
  {p2, Prime[Range[3, 20]]},
  {p3, Prime[Range[4, 30]]}
];
Print["Tested ", total, " cases, errors: ", errors];

If[errors == 0,
  Print["\n=== FORMULA VERIFIED ==="];
  Print["For k = 3 × p₂ × p₃ (with 3 < p₂ < p₃):"];
  Print[""];
  Print["Let:"];
  Print["  c₂ = (3p₃)·(3p₃)⁻¹ mod p₂, taken mod 2"];
  Print["  c₃ = (3p₂)·(3p₂)⁻¹ mod p₃, taken mod 2"];
  Print["  inv₁₂ = 3⁻¹ mod p₂, taken mod 2"];
  Print["  inv₁₃ = 3⁻¹ mod p₃, taken mod 2"];
  Print["  inv₂₃ = p₂⁻¹ mod p₃, taken mod 2"];
  Print["  δ = (c₂ + c₃ + inv₁₂ + inv₁₃ + inv₂₃) mod 2"];
  Print[""];
  Print["Then Σsigns(k) = "];
  Print["  3 - 4δ    if p₂ ≡ p₃ ≡ 1 (mod 3)"];
  Print["  -1 + 4δ   if {p₂ mod 3, p₃ mod 3} = {1, 2}"];
  Print["  -5 - 4δ   if p₂ ≡ p₃ ≡ 2 (mod 3)"];
];
