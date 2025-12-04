(* exact_relationship.wl *)
(* Verify the exact transformation between beta_geom and beta_res *)

Print["=== Exact Relationship Between beta_geom and beta_res ==="];
Print[""];

(* Definitions in terms of theta = Pi/n *)
betaGeomTheta[t_] := Pi^2 Cos[t]/(4 t^2 - Pi^2);
betaResTheta[t_] := 1/4 - t Cot[t]/(4 Pi);

(* The multiplier function *)
multiplier[t_] := t (Pi^2 - 4 t^2)/(4 Pi^3 Sin[t]);

Print["Definitions (theta = Pi/n):"];
Print["  beta_geom(theta) = Pi^2 cos(theta) / (4 theta^2 - Pi^2)"];
Print["  beta_res(theta) = 1/4 - theta cot(theta) / (4 Pi)"];
Print[""];

Print["=== THEOREM ==="];
Print[""];
Print["beta_res = 1/4 + beta_geom * m(theta)"];
Print[""];
Print["where m(theta) = theta (Pi^2 - 4 theta^2) / (4 Pi^3 sin(theta))"];
Print[""];

(* Verification *)
Print["=== Numerical Verification ==="];
Print[""];
Print["n\ttheta\t\tbeta_res (direct)\tbeta_res (formula)\tError"];
Print["--------------------------------------------------------------------------------"];

Do[
  t = Pi/nn;
  direct = betaResTheta[t] // N;
  formula = (1/4 + betaGeomTheta[t] * multiplier[t]) // N;
  err = Abs[direct - formula];
  Print[nn, "\t", t // N, "\t", direct, "\t", formula, "\t", err // ScientificForm],
  {nn, {3, 4, 5, 7, 10, 20, 50, 100}}
];

Print[""];

(* Symbolic verification *)
Print["=== Symbolic Verification ==="];
Print[""];
diff = FullSimplify[betaResTheta[t] - (1/4 + betaGeomTheta[t] * multiplier[t])];
Print["beta_res - (1/4 + beta_geom * m) = ", diff];
Print[""];

If[diff === 0,
  Print["VERIFIED: The relationship is EXACT."],
  Print["Simplified form: ", diff]
];
