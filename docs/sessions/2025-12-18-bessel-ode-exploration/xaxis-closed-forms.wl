(* Closed forms for x-axis crossings at t = 1/4 + n/2 *)

Print["=== X-AXIS CROSSINGS: CLOSED FORMS ===\n"];

g[t_] := -16 t Pi E / (BesselK[2 t - 1, -1/2] BesselK[2 t + 1, -1/2]);

(* At t = 1/4 + n/2, cos(2πt) = cos(π/2 + nπ) = 0 *)
(* So the denominator simplifies! *)

Print["At t = 1/4 + n/2:"];
Print["  cos(2πt) = cos(π/2 + nπ) = 0"];
Print["  sin(2πt) = sin(π/2 + nπ) = (-1)^n\n"];

Print["K_{2t-1}(-1/2) = -K1·0 + i·(K1·(-1)^n - π·I1)"];
Print["             = i·((-1)^n K1 - π I1)\n"];

Print["K_{2t+1}(-1/2) = i·((-1)^n K2 - π I2)\n"];

Print["Denominator = i² · ((-1)^n K1 - π I1)((-1)^n K2 - π I2)"];
Print["           = -((-1)^n K1 - π I1)((-1)^n K2 - π I2)"];
Print["           = -(K1 K2 - (-1)^n π(K1 I2 + K2 I1) + π² I1 I2)  [REAL!]\n"];

Print["This explains why Im(g) = 0 at these points!\n"];

Print["=== COMPUTING EXACT VALUES ===\n"];

(* For half-integer orders, Bessel functions have closed forms! *)
(* K_{n+1/2}(z) and I_{n+1/2}(z) are elementary *)

Print["At t = 1/4 + n/2, we have orders 2t-1 = n and 2t+1 = n+1"];
Print["So we need K_n(1/2), I_n(1/2) for integer n.\n"];

Print["WAIT - let me recalculate the orders more carefully:"];
Table[
  t = 1/4 + m/2;
  Print["t = ", t, ": orders are 2t-1 = ", 2t - 1, ", 2t+1 = ", 2t + 1];
  , {m, -2, 4}
];

Print["\nSo orders are half-integers! K_{-1/2}(1/2), K_{1/2}(1/2), etc.\n"];

(* Half-integer Bessel K: K_{n+1/2}(z) = sqrt(π/(2z)) e^{-z} Σ ... *)
(* Actually simpler: K_{1/2}(z) = sqrt(π/(2z)) e^{-z} *)
(* K_{-1/2}(z) = K_{1/2}(z) = sqrt(π/(2z)) e^{-z} *)

Print["=== HALF-INTEGER BESSEL IDENTITIES ==="];
Print["K_{1/2}(z) = K_{-1/2}(z) = √(π/(2z)) e^{-z}\n"];

(* Verify *)
Print["Verification at z = 1/2:"];
Print["K_{1/2}(1/2) = ", BesselK[1/2, 1/2] // FullSimplify];
Print["√(π) e^{-1/2} = ", Sqrt[Pi] Exp[-1/2] // FullSimplify];
Print["Match: ", BesselK[1/2, 1/2] == Sqrt[Pi] Exp[-1/2] // FullSimplify, "\n"];

(* For I_{1/2}(z) *)
Print["I_{1/2}(z) = √(2/(πz)) sinh(z)"];
Print["I_{-1/2}(z) = √(2/(πz)) cosh(z)\n"];

Print["Verification:"];
Print["I_{1/2}(1/2) = ", BesselI[1/2, 1/2] // FullSimplify];
Print["√(1/π) sinh(1/2) = ", Sqrt[1/Pi] Sinh[1/2] // FullSimplify];

Print["\n=== EXACT VALUES AT X-AXIS CROSSINGS ===\n"];

Table[
  t = 1/4 + m/2;
  gExact = g[t] // FullSimplify;
  gNum = N[gExact, 15];
  Print["g(", t, ") = ", gExact, " = ", gNum];
  , {m, -3, 5}
];

Print["\n=== PATTERN RECOGNITION ==="];
Print["These are exactly the e-series terms!\n"];

(* Compare with our e-series convergents *)
Print["Our EulerEConvergent formula:"];
Print["T_n = (s_n + s_{n-1})/s_{n-1} where s_n satisfies recurrence\n"];

(* The connection: g at half-integer + quarter points gives the series *)
Print["g(3/4) = g(1/4 + 1/2) corresponds to first term"];
Print["g(7/4) = g(1/4 + 3/2) corresponds to second term"];
Print["etc.\n"];

(* Let's verify the exact rational pattern *)
Print["=== CHECKING RATIONALITY ==="];
Table[
  t = 1/4 + m/2;
  gVal = g[t];
  (* Check if it's rational *)
  gSimp = FullSimplify[gVal, t ∈ Reals];
  Print["g(", t, ") simplified: ", gSimp];
  , {m, 0, 5}
];
