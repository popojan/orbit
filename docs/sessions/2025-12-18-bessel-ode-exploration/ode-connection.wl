(* Spojení ODE exponenciály a Besselovy ODE *)

Print["=== ODE CONNECTION ===\n"];

(* Exponenciála: y' = y, řešení y = ce^x *)
Print["1. EXPONENTIAL ODE: y' = y"];
Print["   Solution: y = c·e^x\n"];

(* Besselova ODE: x²y'' + xy' - (x² + ν²)y = 0 *)
Print["2. BESSEL ODE: x²y'' + xy' - (x² + ν²)y = 0"];
Print["   Solutions: I_ν(x), K_ν(x)\n"];

(* Substituce: zkusme y(x) = e^x u(x) *)
Print["3. SUBSTITUTION: y(x) = e^x u(x) in Bessel ODE"];
Print["   If y = e^x u, then y' = e^x(u' + u), y'' = e^x(u'' + 2u' + u)"];
Print["   Bessel ODE becomes..."];

(* Symbolicky *)
y[x_] := Exp[x] u[x];
besselSubst = x^2 D[y[x], {x, 2}] + x D[y[x], x] - (x^2 + nu^2) y[x];
expanded = Expand[besselSubst / Exp[x]];
Print["   ", Collect[expanded, {u[x], u'[x], u''[x]}], " = 0\n"];

(* Asymptotická expanze K_ν(x) *)
Print["4. ASYMPTOTIC: K_ν(x) ~ √(π/2x) e^{-x} Σ_k a_k(ν)/x^k"];
Print["   So K_ν contains e^{-x} as leading behavior!\n"];

(* Pro velké x: K_ν(x) ≈ √(π/2x) e^{-x} *)
Print["   First terms of asymptotic expansion:"];
asymK = Series[BesselK[nu, x] / (Sqrt[Pi/(2x)] Exp[-x]), {x, Infinity, 3}];
Print["   K_ν(x) / [√(π/2x) e^{-x}] = ", Normal[asymK], " + O(1/x^4)\n"];

(* 5. KLÍČ: Exponenciála e je limitní poměr K funkcí! *)
Print["5. KEY INSIGHT: e arises from RATIO of K-values"];
Print["   Our formula: p_n/q_n → e"];
Print["   where q_n involves K_{2n±1}(-1/2)\n"];

(* 6. Rekurentní vztah pro K spojuje sousední řády *)
Print["6. RECURRENCE connects consecutive orders:"];
Print["   K_{ν+1}(x) = (2ν/x) K_ν(x) + K_{ν-1}(x)"];
Print["   This is a LINEAR RECURRENCE - like convergent recurrence!\n"];

(* Srovnání s rekurencí konvergentů *)
Print["7. CONVERGENT RECURRENCE for CF [a_0; a_1, a_2, ...]:"];
Print["   p_n = a_n p_{n-1} + p_{n-2}"];
Print["   q_n = a_n q_{n-1} + q_{n-2}\n"];

Print["   Compare with Bessel recurrence (at x = -1/2):"];
Print["   K_{ν+1}(-1/2) = -4ν K_ν(-1/2) + K_{ν-1}(-1/2)"];
Print["   Coefficient -4ν grows linearly! Like CF [2; 6, 10, 14, ...]!\n"];

(* Ověření *)
Print["8. CHECK: Does -4ν match CF coefficients?"];
Print["   CF for (e+1)/(e-1) = [2; 6, 10, 14, 18, ...] = [2; 4k+2 for k≥1]"];
Print["   Bessel recurrence coefficient at ν: -4ν"];
Table[
  Print["   ν=", n, ": -4ν = ", -4 n, ", CF term a_", n, " = ", 4 n + 2];
  , {n, 1, 5}
];

Print["\n   Hmm, -4ν ≠ 4n+2. But there might be a rescaling...\n"];

(* 9. Hledejme transformaci *)
Print["9. LOOKING FOR TRANSFORMATION:"];
Print["   Define f_n = K_{2n-1}(-1/2) for n = 1, 2, 3, ..."];
Print["   Then f_{n+1} = K_{2n+1}(-1/2) = -4(2n) K_{2n}(-1/2) + K_{2n-1}(-1/2)"];
Print["   But this involves K_{2n} which is not in our sequence!\n"];

Print["   Alternative: Consider K at ODD indices: 1, 3, 5, 7, ..."];
Print["   K_3 = -4·2 K_2 + K_1 = -8 K_2 + K_1"];
Print["   K_5 = -4·4 K_4 + K_3 = -16 K_4 + K_3"];
Print["   Pattern involves EVEN indices too.\n"];

