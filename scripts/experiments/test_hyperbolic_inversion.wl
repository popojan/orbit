#!/usr/bin/env wolframscript
(* Test if Egypt/Chebyshev has hyperbolic inversion symmetry *)

<< Orbit`

Print["Testing hyperbolic inversion in Egypt formulas...\n"];

(* Our hyperbolic form *)
hyperbolicTerm[x_, k_] := 1 / (1/2 + Cosh[(1 + 2*k)*ArcSinh[Sqrt[x]/Sqrt[2]]] /
                                      (Sqrt[2]*Sqrt[2 + x]));

(* Test inversion: x -> 1/x *)
Print["Testing x -> 1/x symmetry:\n"];

Do[
  hx = N[hyperbolicTerm[x, k], 10];
  h1x = N[hyperbolicTerm[1/x, k], 10];
  product = hx * h1x;

  Print["k=", k, ", x=", N[x,3], ": H(x)=", hx, ", H(1/x)=", h1x, ", product=", product];
, {k, 1, 3}, {x, {2, 3, 5}}];

Print["\n"];

(* Test the arguments in hyperbolic form *)
Print["Analyzing arguments under x -> 1/x:\n"];

arg1[x_] := Sqrt[x]/Sqrt[2];
arg2[x_] := Sqrt[2 + x];

Do[
  a1 = arg1[x];
  a1inv = arg1[1/x];
  a2 = arg2[x];
  a2inv = arg2[1/x];

  Print["x=", N[x,3], ":");
  Print["  sqrt(x/2):     ", N[a1, 5], " -> sqrt(1/(2x)): ", N[a1inv, 5]];
  Print["  sqrt(2+x):     ", N[a2, 5], " -> sqrt(2+1/x):  ", N[a2inv, 5]];
  Print["  Product arg1:  ", N[a1 * a1inv, 5]];
  Print["  Product arg2:  ", N[a2 * a2inv, 5]];
  Print[];
, {x, {2, 3, 5}}];

Print["\n"];

(* Map to Poincare disk coordinates? *)
Print["Mapping to potential Poincare disk coordinates:\n"];

(* Hypothesis: sqrt(x/2) might be related to tanh(d/2) where d is hyperbolic distance *)
(* In Poincare disk: r = tanh(d/2) where d is hyperbolic distance from origin *)
(* So: d = 2*ArcTanh[r] = 2*ArcSinh[r/sqrt(1-r²)] *)

(* If sqrt(x/2) = r, then what is x? *)
Print["If r = sqrt(x/2), then x = 2r²\n"];

testPoincare[x_] := Module[{r, d},
  r = Sqrt[x/2];
  d = 2*ArcSinh[r / Sqrt[1 - r^2]];  (* hyperbolic distance *)
  {x, r, d}
];

Print["x\t\tr (Euclidean)\td (Hyperbolic)"];
Print[StringRepeat["-", 50]];
Do[
  {xval, r, d} = testPoincare[x];
  If[r < 1,
    Print[N[xval,4], "\t\t", N[r,5], "\t\t", N[d,5]],
    Print[N[xval,4], "\t\t", N[r,5], "\t\tOUTSIDE DISK (r>=1)"]
  ];
, {x, {0.5, 1, 1.5, 2}}];

Print["\n"];

(* Check relationship between ArcSinh[sqrt(x/2)] and hyperbolic distance *)
Print["Our formula uses: ArcSinh[sqrt(x/2)]\n"];
Print["This is NOT the same as hyperbolic distance in standard Poincare disk!\n"];
Print["But it might be a TRANSFORMED coordinate system...\n"];

Print["DONE!"];
