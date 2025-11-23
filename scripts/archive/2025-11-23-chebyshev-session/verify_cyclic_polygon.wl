#!/usr/bin/env wolframscript

Print["CYCLIC POLYGON STRUCTURE"];
Print[StringRepeat["=", 70]];
Print[];

Print["Idea: Roots of f(x,k) correspond to polygon vertices"];
Print["when lifted to unit circle with alternating signs"];
Print[];

Print[StringRepeat["=", 70]];
Print["FINDING INTERIOR ROOTS (excluding ±1)"];
Print[StringRepeat["=", 70]];
Print[];

Do[
  Module[{fk, roots, interiorRoots},
    fk = ChebyshevT[k + 1, x] - x*ChebyshevT[k, x];
    roots = Solve[fk == 0 && -1 < x < 1, x, Reals];
    interiorRoots = Sort[x /. roots, Less];

    Print["k=", k, ": ", Length[interiorRoots], " interior roots"];
    Print["  x-values: ", N[interiorRoots, 8]];
    Print[];
  ];
, {k, 2, 6}];

Print[StringRepeat["=", 70]];
Print["LIFTING TO UNIT CIRCLE WITH ALTERNATING SIGNS"];
Print[StringRepeat["=", 70]];
Print[];

Do[
  Module[{fk, roots, interiorRoots, points},
    fk = ChebyshevT[k + 1, x] - x*ChebyshevT[k, x];
    roots = Solve[fk == 0 && -1 < x < 1, x, Reals];
    interiorRoots = Sort[x /. roots, Less];

    Print["k=", k, " polygon construction:"];
    Print[];

    (* Lift to circle with alternating y = ±sqrt(1-x^2) *)
    points = Table[
      Module[{xval, yval},
        xval = interiorRoots[[i]];
        (* Alternate sign *)
        yval = If[Mod[i, 2] == 1, 1, -1] * Sqrt[1 - xval^2];
        {xval, yval}
      ],
      {i, 1, Length[interiorRoots]}
    ];

    (* Add boundary points *)
    pointsWithBoundary = Join[{{1, 0}}, points, {{-1, 0}}];

    Print["  Points (with ±1):"];
    Do[
      Print["    ", N[pointsWithBoundary[[i]], 6]];
    , {i, 1, Length[pointsWithBoundary]}];
    Print[];

    (* Check if regular polygon *)
    Print["  Checking regularity:"];
    angles = Table[
      ArcTan[pointsWithBoundary[[i, 1]], pointsWithBoundary[[i, 2]]],
      {i, 1, Length[pointsWithBoundary]}
    ];
    angleDiffs = Table[
      Mod[angles[[i + 1]] - angles[[i]], 2*Pi],
      {i, 1, Length[pointsWithBoundary] - 1}
    ];

    Print["    Angles: ", N[angles, 6]];
    Print["    Angle differences: ", N[angleDiffs, 6]];
    Print["    All equal? ", StandardDeviation[angleDiffs] < 0.001];
    Print[];
  ];
, {k, 3, 5}];

Print[StringRepeat["=", 70]];
Print["ALTERNATIVE: TRIGONOMETRIC ROOTS"];
Print[StringRepeat["=", 70]];
Print[];

Print["From f(cos(theta), k) = -sin(k*theta)*sin(theta)"];
Print["Roots when sin(k*theta) = 0 OR sin(theta) = 0"];
Print[];

Print["sin(k*theta) = 0 at theta = j*pi/k for j = 0,1,...,k"];
Print["sin(theta) = 0 at theta = 0, pi"];
Print[];

Do[
  Print["k=", k, ":"];
  (* Roots from sin(k*theta) = 0 *)
  thetaRoots = Table[j*Pi/k, {j, 0, k}];
  xRoots = Cos[thetaRoots];

  Print["  theta roots: ", N[thetaRoots, 5]];
  Print["  x = cos(theta): ", N[xRoots, 6]];

  (* Corresponding y on unit circle *)
  yVals = Sin[thetaRoots];
  points = Table[{xRoots[[i]], yVals[[i]]}, {i, 1, Length[xRoots]}];

  Print["  Points (x,y) on circle: ", N[points, 6]];

  (* Check if these form regular k+1 gon *)
  angles = Table[thetaRoots[[i]], {i, 1, Length[thetaRoots]}];
  angleDiffs = Table[angles[[i + 1]] - angles[[i]], {i, 1, Length[angles] - 1}];

  Print["  Angular spacing: ", N[angleDiffs, 6]];
  Print["  Expected: pi/", k, " = ", N[Pi/k, 6]];
  Print["  Forms regular ", k + 1, "-gon? ", StandardDeviation[angleDiffs] < 0.0001];
  Print[];
, {k, 3, 6}];

Print[StringRepeat["=", 70]];
Print["CHECKING: (x, f(x,k)) ON UNIT CIRCLE"];
Print[StringRepeat["=", 70]];
Print[];

Print["For theta = j*pi/k (excluding j=0,k):"];
Print[];

Do[
  Print["k=", k, ":"];
  Do[
    Module[{theta, xval, fval, distSquared},
      theta = j*Pi/k;
      xval = Cos[theta];
      fval = -Sin[k*theta]*Sin[theta]; (* From our proof *)

      distSquared = xval^2 + fval^2;

      Print["  j=", j, ": theta=", N[theta, 5], ", x=", N[xval, 5],
            ", f(x,k)=", N[fval, 5], ", x^2+f^2=", N[distSquared, 6]];
    ];
  , {j, 1, k - 1}];
  Print[];
, {k, 3, 5}];

Print["DONE!"];
