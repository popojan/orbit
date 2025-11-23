#!/usr/bin/env wolframscript
(* Patterns in P_n and Q_n coefficients *)

mul[k_, a_] := (I (-I - a)^k - (I - a)^k - I (-I + a)^k + (I + a)^k)/
               ((-I - a)^k - I (I - a)^k + (-I + a)^k - I (I + a)^k)

Print["=== COEFFICIENT PATTERNS ===\n"]

Print["Extracting normalized forms (making leading coefficient ±1):"]
Print[""]

polynomials = Table[
  expr = Together[mul[n, x]];
  pn = Numerator[expr];
  qn = Denominator[expr];

  (* Factor out constant multiples *)
  pCoeffs = CoefficientList[pn, x];
  qCoeffs = CoefficientList[qn, x];

  (* Normalize by constant term of Q (make it 1 or -1) *)
  qConst = qCoeffs[[1]];
  pNorm = Expand[pn/qConst];
  qNorm = Expand[qn/qConst];

  {n, pNorm, qNorm, CoefficientList[pNorm, x], CoefficientList[qNorm, x]}
, {n, 1, 10}];

Do[
  {n, pn, qn, pCoeffs, qCoeffs} = poly;
  Print["n = ", n, ":"];
  Print["  P_", n, "(x) = ", pn];
  Print["  Q_", n, "(x) = ", qn];
  Print["  P coeffs: ", pCoeffs];
  Print["  Q coeffs: ", qCoeffs];
  Print[""];
, {poly, polynomials}]

Print["=== BINOMIAL COEFFICIENT PATTERNS ===\n"]

(* Check if coefficients match binomial patterns *)
Print["Looking for binomial coefficient patterns in Q_n:"];
Print[""];

Do[
  {n, pn, qn, pCoeffs, qCoeffs} = poly;

  (* Extract even coefficients (Q_n has only even powers) *)
  evenCoeffs = Table[qCoeffs[[2*k + 1]], {k, 0, Floor[Length[qCoeffs]/2]}];

  Print["n = ", n, ":"];
  Print["  Q coeffs (even powers): ", evenCoeffs];

  (* Compare with binomial coefficients *)
  binomCoeffs = Table[Binomial[n, k], {k, 0, n}];
  Print["  Binomial(", n, ",k): ", binomCoeffs];

  (* Check with alternating signs *)
  altSigns = Table[(-1)^k * Binomial[n, k], {k, 0, n}];
  Print["  (-1)^k * Binomial(", n, ",k): ", altSigns];

  Print[""];
, {poly, polynomials}]

Print["=== SYMMETRY BETWEEN P AND Q ===\n"]

(* Notice that P_n and Q_n seem related *)
Do[
  {n, pn, qn, pCoeffs, qCoeffs} = poly;

  (* Factor out x from P_n *)
  pNoX = If[pCoeffs[[1]] == 0 && Length[pCoeffs] > 1,
            Expand[pn/x], pn];

  Print["n = ", n, ":"];
  Print["  P_", n, "(x)/x = ", pNoX];
  Print["  Q_", n, "(x)   = ", qn];

  (* Check if P_n(x)/x and Q_n(x) are related by x → ix or similar *)
  pNoXCoeffs = CoefficientList[pNoX, x];
  Print["  P/x coeffs: ", pNoXCoeffs];
  Print["  Q coeffs:   ", qCoeffs];

  Print[""];
, {poly, polynomials[[1;;5]]}]

Print["=== RECURRENCE RELATION ===\n"]

(* Can we find a recurrence for P_n and Q_n? *)
(* Standard identity: tan((n+1)θ) = (tan(nθ) + tan(θ))/(1 - tan(nθ)tan(θ)) *)

Print["Testing recurrence: tan((n+1)θ) = (tan(nθ) + tan(θ))/(1 - tan(nθ)tan(θ))"];
Print[""];

Do[
  tn = mul[n, x];
  tnPlus1 = mul[n+1, x];
  t1 = x;

  recurrence = Simplify[(tn + t1)/(1 - tn*t1)];

  Print["n = ", n, ":"];
  Print["  tan((n+1)θ) direct:      ", Simplify[tnPlus1]];
  Print["  From recurrence:         ", recurrence];
  Print["  Match: ", Simplify[tnPlus1 - recurrence] == 0];
  Print[""];
, {n, 1, 5}]

Print["=== PARITY AND SPECIAL VALUES ===\n"]

(* tan(nπ/4) should be algebraic *)
Print["tan(n·π/4) values (using a=1):"];
Do[
  val = mul[n, 1];
  Print["  n=", n, ": ", val, " (should be tan(", n, "π/4))"];
, {n, 1, 8}]

Print[""];
Print["tan(n·π/6) values (using a=1/√3):"];
Do[
  val = mul[n, 1/Sqrt[3]];
  Print["  n=", n, ": ", Simplify[val], " (should be tan(", n, "π/6))"];
, {n, 1, 8}]
