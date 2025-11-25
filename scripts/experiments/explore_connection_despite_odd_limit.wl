#!/usr/bin/env wolframscript
(* Explore connection despite odd-only limitation *)

Print["=== EXPLORE CONNECTION (ODD LIMITATION) ===\n"];

(* User's subnref formula *)
a[k_, n_] := 1/4 (1 + 3 (-1)^k) (-1 + 2 n^2 + k) (-1)^n (2^(-3 + 2 k) (-3 + (-1)^k))/Gamma[2 k] Pochhammer[n - k + 2, 2 (k - 2) + 1];
subnref[x_, k_] := Sum[a[i, k] x^(2 i - 1), {i, 1, k + 1}];

Print["Known: subnref[x, k] = T_{2k+1}(x) - x*T_{2k}(x) (ONLY ODD U indices)\n"];
Print[];

Print["Part 1: Our product needs U_m(x+1) - U_{m-1}(x+1) for ANY m\n"];

(* For k=1..6, what m values do we get? *)
Do[
  m = Floor[kval/2];
  Print["k=", kval, ": m = ", m, " (", If[OddQ[m], "ODD", "EVEN"], ")"];
, {kval, 1, 8}];

Print["\nSo we need BOTH odd and even m values - subnref can't help directly.\n"];
Print[];

Print["Part 2: But maybe coefficient STRUCTURE still helps?\n"];

Print["Let me analyze coefficient structure in subnref...\n"];

(* Extract coefficients from subnref for k=2 *)
ktest = 2;
poly = subnref[x, ktest] // Expand;
Print["subnref[x, ", ktest, "] = ", poly];
Print["This equals T_5(x) - x*T_4(x) = -(1-x²)*U_3(x)\n"];

coeffs = CoefficientList[poly, x];
Print["Coefficients: ", coeffs];
Print["Non-zero at odd powers only (odd polynomial)\n"];
Print[];

(* Compute a[i, k] explicitly *)
Print["From formula a[i, k], compute for k=", ktest, ":\n"];
Do[
  val = a[i, ktest];
  Print["  a[", i, ", ", ktest, "] = ", val // N];
, {i, 1, ktest + 1}];

Print["\n"];

Print["Part 3: Check if ΔU = U_m - U_{m-1} has Pochhammer in SOME form\n"];

(* We found earlier that ΔU has c[1] = m(m+1) *)
Print["Earlier discovery: [U_m(x+1) - U_{m-1}(x+1)] has c[1] = m(m+1) = Pochhammer[m,2]\n"];

Do[
  deltaU = ChebyshevU[mval, x+1] - ChebyshevU[mval-1, x+1] // Expand;
  coeffs = CoefficientList[deltaU, x];
  c1 = coeffs[[2]];
  Print["  m=", mval, ": c[1] = ", c1, " = ", mval*(mval+1), " = Pochhammer[", mval, ",2]"];
, {mval, 1, 5}];

Print["\nThis works for ALL m (not just odd)!\n"];
Print[];

Print["Part 4: Direct attack on convolution ratio\n"];

Print["For k=4 (n=2, m=2), try to simplify convolution ratio directly:\n"];

k4 = 4;
n4 = 2;
m4 = 2;

tn4 = ChebyshevT[n4, x+1] // Expand;
deltaU4 = ChebyshevU[m4, x+1] - ChebyshevU[m4-1, x+1] // Expand;

tn4coeffs = CoefficientList[tn4, x];
deltaU4coeffs = CoefficientList[deltaU4, x];

Print["T_", n4, "(x+1) coeffs: ", tn4coeffs];
Print["ΔU_", m4, "(x+1) coeffs: ", deltaU4coeffs];
Print[];

(* Convolution for i=2 *)
i = 2;
c2_terms = Table[
  If[ell+1 <= Length[tn4coeffs] && i-ell+1 <= Length[deltaU4coeffs] && i-ell >= 0,
    {ell, tn4coeffs[[ell+1]], deltaU4coeffs[[i-ell+1]], tn4coeffs[[ell+1]] * deltaU4coeffs[[i-ell+1]]}
  ,
    Nothing
  ]
, {ell, 0, i}];

Print["c[", i, "] convolution terms (ℓ, T_n[ℓ], ΔU_m[i-ℓ], product):\n"];
Print[TableForm[c2_terms, TableHeadings -> {None, {"ℓ", "T_n", "ΔU_m", "prod"}}]];
c2_sum = Total[c2_terms[[All, 4]]];
Print["Sum = ", c2_sum];
Print[];

(* Convolution for i=1 *)
i = 1;
c1_terms = Table[
  If[ell+1 <= Length[tn4coeffs] && i-ell+1 <= Length[deltaU4coeffs] && i-ell >= 0,
    {ell, tn4coeffs[[ell+1]], deltaU4coeffs[[i-ell+1]], tn4coeffs[[ell+1]] * deltaU4coeffs[[i-ell+1]]}
  ,
    Nothing
  ]
, {ell, 0, i}];

Print["c[", i, "] convolution terms:\n"];
Print[TableForm[c1_terms, TableHeadings -> {None, {"ℓ", "T_n", "ΔU_m", "prod"}}]];
c1_sum = Total[c1_terms[[All, 4]]];
Print["Sum = ", c1_sum];
Print[];

ratio = c2_sum / c1_sum;
expected = 2*(k4+2)*(k4-2+1) / ((2*2)*(2*2-1));

Print["Ratio c[2]/c[1] = ", ratio, " = ", N[ratio]];
Print["Expected = ", expected, " = ", N[expected]];
Print["Match: ", ratio == expected];
Print[];

Print["=== KEY INSIGHT ===\n"];
Print["T_n coeffs: {", tn4coeffs[[1]], ", ", tn4coeffs[[2]], ", ", tn4coeffs[[3]], "}"];
Print["ΔU_m coeffs: {", deltaU4coeffs[[1]], ", ", deltaU4coeffs[[2]], ", ", deltaU4coeffs[[3]], "}"];
Print[];
Print["Convolution structure:\n"];
Print["  c[1] = ", tn4coeffs[[1]], "*", deltaU4coeffs[[2]], " + ", tn4coeffs[[2]], "*", deltaU4coeffs[[1]]];
Print["       = ", tn4coeffs[[1]]*deltaU4coeffs[[2]], " + ", tn4coeffs[[2]]*deltaU4coeffs[[1]],
      " = ", c1_sum];
Print["  c[2] = ", tn4coeffs[[1]], "*", deltaU4coeffs[[3]], " + ",
      tn4coeffs[[2]], "*", deltaU4coeffs[[2]], " + ",
      tn4coeffs[[3]], "*", deltaU4coeffs[[1]]];
Print["       = ", tn4coeffs[[1]]*deltaU4coeffs[[3]], " + ",
      tn4coeffs[[2]]*deltaU4coeffs[[2]], " + ",
      tn4coeffs[[3]]*deltaU4coeffs[[1]], " = ", c2_sum];
Print[];
Print["To prove ratio = 3, need to show:\n"];
Print["  (", tn4coeffs[[1]], "*", deltaU4coeffs[[3]], " + ",
      tn4coeffs[[2]], "*", deltaU4coeffs[[2]], " + ",
      tn4coeffs[[3]], "*", deltaU4coeffs[[1]], ") / (",
      tn4coeffs[[1]], "*", deltaU4coeffs[[2]], " + ",
      tn4coeffs[[2]], "*", deltaU4coeffs[[1]], ") = 3"];
Print[];
Print["Substituting values:\n"];
Print["  (1*4 + 4*6 + 2*1) / (1*6 + 4*1) = (4 + 24 + 2) / (6 + 4) = 30/10 = 3 ✓"];
Print[];
Print["This is BINOMIAL IDENTITY we need to prove for general k, i!"];
