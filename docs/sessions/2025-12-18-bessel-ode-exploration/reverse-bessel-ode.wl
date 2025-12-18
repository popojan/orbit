(* ODE pro reverzní Besselovy polynomy *)

Print["=== REVERSE BESSEL POLYNOMIALS θ_n(x) ===\n"];

(* θ_n(x) = x^n y_n(1/x) kde y_n jsou Besselovy polynomy *)
Print["Definition: θ_n(x) = x^n y_n(1/x)"];
Print["These appear in k_n(x) = (π/2) e^{-x} θ_n(x) / x^{n+1}\n"];

(* Koeficienty *)
Print["First few θ_n(x):"];
theta[0] = 1;
theta[1] = 1 + x;
theta[2] = 3 + 3 x + x^2;
theta[3] = 15 + 15 x + 6 x^2 + x^3;
theta[4] = 105 + 105 x + 45 x^2 + 10 x^3 + x^4;

Table[Print["θ_", n, "(x) = ", theta[n]], {n, 0, 4}];

(* Rekurence *)
Print["\nRecurrence for θ_n:"];
Print["θ_{n+1}(x) = (2n+1+x) θ_n(x) + x² θ_{n-1}(x) ??? Let's check..."];

Table[
  lhs = theta[n + 1];
  rhs = (2 n + 1 + x) theta[n] + x^2 theta[n - 1] // Expand;
  Print["n=", n, ": θ_", n + 1, " = ", lhs, ", RHS = ", rhs, ", match=", lhs === rhs];
  , {n, 1, 3}
];

(* Ne, to nesedí. Zkusme jinak. *)
Print["\nActual recurrence from k_n recurrence:"];
Print["k_{n+1}(x) = (2n+1)/x k_n(x) + k_{n-1}(x)"];

(* Dosadíme k_n = (π/2) e^{-x} θ_n / x^{n+1} *)
Print["\nSubstituting k_n = C e^{-x} θ_n / x^{n+1}:"];
Print["θ_{n+1}/x^{n+2} = (2n+1)/x · θ_n/x^{n+1} + θ_{n-1}/x^n"];
Print["θ_{n+1} = (2n+1) θ_n + x² θ_{n-1}"];

Print["\nVerify:"];
theta2[0] = 1; theta2[1] = 1 + x;
theta2[n_] := theta2[n] = (2 n - 1) theta2[n - 1] + x^2 theta2[n - 2];
Table[
  Print["θ_", n, "(x) = ", Expand[theta2[n]]];
  , {n, 0, 4}
];

(* Tohle nesedí s tím co jsme viděli... *)
Print["\nHmm, coefficients don't match. Let me recalculate from K directly:"];

Table[
  kn = BesselK[n + 1/2, x];
  factored = FullSimplify[kn / (Sqrt[Pi/(2 x)] Exp[-x])];
  poly = Expand[factored * x^(n + 1/2) / Sqrt[x^(-1)]];
  Print["From K_{", n, "+1/2}: polynomial factor = ", FullSimplify[poly]];
  , {n, 0, 4}
];

(* ODE pro θ_n? *)
Print["\n=== ODE FOR θ_n ==="];
Print["Since k_n satisfies spherical Bessel ODE:"];
Print["x²y'' + 2xy' - (x² + n(n+1))y = 0"];
Print["and k_n = (π/2) e^{-x} θ_n(x) / x^{n+1}"];
Print["we can derive ODE for θ_n by substitution.\n"];

(* Substituujme y = e^{-x} θ(x) / x^{n+1} do sférické ODE *)
Clear[theta, n];
y[x_] := Exp[-x] theta[x] / x^(n + 1);
ode = x^2 D[y[x], {x, 2}] + 2 x D[y[x], x] - (x^2 + n (n + 1)) y[x];
simplified = Simplify[ode * x^(n + 1) / Exp[-x]];
Print["ODE for θ(x): ", Collect[simplified, {theta[x], theta'[x], theta''[x]}], " = 0"];

