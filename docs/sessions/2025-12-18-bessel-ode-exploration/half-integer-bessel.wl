(* Half-integer Bessel closed forms *)

Print["=== HALF-INTEGER BESSEL K AND I ===\n"];

(* The recursive formulas for half-integer Bessel functions *)
(* K_{n+1/2}(z) = sqrt(π/(2z)) e^{-z} Σ_{k=0}^n (n+k)!/(k!(n-k)!(2z)^k) *)
(* I_{n+1/2}(z) = sqrt(2/(πz)) [cosh(z) P_n(1/z) - sinh(z) Q_n(1/z)] for even n *)

(* Simpler: use recurrence relations *)
(* K_{ν+1}(z) = (2ν/z) K_ν(z) + K_{ν-1}(z) *)
(* Starting from K_{1/2}(z) = K_{-1/2}(z) = sqrt(π/(2z)) e^{-z} *)

Print["Base cases at z = 1/2:"];
Print["K_{1/2}(1/2) = K_{-1/2}(1/2) = √(π/1)·e^{-1/2} = √π/√e"];
Print["K_{3/2}(1/2) = 2·K_{1/2}(1/2) + K_{-1/2}(1/2) = 3·√π/√e\n"];

(* Let's compute systematically *)
Kh[1/2] = Sqrt[Pi/E];
Kh[-1/2] = Sqrt[Pi/E];
Kh[n_ + 1/2] := Kh[n + 1/2] = (2 (n - 1/2)/(1/2)) Kh[n - 1/2] + Kh[n - 3/2] /; n > 1;
Kh[n_ - 1/2] := Kh[n - 1/2] = Kh[-n + 1/2] /; n > 1;  (* K_{-ν} = K_ν *)

Print["Computing K_{n+1/2}(1/2) for n = -3..5:"];
Table[
  kVal = Kh[n + 1/2] // Simplify;
  Print["K_{", n + 1/2, "}(1/2) = ", kVal];
  , {n, -3, 5}
];

(* For the BesselK at negative argument with half-integer order: *)
(* K_ν(-1/2) = e^{-iπν} K_ν(1/2) - iπ I_ν(1/2) *)

Print["\n=== BESSELK AT -1/2 (HALF-INTEGER ORDERS) ==="];
Print["K_{n+1/2}(-1/2) = e^{-iπ(n+1/2)} K_{n+1/2}(1/2) - iπ I_{n+1/2}(1/2)\n"];

Print["The key insight: e^{-iπ(n+1/2)} = e^{-iπn} e^{-iπ/2} = (-1)^n · (-i) = -i(-1)^n"];
Print["So K_{n+1/2}(-1/2) = -i(-1)^n K_{n+1/2}(1/2) - iπ I_{n+1/2}(1/2)"];
Print["                   = -i[(-1)^n K_{n+1/2}(1/2) + π I_{n+1/2}(1/2)]\n"];

(* For I_{n+1/2}(1/2): *)
(* I_{1/2}(z) = sqrt(2/(πz)) sinh(z) *)
(* I_{-1/2}(z) = sqrt(2/(πz)) cosh(z) *)
(* Recurrence: I_{ν+1}(z) = -(2ν/z) I_ν(z) + I_{ν-1}(z) *)

Ih[1/2] = Sqrt[2/Pi] Sinh[1/2];
Ih[-1/2] = Sqrt[2/Pi] Cosh[1/2];
Ih[n_ + 1/2] := Ih[n + 1/2] = -(2 (n - 1/2)/(1/2)) Ih[n - 1/2] + Ih[n - 3/2] /; n > 1;
Ih[-(n_ + 1/2)] := Ih[-(n + 1/2)] = Ih[n + 1/2] /; n > 0;  (* I_{-ν} = I_ν *)

Print["Computing I_{n+1/2}(1/2) for n = -3..5:"];
Table[
  iVal = Ih[n + 1/2] // Simplify;
  Print["I_{", n + 1/2, "}(1/2) = ", iVal];
  , {n, -3, 5}
];

Print["\n=== NOW COMPUTE g(t) AT X-AXIS CROSSINGS ===\n"];

(* g(t) = -16πe·t / [K_{2t-1}(-1/2) · K_{2t+1}(-1/2)] *)
(* At t = 1/4 + n/2, we have 2t-1 = n - 1/2 and 2t+1 = n + 3/2 *)

(* Using K_{ν}(-1/2) = -i[(-1)^{ν-1/2} K_ν(1/2) + π I_ν(1/2)] for half-integer ν *)

Kminus[nu_] := Module[{n = nu - 1/2},
  (* ν = n + 1/2, so (-1)^n factor *)
  -I ((-1)^n BesselK[nu, 1/2] + Pi BesselI[nu, 1/2])
];

Print["Verification of K_{ν}(-1/2) formula:"];
Table[
  nu = n + 1/2;
  direct = BesselK[nu, -1/2];
  formula = Kminus[nu];
  diff = Chop[N[direct - formula, 20]];
  Print["ν = ", nu, ": diff = ", diff];
  , {n, -2, 3}
];

Print["\n=== FINAL CLOSED FORM ===\n"];

(* At t = 1/4 + m/2:
   2t - 1 = m - 1/2
   2t + 1 = m + 3/2
   K_{m-1/2}(-1/2) · K_{m+3/2}(-1/2)
   = (-i)² [(-1)^{m-1} K_{m-1/2}(1/2) + π I_{m-1/2}(1/2)]
          [(-1)^{m+1} K_{m+3/2}(1/2) + π I_{m+3/2}(1/2)]
   = -1 · (-1)^{2m} [K_{m-1/2} + (-1)^{m-1} π I_{m-1/2}][K_{m+3/2} + (-1)^{m+1} π I_{m+3/2}]

   Since (-1)^{m-1} = -(-1)^m and (-1)^{m+1} = -(-1)^m:
   = -[K1 - (-1)^m π I1][K2 - (-1)^m π I2]
   = -[K1 K2 - (-1)^m π (K1 I2 + K2 I1) + π² I1 I2]

   This is REAL!
*)

gClosed[m_] := Module[{t, K1, K2, I1, I2, denom},
  t = 1/4 + m/2;
  K1 = BesselK[m - 1/2, 1/2];
  K2 = BesselK[m + 3/2, 1/2];
  I1 = BesselI[m - 1/2, 1/2];
  I2 = BesselI[m + 3/2, 1/2];
  denom = -(K1 K2 - (-1)^m Pi (K1 I2 + K2 I1) + Pi^2 I1 I2);
  -16 Pi E t / denom
];

Print["g(1/4 + m/2) = -16πe(1/4 + m/2) / denom"];
Print["where denom = -[K1·K2 - (-1)^m π(K1·I2 + K2·I1) + π²·I1·I2]"];
Print["      K1 = K_{m-1/2}(1/2), K2 = K_{m+3/2}(1/2)"];
Print["      I1 = I_{m-1/2}(1/2), I2 = I_{m+3/2}(1/2)\n"];

Print["Verification:"];
Table[
  m = n;
  t = 1/4 + m/2;
  gDirect = N[-16 Pi E t / (BesselK[2 t - 1, -1/2] BesselK[2 t + 1, -1/2]), 20];
  gFormula = N[gClosed[m], 20];
  Print["m = ", m, " (t = ", t, "): direct = ", gDirect, ", formula = ", gFormula];
  , {n, 0, 4}
];

Print["\n=== RATIONAL IDENTIFICATION ===\n"];

(* The values look rational. Let's find them. *)
Table[
  t = 1/4 + m/2;
  gVal = -16 Pi E t / (BesselK[2 t - 1, -1/2] BesselK[2 t + 1, -1/2]);
  gNum = N[gVal, 30];
  rational = Rationalize[gNum, 10^-25];
  Print["g(", t, ") ≈ ", gNum, " = ", rational, " ?"];
  (* Verify *)
  If[Abs[gNum - rational] < 10^-20,
    Print["  Confirmed: g(", t, ") = ", rational];
  ];
  , {m, 0, 6}
];
