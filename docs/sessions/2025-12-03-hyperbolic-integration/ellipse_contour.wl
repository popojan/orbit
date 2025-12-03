(* Ellipse contour: center (1/2, 0), semi-axes a (x) and b (y) *)
(* n = center + a*cos(θ) + i*b*sin(θ) *)
(* = 1/2 + a*cos(θ) + i*b*sin(θ) *)

beta[n_] := (n - Cot[Pi/n])/(4n)
B[n_, k_] := 1 + beta[n] * Cos[(2k - 1) Pi/n]

Print["=== ELLIPSE CONTOUR ==="];
Print["Center: (1/2, 0)"];
Print["Semi-axis a (x-direction): smaller to avoid x=0"];
Print["Semi-axis b (y-direction): larger to enclose poles"];
Print[""];

(* Check which poles are inside ellipse *)
(* Pole at 1/m: distance from center = |1/m - 1/2| *)
(* For ellipse: inside if (x-1/2)^2/a^2 + y^2/b^2 < 1 *)
(* Poles are real, so y=0, need (1/m - 1/2)^2/a^2 < 1 *)
(* i.e., |1/m - 1/2| < a *)

Print["For real poles (y=0), inside ellipse if |1/m - 1/2| < a"];
Print[""];

(* a = 0.4: need |1/m - 1/2| < 0.4, i.e., 0.1 < 1/m < 0.9 *)
Print["a = 0.4: poles with 0.1 < 1/m < 0.9"];
Print["  m=2: 1/2, dist = 0 ✓"];
Print["  m=3: 1/3, dist = 1/6 ≈ 0.17 ✓"];
Print["  m=10: 1/10, dist = 0.4 ON BOUNDARY"];
Print[""];

ellipseContourIntegral[cx_, a_, b_, k_, s_] := Module[{n},
  NIntegrate[
    Module[{nVal = cx + a Cos[theta] + I b Sin[theta]},
      (nVal^(s-1) * B[nVal, k]) * (-a Sin[theta] + I b Cos[theta])
    ],
    {theta, 0, 2 Pi},
    MaxRecursion -> 20,
    PrecisionGoal -> 8
  ] / (2 Pi I)
]

Print["=== NUMERICAL TEST ==="];
Print[""];

(* Test with different ellipse parameters *)
s = 1; k = 1;
Print["s = ", s, ", k = ", k];
Print["Expected: -η(1)/(4π) = ", N[-Log[2]/(4 Pi)]];
Print[""];

(* a = minor axis (x), b = major axis (y) *)
params = {
  {0.49, 1},   (* almost touches n=0 *)
  {0.4, 1},    (* safe margin from n=0 *)
  {0.4, 2},    (* taller *)
  {0.3, 1},    (* more narrow *)
  {0.2, 0.5}   (* small ellipse *)
};

Do[
  {a, b} = param;
  result = ellipseContourIntegral[0.5, a, b, k, s] // Chop;
  Print["a = ", a, ", b = ", b, ": integral = ", N[result]],
  {param, params}
];

Print[""];
Print["=== LARGE ELLIPSE (enclose n=1) ==="];
Print[""];

(* To enclose n=1: need |1 - 1/2| = 1/2 < a *)
(* So a > 0.5 *)
params2 = {
  {0.51, 1},   (* just encloses n=1 *)
  {0.6, 1},    (* safely encloses n=1 *)
  {0.8, 1}     (* large *)
};

Do[
  {a, b} = param;
  result = ellipseContourIntegral[0.5, a, b, k, s] // Chop;
  Print["a = ", a, ", b = ", b, ": integral = ", N[result]],
  {param, params2}
];

Print[""];
Print["=== KEY: ELLIPSE AVOIDS CLUSTER POINT! ==="];
Print["Left edge of ellipse: 1/2 - a"];
Print["For a < 1/2, left edge > 0, so cluster point at n=0 is outside!"];
