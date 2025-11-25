#!/usr/bin/env wolframscript
(* Analyze coefficient structure of U_m(x+1) - U_{m-1}(x+1) *)

Print["=== ANALYZE DELTA-U COEFFICIENT STRUCTURE ===\n"];

Print["Part 1: Extract coefficients of U_m(x+1) - U_{m-1}(x+1)\n"];

deltaUCoeffs = Table[
  poly = ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1] // Expand;
  CoefficientList[poly, x]
, {m, 1, 6}];

Do[
  Print["m=", m, ": ", deltaUCoeffs[[m]]];
, {m, 1, 6}];

Print["\n"];

Print["Part 2: Look for recurrence in Delta-U coefficients\n"];

(* For each m, check if coefficients satisfy a recurrence *)
Do[
  coeffs = deltaUCoeffs[[mval]];
  Print["m=", mval, ":\n"];

  (* Check ratios *)
  If[Length[coeffs] >= 3,
    Do[
      If[coeffs[[i]] != 0 && coeffs[[i-1]] != 0,
        ratio = coeffs[[i]] / coeffs[[i-1]];
        Print["  c[", i-1, "]/c[", i-2, "] = ", ratio];
      ];
    , {i, 2, Min[Length[coeffs], 5]}];
  ];
  Print[];
, {mval, 2, 4}];

Print["Part 3: Product T_n(x+1) * Delta-U_m(x+1) coefficients\n"];

(* For k=1..6, compute product and analyze *)
Do[
  n = Ceiling[kval/2];
  m = Floor[kval/2];

  tn = ChebyshevT[n, x+1] // Expand;
  deltaU = ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1] // Expand;
  product = Expand[tn * deltaU];

  coeffs = CoefficientList[product, x];

  Print["k=", kval, " (n=", n, ", m=", m, "): ", coeffs];
, {kval, 1, 6}];

Print["\n"];

Print["Part 4: Check if Delta-U has closed form with factorials\n"];

(* Hypothesis: coefficients of U_m - U_{m-1} might have factorial pattern *)
Print["Looking at m=3 example:\n"];
m3coeffs = deltaUCoeffs[[3]];
Print["Coefficients: ", m3coeffs];
Print["  c[0] = ", m3coeffs[[1]], " = 1"];
Print["  c[1] = ", m3coeffs[[2]], " = 12 = 3*4 = m*(m+1)"];
Print["  c[2] = ", m3coeffs[[3]], " = 20 = ?"];
Print["  c[3] = ", m3coeffs[[4]], " = 8 = 2^3"];
Print[];

Print["Pattern check for c[1]:\n"];
Do[
  coeffs = deltaUCoeffs[[mval]];
  c1 = coeffs[[2]];
  expected = mval * (mval + 1);
  Print["  m=", mval, ": c[1] = ", c1, ", m(m+1) = ", expected, " ", If[c1 == expected, "â", "â"]];
, {mval, 1, 6}];

Print["\n"];

Print["Part 5: Generating function coefficients\n"];

(* Generating function: (1-t)/(1-2xt+t^2) *)
Print["G(x,t) = (1-t)/(1-2xt+t^2)\n"];

(* Extract coefficients symbolically *)
genFunc = (1-t)/(1-2*x*t+t^2);
ser = Series[genFunc, {t, 0, 6}];
Print["Series expansion:\n", ser];
Print[];

(* Compare with our Delta-U values *)
Print["Verification: [t^m] in G(x,t) should equal U_m(x) - U_{m-1}(x)\n"];
Do[
  coeff = SeriesCoefficient[genFunc, {t, 0, mval}] // Expand;
  actual = ChebyshevU[mval, x] - ChebyshevU[mval-1, x] // Expand;
  match = Simplify[coeff - actual] == 0;
  Print["m=", mval, ": ", If[match, "MATCH â", "DIFFER â"]];
  If[!match,
    Print["  Gen func: ", coeff];
    Print["  Actual:   ", actual];
  ];
, {mval, 0, 6}];

Print["\n"];

Print["Part 6: KEY INSIGHT CHECK\n"];
Print["User's intuition: factorial structure in mutual recurrence\n"];
Print["might help prove coefficient recurrence for our product.\n"];
Print[];
Print["Question: Does U_m(x+1) - U_{m-1}(x+1) have factorial form?\n"];

(* Try to find pattern *)
Print["Coefficient c[1] pattern: m(m+1) - looks like Pochhammer!\n"];
Print["  Pochhammer[m, 2] = m(m+1)\n"];
Print[];

Print["Let me check if ALL coefficients have Pochhammer structure...\n"];

(* For m=4, analyze each coefficient *)
m4 = 4;
coeffs4 = deltaUCoeffs[[m4]];
Print["m=", m4, " coefficients: ", coeffs4];
Print["  c[0] = ", coeffs4[[1]], " = 1"];
Print["  c[1] = ", coeffs4[[2]], " = 20 = 4*5 = Pochhammer[4,2]"];
Print["  c[2] = ", coeffs4[[3]], " = 60 = ?"];
Print["  c[3] = ", coeffs4[[4]], " = 56 = ?"];
Print["  c[4] = ", coeffs4[[5]], " = 16 = 2^4"];
Print[];

(* Check if c[i]/c[i-1] has pattern *)
Print["Ratios for m=4:\n"];
Do[
  If[i >= 2 && coeffs4[[i]] != 0 && coeffs4[[i-1]] != 0,
    ratio = coeffs4[[i+1]] / coeffs4[[i]];
    Print["  c[", i, "]/c[", i-1, "] = ", ratio];
  ];
, {i, 1, 4}];

Print["\n=== SUMMARY ===\n"];
Print["1. U_m(x+1) - U_{m-1}(x+1) has c[1] = m(m+1) = Pochhammer[m,2]"];
Print["2. Generating function: (1-t)/(1-2xt+t^2)"];
Print["3. Need to check if THIS helps with product T_n * Delta-U"];
Print[];
Print["Next: Can we use Delta-U structure + T_n structure to prove"];
Print["      coefficient recurrence algebraically?"];
