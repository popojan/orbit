(* Analýza tříčlenných rekurencí *)

Print["=== THREE-TERM RECURRENCE ANALYSIS ===\n"];

(* CF rekurence pro coth(1/2) = [2; 6, 10, 14, ...] *)
Print["1. CF RECURRENCE for coth(1/2) = [2; 6, 10, 14, ...]"];
Print["   a_0 = 2, a_n = 4n + 2 for n ≥ 1"];
Print["   p_n = a_n p_{n-1} + p_{n-2}, p_{-1}=1, p_0=2"];
Print["   q_n = a_n q_{n-1} + q_{n-2}, q_{-1}=0, q_0=1\n"];

(* Spočítejme konvergenty *)
a[0] = 2; a[n_] := 4 n + 2;
p[-1] = 1; p[0] = 2;
q[-1] = 0; q[0] = 1;
p[n_] := p[n] = a[n] p[n - 1] + p[n - 2];
q[n_] := q[n] = a[n] q[n - 1] + q[n - 2];

Print["   Convergents p_n/q_n:"];
Table[Print["   n=", n, ": p_", n, "=", p[n], ", q_", n, "=", q[n], 
  ", ratio=", N[p[n]/q[n], 10]], {n, 0, 6}];

Print["\n   coth(1/2) = ", N[Coth[1/2], 10]];

(* Bessel rekurence *)
Print["\n2. BESSEL RECURRENCE at x = -1/2:"];
Print["   K_{ν+1} = -4ν K_ν + K_{ν-1}"];
Print["   K_{-ν} = K_ν (symmetry)\n"];

Print["   Values K_n(-1/2):"];
Table[
  k = N[BesselK[n, -1/2], 10];
  Print["   K_", n, "(-1/2) = ", k];
  , {n, 0, 6}
];

(* Ověřme rekurenci *)
Print["\n   Verify recurrence:"];
Table[
  lhs = N[BesselK[n + 1, -1/2], 15];
  rhs = N[-4 n BesselK[n, -1/2] + BesselK[n - 1, -1/2], 15];
  Print["   K_", n + 1, " = -4·", n, "·K_", n, " + K_", n - 1, 
    " ? LHS=", lhs, ", RHS=", rhs, ", match=", Abs[lhs - rhs] < 10^-10];
  , {n, 1, 4}
];

(* 3. Hledejme spojení *)
Print["\n3. SEARCHING FOR CONNECTION:"];
Print["   CF coefficients: 2, 6, 10, 14, 18, 22 = 2 + 4n"];
Print["   Bessel coeff -4ν at odd ν=1,3,5,7: -4, -12, -20, -28 = -4(2m-1)\n"];

(* Absolutní hodnoty *)
Print["   |Bessel coeff| at odd ν=2m-1: 4(2m-1) = 8m - 4"];
Print["   CF coeff at position m: 4m + 2"];
Print["   Difference: (4m+2) - (8m-4) = 6 - 4m ... not constant!\n"];

(* Zkusme jiný přístup: Miller's algorithm *)
Print["4. ALTERNATIVE: Consider K as solution to recurrence"];
Print["   K_{n+1} + 4n K_n - K_{n-1} = 0  (rearranged)");
Print["   Characteristic equation: r² + 4n·r - 1 = 0");
Print["   This is NOT a constant-coefficient recurrence!\n"];

(* 5. Spojení přes Bessel polynomy *)
Print["5. CONNECTION via BESSEL POLYNOMIALS"];
Print["   y_n(x) = Σ_{k=0}^n (n+k)!/(k!(n-k)!) (x/2)^k"];
Print["   OEIS A001497 (signed), A001498 (unsigned)"];
Print["   q_n in CF for e are related to Bessel polynomials y_n(-2)!\n"];

Print["   OEIS A002119: Bessel polynomial y_n(-2)"];
bessel[0] = 1; bessel[1] = -1;
bessel[n_] := bessel[n] = -(4 n - 2) bessel[n - 1] - bessel[n - 2];

Print["   Bessel polynomials y_n(-2):"];
Table[Print["   y_", n, "(-2) = ", bessel[n]], {n, 0, 8}];

Print["\n   Compare with our q_n:"];
Table[Print["   q_", n, " = ", q[n]], {n, 0, 8}];

(* Jsou to stejné? *)
Print["\n   Are they the same? Let's check ratio:"];
Table[
  If[bessel[n] != 0, 
    Print["   q_", n, "/y_", n, "(-2) = ", q[n]/bessel[n]],
    Print["   q_", n, "/y_", n, "(-2) = undef (y_n=0)"]
  ];
  , {n, 0, 6}
];

