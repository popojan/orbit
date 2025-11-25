#!/usr/bin/env wolframscript
(* Try hypergeometric approach to prove the identity *)
(* The factorial form is a hypergeometric term *)

Print["=== HYPERGEOMETRIC APPROACH ===\n"];

(* Factorial form coefficient *)
factorialCoeff[k_, i_] := If[i == 0, 1, 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i])];

Print["Part 1: Express factorial coefficients as hypergeometric\n"];

Do[
  coeff = factorialCoeff[k, i];
  Print["k=", k, ", i=", i, ": ", coeff];

  (* Try to express as hypergeometric *)
  (* Factor out powers of 2 and x *)
  If[i > 0,
    ratio = coeff / (x^i * 2^(i-1));
    Print["  Without x^i * 2^(i-1): ", ratio];
    Print["  = (k+i)! / ((k-i)! * (2i)!)"];
    Print["  = Pochhammer[k-i+1, 2i] / (2i)!"];
    Print["  = Product[(k-i+j), {j, 1, 2i}] / (2i)!"];
    Print[];
  ];
, {k, 3, 5}, {i, 0, k}];

Print["Part 2: Look for recurrence relation\n"];

(* Check if factorial coefficients satisfy a recurrence *)
k = 5;
Print["For k=", k, ", check recurrence in i:\n"];

Do[
  c_i = factorialCoeff[k, i];
  c_im1 = If[i > 0, factorialCoeff[k, i-1], 0];

  If[i > 0 && c_im1 != 0,
    ratio = Simplify[c_i / c_im1];
    Print["  c[", i, "] / c[", i-1, "] = ", ratio];
  ];
, {i, 0, k}];

Print[];

Print["Part 3: Try to find closed form via RSolve\n"];

(* Define recurrence *)
(* c[i] / c[i-1] = f(i, k) *)
(* From above pattern *)

Print["Recurrence appears to be:"];
Print["  c[i] = c[i-1] * (k+i)(k-i+1) * 2 / ((2i)(2i-1))"];
Print["  c[0] = 1"];
Print[];

(* Verify this recurrence *)
k = 4;
Print["Verify for k=", k, ":\n"];

cRecurrence[0] = 1;
cRecurrence[i_] := cRecurrence[i-1] * (k+i)*(k-i+1) * 2 / ((2*i)*(2*i-1));

Do[
  cRec = cRecurrence[i];
  cFac = factorialCoeff[k, i];

  Print["  i=", i, ": recurrence = ", cRec, ", factorial = ", cFac, ", match = ", cRec == cFac];
, {i, 0, k}];

Print[];

Print["Part 4: Check if Chebyshev product satisfies same recurrence\n"];

(* Compute Chebyshev coefficients *)
k = 4;
n = Ceiling[k/2];
m = Floor[k/2];

tn = Expand[ChebyshevT[n, x+1]];
deltaU = Expand[ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1]];
product = Expand[tn * deltaU];

prodCoeffs = CoefficientList[product, x];

Print["For k=", k, " (n=", n, ", m=", m, "):\n"];
Print["Product coefficients: ", prodCoeffs];
Print[];

Print["Check recurrence:"];
Do[
  If[i > 0 && prodCoeffs[[i]] != 0,
    ratio = Simplify[prodCoeffs[[i+1]] / prodCoeffs[[i]]];
    expectedRatio = (k+i)*(k-i+1) * 2 / ((2*i)*(2*i-1));
    Print["  [x^", i, "] / [x^", i-1, "] = ", ratio];
    Print["    Expected: ", expectedRatio];
    Print["    Match: ", Simplify[ratio - expectedRatio] == 0];
  ];
, {i, 1, k}];

Print[];

Print["=== KEY INSIGHT ==="];
Print["If we can prove Chebyshev product satisfies the same recurrence,"];
Print["and both start with c[0]=1, then by induction they are equal!"];
