(* Ověření Grosswaldovy formule vs moje *)

Print["=== GROSSWALD vs MY FORMULA ===\n"];

y[0, x_] := 1;
y[1, x_] := 1 + x;
y[n_, x_] := y[n, x] = (2 n - 1) x y[n - 1, x] + y[n - 2, x];

Print["Grosswald (1951): y_n(z) ~ (2n-1)!! / z^n · e^{1/z}"];
Print["So: y_n(z) · z^n / (2n-1)!! → e^{1/z}\n"];

Print["My formula: y_n(x) / [(2n-1)!! · x^n] → e^{1/x}\n"];

Print["=== TEST AT x = 1 ==="];
Print["Both formulas give: y_n(1) / (2n-1)!! → e"];
Table[
  ratio = N[y[n, 1] / (2 n - 1)!!, 15];
  Print["n=", n, ": ", ratio];
  , {n, {50, 100, 150}}
];
Print["e = ", N[E, 15], "\n"];

Print["=== TEST AT x = 2 ==="];
Print["Grosswald: y_n(2) · 2^n / (2n-1)!! → e^{1/2}"];
Print["My formula: y_n(2) / [(2n-1)!! · 2^n] → e^{1/2}\n"];

Table[
  grosswald = N[y[n, 2] (2^n) / (2 n - 1)!!, 15];
  myFormula = N[y[n, 2] / ((2 n - 1)!! (2^n)), 15];
  Print["n=", n, ":"];
  Print["  Grosswald: y·2^n/(2n-1)!! = ", grosswald];
  Print["  My:        y/[(2n-1)!!·2^n] = ", myFormula];
  , {n, {20, 50, 100}}
];
Print["e^{1/2} = √e = ", N[Sqrt[E], 15], "\n"];

Print["=== CONCLUSION ==="];
Print["Grosswald uses different convention for y_n!"];
Print["Need to check definition carefully.\n"];

(* Grosswaldova definice vs standard *)
Print["=== CHECKING DEFINITIONS ==="];
Print["Standard: y_n(x) = Σ (n+k)!/(k!(n-k)!) (x/2)^k"];
Print["         y_0 = 1, y_1 = 1+x, y_2 = 3x² + 3x + 1\n"];

Print["Our recurrence: y_{n+1} = (2n+1)x·y_n + y_{n-1}"];
Print["Check: y_2 = 3·x·(1+x) + 1 = 3x + 3x² + 1 ✓\n"];

(* Alternativní definice *)
Print["Alternative definition (reverse): θ_n(x) = x^n y_n(1/x)"];
Print["θ_n(x) are reverse Bessel polynomials.\n"];

Print["If Grosswald uses θ_n convention:"];
Print["θ_n(z) ~ (2n-1)!! · z^n · e^z"];
Print["Then θ_n(z) / [(2n-1)!! · z^n] → e^z"];
Print["At z=1/2: θ_n(1/2) / [(2n-1)!! · (1/2)^n] → e^{1/2}"];
Print["         θ_n(1/2) · 2^n / (2n-1)!! → √e\n"];

Table[
  theta = (1/2)^n y[n, 2];
  ratio = N[theta 2^n / (2 n - 1)!!, 15];
  Print["n=", n, ": θ_n(1/2)·2^n/(2n-1)!! = ", ratio];
  , {n, {50, 100, 150}}
];
Print["√e = ", N[Sqrt[E], 15]];

