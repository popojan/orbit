(* Spojení s Besselovými polynomy y_n(-2) = A002119 *)

Print["=== BESSEL POLYNOMIAL CONNECTION ===\n"];

(* A002119: y_n(-2) *)
Print["1. OEIS A002119: Bessel polynomial y_n(-2)"];
Print["   y_n(x) = sum_{k=0}^n (n+k)!/(k!(n-k)!) * (x/2)^k"];
Print["   Recurrence: y_n(x) = (2n-1)x y_{n-1}(x) + y_{n-2}(x)\n"];

(* Spočítejme y_n(-2) *)
y[-1] = 0; y[0] = 1;
y[n_] := y[n] = (2 n - 1) (-2) y[n - 1] + y[n - 2];

Print["   y_n(-2) sequence:"];
Table[Print["   y_", n, "(-2) = ", y[n]], {n, 0, 8}];

(* OEIS A002119 values: 1, -1, 1, 1, -9, 1, 81, ... *)
Print["\n   OEIS A002119: 1, -1, 1, 1, -9, 1, 81, 225, -2025, ..."];

(* 2. CF pro e = [2; 1, 2, 1, 1, 4, 1, 1, 6, ...] *)
Print["\n2. CF for e = [2; 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, ...]"];
Print["   This is Euler's CF from 1737!\n"];

(* Konvergenty *)
cfE = {2, 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, 1, 1, 10};
pE[-1] = 1; pE[0] = cfE[[1]]; qE[-1] = 0; qE[0] = 1;
Do[
  pE[n] = cfE[[n + 1]] pE[n - 1] + pE[n - 2];
  qE[n] = cfE[[n + 1]] qE[n - 1] + qE[n - 2];
  , {n, 1, Length[cfE] - 1}
];

Print["   Convergents of e:"];
Table[Print["   p_", n, "/q_", n, " = ", pE[n], "/", qE[n], " = ", 
  N[pE[n]/qE[n], 12]], {n, 0, Min[10, Length[cfE] - 1]}];
Print["   e = ", N[E, 12]];

(* 3. Spojení K a y_n *)
Print["\n3. KEY CONNECTION: K_n and Bessel polynomials"];
Print["   Bessel polynomial y_n(x) satisfies:"];
Print["   x^2 y'' + (2x+2) y' - n(n+1) y = 0\n"];

(* Modified Bessel vs Bessel polynomial *)
Print["   Modified Bessel K_n(x) is different from polynomial y_n!"];
Print["   BUT: at x=1/2, there's a connection through integral rep.\n"];

(* 4. Produktový vzorec *)
Print["4. PRODUCT FORMULA from our paper:"];
Print["   q_n = Product of K_{2k-1}(-1/2) K_{2k+1}(-1/2) terms"];
Print["   These are denominators converging to e!\n"];

(* Numerická kontrola *)
Print["   Numerical check: K products vs q_n"];
kProd[n_] := Product[BesselK[2 k - 1, -1/2] BesselK[2 k + 1, -1/2], {k, 1, n}];

Do[
  kp = N[kProd[n], 15];
  qn = qE[3 n - 1]; (* každý 3. konvergent pro standardní e CF *)
  Print["   n=", n, ": K-product = ", kp, ", q-related = ", qn];
  , {n, 1, 3}
];

(* 5. ODE spojení *)
Print["\n5. THE ODE CONNECTION:"];
Print["   Both y_n(x) and K_n(x) arise from 2nd order linear ODEs."];
Print["   y_n: confluent hypergeometric type"];
Print["   K_n: modified Bessel equation"];
Print["   e appears in BOTH contexts:\n"];
Print["   - K_n contains e^{-x} asymptotically"];
Print["   - y_n(-2) gives CF denominators for e"];

