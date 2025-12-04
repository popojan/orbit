(* polynomial_fit.wl *)
(* Approximate polynomial relationship beta_res = P(beta_geom) *)

Print["=== Polynomial Approximation: beta_res = P(beta_geom) ==="];
Print[""];

betaGeomTheta[t_] := Pi^2 Cos[t]/(4 t^2 - Pi^2);
betaResTheta[t_] := 1/4 - t Cot[t]/(4 Pi);

(* Generate data points for n >= 3 *)
(* theta = Pi/n, so theta in (0, Pi/3] for n >= 3 *)
data = Table[{betaGeomTheta[t], betaResTheta[t]} // N, {t, 0.1, Pi/3 + 0.1, 0.01}];

Print["Data range:"];
Print["  beta_geom in [", Min[data[[All, 1]]], ", ", Max[data[[All, 1]]], "]"];
Print["  beta_res in [", Min[data[[All, 2]]], ", ", Max[data[[All, 2]]], "]"];
Print[""];

(* Test polynomial fits of various degrees *)
Print["=== Polynomial Fit Quality ==="];
Print[""];
Print["Degree\tMax Error"];
Print["--------------------"];

Do[
  fit = Fit[data, Table[x^k, {k, 0, deg}], x];
  residuals = Table[Abs[p[[2]] - (fit /. x -> p[[1]])], {p, data}];
  maxErr = Max[residuals];
  Print[deg, "\t", maxErr // ScientificForm],
  {deg, 1, 6}
];

Print[""];

(* Best quartic fit *)
Print["=== Quartic Fit (recommended) ==="];
Print[""];
fit4 = Fit[data, {1, x, x^2, x^3, x^4}, x];
coeffs = CoefficientList[fit4, x];

Print["beta_res = a0 + a1*g + a2*g^2 + a3*g^3 + a4*g^4"];
Print[""];
Print["where g = beta_geom and:"];
Print["  a0 = ", coeffs[[1]]];
Print["  a1 = ", coeffs[[2]]];
Print["  a2 = ", coeffs[[3]]];
Print["  a3 = ", coeffs[[4]]];
Print["  a4 = ", coeffs[[5]]];
Print[""];

(* Verification *)
Print["=== Verification ==="];
Print[""];
Print["n\tbeta_geom\tbeta_res (exact)\tbeta_res (poly)\t\tError"];
Print["------------------------------------------------------------------------"];

Do[
  bg = betaGeomTheta[Pi/nn] // N;
  brExact = betaResTheta[Pi/nn] // N;
  brPoly = fit4 /. x -> bg;
  Print[nn, "\t", bg, "\t", brExact, "\t", brPoly, "\t", Abs[brExact - brPoly] // ScientificForm],
  {nn, {3, 5, 7, 10, 20, 50, 100}}
];

Print[""];
Print["Note: This approximation is valid for n >= 3 (beta_geom in [-1, -0.9])."];
Print["The exact relationship requires knowing theta = Pi/n."];
