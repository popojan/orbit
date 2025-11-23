#!/usr/bin/env wolframscript

Print["GEOMETRIC VERIFICATION: POLYGON VERTICES"];
Print[StringRepeat["=", 70]];
Print[];

Print["Testing: x^2 + f(x,k)^2 = 1 where f(x,k) = T_{k+1}(x) - x*T_k(x)"];
Print[];

Print[StringRepeat["=", 70]];
Print["SYMBOLIC CHECK FOR k=1..5"];
Print[StringRepeat["=", 70]];
Print[];

Do[
  Module[{fk, expr, simplified},
    fk = ChebyshevT[k + 1, x] - x*ChebyshevT[k, x];
    expr = x^2 + fk^2;
    simplified = Simplify[expr];

    Print["k=", k, ":"];
    Print["  f(x,", k, ") = ", fk];
    Print["  x^2 + f(x,k)^2 = ", simplified];
    Print["  Is this 1? ", simplified == 1];
    Print[];
  ];
, {k, 1, 5}];

Print[StringRepeat["=", 70]];
Print["TRIGONOMETRIC FORM"];
Print[StringRepeat["=", 70]];
Print[];

Print["From proof: f(cos(theta), k) = -sin(k*theta)*sin(theta)"];
Print[];
Print["So: x^2 + f(x,k)^2 = cos^2(theta) + sin^2(k*theta)*sin^2(theta)"];
Print[];

Do[
  Module[{expr, simplified},
    expr = Cos[theta]^2 + Sin[k*theta]^2 * Sin[theta]^2;
    simplified = Simplify[expr];

    Print["k=", k, ": cos^2(theta) + sin^2(", k, "*theta)*sin^2(theta)"];
    Print["  = ", simplified];
    Print["  Is this 1? ", simplified == 1];
    Print[];
  ];
, {k, 1, 5}];

Print[StringRepeat["=", 70]];
Print["FINDING WHEN x^2 + f(x,k)^2 = 1"];
Print[StringRepeat["=", 70]];
Print[];

Print["For general k, when does cos^2(theta) + sin^2(k*theta)*sin^2(theta) = 1?"];
Print[];

Print["This simplifies to: cos^2(theta) + sin^2(k*theta)*sin^2(theta) = 1"];
Print["                    cos^2(theta) + sin^2(k*theta)*(1 - cos^2(theta)) = 1"];
Print["                    cos^2(theta) + sin^2(k*theta) - sin^2(k*theta)*cos^2(theta) = 1"];
Print["                    cos^2(theta)*(1 - sin^2(k*theta)) + sin^2(k*theta) = 1"];
Print["                    cos^2(theta)*cos^2(k*theta) + sin^2(k*theta) = 1"];
Print[];

Print["Checking this identity:"];
Do[
  Module[{lhs, simplified},
    lhs = Cos[theta]^2 * Cos[k*theta]^2 + Sin[k*theta]^2;
    simplified = Simplify[lhs];

    Print["k=", k, ": ", simplified, " = 1? ", simplified == 1];
  ];
, {k, 1, 5}];
Print[];

Print[StringRepeat["=", 70]];
Print["ALTERNATIVE: DOUBLE ROOTS"];
Print[StringRepeat["=", 70]];
Print[];

Print["Finding roots of f(x,k):"];
Print[];

Do[
  Module[{fk, roots, numRoots},
    fk = ChebyshevT[k + 1, x] - x*ChebyshevT[k, x];
    roots = Solve[fk == 0 && -1 <= x <= 1, x, Reals];
    numRoots = Length[roots];

    Print["k=", k, ": ", numRoots, " roots"];
    Print["  Roots: ", x /. roots // N // Sort];

    (* Check multiplicity *)
    Print["  Checking multiplicities:"];
    Do[
      Module[{root, derivative, val},
        root = x /. roots[[i]];
        derivative = D[fk, x] /. x -> root;
        val = Simplify[derivative];
        Print["    x=", N[root, 5], ": f'(x) = ", val,
              If[val == 0, " (DOUBLE ROOT)", " (simple root)"]];
      ];
    , {i, 1, numRoots}];
    Print[];
  ];
, {k, 2, 4}];

Print[StringRepeat["=", 70]];
Print["POLYGON VERTICES"];
Print[StringRepeat["=", 70]];
Print[];

Print["Regular k-gon vertices on unit circle: (cos(2*pi*j/k), sin(2*pi*j/k))"];
Print[];

Do[
  Print["k=", k, " polygon:"];
  vertices = Table[{Cos[2*Pi*j/k], Sin[2*Pi*j/k]}, {j, 0, k - 1}];
  Print["  Vertices: ", N[vertices, 5]];

  (* Compare with (x, f(x,k)) on unit circle *)
  Print["  Checking if f(x,k) matches for x = cos(2*pi*j/k):"];
  Do[
    Module[{xval, fval, yvert},
      xval = Cos[2*Pi*j/k];
      fval = (ChebyshevT[k + 1, xval] - xval*ChebyshevT[k, xval]) // N;
      yvert = Sin[2*Pi*j/k];

      Print["    j=", j, ": x=", N[xval, 5], ", f(x,k)=", N[fval, 5],
            ", y_vertex=", N[yvert, 5], ", match? ", Abs[fval - yvert] < 0.001];
    ];
  , {j, 0, k - 1}];
  Print[];
, {k, 3, 5}];

Print["DONE!"];
