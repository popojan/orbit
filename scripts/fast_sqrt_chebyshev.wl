#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Fast Square Root Approximation via Chebyshev Refinement *)

(* Binet-like formula - bounds using (n±√nn)^k *)
binet[nn_, n_, k_] := Sqrt[nn] {(#1 - #2)/(#1 + #2), (#1 + #2)/(#1 - #2)}& @@
  {(n + Sqrt[nn])^k, (n - Sqrt[nn])^k} // FullSimplify

(* Babylonian algorithm step *)
next[nn_, n_, x_] := {nn/#, #}& @ Mean @ x

(* Iterated Babylonian *)
babylon[nn_, n_, k_] := Nest[next[nn, n, #]&, {(2 n nn)/(n^2 + nn), (n^2 + nn)/(2 n)}, k]

(* Original Chebyshev term (from Egypt.wl) *)
term[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x + 1] *
  (ChebyshevU[Floor[k/2], x + 1] - ChebyshevU[Floor[k/2] - 1, x + 1]))

(* Sum of Chebyshev terms *)
sqrtt[x_, n_] := 1 + Sum[term[x, j], {j, 1, n}]

(* Chebyshev-based refinement formula - THE KEY INNOVATION *)
sqrttrf[nn_, n_, m_] := (n^2 + nn)/(2 n) + (n^2 - nn)/(2 n) *
  ChebyshevU[m - 1, Sqrt[nn/(-n^2 + nn)]]/ChebyshevU[m + 1, Sqrt[nn/(-n^2 + nn)]] // Simplify

(* Symmetric refinement step *)
sym[nn_, n_, m_] := Module[{x = sqrttrf[nn, n, m]}, nn/(2 x) + x/2]

(* Nested iteration combining Chebyshev refinement *)
nestqrt[nn_, n_, {m1_, m2_}] := Nest[sym[nn, #, m1]&, n, m2]

(* Alternative Chebyshev formulations *)
nsqrtt[n_, m_] := ChebyshevT[-1 + 2 m, 1 + n]/ChebyshevU[-2 + 2 m, 1 + n]

sqrttn[n_, m_] := n (n + 2) ChebyshevU[-2 + 2 m, n + 1]/ChebyshevT[-1 + 2 m, n + 1]

sqrttf[n_, k_] := 1/2 (ChebyshevT[-1 + 2 k, 1 + n]/ChebyshevU[-2 + 2 k, 1 + n] +
  n (2 + n) ChebyshevU[-2 + 2 k, 1 + n]/ChebyshevT[-1 + 2 k, 1 + n])

(* ========== TESTS ========== *)

Print["=== FAST SQUARE ROOT VIA CHEBYSHEV REFINEMENT ===\n"];

(* Test the key sqrttrf function *)
Print["=== Testing sqrttrf (Chebyshev refinement) ===\n"];

TestSqrttrf[nn_, n_, maxM_] := Module[{},
  Print["√", nn, " starting from n=", n, ":\n"];
  Print["m\tApproximation\t\t\tError"];
  Print[StringRepeat["-", 70]];
  Do[
    Module[{approx, err},
      approx = sqrttrf[nn, n, m];
      err = Abs[approx - Sqrt[nn]];
      Print[m, "\t", N[approx, 15], "\t", N[err, 5]];
    ],
    {m, 1, maxM}
  ];
  Print["\n"];
];

TestSqrttrf[2, 1, 10];
TestSqrttrf[5, 2, 10];

(* Test nested iteration *)
Print["=== Testing nestqrt (nested Chebyshev refinement) ===\n"];

TestNestqrt[nn_, n_, m1_, maxM2_] := Module[{},
  Print["√", nn, " with m1=", m1, " (Chebyshev depth), varying nesting:\n"];
  Print["m2\tApproximation\t\t\tError"];
  Print[StringRepeat["-", 70]];
  Do[
    Module[{approx, err},
      approx = nestqrt[nn, n, {m1, m2}];
      err = Abs[approx - Sqrt[nn]];
      Print[m2, "\t", N[approx, 15], "\t", N[err, 5]];
    ],
    {m2, 0, maxM2}
  ];
  Print["\n"];
];

TestNestqrt[2, 1, 3, 5];

(* Compare methods *)
Print["=== COMPARISON: Babylonian vs Chebyshev Refinement ===\n"];

CompareMethods[nn_, n_] := Module[{baby, cheb, babyErr, chebErr},
  Print["√", nn, " starting from n=", n, ":\n"];

  baby = babylon[nn, n, 5];
  cheb = sqrttrf[nn, n, 5];

  babyErr = Abs[Mean[baby] - Sqrt[nn]];
  chebErr = Abs[cheb - Sqrt[nn]];

  Print["Babylonian (5 iterations): ", N[Mean[baby], 15]];
  Print["  Error: ", N[babyErr, 10]];
  Print["Chebyshev refinement (m=5): ", N[cheb, 15]];
  Print["  Error: ", N[chebErr, 10]];
  Print["Speedup factor: ", N[babyErr/chebErr, 5], "x\n"];
];

CompareMethods[2, 1];
CompareMethods[13, 3];

Print["=== TEST COMPLETE ==="];
