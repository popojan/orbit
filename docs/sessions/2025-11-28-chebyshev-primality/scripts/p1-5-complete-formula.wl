(* Complete formula for p1=5: verify (r2, r3, δ1, δ2) determines Σsigns *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

    inv23 = Mod[PowerMod[p2, -1, p3], 2];
    inv32 = Mod[PowerMod[p3, -1, p2], 2];
    M2 = p1 p3; M3 = p1 p2;
    c2 = Mod[M2 PowerMod[M2, -1, p2], 2];
    c3 = Mod[M3 PowerMod[M3, -1, p3], 2];

    d1 = Mod[inv23 + c2, 2];
    d2 = Mod[inv32 + c3, 2];

    AppendTo[data, <|"ss" -> ss, "r2" -> r2, "r3" -> r3, "d1" -> d1, "d2" -> d2|>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 25]]},
  {p3, Prime[Range[5, 40]]}
];

Print["=== Testing (r2, r3, δ1, δ2) for ALL classes ==="];
Print["Total cases: ", Length[data], "\n"];

grouped = GroupBy[data, {#["r2"], #["r3"], #["d1"], #["d2"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  If[Length[ssVals] > 1,
    Print["CONFLICT: ", key, " → ", ssVals];
    conflicts++
  ],
  {key, Keys[grouped]}
];
Print["Conflicts: ", conflicts, " / ", Length[Keys[grouped]], " patterns"];

If[conflicts == 0,
  Print["\n=== SUCCESS! Complete formula for p1=5 ==="];
  Print["Σsigns(5·p₂·p₃) = f(r₂, r₃, δ₁, δ₂)"];
  Print["where:"];
  Print["  r₂ = p₂ mod 5, r₃ = p₃ mod 5"];
  Print["  δ₁ = (p₂⁻¹ mod p₃) ⊕ c₂"];
  Print["  δ₂ = (p₃⁻¹ mod p₂) ⊕ c₃"];
  Print["  cᵢ = (5·pⱼ)·(5·pⱼ)⁻¹ mod pᵢ (mod 2)"];

  Print["\n=== Lookup table ==="];
  Do[
    ss = First[#["ss"] & /@ grouped[key]];
    Print[key, " → ", ss],
    {key, Sort[Keys[grouped]]}
  ]
];
