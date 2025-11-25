#!/usr/bin/env wolframscript
(* Try to trace HOW Mathematica simplifies the ratio to expected value *)

Print["=== TRACE MATHEMATICA SIMPLIFICATION ===\n"];

(* For specific k, trace the simplification *)
k = 4;
i = 3;

Print["k=", k, ", i=", i, "\n"];

n = Ceiling[k/2];
m = Floor[k/2];

(* Compute product *)
tn = ChebyshevT[n, x+1];
deltaU = ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1];
product = Expand[tn * deltaU];

coeffs = CoefficientList[product, x];

ci = coeffs[[i+1]];
cim1 = coeffs[[i]];

Print["c[", i, "] = ", ci];
Print["c[", i-1, "] = ", cim1];
Print[];

ratio = ci / cim1;
Print["Ratio (unsimplified): ", ratio];
Print[];

expected = 2 * (k+i) * (k-i+1) / ((2*i)*(2*i-1));
Print["Expected: ", expected];
Print[];

(* Try different simplification functions *)
Print["FullSimplify: ", FullSimplify[ratio]];
Print["Simplify: ", Simplify[ratio]];
Print["Factor: ", Factor[ratio]];
Print["Expand: ", Expand[ratio]];
Print[];

(* Check if equal *)
diff = Simplify[ratio - expected];
Print["Difference after Simplify: ", diff];
Print[];

(* Try to trace FullSimplify steps *)
Print["Attempting to trace FullSimplify...\n"];

(* This will be very verbose, so limit output *)
TracePrint[FullSimplify[ratio - expected], _Simplify | _FullSimplify | _Together | _Apart,
  TraceInternal -> True] // Short[#, 5]&;

Print["\n=== ALTERNATIVE: Use symbolic k ===\n"];

(* Try with symbolic k for small specific case *)
ClearAll[k2, i2];
k2 = 4;  (* Keep numeric for now *)
i2 = 3;

n2 = Ceiling[k2/2];
m2 = Floor[k2/2];

Print["Computing coefficients algebraically...\n"];

(* Get coefficients as functions *)
prod2 = Expand[ChebyshevT[n2, x+1] * (ChebyshevU[m2, x+1] - ChebyshevU[m2-1, x+1])];
c2 = CoefficientList[prod2, x];

Print["Coefficients: ", c2];
Print[];

(* Look at structure *)
Print["c[3] = ", c2[[4]], " = ", FullSimplify[c2[[4]]]];
Print["c[2] = ", c2[[3]], " = ", FullSimplify[c2[[3]]]];
Print[];

(* Manual simplification *)
Print["Manual ratio: ", c2[[4]]/c2[[3]]];
Print["Expand ratio: ", Expand[c2[[4]]/c2[[3]]]];
Print["Together: ", Together[c2[[4]]/c2[[3]]]];
Print[];

Print["=== KEY QUESTION ==="];
Print["Can we express c[i]/c[i-1] in closed form using k, i, n, m?"];
Print[];
Print["From M&H product formulas (2.38-2.42), we have tools to"];
Print["manipulate products of Chebyshev polynomials."];
Print[];
Print["But converting coefficient ratio to closed form requires"];
Print["analyzing the CONVOLUTION structure...");
