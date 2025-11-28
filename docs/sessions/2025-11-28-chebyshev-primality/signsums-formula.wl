(* Finding the formula for Σsigns in semiprimes p×q *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;

signSum[k_] := Module[{primLobes},
  primLobes = Select[Range[2, k-1], isPrimitiveLobe[#, k] &];
  Total[(-1)^(# - 1) & /@ primLobes]
];

(* Test hypothesis: Σsigns depends on p^(-1) mod q *)
Print["=== Testing formula based on p^(-1) mod q ===\n"];

Do[
  Do[
    If[q > p,
      k = p q;
      ss = signSum[k];
      pinv = PowerMod[p, -1, q];
      (* Hypothesis: Σsigns depends on parity of something *)
      Print[p, "×", q, " = ", k, ": Σsigns = ", ss,
            ", p^(-1) mod q = ", pinv,
            " (", If[OddQ[pinv], "odd", "even"], ")",
            ", (p-1)/2 = ", (p-1)/2,
            ", pinv mod p = ", Mod[pinv, p]];
    ],
    {q, Prime[Range[2, 12]]}
  ];
  Print[""],
  {p, {3, 5, 7}}
];

(* More refined test *)
Print["\n=== Testing: is (p^(-1) mod q) < q/2? ===\n"];
Do[
  Do[
    If[q > p,
      k = p q;
      ss = signSum[k];
      pinv = PowerMod[p, -1, q];
      test = pinv < q/2;
      Print[p, "×", q, ": Σsigns=", ss, ", p^(-1)=", pinv,
            ", <q/2? ", test,
            " → predicts ", If[test, "+1", "-3"]];
    ],
    {q, Prime[Range[2, 12]]}
  ];
  Print[""],
  {p, {3, 5, 7}}
];

(* Test quadratic residue hypothesis *)
Print["\n=== Testing: is (p^(-1) mod q) a QR mod q? ===\n"];
Do[
  Do[
    If[q > p,
      k = p q;
      ss = signSum[k];
      pinv = PowerMod[p, -1, q];
      isQR = JacobiSymbol[pinv, q] == 1;
      Print[p, "×", q, ": Σsigns=", ss, ", p^(-1)=", pinv,
            ", QR? ", isQR];
    ],
    {q, Prime[Range[2, 12]]}
  ];
  Print[""],
  {p, {3, 5, 7}}
];

(* Test Legendre symbol directly *)
Print["\n=== Testing Legendre symbols ===\n"];
Do[
  Do[
    If[q > p,
      k = p q;
      ss = signSum[k];
      leg1 = JacobiSymbol[p, q];
      leg2 = JacobiSymbol[q, p];
      prod = leg1 * leg2;
      Print[p, "×", q, ": Σsigns=", ss,
            ", (p/q)=", leg1, ", (q/p)=", leg2, ", product=", prod];
    ],
    {q, Prime[Range[2, 15]]}
  ];
  Print[""],
  {p, {3, 5, 7, 11}}
];
