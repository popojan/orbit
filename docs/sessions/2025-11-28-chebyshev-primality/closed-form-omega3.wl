(* Closed form for ω=3: The sum DOES factor! *)

Print["=== Closed form derivation for ω=3 ===\n"];

(* Key insight from analysis:
   Σ_{a=2}^{p-1} (-1)^{a·b} =
     - If b=0: p-2  (all terms are +1)
     - If b=1: 1    (alternating sum, odd count, starts and ends at +1)
*)

(* The sign formula:
   sign(n) = (-1)^{n-1}
   n mod 2 = (a₁b₁ + a₂b₂ + a₃b₃) mod 2

   So (-1)^{n-1} = (-1)^{n} · (-1)^{-1} = -(-1)^{a₁b₁+a₂b₂+a₃b₃}

   Therefore:
   Σsigns = Σ (-1)^{n-1} = -Σ (-1)^{a₁b₁+a₂b₂+a₃b₃}
          = -[Σ_{a₁} (-1)^{a₁b₁}][Σ_{a₂} (-1)^{a₂b₂}][Σ_{a₃} (-1)^{a₃b₃}]
*)

(* Define the factor for each prime *)
factor[p_, b_] := If[b == 0, p - 2, 1];

(* The closed form *)
closedForm[p1_, p2_, p3_] := Module[
  {c1, c2, c3, b1, b2, b3},
  c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
  c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
  c3 = p1 p2 * PowerMod[p1 p2, -1, p3];
  b1 = Mod[c1, 2]; b2 = Mod[c2, 2]; b3 = Mod[c3, 2];
  -factor[p1, b1] * factor[p2, b2] * factor[p3, b3]
];

(* Verify against direct computation *)
isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

Print["=== Verification of closed form ===\n"];
errors = 0;
total = 0;
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    actual = signSum[k];
    predicted = closedForm[p1, p2, p3];
    total++;
    If[actual != predicted,
      errors++;
      If[errors <= 10,
        Print["ERROR: ", p1, "*", p2, "*", p3, " actual=", actual, " predicted=", predicted]
      ]
    ]
  ],
  {p1, Prime[Range[2, 10]]},
  {p2, Prime[Range[3, 15]]},
  {p3, Prime[Range[4, 20]]}
];
Print["Tested: ", total, " cases"];
Print["Errors: ", errors];

If[errors == 0,
  Print["\n*** CLOSED FORM VERIFIED! ***\n"];

  Print["=== The Formula ===\n"];
  Print["For k = p₁·p₂·p₃ with distinct odd primes:"];
  Print[""];
  Print["  Σsigns(k) = -f(p₁,b₁)·f(p₂,b₂)·f(p₃,b₃)"];
  Print[""];
  Print["where:"];
  Print["  f(p, 0) = p - 2"];
  Print["  f(p, 1) = 1"];
  Print[""];
  Print["  bᵢ = cᵢ mod 2 = ((rⱼ·rₖ)⁻¹ mod pᵢ) mod 2"];
  Print[""];

  Print["=== Examples ===\n"];
  Do[
    If[p1 < p2 < p3,
      c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
      c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
      c3 = p1 p2 * PowerMod[p1 p2, -1, p3];
      {b1, b2, b3} = Mod[{c1, c2, c3}, 2];
      ss = closedForm[p1, p2, p3];
      f1 = factor[p1, b1]; f2 = factor[p2, b2]; f3 = factor[p3, b3];
      Print[p1, "×", p2, "×", p3, ": b=(", b1, ",", b2, ",", b3, ")"];
      Print["  f = (", f1, ",", f2, ",", f3, ") → Σsigns = -", f1, "·", f2, "·", f3, " = ", ss];
      Print[""]
    ],
    {p1, {3, 5}},
    {p2, {5, 7, 11}},
    {p3, {7, 11, 13}}
  ];

  (* Analyze when Σsigns takes specific values *)
  Print["=== Value distribution ===\n"];
  data = {};
  Do[
    If[p1 < p2 < p3,
      ss = closedForm[p1, p2, p3];
      c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
      c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
      c3 = p1 p2 * PowerMod[p1 p2, -1, p3];
      {b1, b2, b3} = Mod[{c1, c2, c3}, 2];
      AppendTo[data, <|"k" -> p1 p2 p3, "ss" -> ss, "b" -> {b1, b2, b3},
                       "p" -> {p1, p2, p3}|>]
    ],
    {p1, Prime[Range[2, 8]]},
    {p2, Prime[Range[3, 12]]},
    {p3, Prime[Range[4, 15]]}
  ];

  byB = GroupBy[data, #["b"] &];
  Print["By parity pattern (b₁,b₂,b₃):"];
  Do[
    ssVals = Union[#["ss"] & /@ byB[b]];
    Print["  ", b, ": Σsigns ∈ ", ssVals],
    {b, Sort[Keys[byB]]}
  ];

  Print["\n=== Congruence check ==="];
  Print["Recall: Σsigns ≡ 1 - 2ω (mod 4) = 1 - 6 = -5 ≡ 3 (mod 4)"];
  violations = 0;
  Do[
    ss = d["ss"];
    If[Mod[ss, 4] != 3 && Mod[ss, 4] != -1,
      violations++;
      Print["  Violation: k=", d["k"], " ss=", ss, " mod 4 = ", Mod[ss, 4]]
    ],
    {d, data}
  ];
  Print["Congruence violations: ", violations];
];
