(* Integrální reprezentace a ODE spojení *)

Print["=== Integral representation of K_ν ==="];
Print["K_ν(x) = ∫_0^∞ e^{-x cosh(t)} cosh(νt) dt  (for Re(x) > 0)"];

(* Pro x = 1/2, ν = 0 *)
Print["\n=== K_0(1/2) via integral ==="];
intK0 = NIntegrate[Exp[-Cosh[t]/2], {t, 0, Infinity}, WorkingPrecision -> 20];
Print["∫_0^∞ e^{-cosh(t)/2} dt = ", intK0];
Print["K_0(1/2) = ", N[BesselK[0, 1/2], 20]];

(* Generující funkce pro Bessel I_n *)
Print["\n=== Generating function for I_n ==="];
Print["e^{(x/2)(t + 1/t)} = Σ_{n=-∞}^∞ I_n(x) t^n"];

(* Zkusme x=1, t=1 *)
Print["\n=== At x=1, t=1: ==="];
Print["e^1 = Σ I_n(1)"];
sumIn = Sum[BesselI[n, 1], {n, -100, 100}];
Print["Σ_{n=-100}^{100} I_n(1) = ", N[sumIn, 15]];
Print["e = ", N[E, 15]];

(* Tohle je známá identita! *)
Print["\n=== Known identity: e = Σ_{n=-∞}^∞ I_n(1) ==="];

(* A teď K funkce *)
Print["\n=== Can we get e from K functions? ==="];

(* Poyntingova-Somerfeld integrální reprezentace *)
Print["\n=== Connection formula (reflection) ==="];
Print["K_ν(xe^{iπ}) = e^{-iπν} K_ν(x) - iπ I_ν(x)"];

(* Ověření pro K_0 *)
kReflect = BesselK[0, x Exp[I Pi]] - (Exp[-I Pi * 0] BesselK[0, x] - I Pi BesselI[0, x]);
Print["Check ν=0: ", FullSimplify[kReflect]];

(* K(-1/2) = K(1/2 * e^{iπ}) *)
Print["\n=== K_ν(-1/2) via reflection formula ==="];
Print["K_ν(-1/2) = K_ν(1/2 · e^{iπ}) = e^{-iπν} K_ν(1/2) - iπ I_ν(1/2)"];

(* Numerická verifikace *)
Print["\nNumerical check for ν=0:"];
lhs = N[BesselK[0, -1/2], 15];
rhs = N[Exp[-I Pi * 0] BesselK[0, 1/2] - I Pi BesselI[0, 1/2], 15];
Print["K_0(-1/2) = ", lhs];
Print["K_0(1/2) - iπ I_0(1/2) = ", rhs];

Print["\nNumerical check for ν=1:"];
lhs1 = N[BesselK[1, -1/2], 15];
rhs1 = N[Exp[-I Pi * 1] BesselK[1, 1/2] - I Pi BesselI[1, 1/2], 15];
Print["K_1(-1/2) = ", lhs1];
Print["e^{-iπ} K_1(1/2) - iπ I_1(1/2) = ", rhs1];

