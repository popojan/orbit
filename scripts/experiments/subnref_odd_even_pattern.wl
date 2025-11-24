#!/usr/bin/env wolframscript
(* Quick check: odd/even pattern in subnref and connection to ΔU *)

Print["=== SUBNREF ODD/EVEN PATTERN CHECK ===\n"];

(* User's subnref formula *)
a[k_, n_] := 1/4 (1 + 3 (-1)^k) (-1 + 2 n^2 + k) (-1)^n (2^(-3 + 2 k) (-3 + (-1)^k))/Gamma[2 k] Pochhammer[n - k + 2, 2 (k - 2) + 1];
subnref[x_, k_] := Sum[a[i, k] x^(2 i - 1), {i, 1, k + 1}];

Print["Known: subnref[x, k] = T_{2k+1}(x) - x*T_{2k}(x)\n"];
Print[];

Print["Part 1: Check both T_{odd} - x*T_{even} and T_{even} - x*T_{odd}\n"];

Do[
  (* Odd case: T_{k+1} - x*T_k where k is even *)
  k_even = 2*j;
  odd_case = ChebyshevT[k_even+1, x] - x*ChebyshevT[k_even, x] // Expand;

  (* Even case: T_{k+1} - x*T_k where k is odd *)
  k_odd = 2*j + 1;
  even_case = ChebyshevT[k_odd+1, x] - x*ChebyshevT[k_odd, x] // Expand;

  Print["j=", j];
  Print["  ODD:  T_{", k_even+1, "} - x*T_{", k_even, "} = ", odd_case];
  Print["  EVEN: T_{", k_odd+1, "} - x*T_{", k_odd, "} = ", even_case];

  (* Check if subnref matches odd case *)
  If[j >= 1,
    subn_val = subnref[x, j] // Expand;
    Print["  subnref[x,", j, "] = ", subn_val];
    match = Simplify[subn_val - odd_case] == 0;
    Print["  Match with ODD: ", match];
  ];
  Print[];
, {j, 1, 3}];

Print["Part 2: Look for pattern in coefficients\n"];

Print["For T_{2k+1} - x*T_{2k} (subnref works):\n"];
Do[
  poly = subnref[x, kval] // Expand;
  coeffs = CoefficientList[poly, x];
  Print["k=", kval, ": ", coeffs, " (odd powers only)"];
, {kval, 1, 3}];

Print["\nFor T_{2k} - x*T_{2k-1} (need to derive):\n"];
Do[
  k_test = 2*kval;
  poly = ChebyshevT[k_test, x] - x*ChebyshevT[k_test-1, x] // Expand;
  coeffs = CoefficientList[poly, x];
  Print["k=", k_test, ": ", coeffs];
, {kval, 1, 3}];

Print["\n"];

Print["Part 3: Connection to U_m - U_{m-1}\n"];

Print["From mutual recurrence:\n"];
Print["  T_{k+1} - x*T_k = -(1-x²)*U_{k-1}\n"];
Print["  Therefore: U_{k-1} = -[T_{k+1} - x*T_k]/(1-x²)\n"];
Print[];

Print["For ΔU_m = U_m - U_{m-1}:\n"];
Print["  U_m = -[T_{m+2} - x*T_{m+1}]/(1-x²)\n"];
Print["  U_{m-1} = -[T_{m+1} - x*T_m]/(1-x²)\n"];
Print["  ΔU_m = -[(T_{m+2} - x*T_{m+1}) - (T_{m+1} - x*T_m)]/(1-x²)\n"];
Print["       = -[T_{m+2} - x*T_{m+1} - T_{m+1} + x*T_m]/(1-x²)\n"];
Print["       = -[T_{m+2} - (x+1)*T_{m+1} + x*T_m]/(1-x²)\n"];
Print[];

Print["Test for m=2:\n"];
m = 2;
lhs = ChebyshevU[m, x] - ChebyshevU[m-1, x] // Expand;
rhs = -((ChebyshevT[m+2, x] - (x+1)*ChebyshevT[m+1, x] + x*ChebyshevT[m, x]) / (1-x^2)) // Expand;

Print["ΔU_", m, " (direct): ", lhs];
Print["Via mutual rec:      ", rhs];
Print["Match: ", Simplify[lhs - rhs] == 0];
Print[];

Print["Part 4: Can subnref help with shifted argument?\n"];

Print["Our problem needs ΔU_m(x+1) = U_m(x+1) - U_{m-1}(x+1)\n"];
Print[];

Print["From mutual recurrence at y=x+1:\n"];
Print["  U_{m-1}(x+1) = -[T_m(x+1) - (x+1)*T_{m-1}(x+1)] / (1-(x+1)²)\n"];
Print["               = -[T_m(x+1) - (x+1)*T_{m-1}(x+1)] / (-x²-2x)\n"];
Print["               = [T_m(x+1) - (x+1)*T_{m-1}(x+1)] / (x(x+2))\n"];
Print[];

Print["For m=2 shifted:\n"];
m = 2;
lhs_shift = ChebyshevU[m-1, x+1] // Expand;
rhs_shift = (ChebyshevT[m, x+1] - (x+1)*ChebyshevT[m-1, x+1]) / (x*(x+2)) // Expand;

Print["U_", m-1, "(x+1) = ", lhs_shift];
Print["Via mutual rec: ", rhs_shift];
match_shift = Simplify[lhs_shift - rhs_shift] == 0;
Print["Match: ", match_shift];
Print[];

Print["Part 5: KEY QUESTION\n"];

Print["Can we express T_n(x+1) * [U_m(x+1) - U_{m-1}(x+1)] using mutual recurrence?\n"];
Print[];

Print["If ΔU_m(x+1) can be written as linear combination of\n"];
Print["mutual recurrence terms with explicit (Pochhammer) coefficients,\n"];
Print["then convolution T_n * ΔU_m might simplify!\n"];
Print[];

Print["=== QUICK ASSESSMENT ===\n"];
Print["✓ Mutual recurrence relates T and U\n"];
Print["✓ subnref gives explicit coefficients for odd U indices\n"];
Print["✓ ΔU_m expressible via mutual recurrence\n"];
Print["✗ BUT: Division by (1-x²) or x(x+2) complicates coefficients\n"];
Print["✗ AND: Need convolution of these expressions\n"];
Print[];
Print["Verdict: INTERESTING but probably AS COMPLEX as direct binomial proof.\n"];
Print["Might give different insight, but not necessarily faster.\n"];
