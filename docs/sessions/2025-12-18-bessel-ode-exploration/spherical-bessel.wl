(* Sférické Besselovy funkce a jejich ODE *)

Print["=== SPHERICAL BESSEL FUNCTIONS ===\n"];

(* K_{n+1/2}(x) jsou sférické modifikované Besselovy funkce *)
Print["K_{n+1/2}(x) = sqrt(pi/2x) * k_n(x)  (spherical modified Bessel)"];
Print["where k_n(x) = sqrt(pi/2x) K_{n+1/2}(x)\n"];

(* Sférická Besselova ODE *)
Print["SPHERICAL BESSEL ODE:"];
Print["x² y'' + 2x y' - [x² + n(n+1)] y = 0  (modified, for k_n)\n"];

(* Elementární řešení *)
Print["ELEMENTARY SOLUTIONS for k_n(x):"];
Print["k_0(x) = (π/2) e^{-x} / x"];
Print["k_1(x) = (π/2) e^{-x} (1 + 1/x) / x"];
Print["k_n(x) = (π/2) e^{-x} P_n(1/x) / x  where P_n is polynomial\n"];

(* Ověření *)
Print["Verification:"];
Table[
  kn = Sqrt[Pi/(2 x)] BesselK[n + 1/2, x];
  simplified = FullSimplify[kn];
  Print["k_", n, "(x) = ", simplified];
  , {n, 0, 4}
];

(* Teď: co když vyjdeme ze sférické ODE a odvodíme e? *)
Print["\n=== DERIVING FROM SPHERICAL ODE ==="];

(* Sférická ODE: x²y'' + 2xy' - (x² + n(n+1))y = 0 *)
(* Pro n=0: x²y'' + 2xy' - x²y = 0 *)
Print["\nFor n=0: x²y'' + 2xy' - x²y = 0"];
Print["Substitution y = e^{-x} u(x) transforms this to:"];

(* y = e^{-x} u *)
(* y' = e^{-x}(u' - u) *)
(* y'' = e^{-x}(u'' - 2u' + u) *)
y = Exp[-x] u[x];
ode0 = x^2 D[y, {x, 2}] + 2 x D[y, x] - x^2 y;
simplified0 = Simplify[ode0 / Exp[-x]];
Print["After substitution: ", Collect[simplified0, {u[x], u'[x], u''[x]}], " = 0"];

(* Toto by mělo být jednodušší! *)
Print["\nSimplified ODE for u(x): x²u'' + 2(x-x²)u' + (x²-2x)u = 0 ???"];

(* Zkusme přímo: k_0(x) = c·e^{-x}/x *)
Print["\nDirect: k_0(x) = c·e^{-x}/x satisfies:"];
k0 = c Exp[-x]/x;
check0 = x^2 D[k0, {x, 2}] + 2 x D[k0, x] - x^2 k0;
Print["LHS = ", Simplify[check0]];

Print["\n=== THE KEY: Exponential IS the fundamental solution! ==="];
Print["k_0(x) ∝ e^{-x}/x means the spherical ODE at n=0"];
Print["has e^{-x} built into its solutions.\n"];

(* Argument x = 1/2 *)
Print["At x = 1/2:"];
Print["k_0(1/2) = (π/2) e^{-1/2} / (1/2) = π e^{-1/2} = π/√e"];
Print["Numerical: ", N[Pi/Sqrt[E], 15]];
Print["Direct:    ", N[Sqrt[Pi] BesselK[1/2, 1/2], 15]];

