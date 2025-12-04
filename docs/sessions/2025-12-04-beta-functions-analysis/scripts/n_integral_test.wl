(* n_integral_test.wl *)
(* Verify that n-integral (via residues) gives eta(s) ONLY for beta_res *)

Print["=== n-Integral Test: Contour Integral -> eta(s) ==="];
Print[""];

(* Two beta definitions *)
betaGeom[n_] := n^2 Cos[Pi/n]/(4 - n^2);
betaRes[n_] := (n - Cot[Pi/n])/(4 n);

(* B functions *)
BGeom[n_, k_] := 1 + betaGeom[n] Cos[(2 k - 1) Pi/n];
BRes[n_, k_] := 1 + betaRes[n] Cos[(2 k - 1) Pi/n];

Print["=== Pole Structure ==="];
Print[""];
Print["beta_geom(n) = n^2 * cos(pi/n) / (4 - n^2)"];
Print["  Poles: n = +/- 2"];
Print["  At n = 2: numerator has cos(pi/2) = 0, so REMOVABLE singularity"];
Print[""];
Print["beta_res(n) = (n - cot(pi/n)) / (4n)"];
Print["  Poles: n = 1/k for all integers k != 0"];
Print["  cot(pi/n) diverges when pi/n = k*pi, i.e., n = 1/k"];
Print[""];

(* Test residues for B_geom at n = 2 *)
Print["=== Residues for B_geom ==="];
Print[""];
s = 2; k = 1;

resGeomAt2 = Residue[n^(s - 1) BGeom[n, k], {n, 2}];
resGeomAtMinus2 = Residue[n^(s - 1) BGeom[n, k], {n, -2}];

Print["s = ", s, ", k = ", k];
Print["Res[n^(s-1) * B_geom, n = 2] = ", resGeomAt2 // N];
Print["Res[n^(s-1) * B_geom, n = -2] = ", resGeomAtMinus2 // N];
Print[""];
Print["B_geom has NO useful residues for eta(s)!"];
Print[""];

(* Test residues for B_res at n = 1/m *)
Print["=== Residues for B_res ==="];
Print[""];
Print["s = ", s, ", k = ", k];
Print[""];
Print["m\tRes[n^(s-1) * B_res, n = 1/m]\tExpected (-1)^m / (4*pi*m^s)"];
Print["------------------------------------------------------------------------"];

sumRes = 0;
Do[
  res = Residue[n^(s - 1) BRes[n, k], {n, 1/m}];
  expected = (-1)^m / (4 Pi m^s);
  sumRes += res;
  If[m <= 6,
    Print[m, "\t", res // N, "\t\t\t", expected // N]
  ],
  {m, 1, 100}
];

Print["..."];
Print[""];
Print["Sum of residues (m = 1 to 100): ", sumRes // N];
Print["-eta(", s, ") / (4*pi) = ", N[-DirichletEta[s]/(4 Pi)]];
Print[""];

(* Test for s = 1 *)
Print["=== Test for s = 1 ==="];
s = 1;
sumRes1 = Sum[Residue[n^(s - 1) BRes[n, 1], {n, 1/m}], {m, 1, 100}];
Print["Sum of residues (s=1): ", sumRes1 // N];
Print["-eta(1) / (4*pi) = -log(2) / (4*pi) = ", N[-Log[2]/(4 Pi)]];
Print[""];

Print["=== Conclusion ==="];
Print[""];
Print["beta_geom: Poles at n = +/-2 are removable, NO eta(s) connection"];
Print["beta_res:  Poles at n = 1/k give alternating series -> eta(s)"];
Print[""];
Print["The n-integral (contour) giving eta(s) works ONLY for beta_res!"];
