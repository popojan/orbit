(* compare_betas.wl *)
(* Numerical comparison of β_geom and β_res *)

Print["=== Comparison of Two Beta Functions ==="];
Print[""];

(* Definitions *)
betaGeom[n_] := n^2 Cos[Pi/n]/(4 - n^2);
betaRes[n_] := (n - Cot[Pi/n])/(4 n);

(* Table of values *)
Print["n\t\tbeta_geom\tbeta_res\tRatio"];
Print["--------------------------------------------------------"];

Do[
  bg = N[betaGeom[n], 6];
  br = N[betaRes[n], 6];
  ratio = N[bg/br, 4];
  Print[n, "\t\t", bg, "\t", br, "\t", ratio],
  {n, {3, 5, 7, 10, 20, 50, 100, 1000}}
];

Print[""];
Print["=== Limits as n -> infinity ==="];
Print[""];
Print["beta_geom(infinity) = ", Limit[betaGeom[n], n -> Infinity]];
Print["beta_res(infinity) = ", Limit[betaRes[n], n -> Infinity] // FullSimplify];
Print[""];
Print["Numerical values:"];
Print["beta_geom(infinity) = ", N[Limit[betaGeom[n], n -> Infinity]]];
Print["beta_res(infinity) = ", N[Limit[betaRes[n], n -> Infinity]]];

Print[""];
Print["=== Ratio limit ==="];
Print[""];
ratioLimit = Limit[betaGeom[n]/betaRes[n], n -> Infinity] // FullSimplify;
Print["beta_geom/beta_res -> ", ratioLimit, " = ", N[ratioLimit]];

Print[""];
Print["=== Values at n = 2 ==="];
Print[""];
Print["beta_geom(2) = ", Limit[betaGeom[n], n -> 2], " (L'Hopital limit)"];
Print["beta_res(2) = ", betaRes[2] // FullSimplify];

Print[""];
Print["=== Pole structure ==="];
Print[""];
Print["beta_geom poles: n = +/- 2 (from denominator 4 - n^2)"];
Print["beta_res poles: n = 1/k for k in Z \\ {0} (from cot(pi/n))"];
