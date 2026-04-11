<< Orbit`

alpha = Sqrt[2];

(* Extract polynomial at convergent level k, expressed in actual position n *)
levelPoly[alpha_, k_] := Module[{cv, a, b, height, maxPos, prevPos, row, data, pts},
  cv = Convergents[alpha, k];
  {a, b} = Take[cv, -2];
  height = Denominator[a];
  maxPos = Numerator[b];
  prevPos = Numerator[a];
  row = BeattyBallotCount[alpha, All, {maxPos, height}];
  data = Drop[row, prevPos - 1];
  pts = Table[{nn, data[[nn - prevPos + 1]]}, {nn, prevPos, maxPos}];
  {height, prevPos, maxPos, InterpolatingPolynomial[pts, n] // Expand}
]

Print["=== Polynomial coefficients at each convergent level, Sqrt[2] ==="];
Print[""];

polys = {};
Do[
  {height, pPrev, pNext, poly} = levelPoly[alpha, k];
  factored = Factor[poly];

  (* Extract j! * poly to get integer-coefficient version *)
  intPoly = Expand[height! * poly];

  (* Factor: should be (n - root) * Q(n) *)
  (* The integer root is at Ceiling[height * alpha] - 1 *)
  intRoot = Ceiling[height * alpha] - 1;

  (* Verify it's a root *)
  rootCheck = (intPoly /. n -> intRoot) === 0;

  (* Divide out the root *)
  quotient = PolynomialQuotient[intPoly, n - intRoot, n];
  remainder = PolynomialRemainder[intPoly, n - intRoot, n];

  Print["k=", k, ": deg=", height,
    " window=[", pPrev, ",", pNext, "]"];
  Print["  j! * poly = (n - ", intRoot, ") * Q(n)  [root check: ", rootCheck,
    ", remainder: ", remainder, "]"];
  Print["  Q(n) coefficients (low to high): ",
    Table[Coefficient[quotient, n, i], {i, 0, height - 1}]];
  Print[""];

  AppendTo[polys, {k, height, intRoot, quotient}];,
  {k, 3, 8}
];

(* Now check: is the polynomial universal or window-dependent? *)
(* Compare height=2 polynomial from different windows *)
Print["=== Universality test: same height, different windows ==="];
Print[""];

Do[
  cv = Convergents[alpha, k];
  {a, b} = Take[cv, -2];
  maxPos = Numerator[b];
  prevPos = Numerator[a];

  (* Always compute at height 2 *)
  row = BeattyBallotCount[alpha, All, {maxPos, 2}];
  data = row[[prevPos ;; maxPos]];
  pts = Table[{nn, row[[nn]]}, {nn, prevPos, maxPos}];
  poly = InterpolatingPolynomial[pts, n] // Expand;
  Print["height=2, window=[", prevPos, ",", maxPos, "]: ",
    Factor[poly]];,
  {k, 3, 7}
];

Print[""];

(* Same for height=5 *)
Do[
  cv = Convergents[alpha, k];
  {a, b} = Take[cv, -2];
  maxPos = Numerator[b];
  prevPos = Numerator[a];
  If[maxPos < 20, Continue[]];

  row = BeattyBallotCount[alpha, All, {maxPos, 5}];
  data = row[[prevPos ;; maxPos]];
  pts = Table[{nn, row[[nn]]}, {nn, prevPos, maxPos}];
  poly = InterpolatingPolynomial[pts, n] // Expand;
  Print["height=5, window=[", prevPos, ",", maxPos, "]: ",
    Factor[poly]];,
  {k, 4, 8}
];

Print[""];
Print["=== Coefficient ratios / structure ==="];
Print[""];

(* Look at ratios between consecutive coefficients of Q(n) *)
Do[
  {k, height, intRoot, quotient} = polys[[i]];
  coeffs = Table[Coefficient[quotient, n, j], {j, 0, height - 1}];
  Print["k=", k, " (deg ", height, "):"];
  Print["  coeffs: ", coeffs];
  If[Length[coeffs] > 1,
    ratios = Table[coeffs[[j + 1]]/coeffs[[j]], {j, 1, Length[coeffs] - 1}];
    Print["  ratios c_{i+1}/c_i: ", N[ratios, 5]];
  ];
  Print[""];,
  {i, 1, Length[polys]}
];
