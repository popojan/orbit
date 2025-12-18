(* Upřesnění notace a vztahů *)

Print["=== CLARIFYING NOTATION ===\n"];

(* Besselův polynom y_n(x) *)
Print["BESSEL POLYNOMIAL y_n(x):"];
Print["y_n(x) = sum_{k=0}^n (n+k)!/(k!(n-k)!) (x/2)^k"];
Print["Recurrence: y_{n+1}(x) = (2n+1)x y_n(x) + y_{n-1}(x)\n"];

y[0, x_] := 1;
y[1, x_] := 1 + x;
y[n_, x_] := y[n, x] = (2 n - 1) x y[n - 1, x] + y[n - 2, x];

Print["y_n(1): "];
Table[Print["y_", n, "(1) = ", y[n, 1]], {n, 0, 6}];

Print["\ny_n(1)/(2n-1)!!: "];
Table[
  ratio = N[y[n, 1] / (2 n - 1)!!, 15];
  Print["y_", n, "(1)/(2n-1)!! = ", ratio];
  , {n, 1, 10}
];

Print["\nCompare with sqrt(e) = ", N[Sqrt[E], 15]];

(* A teď: K_{n+1/2}(1/2) = sqrt(pi/e) y_n(1) ? *)
Print["\n=== VERIFY: K_{n+1/2}(1/2) = sqrt(pi/e) y_n(1) ==="];
Table[
  kExact = N[BesselK[n + 1/2, 1/2], 15];
  formula = N[Sqrt[Pi/E] y[n, 1], 15];
  Print["n=", n, ": K = ", kExact, ", sqrt(pi/e) y_n(1) = ", formula, 
    ", match=", Abs[kExact - formula] < 10^-10];
  , {n, 0, 5}
];

Print["\n=== SO THE QUESTION IS: lim y_n(1)/(2n-1)!! = ? ==="];

(* Vyšší n *)
Print["\nHigh n extrapolation:"];
r50 = N[y[50, 1] / (2*50 - 1)!!, 25];
r100 = N[y[100, 1] / (2*100 - 1)!!, 25];
Print["r_50  = ", r50];
Print["r_100 = ", r100];
Print["sqrt(e) = ", N[Sqrt[E], 25]];

(* Richardson *)
rich = (100 r100 - 50 r50) / 50;
Print["\nRichardson R(50,100) = ", rich];

Print["\n=== CONCLUSION ==="];
Print["IF lim y_n(1)/(2n-1)!! = sqrt(e), THEN:"];
Print["K_{n+1/2}(1/2) ~ sqrt(pi/e) * sqrt(e) * (2n-1)!! = sqrt(pi) * (2n-1)!!\n"];

Print["The ODE connection: y_n(x) satisfies"];
Print["x^2 y'' + (2x+2)y' - n(n+1)y = 0"];
Print["and the limit sqrt(e) emerges from this ODE at x=1!"];

