(* Odvození e z Besselových funkcí *)
(* Session: 2025-12-18-bessel-ode-exploration *)

Print["=== Two representations of e via Bessel functions ===\n"];

(* 1. Známá identita: e = Σ I_n(1) *)
Print["1. KNOWN IDENTITY: e = Σ_{n=-∞}^∞ I_n(1)"];
Print["   From generating function: e^{(t+1/t)/2} = Σ I_n(1) t^n"];
Print["   At t=1: e^1 = Σ I_n(1)\n"];

sum1 = Sum[BesselI[n, 1], {n, -200, 200}];
Print["   Σ_{n=-200}^{200} I_n(1) = ", N[sum1, 25]];
Print["   e                       = ", N[E, 25]];
Print["   Difference: ", N[sum1 - E, 25]];

(* 2. Naše reprezentace přes konvergenty *)
Print["\n2. OUR REPRESENTATION via convergents:"];
Print["   e = lim_{n→∞} p_n/q_n"];
Print["   where q_n = -K_{2n-1}(-1/2) · K_{2n+1}(-1/2) / (2πi)\n"];

(* 3. Spojení: I_n a K_n jsou řešení TÉŽE ODE! *)
Print["3. CONNECTION: I_ν and K_ν solve the SAME ODE:"];
Print["   x² y'' + x y' - (x² + ν²) y = 0\n"];
Print["   I_ν is the solution regular at origin"];
Print["   K_ν is the solution decaying at infinity"];

(* 4. Wronskian spojuje obě řešení *)
Print["\n4. WRONSKIAN connects both solutions:"];
Print["   W[I_ν, K_ν](x) = I_ν(x) K'_ν(x) - I'_ν(x) K_ν(x) = -1/x\n"];

(* Ověření *)
wron = FullSimplify[BesselI[nu, x] D[BesselK[nu, x], x] - D[BesselI[nu, x], x] BesselK[nu, x]];
Print["   Check: ", wron];

(* 5. Reflexní vzorec *)
Print["\n5. REFLECTION FORMULA:"];
Print["   K_ν(x e^{iπ}) = e^{-iπν} K_ν(x) - iπ I_ν(x)"];
Print["   So: K_ν(-1/2) = e^{-iπν} K_ν(1/2) - iπ I_ν(1/2)\n"];

(* 6. KLÍČOVÁ OTÁZKA: Lze odvodit Σ I_n(1) = e z naší K-reprezentace? *)
Print["6. KEY QUESTION:"];
Print["   Can we derive Σ I_n(1) = e from our K-representation?"];
Print["   Or vice versa?\n"];

(* Zkusme vyjádřit I přes K *)
Print["   Using reflection formula:"];
Print["   I_ν(1/2) = (e^{-iπν} K_ν(1/2) - K_ν(-1/2)) / (iπ)\n"];

(* Numerická kontrola *)
Print["   Numerical check for ν=0:"];
lhs = N[BesselI[0, 1/2], 15];
rhs = N[(Exp[-I Pi * 0] BesselK[0, 1/2] - BesselK[0, -1/2]) / (I Pi), 15];
Print["   I_0(1/2) = ", lhs];
Print["   (K_0(1/2) - K_0(-1/2))/(iπ) = ", rhs];

