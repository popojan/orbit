#!/usr/bin/env wolframscript
(* Test modular arithmetic approach for TOTAL-EVEN proof *)

(* Key idea: Work modulo (x+1) *)
(* If Num(S_k) ≡ 0 (mod x+1) ⟺ (k+1) EVEN, then we have a proof *)

(* Chebyshev polynomial values at x = -1 *)
Print["Chebyshev polynomial values at x = -1:"];
Print["T_n(-1) = (-1)^n"];
Print["U_n(-1) = (-1)^n * (n+1)"];
Print[""];

(* Test: Evaluate S_k at x = -1 numerically *)
term[z_, j_] := 1 / (ChebyshevT[Ceiling[j/2], z+1] *
  (ChebyshevU[Floor[j/2], z+1] - ChebyshevU[Floor[j/2]-1, z+1]));

SkNumerical[x_, k_] := 1 + Sum[term[x-1, j], {j, 1, k}];

Print["Numerical evaluation of S_k at x approaching -1:"];
Print["(If S_k(-1) = 0 or ∞, then (x+1) | Num(S_k))"];
Print[""];

(* Test for k = 1 to 10, approaching x = -1 *)
testValues = {-0.9, -0.99, -0.999, -0.9999};

For[k = 1, k <= 10, k++,
  total = k + 1;
  parity = If[EvenQ[total], "EVEN", "ODD"];

  Print["k = ", k, " (total = ", total, ", ", parity, "):"];

  vals = Table[SkNumerical[x, k], {x, testValues}];
  Print["  S_k(x) for x → -1: ", vals];

  (* Check if approaching 0 or ∞ *)
  ratio = Abs[vals[[4]] / vals[[1]]];
  If[Abs[vals[[4]]] < 0.01,
    Print["  → Approaches 0 (numerator has (x+1) factor) ✓"],
    If[ratio > 100,
      Print["  → Diverges to ∞ (denominator has (x+1) factor)"],
      Print["  → Finite nonzero limit (no (x+1) in numerator)"]
    ]
  ];
  Print[""];
];

Print["========================================"];
Print["Symbolic approach: Compute Num(S_k) mod (x+1)"];
Print[""];

(* Compute S_k symbolically and check numerator modulo (x+1) *)
SkSymbolic[k_] := Module[{s, num, den},
  s = 1 + Sum[term[x-1, j], {j, 1, k}];
  s = Together[s];
  num = Numerator[s];
  den = Denominator[s];

  (* Factor numerator *)
  numFactored = Factor[num];

  (* Check if (x+1) divides numerator *)
  numMod = PolynomialRemainder[num, x+1, x];

  {numFactored, numMod == 0}
];

Print["Symbolic factorization check:"];
For[k = 1, k <= 8, k++,
  total = k + 1;
  parity = If[EvenQ[total], "EVEN", "ODD"];

  {numFactor, isDivisible} = SkSymbolic[k];

  Print["k = ", k, " (", parity, "): Num = ", numFactor];
  Print["  (x+1) | Num? ", isDivisible];
  Print["  Expected? ", parity == "EVEN"];
  Print["  Match: ", isDivisible == (parity == "EVEN"), "\n"];
];

Print["========================================"];
Print["Key observation from Lemma 3:"];
Print["term(2m) + term(2m+1) has numerator (x+1)"];
Print[""];
Print["This means pairs always contribute (x+1) factor."];
Print["For EVEN total k+1 (k odd), all terms are paired."];
Print["For ODD total k+1 (k even), one term is unpaired."];
Print[""];
Print["Question: Does the unpaired term lack (x+1)?"];
Print[""];

(* Check if individual terms have (x+1) in numerator *)
Print["Individual term analysis:"];
For[j = 1, j <= 10, j++,
  t = term[x-1, j];
  t = Together[t];
  num = Numerator[t];
  numMod = PolynomialRemainder[num, x+1, x];

  hasFactor = numMod == 0;

  Print["term(", j, "): ", If[hasFactor, "HAS (x+1)", "NO (x+1)"]];
];

Print["\nDone."];
