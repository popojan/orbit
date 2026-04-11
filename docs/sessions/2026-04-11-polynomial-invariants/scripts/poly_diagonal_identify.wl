(* We have C_3 ≈ 0.456310987307923638429144028211748 (31 digits) *)
(* Try to identify as root of polynomial with small coefficients *)

(* From n=3000 extrapolation *)
c3 = 0.45631098730792363842914402821174811679816600038489321873369119981308322452317256452125378282172`;

(* Brute force: find a,b,c,d with |coeffs| <= 50 such that *)
(* a*c3^deg + ... + constant ≈ 0 *)

Print["=== Brute force minimal polynomial search ==="];
Print["C_3 ≈ ", c3];
Print[""];

(* Degree 2: ax^2 + bx + c = 0, |a|,|b|,|c| <= 100 *)
Print["--- Degree 2 ---"];
best2 = {Infinity, {}};
Do[
  val = a c3^2 + b c3 + c;
  If[Abs[val] < Abs[best2[[1]]] && {a, b, c} =!= {0, 0, 0},
    best2 = {val, {a, b, c}}],
  {a, -50, 50}, {b, -50, 50}, {c, -50, 50}
];
Print["Best: ", best2[[2]], " residual: ", best2[[1]]];

(* Degree 3: ax^3 + bx^2 + cx + d = 0 *)
Print["--- Degree 3, coeffs <= 30 ---"];
best3 = {Infinity, {}};
Do[
  val = a c3^3 + b c3^2 + c c3 + d;
  If[Abs[val] < Abs[best3[[1]]] && a != 0,
    best3 = {val, {a, b, c, d}}],
  {a, -30, 30}, {b, -30, 30}, {c, -30, 30}, {d, -30, 30}
];
Print["Best: ", best3[[2]], " residual: ", best3[[1]]];

(* Also try 1/C_3 ≈ 2.19146 *)
d3 = 1/c3;
Print[""];
Print["1/C_3 ≈ ", d3];

Print["--- Degree 2 for 1/C_3 ---"];
best2d = {Infinity, {}};
Do[
  val = a d3^2 + b d3 + c;
  If[Abs[val] < Abs[best2d[[1]]] && {a, b, c} =!= {0, 0, 0},
    best2d = {val, {a, b, c}}],
  {a, -50, 50}, {b, -50, 50}, {c, -50, 50}
];
Print["Best: ", best2d[[2]], " residual: ", best2d[[1]]];

Print["--- Degree 3 for 1/C_3, coeffs <= 30 ---"];
best3d = {Infinity, {}};
Do[
  val = a d3^3 + b d3^2 + c d3 + d;
  If[Abs[val] < Abs[best3d[[1]]] && a != 0,
    best3d = {val, {a, b, c, d}}],
  {a, -30, 30}, {b, -30, 30}, {c, -30, 30}, {d, -30, 30}
];
Print["Best: ", best3d[[2]], " residual: ", best3d[[1]]];

(* Same for k=4, k=5 *)
Print[""];
c4 = 0.48120993632411577809254610575697935002640836862294669664869215316563363309084`;
c5 = 0.49133960835799586353615703361884389271400601123798601518953414641936368826430`;

Do[
  {ck, name} = entry;
  dk = 1/ck;
  Print["=== ", name, " ==="];
  Print["C ≈ ", ck, "  1/C ≈ ", dk];

  best = {Infinity, {}};
  Do[
    val = a dk^3 + b dk^2 + c dk + d;
    If[Abs[val] < Abs[best[[1]]] && a != 0,
      best = {val, {a, b, c, d}}],
    {a, -30, 30}, {b, -30, 30}, {c, -30, 30}, {d, -30, 30}
  ];
  Print["  Best cubic for 1/C: ", best[[2]], " residual: ", best[[1]]];
  Print[""];,
  {{c4, "k=4"}, {c5, "k=5"}}
];
