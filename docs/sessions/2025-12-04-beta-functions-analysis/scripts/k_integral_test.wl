(* k_integral_test.wl *)
(* Verify that k-integral works for BOTH beta functions *)
(* Integral from 0 to n of B(n,k) dk should equal n *)

Print["=== k-Integral Test: Integral[B(n,k), {k, 0, n}] = n ? ==="];
Print[""];

(* Two beta definitions *)
betaGeom[n_] := n^2 Cos[Pi/n]/(4 - n^2);
betaRes[n_] := (n - Cot[Pi/n])/(4 n);

(* B functions *)
BGeom[n_, k_] := 1 + betaGeom[n] Cos[(2 k - 1) Pi/n];
BRes[n_, k_] := 1 + betaRes[n] Cos[(2 k - 1) Pi/n];

(* Symbolic integral *)
Print["=== Symbolic Analysis ==="];
Print[""];
Print["B(n,k) = 1 + beta(n) * cos((2k-1)*pi/n)"];
Print[""];
Print["Integral[B, {k, 0, n}] = Integral[1, {k, 0, n}] + beta(n) * Integral[cos(...), {k, 0, n}]"];
Print["                      = n + beta(n) * 0"];
Print["                      = n"];
Print[""];
Print["The cosine integrates to 0 over a full period (2*pi),"];
Print["regardless of the value of beta(n)!"];
Print[""];

(* Numerical verification *)
Print["=== Numerical Verification ==="];
Print[""];
Print["n\tIntegral(B_geom)\tIntegral(B_res)\tExpected"];
Print["------------------------------------------------------"];

Do[
  intGeom = NIntegrate[BGeom[n, k], {k, 0, n}];
  intRes = NIntegrate[BRes[n, k], {k, 0, n}];
  Print[n, "\t", intGeom, "\t\t", intRes, "\t\t", n],
  {n, {5, 7, 10, 15, 20, 50}}
];

Print[""];
Print["=== Conclusion ==="];
Print[""];
Print["The k-integral gives n for BOTH beta functions."];
Print["This is because the beta only affects the amplitude of the cosine,"];
Print["and the cosine integrates to zero over a complete period."];
