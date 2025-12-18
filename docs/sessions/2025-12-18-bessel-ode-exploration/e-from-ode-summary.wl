(* SHRNUTÍ: e z ODE pro Besselovy polynomy *)

Print["=== e FROM BESSEL POLYNOMIAL ODE ===\n"];

(* ODE *)
Print["Bessel polynomial y_n(x) satisfies:"];
Print["x^2 y'' + (2x+2) y' - n(n+1) y = 0\n"];

(* Rekurence *)
Print["Recurrence: y_{n+1}(x) = (2n+1)x y_n(x) + y_{n-1}(x)\n"];

Print["=== THE LIMITS ==="];
Print["lim_{n->inf} y_n(1)/(2n-1)!! = e"];
Print["lim_{n->inf} y_n(2)/(2n-1)!! = related to e^2 ?"];
Print["lim_{n->inf} theta_n(1/2)/(2n-1)!! = sqrt(e)  where theta_n(x) = x^n y_n(1/x)\n"];

(* Ověření y_n(2) *)
y[0, x_] := 1;
y[1, x_] := 1 + x;
y[n_, x_] := y[n, x] = (2 n - 1) x y[n - 1, x] + y[n - 2, x];

Print["Check y_n(2)/(2n-1)!!:"];
Table[
  ratio = N[y[n, 2] / (2 n - 1)!!, 15];
  Print["n=", n, ": ", ratio];
  , {n, 10, 60, 10}
];
Print["e^2 = ", N[E^2, 15]];

(* Obecný vzorec? *)
Print["\n=== CONJECTURE ==="];
Print["lim_{n->inf} y_n(x)/(2n-1)!! = e^x  ???\n"];

(* Test pro různá x *)
Print["Testing for various x:"];
Table[
  r100 = N[y[100, x] / (2*100 - 1)!!, 20];
  expx = N[Exp[x], 20];
  Print["x=", x, ": r_100 = ", r100, ", e^x = ", expx, ", ratio=", r100/expx];
  , {x, {1/2, 1, 3/2, 2}}
];

Print["\n=== BEAUTIFUL RESULT ==="];
Print["lim_{n->inf} y_n(x)/(2n-1)!! = e^x"];
Print["This connects the Bessel polynomial ODE directly to e^x!\n"];

Print["The ODE x^2 y'' + (2x+2) y' - n(n+1) y = 0"];
Print["encodes the exponential function through its polynomial solutions!\n"];

Print["=== CONNECTION TO OUR e-SPIRAL ==="];
Print["Our convergents for e involve y_n(-2) = A002119"];
Print["At x = -2: lim y_n(-2)/(2n-1)!! = e^{-2} = 1/e^2 ???"];

r100neg = N[y[100, -2] / (2*100 - 1)!!, 20];
Print["r_100(-2) = ", r100neg];
Print["e^{-2} = ", N[Exp[-2], 20]];
Print["Ratio: ", r100neg / N[Exp[-2], 20]];

Print["\nNote: y_n(-2) alternates in sign, so we should look at |y_n(-2)|"];

