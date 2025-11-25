#!/usr/bin/env wolframscript
(* Use de Moivre derived formulas - simplest form *)

Print["=== DE MOIVRE FORMULA VERIFICATION ===\n"];

Print["Source: Wikipedia, derived from de Moivre's formula"];
Print["cos(n theta) = Re[(cos theta + i sin theta)^n]\n"];

(* De Moivre T_n formula *)
tnDeMoivre[n_, x_] := Module[{sum},
  If[n == 0, Return[1]];
  sum = Sum[
    Binomial[n, 2*j] * (x^2 - 1)^j * x^(n - 2*j),
    {j, 0, Floor[n/2]}
  ];
  Expand[sum]
];

(* De Moivre U_n formula *)
unDeMoivre[n_, x_] := Module[{sum},
  If[n < 0, Return[0]];
  If[n == 0, Return[1]];
  sum = Sum[
    Binomial[n+1, 2*k+1] * (x^2 - 1)^k * x^(n - 2*k),
    {k, 0, Floor[n/2]}
  ];
  Expand[sum]
];

Print["Step 1: Verify de Moivre formulas\n"];

allMatch = True;

Do[
  deMoivre = tnDeMoivre[n, y];
  mathForm = ChebyshevT[n, y] // Expand;
  match = (deMoivre === mathForm);
  allMatch = allMatch && match;

  Print["T_", n, "(y): ", If[match, "MATCH", "FAIL"]];
  If[!match,
    Print["  de Moivre: ", deMoivre];
    Print["  Chebyshev: ", mathForm];
  ];
, {n, 0, 5}];

Do[
  deMoivre = unDeMoivre[n, y];
  mathForm = ChebyshevU[n, y] // Expand;
  match = (deMoivre === mathForm);
  allMatch = allMatch && match;

  Print["U_", n, "(y): ", If[match, "MATCH", "FAIL"]];
  If[!match,
    Print["  de Moivre: ", deMoivre];
    Print["  Chebyshev: ", mathForm];
  ];
, {n, 0, 5}];

Print[];
If[allMatch,
  Print["All de Moivre formulas verified!\n"];
,
  Print["ERROR: Some formulas do not match.\n"];
  Exit[1];
];

Print["Step 2: Verify identity for k=1..5\n"];

allIdentitiesMatch = True;

Do[
  n = Ceiling[k/2];
  m = Floor[k/2];

  (* Use de Moivre formulas *)
  tn = tnDeMoivre[n, x+1] // Expand;
  um = unDeMoivre[m, x+1] // Expand;
  umPrev = unDeMoivre[m-1, x+1] // Expand;

  deltaU = Expand[um - umPrev];
  product = Expand[tn * deltaU];

  factForm = 1 + Sum[2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]), {i, 1, k}] // Expand;

  prodCoeffs = CoefficientList[product, x];
  factCoeffs = CoefficientList[factForm, x];

  match = (prodCoeffs == factCoeffs);
  allIdentitiesMatch = allIdentitiesMatch && match;

  Print["k=", k, " (n=", n, ", m=", m, "): ", If[match, "MATCH", "FAIL"]];

  If[!match,
    Print["  Product: ", product];
    Print["  Factorial: ", factForm];
  ];
, {k, 1, 5}];

Print[];

If[allIdentitiesMatch,
  Print["=== SUCCESS ===\n"];
  Print["ALL identities verified using de Moivre formulas!"];
  Print[];
  Print["Proof chain:"];
  Print["  1. de Moivre formula: cos(n theta) = Re[(cos theta + i sin theta)^n]"];
  Print["  2. Binomial expansion of (cos + i sin)^n"];
  Print["  3. T_n(x) = sum binom(n,2j) (x^2-1)^j x^{n-2j} (standard)"];
  Print["  4. U_n(x) = sum binom(n+1,2k+1) (x^2-1)^k x^{n-2k} (standard)"];
  Print["  5. Shift to (x+1) via binomial theorem (elementary)"];
  Print["  6. Polynomial multiplication (elementary)"];
  Print["  7. Coefficient matching (verified k=1..5)"];
  Print[];
  Print["All steps hand-checkable, based on standard formulas!");
,
  Print["=== FAILURE ==="];
  Print["Some identities do not match. Debug needed."];
  Exit[1];
];
