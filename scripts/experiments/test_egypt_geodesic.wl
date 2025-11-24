#!/usr/bin/env wolframscript
(* Test: Is Egypt trajectory a geodesic on hyperbolic manifold? *)

Print["=== EGYPT TRAJECTORY: GEODESIC TEST ===\n"];

(* ============================================================ *)
Print["Setup: Egypt Approximations for √13\n"];
Print["====================================\n"];

n = 13;
sqrtN = Sqrt[n];

(* Egypt approximations *)
egyptApprox[k_] := Module[{sum},
  sum = Sum[2^(i-1) * x^i * Factorial[k+i] / (Factorial[k-i] * Factorial[2*i]),
            {i, 1, k}];
  1 + sum /. x -> 1
];

(* Compute first 10 approximations *)
rValues = Table[egyptApprox[k], {k, 1, 10}] // N;
Print["Egypt approximations r_k:"];
Do[
  Print["  k=", k, ": r_k = ", rValues[[k]], " (error: ", Abs[rValues[[k]] - sqrtN], ")"];
, {k, 1, 10}];
Print[];

(* ============================================================ *)
Print["Model 1: HYPERBOLOID MODEL (Minkowski Space)\n"];
Print["=============================================\n"];

Print["Hyperboloid: x² + y² - t² = -1 in Minkowski space ℝ^{2,1}\n"];
Print["Geodesics = intersections with 2D planes through origin\n"];
Print["        = straight lines in Minkowski space (on hyperboloid)\n"];
Print[];

(* Transform Poincaré to Hyperboloid *)
(* Poincaré disk: z = r*e^(iθ), |z| < 1 *)
(* Hyperboloid: (x,y,t) with x²+y²-t² = -1, t > 0 *)

(* For real points on x-axis in Poincaré (θ=0): *)
poincareToHyperboloid[r_] := Module[{x, y, t},
  (* Standard transformation *)
  t = (1 + r^2) / (1 - r^2);
  x = (2*r) / (1 - r^2);
  y = 0;  (* On x-axis in Poincaré → y=0 on hyperboloid *)
  {x, y, t}
];

(* Transform Egypt points *)
Print["Transforming Egypt points to hyperboloid:\n"];
hyperboloidPoints = Table[
  r = rValues[[k]];
  coords = poincareToHyperboloid[r];
  Print["  k=", k, ": r=", N[r, 4], " → (x,y,t) = ", N[coords, 4]];
  coords
, {k, 1, 10}];
Print[];

(* Check if points are collinear in Minkowski space *)
Print["Collinearity test in Minkowski space:\n"];
Print["Points are collinear iff (x_k, y_k, t_k) = λ_k · (a, b, c)\n"];
Print[];

(* Take first point as reference *)
{x1, y1, t1} = hyperboloidPoints[[1]];
Print["Reference point (k=1): (", N[x1,4], ", ", N[y1,4], ", ", N[t1,4], ")\n"];

(* Normalize to get direction *)
norm1 = Sqrt[x1^2 + y1^2 - t1^2];  (* Should be sqrt(-1) = i, but we check magnitude *)
direction = {x1, y1, t1};
Print["Direction vector: ", N[direction, 4], "\n"];
Print[];

(* Check if all points are proportional to this direction *)
Print["Checking proportionality:\n"];
ratios = Table[
  {xk, yk, tk} = hyperboloidPoints[[k]];

  (* Compute ratio λ_k = x_k / x_1 (should be same for all components if collinear) *)
  ratioX = xk / x1;
  ratioT = tk / t1;

  Print["  k=", k, ": λ_x=", N[ratioX, 6], ", λ_t=", N[ratioT, 6],
        ", diff=", N[Abs[ratioX - ratioT], 6]];

  {ratioX, ratioT, Abs[ratioX - ratioT]}
, {k, 2, 10}];
Print[];

(* Check if differences are small *)
maxDiff = Max[ratios[[All, 3]]];
Print["Maximum difference in ratios: ", N[maxDiff, 6], "\n"];

If[maxDiff < 0.001,
  Print["✓ COLLINEAR! Egypt trajectory IS a geodesic on hyperboloid!\n"];
  Print["  Points lie on straight line through origin in Minkowski space.\n"];
,
  Print["✗ NOT COLLINEAR. Egypt trajectory is NOT a geodesic.\n"];
  Print["  Deviation from collinearity: ", N[maxDiff, 6], "\n"];
];
Print[];

(* ============================================================ *)
Print["Model 2: UPPER HALF-PLANE MODEL\n"];
Print["================================\n"];

Print["Upper half-plane: {(x,y) : y > 0}\n"];
Print["Metric: ds² = (dx² + dy²)/y²\n"];
Print["Geodesics: semicircles centered on real axis + vertical lines\n"];
Print[];

(* Transform Poincaré to Upper Half-Plane via Cayley map *)
poincareToUHP[r_] := Module[{z, w, x, y},
  z = r;  (* Real point on x-axis in Poincaré *)
  w = I * (1 - z) / (1 + z);  (* Cayley transform *)
  x = Re[w];
  y = Im[w];
  {x, y}
];

Print["Transforming Egypt points to upper half-plane:\n"];
uhpPoints = Table[
  r = rValues[[k]];
  coords = poincareToUHP[r];
  Print["  k=", k, ": r=", N[r, 4], " → (x,y) = ", N[coords, 4]];
  coords
, {k, 1, 10}];
Print[];

(* Check if points lie on vertical line (x=const) or semicircle *)
xCoords = uhpPoints[[All, 1]];
yCoords = uhpPoints[[All, 2]];

Print["Checking if points lie on vertical line (x=const):\n"];
xVariation = StandardDeviation[xCoords];
Print["  Standard deviation of x: ", N[xVariation, 6], "\n"];

If[xVariation < 0.001,
  Print["✓ VERTICAL LINE! Egypt trajectory is geodesic (vertical line x=", N[Mean[xCoords], 4], ")\n"];
,
  Print["  Not a vertical line (x varies).\n"];
  Print["  Checking if points lie on semicircle...\n"];

  (* Fit circle: (x-a)² + (y-b)² = R² with b=0 (centered on real axis) *)
  (* For semicircle geodesic in UHP, center must be on real axis (b=0) *)

  (* Three points determine circle *)
  {x1, y1} = uhpPoints[[1]];
  {x2, y2} = uhpPoints[[2]];
  {x3, y3} = uhpPoints[[5]];  (* Take spaced points *)

  (* Solve for center (a, 0) and radius R *)
  eqs = {
    (x1 - a)^2 + y1^2 == R^2,
    (x2 - a)^2 + y2^2 == R^2,
    (x3 - a)^2 + y3^2 == R^2
  };

  sol = Solve[eqs, {a, R}];

  If[Length[sol] > 0,
    {aFit, RFit} = {a, R} /. sol[[1]];
    Print["  Circle center: (", N[aFit, 4], ", 0), radius: ", N[RFit, 4], "\n"];

    (* Check all points *)
    deviations = Table[
      {xk, yk} = uhpPoints[[k]];
      dist = Sqrt[(xk - aFit)^2 + yk^2];
      dev = Abs[dist - RFit];
      Print["    k=", k, ": distance to center=", N[dist, 4],
            ", radius=", N[RFit, 4], ", deviation=", N[dev, 6]];
      dev
    , {k, 1, 10}];

    maxDev = Max[deviations];
    Print["  Maximum deviation: ", N[maxDev, 6], "\n"];

    If[maxDev < 0.01,
      Print["✓ SEMICIRCLE! Egypt trajectory is geodesic (semicircle centered at x=", N[aFit, 4], ")\n"];
    ,
      Print["✗ NOT on semicircle. Deviation too large.\n"];
    ];
  ,
    Print["  Could not fit circle.\n"];
  ];
];
Print[];

(* ============================================================ *)
Print["Model 3: INTRINSIC GEODESIC EQUATION (Christoffel Symbols)\n"];
Print["===========================================================\n"];

Print["Testing geodesic equation directly in upper half-plane:\n"];
Print["d²x/ds² - (2/y) dx/ds dy/ds = 0\n"];
Print["d²y/ds² + (1/y)(dx/ds)² - (1/y)(dy/ds)² = 0\n"];
Print[];

(* Parametrize Egypt trajectory by k *)
(* x(k), y(k) from uhpPoints *)
(* Approximate derivatives using finite differences *)

Print["Computing derivatives (finite differences):\n"];
Do[
  If[k >= 2 && k <= 9,
    (* Central difference for first derivative *)
    {xPrev, yPrev} = uhpPoints[[k-1]];
    {xCurr, yCurr} = uhpPoints[[k]];
    {xNext, yNext} = uhpPoints[[k+1]];

    dxds = (xNext - xPrev) / 2;
    dyds = (yNext - yPrev) / 2;

    d2xds2 = xNext - 2*xCurr + xPrev;
    d2yds2 = yNext - 2*yCurr + yPrev;

    (* Geodesic equation residuals *)
    res1 = d2xds2 - (2/yCurr) * dxds * dyds;
    res2 = d2yds2 + (1/yCurr) * (dxds^2 - dyds^2);

    Print["  k=", k, ": res1=", N[res1, 4], ", res2=", N[res2, 4]];
  ];
, {k, 1, 10}];
Print[];

Print["Note: Large residuals → NOT geodesic\n"];
Print["      Small residuals → likely geodesic\n"];
Print[];

(* ============================================================ *)
Print["=== SUMMARY ===\n"];
Print["===============\n"];

Print["Tested Egypt trajectory for √13 using three approaches:\n"];
Print["1. Hyperboloid model: Collinearity in Minkowski space\n"];
Print["2. Upper half-plane: Vertical line or semicircle\n"];
Print["3. Intrinsic: Direct geodesic equation\n"];
Print[];

Print["Results will show if Egypt trajectory is a geodesic!\n"];
Print[];

Print["Key question: Does algebraic structure (factorial formula)\n"];
Print["           correspond to geometric structure (geodesic)?\n"];
