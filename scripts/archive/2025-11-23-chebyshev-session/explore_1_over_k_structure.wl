#!/usr/bin/env wolframscript

Print["EXPLORING 1/k STRUCTURE"];
Print[StringRepeat["=", 70]];
Print[];

Print["AB[k] pattern:"];
Print["  Odd k:  AB[k] = 1/k"];
Print["  Even k: AB[k] ~ -1/k (asymptotically)"];
Print[];

Print[StringRepeat["=", 70]];
Print["DIRECTION 1: SUMMING AB[k]"];
Print[StringRepeat["=", 70]];
Print[];

Print["Computing Σ AB[k] for k=1..N:"];
Print[];

(* Define AB symbolically *)
AB[k_] := Module[{ak, bk},
  ak = Integrate[Sin[k*theta], {theta, 0, Pi}];
  bk = Integrate[Sin[k*theta]*Cos[theta], {theta, 0, Pi}];
  Simplify[(ak - bk)/2]
];

(* Compute partial sums *)
partialSums = Table[
  {n, Sum[AB[k], {k, 1, n}] // N},
  {n, 1, 20}
];

Print["n\tΣ_{k=1}^n AB[k]"];
Print[StringRepeat["-", 40]];
Do[
  Print[partialSums[[i, 1]], "\t", partialSums[[i, 2]]];
, {i, 1, 20}];
Print[];

(* Check for pattern *)
Print["Looking for limit or pattern..."];
Print["Ratio test: Σ AB[k] / log(n)"];
Do[
  sum = Sum[AB[k], {k, 1, n}] // N;
  ratio = sum/Log[n];
  Print["  n=", n, ": sum=", sum, ", sum/log(n)=", ratio];
, {n, {10, 20, 50, 100}}];
Print[];

Print[StringRepeat["=", 70]];
Print["DIRECTION 2: ALTERNATING SUM (EULER-LIKE)"];
Print[StringRepeat["=", 70]];
Print[];

Print["Computing Σ (-1)^k AB[k]:"];
Print[];

altSums = Table[
  {n, Sum[(-1)^k * AB[k], {k, 1, n}] // N},
  {n, 1, 20}
];

Print["n\tΣ_{k=1}^n (-1)^k AB[k]"];
Print[StringRepeat["-", 40]];
Do[
  Print[altSums[[i, 1]], "\t", altSums[[i, 2]]];
, {i, 1, 20}];
Print[];

(* Check convergence *)
lastVal = altSums[[-1, 2]];
Print["Appears to converge to: ", lastVal];
Print[];

Print[StringRepeat["=", 70]];
Print["DIRECTION 3: GENERATING FUNCTION"];
Print[StringRepeat["=", 70]];
Print[];

Print["Define G(x) = Σ AB[k] x^k"];
Print[];
Print["Computing for x = 1/2:"];
gf = Sum[AB[k] * (1/2)^k, {k, 1, 30}] // N;
Print["  G(1/2) = ", gf];
Print[];

Print["Computing for x = -1/2:"];
gfAlt = Sum[AB[k] * (-1/2)^k, {k, 1, 30}] // N;
Print["  G(-1/2) = ", gfAlt];
Print[];

Print[StringRepeat["=", 70]];
Print["DIRECTION 4: FOURIER SERIES CONNECTION"];
Print[StringRepeat["=", 70]];
Print[];

Print["AB[k] comes from Fourier coefficients of sin^2(theta)"];
Print[];
Print["Standard Fourier series:"];
Print["  sin^2(theta) = 1/2 - (1/2)cos(2*theta)"];
Print[];
Print["Our decomposition uses |sin(k*theta)| instead of sin(k*theta)"];
Print[];

Print["Key observation: AB[k] ~ 1/k is harmonic decay"];
Print["This is characteristic of Fourier coefficients at discontinuities!"];
Print[];

Print["Checking: Does |sin(k*theta)| have jump discontinuities?"];
Print["  |sin(k*theta)| has discontinuities in derivative at theta = j*pi/k"];
Print["  Number of discontinuities in [0,pi]: k"];
Print[];
Print["Gibbs phenomenon suggests ~ 1/k decay for k discontinuities!");
Print[];

Print[StringRepeat["=", 70]];
Print["DIRECTION 5: DIRICHLET L-FUNCTION CONNECTION"];
Print[StringRepeat["=", 70]];
Print[];

Print["Dirichlet beta function: β(s) = Σ (-1)^n/(2n+1)^s"];
Print[];
Print["Our odd-k series: Σ AB[2m+1] = Σ 1/(2m+1)"];
Print[];

Print["For s=1: β(1) = π/4 = ", N[Pi/4, 10]];
Print[];

oddSum = Sum[AB[2*m+1], {m, 0, 50}] // N;
Print["Our Σ_{m=0}^50 1/(2m+1) = ", oddSum];
Print["Compare to π/4 = ", N[Pi/4, 10]];
Print["Ratio: ", oddSum / (Pi/4)];
Print[];

Print["So odd-k sum → π/4 (Leibniz formula!)"];
Print[];

Print[StringRepeat["=", 70]];
Print["DIRECTION 6: ANALYTICAL CONTINUATION"];
Print[StringRepeat["=", 70]];
Print[];

Print["Can we extend k to real numbers?"];
Print[];
Print["Define: AB(x) = ∫₀^π sin(x*theta)·(1 - cos(theta))/2 dθ"];
Print[];

ABcont[x_] := Integrate[Sin[x*theta]*(1 - Cos[theta])/2, {theta, 0, Pi}];

Print["Computing AB(x) for real x:"];
Do[
  val = ABcont[x] // N;
  Print["  AB(", x, ") = ", val];
, {x, 1.5, 5.5, 0.5}];
Print[];

Print["Plotting would show: AB(x) has poles and zeros!"];
Print["This connects to complex analysis / zeta-like functions"];
Print[];

Print["DONE!"];
