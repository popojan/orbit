(* Verify the formula: Σsigns(pq) = +1 iff p^(-1) mod q is odd *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;

signSum[k_] := Module[{primLobes},
  primLobes = Select[Range[2, k-1], isPrimitiveLobe[#, k] &];
  Total[(-1)^(# - 1) & /@ primLobes]
];

(* Formula prediction *)
predictSignSum[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -3];

(* Test all semiprimes up to reasonable limit *)
Print["=== VERIFICATION OF FORMULA ==="];
Print["Formula: Σsigns(pq) = +1 iff p^(-1) mod q is odd, else -3\n"];

failures = {};
successes = 0;

Do[
  Do[
    If[q > p,
      k = p q;
      actual = signSum[k];
      predicted = predictSignSum[p, q];
      If[actual === predicted,
        successes++,
        AppendTo[failures, {p, q, actual, predicted}]
      ];
    ],
    {q, Prime[Range[2, 30]]}
  ],
  {p, Prime[Range[1, 15]]}
];

Print["Successes: ", successes];
Print["Failures: ", Length[failures]];

If[Length[failures] > 0,
  Print["\nFailed cases:"];
  Do[Print[f], {f, failures}],
  Print["\n✓ ALL CASES VERIFIED!"]
];

(* Also verify symmetry: is p^(-1) mod q odd iff q^(-1) mod p odd? *)
Print["\n=== SYMMETRY TEST: p^(-1) mod q vs q^(-1) mod p ===\n"];
asymmetric = {};
Do[
  Do[
    If[q > p,
      pinv = PowerMod[p, -1, q];
      qinv = PowerMod[q, -1, p];
      If[OddQ[pinv] =!= OddQ[qinv],
        AppendTo[asymmetric, {p, q, pinv, qinv}]
      ]
    ],
    {q, Prime[Range[2, 15]]}
  ],
  {p, Prime[Range[1, 10]]}
];

Print["Asymmetric cases: ", Length[asymmetric]];
If[Length[asymmetric] > 0,
  Print["Examples:"];
  Do[
    {p, q, pinv, qinv} = a;
    Print[p, "×", q, ": p^(-1)=", pinv, " (", If[OddQ[pinv], "odd", "even"], "), ",
          "q^(-1)=", qinv, " (", If[OddQ[qinv], "odd", "even"], ")"],
    {a, Take[asymmetric, Min[10, Length[asymmetric]]]}
  ]
];

(* Relate to Legendre symbol? *)
Print["\n=== RELATION TO QUADRATIC RECIPROCITY ===\n"];
Print["Checking if parity of p^(-1) mod q relates to Legendre symbols...\n"];

Do[
  p = 3;
  pinv = PowerMod[p, -1, q];
  parityInv = If[OddQ[pinv], 1, 0];
  leg = JacobiSymbol[p, q];
  qMod4 = Mod[q, 4];
  qMod8 = Mod[q, 8];
  Print["q=", q, " (mod 4: ", qMod4, ", mod 8: ", qMod8, "): ",
        "p^(-1)=", pinv, " (parity ", parityInv, "), (p/q)=", leg],
  {q, Prime[Range[3, 15]]}
];
