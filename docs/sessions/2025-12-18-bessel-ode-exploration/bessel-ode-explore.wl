(* Diferenciální rovnice pro modifikovanou Besselovu funkci *)
(* x² y'' + x y' - (x² + ν²) y = 0 *)

Print["=== Modified Bessel ODE ==="];
besselODE = x^2 y''[x] + x y'[x] - (x^2 + nu^2) y[x] == 0;
Print["ODE: ", besselODE];

(* Ověření, že K_ν je řešení *)
Print["\n=== Verification that K_ν solves the ODE ==="];
testK = x^2 D[BesselK[nu, x], {x, 2}] + x D[BesselK[nu, x], x] - (x^2 + nu^2) BesselK[nu, x];
Print["Substituting K_ν: ", FullSimplify[testK]];

(* Rekurentní vztahy pro K_ν *)
Print["\n=== Recurrence relations ==="];
Print["K_{ν-1}(x) - K_{ν+1}(x) = -2ν/x K_ν(x)"];
rec1 = BesselK[nu-1, x] - BesselK[nu+1, x] + (2 nu/x) BesselK[nu, x];
Print["Check: ", FullSimplify[rec1]];

Print["K_{ν-1}(x) + K_{ν+1}(x) = -2 K'_ν(x)"];
rec2 = BesselK[nu-1, x] + BesselK[nu+1, x] + 2 D[BesselK[nu, x], x];
Print["Check: ", FullSimplify[rec2]];

(* Naše funkce g(z) *)
Print["\n=== Our g(z) function ==="];
g[z_] := -16 Pi E z / (BesselK[2z - 1, -1/2] BesselK[2z + 1, -1/2]);
Print["g(z) = -16πe·z / [K_{2z-1}(-1/2) · K_{2z+1}(-1/2)]"];

(* Zkusme derivaci g(z) *)
Print["\n=== Derivative g'(z) ==="];
gPrime = D[g[z], z];
Print["g'(z) = ", Simplify[gPrime]];

(* Podíl g'(z)/g(z) - logaritmická derivace *)
Print["\n=== Logarithmic derivative g'/g ==="];
logDeriv = Simplify[gPrime / g[z]];
Print["g'(z)/g(z) = ", logDeriv];

