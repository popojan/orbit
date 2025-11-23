#!/usr/bin/env wolframscript

Print["CORRECTED 1/k ANALYSIS"];
Print[StringRepeat["=", 70]];
Print[];

Print[StringRepeat["=", 70]];
Print["KEY FINDING: ANALYTICAL CONTINUATION"];
Print[StringRepeat["=", 70]];
Print[];

Print["From trigonometric integrals:"];
Print["  AB(x) = (1/2)[A(x) - B(x)]"];
Print["  where A(x) = ∫₀^π sin(xθ) dθ"];
Print["        B(x) = ∫₀^π sin(xθ)cos(θ) dθ"];
Print[];

(* Compute closed form *)
A[x_] := Integrate[Sin[x*theta], {theta, 0, Pi}];
B[x_] := Integrate[Sin[x*theta]*Cos[theta], {theta, 0, Pi}];
AB[x_] := (A[x] - B[x])/2;

Print["Closed form:"];
abForm = AB[x] // FullSimplify;
Print["  AB(x) = ", abForm];
Print[];

Print["Simplifying numerator and denominator:"];
num = Numerator[abForm] // FullSimplify;
den = Denominator[abForm] // FullSimplify;
Print["  Numerator: ", num];
Print["  Denominator: ", den];
Print[];

Print[StringRepeat["=", 70]];
Print["POLES AND ZEROS"];
Print[StringRepeat["=", 70]];
Print[];

Print["Poles (where denominator = 0):"];
poles = Solve[den == 0, x];
Print["  ", poles];
Print["  → Poles at x = 0, ±1"];
Print[];

Print["Zeros (where numerator = 0):"];
Print["  -1 + cos(πx) - 2x²cos(πx) = 0"];
Print["  (1 - 2x²)cos(πx) = 1"];
Print[];

(* Find zeros numerically *)
zeros = Table[
  FindRoot[(1 - 2*x^2)*Cos[Pi*x] == 1, {x, start}][[1,2]],
  {start, {0.5, 1.5, 2.5, 3.5}}
];
Print["  Numerical zeros: ", zeros];
Print[];

Print[StringRepeat["=", 70]];
Print["CONNECTION TO ALTERNATING ZETA"];
Print[StringRepeat["=", 70]];
Print[];

Print["Dirichlet eta: η(s) = Σ_{n=1}^∞ (-1)^(n-1)/n^s"];
Print["For s=1: η(1) = ln(2) ≈ ", N[Log[2], 10]];
Print[];

Print["Our series structure:"];
Print["  Odd k:  AB[2m+1] = +1/(2m+1)"];
Print["  Even k: AB[2m] ≈ -1/(2m)"];
Print[];

Print["Total sum Σ AB[k] for k=1..N:"];
partialSums = Table[
  {n, N[Sum[AB[k], {k, 1, n}], 10]},
  {n, {10, 20, 50, 100}}
];
Do[Print["  N=", partialSums[[i,1]], ": ", partialSums[[i,2]]], 
   {i, 1, Length[partialSums]}];
Print[];

Print["Oscillates around 1/2 (odd N > 1/2, even N < 1/2)"];
Print[];

Print[StringRepeat["=", 70]];
Print["GENERATING FUNCTION"];
Print[StringRepeat["=", 70]];
Print[];

Print["G(z) = Σ_{k=1}^∞ AB[k] z^k"];
Print[];

(* Compute for various z *)
gVals = Table[
  {z, N[Sum[AB[k]*z^k, {k, 1, 100}], 10]},
  {z, {1/4, 1/3, 1/2, 2/3, 3/4}}
];

Print["z\tG(z)"];
Print[StringRepeat["-", 40]];
Do[Print[gVals[[i,1]], "\t", gVals[[i,2]]], {i, 1, Length[gVals]}];
Print[];

Print["Looking for closed form of G(z)..."];
Print[];

Print[StringRepeat["=", 70]];
Print["RESIDUE AT POLE x=1"];
Print[StringRepeat["=", 70]];
Print[];

Print["Near x=1, AB(x) has simple pole"];
Print["Computing residue:"];
Print[];

(* L'Hospital near x=1 *)
Print["lim_{x→1} (x-1)·AB(x) = ?"];
residue = Limit[(x-1)*AB[x], x -> 1] // FullSimplify;
Print["  Residue = ", residue];
Print[];

Print["This connects to integral representation!"];
Print[];

Print[StringRepeat["=", 70]];
Print["FOURIER/GIBBS PHENOMENON"];
Print[StringRepeat["=", 70]];
Print[];

Print["|sin(kθ)| has derivative discontinuities at θ = jπ/k"];
Print["Number of discontinuities in [0,π]: k"];
Print[];

Print["Gibbs phenomenon: Fourier coefficients decay as 1/k"];
Print["for functions with k discontinuities"];
Print[];

Print["Our AB[k] ~ 1/k behavior is EXACTLY this phenomenon!"];
Print[];

Print["DONE!"];
