#!/usr/bin/env wolframscript
(* Symbolic derivative of F_n(alpha) *)

Print["================================================================"];
Print["SYMBOLIC DERIVATIVE EXPLORATION"];
Print["================================================================"];
Print[""];

(* ============================================================================ *)
(* SINGLE TERM DERIVATIVE                                                     *)
(* ============================================================================ *)

Print["[1/4] Single term derivative"];
Print[""];

Print["Given term: T(alpha) = [(n - k*d - d^2)^2 + eps]^(-alpha)"];
Print[""];

(* Define symbolic term *)
term = ((n - k*d - d^2)^2 + eps)^(-alpha);

Print["Computing D[T, alpha]..."];
Print[""];

derivative = D[term, alpha];

Print["Result:"];
Print[derivative];
Print[""];

(* Simplify *)
simplified = Simplify[derivative];
Print["Simplified:"];
Print[simplified];
Print[""];

(* Factor out the term *)
Print["Factor out original term:"];
factored = Simplify[derivative / term];
Print["dT/dalpha = T(alpha) * (", factored, ")"];
Print[""];

Print["Observation: dT/dalpha = -Log[dist^2 + eps] * T(alpha)"];
Print["  where dist = n - k*d - d^2"];
Print[""];

(* ============================================================================ *)
(* INNER SUM DERIVATIVE                                                       *)
(* ============================================================================ *)

Print["[2/4] Inner sum derivative"];
Print[""];

Print["Inner sum (over k): S_d(alpha) = Sum_k [(n-k*d-d^2)^2 + eps]^(-alpha)"];
Print[""];
Print["Derivative: dS_d/dalpha = Sum_k [-Log[...] * term]"];
Print[""];

Print["Can Wolfram compute this symbolically for small cases?"];
Print[""];

(* Test for specific n, d *)
Print["Example: n=10, d=2, k=0..5"];
Print[""];

nVal = 10;
dVal = 2;
epsVal = 1;

innerSum = Sum[((nVal - k*dVal - dVal^2)^2 + epsVal)^(-alpha), {k, 0, 5}];
Print["S_2(alpha) = ", innerSum];
Print[""];

innerDerivative = D[innerSum, alpha];
Print["dS_2/dalpha = ", innerDerivative];
Print[""];

Print["Numerical check at alpha=3:"];
Print["  S_2(3) = ", N[innerSum /. alpha -> 3, 6]];
Print["  dS_2/dalpha|_{alpha=3} = ", N[innerDerivative /. alpha -> 3, 6]];
Print[""];

(* ============================================================================ *)
(* OUTER SUM DERIVATIVE                                                       *)
(* ============================================================================ *)

Print["[3/4] Full double sum derivative"];
Print[""];

Print["Full: F_n(alpha) = Sum_d Sum_k [(n-k*d-d^2)^2 + eps]^(-alpha)"];
Print[""];
Print["Derivative: dF_n/dalpha = Sum_d Sum_k [-Log[(n-k*d-d^2)^2+eps] * term]"];
Print[""];

Print["Structure remains DOUBLE SUM - no simplification!"];
Print[""];

Print["Example: n=10, d=2..3, k=0..5"];
Print[""];

fullSum = Sum[
  Sum[((nVal - k*d - d^2)^2 + epsVal)^(-alpha), {k, 0, 5}],
  {d, 2, 3}
];

Print["F_10(alpha) (truncated) = ", fullSum];
Print[""];

fullDerivative = D[fullSum, alpha];
Print["dF_10/dalpha = "];
Print[fullDerivative];
Print[""];

Print["Numerical at alpha=3:"];
Print["  F_10(3) = ", N[fullSum /. alpha -> 3, 6]];
Print["  dF_10/dalpha = ", N[fullDerivative /. alpha -> 3, 6]];
Print[""];

(* ============================================================================ *)
(* SECOND DERIVATIVE                                                          *)
(* ============================================================================ *)

Print["[4/4] Second derivative"];
Print[""];

Print["Second derivative of single term:"];
secondDeriv = D[term, {alpha, 2}];
Print["d^2T/dalpha^2 = ", secondDeriv];
Print[""];

simplifiedSecond = Simplify[secondDeriv];
Print["Simplified: ", simplifiedSecond];
Print[""];

Print["Factor out T(alpha):"];
factoredSecond = Simplify[secondDeriv / term];
Print["d^2T/dalpha^2 = T(alpha) * (", factoredSecond, ")"];
Print[""];

Print["Result: d^2T/dalpha^2 = Log^2[dist^2 + eps] * T(alpha)"];
Print[""];

(* Test pattern for higher derivatives *)
Print["Pattern for n-th derivative:"];
Print[""];

Do[
  Module[{nthDeriv, factored},
    nthDeriv = D[term, {alpha, order}];
    factored = Simplify[nthDeriv / term];
    Print["d^", order, "T/dalpha^", order, " = T(alpha) * (", factored, ")"];
  ],
  {order, 1, 4}
];
Print[""];

Print["Pattern: d^n T/dalpha^n = (-1)^n * Log^n[dist^2+eps] * T(alpha)"];
Print[""];

(* ============================================================================ *)
(* DOES IT SIMPLIFY?                                                          *)
(* ============================================================================ *)

Print["================================================================"];
Print["DOES DERIVATIVE SIMPLIFY THE FORMULA?"];
Print["================================================================"];
Print[""];

Print["NO - derivative makes it MORE complex:"];
Print[""];
Print["Original:  F_n = Sum Sum (dist^2 + eps)^(-alpha)"];
Print[""];
Print["Derivative: dF/dalpha = Sum Sum -Log(dist^2+eps) * (dist^2+eps)^(-alpha)"];
Print[""];
Print["Added complexity:"];
Print["  - Extra Log(...) factor in each term"];
Print["  - Still double infinite sum"];
Print["  - No closed form emerges"];
Print[""];

Print["Higher derivatives add more Log powers:"];
Print["  d^2F/dalpha^2 has Log^2(...)"];
Print["  d^3F/dalpha^3 has Log^3(...)"];
Print["  etc.");
Print[""];

(* ============================================================================ *)
(* CAN WE SUM SYMBOLICALLY?                                                   *)
(* ============================================================================ *)

Print["================================================================"];
Print["SYMBOLIC SUMMATION ATTEMPTS"];
Print["================================================================"];
Print[""];

Print["Can Wolfram find closed form for sums?"];
Print[""];

Print["Test 1: Simple power sum"];
Print["  Sum_k k^(-alpha), {k, 1, Infinity}"];
Print[""];

TimeConstrained[
  Module[{result},
    result = Sum[k^(-alpha), {k, 1, Infinity}, Assumptions -> alpha > 1];
    Print["  Result: ", result];
    Print["  (This is Riemann zeta function!)"];
  ],
  3,
  Print["  Timed out"]
];
Print[""];

Print["Test 2: Our inner sum structure"];
Print["  Sum_k [(C - k)^2 + eps]^(-alpha), {k, 0, K}"];
Print[""];

TimeConstrained[
  Module[{result},
    result = Sum[((C - k)^2 + eps)^(-alpha), {k, 0, K},
      Assumptions -> {C > 0, eps > 0, alpha > 0, K > 0}];
    Print["  Result: ", result];
  ],
  5,
  Print["  Timed out - no closed form"]
];
Print[""];

Print["Test 3: Derivative of simple power sum"];
Print["  d/dalpha Sum_k k^(-alpha) = d/dalpha zeta(alpha)"];
Print[""];

TimeConstrained[
  Module[{zetaDeriv},
    zetaDeriv = D[Zeta[alpha], alpha];
    Print["  Result: ", zetaDeriv];
    Print["  This is Zeta'(alpha) - a transcendental function"];
  ],
  3,
  Print["  Timed out"]
];
Print[""];

(* ============================================================================ *)
(* CONCLUSION                                                                 *)
(* ============================================================================ *)

Print["================================================================"];
Print["CONCLUSION"];
Print["================================================================"];
Print[""];

Print["SYMBOLIC DERIVATIVE STRUCTURE:"];
Print[""];
Print["1. Single term: dT/dalpha = -Log(dist^2+eps) * T(alpha)"];
Print["   - Clean pattern"];
Print["   - Higher derivatives: (-1)^n * Log^n(...) * T");
Print[""];

Print["2. Full sum: dF/dalpha = Sum Sum -Log(...) * (...)^(-alpha)"];
Print["   - STILL double infinite sum"];
Print["   - NO simplification"];
Print["   - NO closed form"];
Print[""];

Print["3. Connection to known functions:"];
Print["   - If terms were k^(-alpha), we'd get Zeta'(alpha)"];
Print["   - Our terms are more complex: ((n-kd-d^2)^2+eps)^(-alpha)"];
Print["   - No match to standard special functions"];
Print[""];

Print["ANSWER TO QUESTION: Does derivative simplify?"];
Print["  NO - it adds Log(...) factors, making it MORE complex"];
Print[""];

Print["HOWEVER: Derivative has useful PROPERTIES:"];
Print["  - Detects sensitivity to alpha"];
Print["  - Different behavior for primes vs composites"];
Print["  - Could be used as additional feature in classification"];
Print[""];

Print["The derivative is useful for ANALYSIS, not SIMPLIFICATION."];
Print[""];
