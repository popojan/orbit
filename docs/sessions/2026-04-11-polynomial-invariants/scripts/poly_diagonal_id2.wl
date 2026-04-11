(* From n=3000 extrapolation *)
c4 = 0.48120993632411577809254610575697935002640836862294669664869215316563363309084`;
c5 = 0.49133960835799586353615703361884389271400601123798601518953414641936368826430`;

(* Brute force degree 4, coeffs <= 30 *)
Print["=== k=4: C_4 ~ ", c4, " ==="];
Print["--- Degree 3 ---"];
best3 = {Infinity, {}};
Do[
  val = a c4^3 + b c4^2 + cc c4 + dd;
  If[Abs[val] < Abs[best3[[1]]] && a != 0,
    best3 = {val, {a, b, cc, dd}}],
  {a, -30, 30}, {b, -30, 30}, {cc, -30, 30}, {dd, -30, 30}
];
Print["Best cubic: ", best3[[2]], " residual: ", best3[[1]]];

Print["--- Degree 4, coeffs <= 20 ---"];
best4 = {Infinity, {}};
Do[
  val = a c4^4 + b c4^3 + cc c4^2 + dd c4 + ee;
  If[Abs[val] < Abs[best4[[1]]] && a != 0,
    best4 = {val, {a, b, cc, dd, ee}}],
  {a, -20, 20}, {b, -20, 20}, {cc, -20, 20}, {dd, -20, 20}, {ee, -20, 20}
];
Print["Best quartic: ", best4[[2]], " residual: ", best4[[1]]];

Print[""];
Print["=== k=5: C_5 ~ ", c5, " ==="];
Print["--- Degree 4, coeffs <= 15 ---"];
best4b = {Infinity, {}};
Do[
  val = a c5^4 + b c5^3 + cc c5^2 + dd c5 + ee;
  If[Abs[val] < Abs[best4b[[1]]] && a != 0,
    best4b = {val, {a, b, cc, dd, ee}}],
  {a, -15, 15}, {b, -15, 15}, {cc, -15, 15}, {dd, -15, 15}, {ee, -15, 15}
];
Print["Best quartic: ", best4b[[2]], " residual: ", best4b[[1]]];

Print["--- Degree 5, coeffs <= 10 ---"];
best5 = {Infinity, {}};
Do[
  val = a c5^5 + b c5^4 + cc c5^3 + dd c5^2 + ee c5 + ff;
  If[Abs[val] < Abs[best5[[1]]] && a != 0,
    best5 = {val, {a, b, cc, dd, ee, ff}}],
  {a, -10, 10}, {b, -10, 10}, {cc, -10, 10}, {dd, -10, 10}, {ee, -10, 10}, {ff, -10, 10}
];
Print["Best quintic: ", best5[[2]], " residual: ", best5[[1]]];

(* Summary *)
Print[""];
Print["=== Summary of minimal polynomials ==="];
Print["k=2: x^2 - 3x + 1 = 0  (coeffs: 1,-3,1)"];
Print["k=3: x^3 - 4x^2 + 6x - 2 = 0  (coeffs: 1,-4,6,-2)"];
Print["k=4: ", best4[[2]]];
Print["k=5: quartic ", best4b[[2]], " or quintic ", best5[[2]]];
