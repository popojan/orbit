(* residue_analysis.wl *)
(* Detailed analysis of residue structure for both beta functions *)

Print["=== Detailed Residue Analysis ==="];
Print[""];

(* Definitions *)
betaGeom[n_] := n^2 Cos[Pi/n]/(4 - n^2);
betaRes[n_] := (n - Cot[Pi/n])/(4 n);

Print["=== Part 1: beta_geom Pole Analysis ==="];
Print[""];
Print["beta_geom(n) = n^2 * cos(pi/n) / (4 - n^2)"];
Print[""];
Print["Denominator: 4 - n^2 = 0 when n = +/- 2"];
Print[""];

(* Check if n=2 is a true pole or removable *)
Print["At n = 2:"];
Print["  Numerator: n^2 * cos(pi/n) = 4 * cos(pi/2) = 4 * 0 = 0"];
Print["  Denominator: 4 - 4 = 0"];
Print["  Form: 0/0 -> removable singularity"];
Print[""];
Print["L'Hopital limit:"];
limitAt2 = Limit[betaGeom[n], n -> 2];
Print["  lim_{n->2} beta_geom(n) = ", limitAt2, " = ", N[limitAt2]];
Print[""];

(* Residue at n=2 for beta_geom *)
resBetaGeomAt2 = Residue[betaGeom[n], {n, 2}];
Print["Residue[beta_geom, n=2] = ", resBetaGeomAt2];
Print["(Zero because the singularity is removable)"];
Print[""];

Print["=== Part 2: beta_res Pole Analysis ==="];
Print[""];
Print["beta_res(n) = (n - cot(pi/n)) / (4n)"];
Print[""];
Print["cot(pi/n) = cos(pi/n) / sin(pi/n)"];
Print["Diverges when sin(pi/n) = 0, i.e., pi/n = k*pi for integer k"];
Print["This means n = 1/k for k in Z \\ {0}"];
Print[""];

(* Derive residue formula *)
Print["=== Residue Derivation for beta_res ==="];
Print[""];
Print["Near n = 1/k, let n = 1/k + epsilon"];
Print["  pi/n = pi/(1/k + epsilon) = k*pi / (1 + k*epsilon)"];
Print["       = k*pi * (1 - k*epsilon + ...) = k*pi - k^2*pi*epsilon + ..."];
Print[""];
Print["  cot(k*pi - k^2*pi*epsilon) = cot(k*pi) * cos(...) - ..."];
Print["  Since cot has period pi: cot(k*pi - x) = -cot(x) for small x"];
Print["  cot(-k^2*pi*epsilon) = -1/(k^2*pi*epsilon) for small epsilon"];
Print[""];
Print["  So: cot(pi/n) ~ -1/(k^2*pi*epsilon) near n = 1/k"];
Print[""];
Print["  beta_res ~ (1/k - (-1/(k^2*pi*epsilon))) / (4/k)"];
Print["           ~ (1/k + 1/(k^2*pi*epsilon)) * k/4"];
Print["           ~ 1/(4k) + 1/(4*pi*k*epsilon)"];
Print[""];
Print["  Residue = coefficient of 1/epsilon = 1/(4*pi*k)"];
Print[""];

(* Verify numerically *)
Print["=== Numerical Verification of Residues ==="];
Print[""];
Print["k\tRes[beta_res, n=1/k]\tExpected 1/(4*pi*k)"];
Print["--------------------------------------------------------"];

Do[
  res = Residue[betaRes[n], {n, 1/k}] // FullSimplify;
  expected = 1/(4 Pi k);
  Print[k, "\t", res // N, "\t\t", expected // N],
  {k, 1, 6}
];

Print[""];
Print["=== Part 3: Full B(n,k) Residues ==="];
Print[""];
Print["B_res(n,k) = 1 + beta_res(n) * cos((2k-1)*pi/n)"];
Print[""];
Print["At n = 1/m, the cos factor evaluates to:"];
Print["  cos((2k-1)*pi/(1/m)) = cos((2k-1)*m*pi)"];
Print["  For integer k: cos((2k-1)*m*pi) = cos(m*pi) = (-1)^m"];
Print[""];
Print["So: Res[B_res, n=1/m] = Res[beta_res, n=1/m] * (-1)^m"];
Print["                      = 1/(4*pi*m) * (-1)^m"];
Print["                      = (-1)^m / (4*pi*m)"];
Print[""];

(* Verify *)
Print["=== Verification for k=1 ==="];
Print[""];
BRes[n_, k_] := 1 + betaRes[n] Cos[(2 k - 1) Pi/n];

Print["m\tRes[B_res(n,1), n=1/m]\tExpected (-1)^m/(4*pi*m)"];
Print["--------------------------------------------------------------"];

Do[
  res = Residue[BRes[n, 1], {n, 1/m}] // FullSimplify;
  expected = (-1)^m / (4 Pi m);
  Print[m, "\t", res // N, "\t\t", expected // N],
  {m, 1, 6}
];

Print[""];
Print["=== Sum -> eta(s) ==="];
Print[""];
Print["Sum_{m=1}^infty (-1)^m / (4*pi*m) = (1/4*pi) * Sum (-1)^m / m"];
Print["                                  = (1/4*pi) * (-log(2))"];
Print["                                  = -eta(1) / (4*pi)"];
Print[""];
Print["More generally:"];
Print["Sum_{m=1}^infty Res[n^{s-1} B_res, n=1/m]"];
Print["  = Sum (-1)^m * (1/m)^{s-1} / (4*pi*m)"];
Print["  = Sum (-1)^m / (4*pi*m^s)"];
Print["  = -eta(s) / (4*pi)"];
