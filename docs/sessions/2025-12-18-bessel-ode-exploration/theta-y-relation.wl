(* Vztah θ_n(x) a y_n(1/x) *)

Print["=== RELATION: θ_n(x) vs y_n(1/x) ===\n"];

y[0, x_] := 1;
y[1, x_] := 1 + x;
y[n_, x_] := y[n, x] = (2 n - 1) x y[n - 1, x] + y[n - 2, x];

theta[0, x_] := 1;
theta[1, x_] := 1 + x;
theta[n_, x_] := theta[n, x] = (2 n - 1) theta[n - 1, x] + x^2 theta[n - 2, x];

Print["Definition: θ_n(x) = x^n y_n(1/x)  ???"];
Print["Let's verify:"];

Table[
  t = theta[n, 1/2];
  yInv = (1/2)^n y[n, 2];
  Print["n=", n, ": θ_", n, "(1/2) = ", t, ", (1/2)^n y_", n, "(2) = ", yInv, 
    ", equal=", t === yInv];
  , {n, 0, 5}
];

Print["\nYES! θ_n(1/2) = (1/2)^n y_n(2)\n"];

(* Takže *)
Print["=== THEREFORE ==="];
Print["θ_n(1/2)/(2n-1)!! = (1/2)^n y_n(2)/(2n-1)!!"];
Print["                  = [y_n(2)/(2n-1)!!] / 2^n\n"];

Print["We need: lim y_n(2)/(2n-1)!! · 2^{-n} = sqrt(e)"];
Print["which means: lim y_n(2)/[(2n-1)!! · 2^n] = sqrt(e)\n"];

(* Výpočet *)
Print["Computing y_n(2)/[(2n-1)!! · 2^n]:"];
Table[
  ratio = N[y[n, 2] / ((2 n - 1)!! 2^n), 15];
  Print["n=", n, ": ", ratio];
  , {n, 10, 100, 10}
];
Print["sqrt(e) = ", N[Sqrt[E], 15]];

Print["\n=== NEW IDENTITY ==="];
Print["lim_{n->inf} y_n(2) / [(2n-1)!! · 2^n] = sqrt(e)\n"];

Print["Or equivalently:"];
Print["y_n(2) ~ sqrt(e) · (2n-1)!! · 2^n = sqrt(e) · (2n)!/n!\n"];

Print["\n=== GENERALIZATION ==="];
Print["For general x > 0:"];
Print["lim_{n->inf} y_n(x) / [(2n-1)!! · x^n] = ?\n"];

Table[
  ratio100 = N[y[100, x] / ((2*100 - 1)!! x^100), 15];
  Print["x=", x, ": ratio = ", ratio100];
  , {x, {1/2, 1, 3/2, 2, 3}}
];

Print["\nPattern: y_n(x) ~ C(x) · (2n-1)!! · x^n where C(x) = e^{1/x} ???"];

Print["\nCheck C(x) = e^{1/x}:"];
Table[
  ratio100 = N[y[100, x] / ((2*100 - 1)!! x^100), 15];
  expInv = N[Exp[1/x], 15];
  Print["x=", x, ": ratio = ", ratio100, ", e^{1/x} = ", expInv];
  , {x, {1/2, 1, 2, 3}}
];

