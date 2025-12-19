(* Symbolic analysis of spiral intersections *)

Print["=== SYMBOLIC SPIRAL INTERSECTION ANALYSIS ===\n"];

(* The spiral function *)
g[t_] := -16 t Pi E / (BesselK[2 t - 1, -1/2] BesselK[2 t + 1, -1/2]);

Print["g(t) = -16πe·t / [K_{2t-1}(-1/2) · K_{2t+1}(-1/2)]\n"];

(* Key identity: BesselK at negative argument *)
Print["=== BESSELK AT NEGATIVE ARGUMENT ==="];
Print["For z < 0 (z real), BesselK[ν, z] is complex."];
Print["Identity: K_ν(-x) = e^{-iπν} K_ν(x) - iπ I_ν(x)  [x > 0]\n"];

(* Let's verify this identity *)
Print["Verification at ν = 1/2, x = 1/2:"];
nu = 1/2; x = 1/2;
lhs = BesselK[nu, -x] // N;
rhs = Exp[-I Pi nu] BesselK[nu, x] - I Pi BesselI[nu, x] // N;
Print["LHS = K_{1/2}(-1/2) = ", lhs];
Print["RHS = e^{-iπ/2} K_{1/2}(1/2) - iπ I_{1/2}(1/2) = ", rhs];
Print["Match: ", Chop[lhs - rhs] == 0, "\n"];

(* For our case: K_{2t±1}(-1/2) *)
Print["=== APPLYING TO OUR SPIRAL ==="];
Print["K_{2t-1}(-1/2) = e^{-iπ(2t-1)} K_{2t-1}(1/2) - iπ I_{2t-1}(1/2)"];
Print["K_{2t+1}(-1/2) = e^{-iπ(2t+1)} K_{2t+1}(1/2) - iπ I_{2t+1}(1/2)\n"];

(* Define the real and imaginary parts symbolically *)
K1[t_] := BesselK[2 t - 1, 1/2];
I1[t_] := BesselI[2 t - 1, 1/2];
K2[t_] := BesselK[2 t + 1, 1/2];
I2[t_] := BesselI[2 t + 1, 1/2];

(* K_{2t-1}(-1/2) = e^{-iπ(2t-1)} K1 - iπ I1 *)
(* Let φ1 = -π(2t-1) = -2πt + π *)
(* e^{iφ1} = e^{iπ} e^{-2πit} = -e^{-2πit} = -(cos(2πt) - i sin(2πt)) *)

Print["=== PHASE ANALYSIS ==="];
Print["e^{-iπ(2t-1)} = e^{iπ} e^{-2πit} = -e^{-2πit}"];
Print["            = -(cos(2πt) - i·sin(2πt))"];
Print["            = -cos(2πt) + i·sin(2πt)\n"];

Print["e^{-iπ(2t+1)} = e^{-iπ} e^{-2πit} = -e^{-2πit}"];
Print["            = -cos(2πt) + i·sin(2πt)\n"];

Print["Interesting! Both phases are IDENTICAL: e^{-iπ(2t±1)} = -e^{-2πit}\n"];

(* So: *)
(* K_{2t-1}(-1/2) = -e^{-2πit} K1 - iπ I1 *)
(*                = K1(-cos(2πt) + i sin(2πt)) - iπ I1 *)
(*                = -K1 cos(2πt) + i(K1 sin(2πt) - π I1) *)

Print["=== REAL AND IMAGINARY DECOMPOSITION ==="];
Print["K_{2t-1}(-1/2) = -K1·cos(2πt) + i·(K1·sin(2πt) - π·I1)"];
Print["where K1 = K_{2t-1}(1/2), I1 = I_{2t-1}(1/2)\n"];

Print["K_{2t+1}(-1/2) = -K2·cos(2πt) + i·(K2·sin(2πt) - π·I2)"];
Print["where K2 = K_{2t+1}(1/2), I2 = I_{2t+1}(1/2)\n"];

(* Let's define: *)
(* a1 = -K1 cos(2πt),  b1 = K1 sin(2πt) - π I1 *)
(* a2 = -K2 cos(2πt),  b2 = K2 sin(2πt) - π I2 *)
(* K_{2t-1}(-1/2) = a1 + i b1 *)
(* K_{2t+1}(-1/2) = a2 + i b2 *)

(* Product: (a1 + ib1)(a2 + ib2) = (a1 a2 - b1 b2) + i(a1 b2 + a2 b1) *)

Print["=== DENOMINATOR PRODUCT ==="];
Print["Let a1 = -K1·cos(2πt), b1 = K1·sin(2πt) - π·I1"];
Print["Let a2 = -K2·cos(2πt), b2 = K2·sin(2πt) - π·I2\n"];

Print["Denominator = (a1 + i·b1)(a2 + i·b2)"];
Print["Re(denom) = a1·a2 - b1·b2"];
Print["Im(denom) = a1·b2 + a2·b1\n"];

(* Expand: *)
(* a1 a2 = K1 K2 cos²(2πt) *)
(* b1 b2 = (K1 sin - π I1)(K2 sin - π I2) *)
(*       = K1 K2 sin² - π K1 I2 sin - π K2 I1 sin + π² I1 I2 *)
(*       = K1 K2 sin² - π sin(K1 I2 + K2 I1) + π² I1 I2 *)

(* a1 a2 - b1 b2 = K1 K2 cos² - K1 K2 sin² + π sin(K1 I2 + K2 I1) - π² I1 I2 *)
(*              = K1 K2 (cos² - sin²) + π sin(K1 I2 + K2 I1) - π² I1 I2 *)
(*              = K1 K2 cos(4πt) + π sin(2πt)(K1 I2 + K2 I1) - π² I1 I2 *)

Print["=== EXPANDED FORMULAS ==="];
Print["Re(denom) = K1·K2·cos(4πt) + π·sin(2πt)·(K1·I2 + K2·I1) - π²·I1·I2\n"];

(* a1 b2 = -K1 cos · (K2 sin - π I2) = -K1 K2 cos sin + π K1 I2 cos *)
(* a2 b1 = -K2 cos · (K1 sin - π I1) = -K1 K2 cos sin + π K2 I1 cos *)
(* sum = -2 K1 K2 cos sin + π cos (K1 I2 + K2 I1) *)
(*     = -K1 K2 sin(4πt) + π cos(2πt)(K1 I2 + K2 I1) *)

Print["Im(denom) = -K1·K2·sin(4πt) + π·cos(2πt)·(K1·I2 + K2·I1)\n"];

(* Since numerator is real (-16πet), we have: *)
(* Re(g) = -16πet · Re(denom) / |denom|² *)
(* Im(g) = 16πet · Im(denom) / |denom|²  [note sign flip from 1/z] *)

Print["=== INTERSECTION CONDITIONS ===\n"];

Print["Since g(t) = -16πet / denom, and numerator is REAL:\n"];

Print["X-AXIS CROSSING (Im(g) = 0):"];
Print["⟺ Im(1/denom) = 0"];
Print["⟺ Im(denom) = 0"];
Print["⟺ -K1·K2·sin(4πt) + π·cos(2πt)·(K1·I2 + K2·I1) = 0"];
Print["⟺ K1·K2·sin(4πt) = π·cos(2πt)·(K1·I2 + K2·I1)"];
Print["⟺ 2·K1·K2·sin(2πt)·cos(2πt) = π·cos(2πt)·(K1·I2 + K2·I1)\n"];

Print["CASE 1: cos(2πt) = 0  ⟹  t = 1/4 + n/2  (n ∈ ℤ)\n"];

Print["CASE 2: cos(2πt) ≠ 0, then:"];
Print["2·K1·K2·sin(2πt) = π·(K1·I2 + K2·I1)"];
Print["sin(2πt) = π·(K1·I2 + K2·I1) / (2·K1·K2)\n"];

(* Verify Case 1 *)
Print["=== VERIFICATION OF CASE 1 ==="];
Table[
  t = 1/4 + n/2;
  gVal = g[t] // N;
  Print["t = ", t, ": g(t) = ", gVal, ", Im = ", Im[gVal]];
  , {n, -2, 2}
];

Print["\n=== VERIFICATION OF CASE 2 ==="];
(* At t where sin(2πt) = π(K1 I2 + K2 I1)/(2 K1 K2) *)
(* This is transcendental in t because K1, K2, I1, I2 all depend on t *)

(* Let's verify numerically that the formula works *)
testT = 0.37;  (* arbitrary test point *)
K1v = BesselK[2 testT - 1, 1/2] // N;
I1v = BesselI[2 testT - 1, 1/2] // N;
K2v = BesselK[2 testT + 1, 1/2] // N;
I2v = BesselI[2 testT + 1, 1/2] // N;

imDenomFormula = -K1v K2v Sin[4 Pi testT] + Pi Cos[2 Pi testT] (K1v I2v + K2v I1v);
imDenomDirect = Im[BesselK[2 testT - 1, -1/2] BesselK[2 testT + 1, -1/2]] // N;
Print["At t = ", testT, ":"];
Print["Im(denom) via formula: ", imDenomFormula];
Print["Im(denom) direct:      ", imDenomDirect];
Print["Match: ", Abs[imDenomFormula - imDenomDirect] < 10^-10, "\n"];

Print["=== Y-AXIS CROSSING (Re(g) = 0) ==="];
Print["⟺ Re(denom) = 0  (since numerator is real and nonzero for t≠0)"];
Print["⟺ K1·K2·cos(4πt) + π·sin(2πt)·(K1·I2 + K2·I1) - π²·I1·I2 = 0\n"];

Print["This is a transcendental equation mixing cos(4πt), sin(2πt),"];
Print["and Bessel functions of 2t±1. Generally no closed-form solution.\n"];

Print["=== SUMMARY OF SYMBOLIC CONDITIONS ===\n"];
Print["Let K1 = K_{2t-1}(1/2), K2 = K_{2t+1}(1/2)"];
Print["    I1 = I_{2t-1}(1/2), I2 = I_{2t+1}(1/2)\n"];

Print["X-AXIS (Im = 0):"];
Print["  t = 1/4 + n/2  (n ∈ ℤ)  [trivial family]"];
Print["  OR  sin(2πt) = π(K1·I2 + K2·I1)/(2·K1·K2)  [transcendental]\n"];

Print["Y-AXIS (Re = 0):"];
Print["  K1·K2·cos(4πt) + π·sin(2πt)·(K1·I2 + K2·I1) = π²·I1·I2  [transcendental]\n"];

Print["SELF-INTERSECTION g(t1) = g(t2):"];
Print["  By oddness: g(-t) = -g(t), so (t, -t) pairs give opposite points."];
Print["  Non-trivial: requires t1/(denom at t1) = t2/(denom at t2)"];
Print["  This is doubly transcendental - no closed form expected.\n"];
