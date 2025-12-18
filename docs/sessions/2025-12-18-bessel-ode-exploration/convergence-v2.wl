(* Corrected convergence comparison *)

Print["=== CONVERGENCE TO e: METHOD COMPARISON ===\n"];

(* coth(1/2) = (e+1)/(e-1) = [2; 6, 10, 14, ...] *)
cothCF = {2} ~Join~ Table[4 k + 2, {k, 1, 100}];

(* Get convergents *)
getConvergents[n_] := Convergents[cothCF, n + 1][[-1]];

(* From p/q = (e+1)/(e-1), we get e = (p+q)/(p-q) *)
eFromCF[n_] := Module[{c = getConvergents[n], p, q},
  p = Numerator[c]; q = Denominator[c];
  (p + q)/(p - q)
];

Print["=== coth(1/2) CONTINUED FRACTION ==="];
Print["CF = [2; 6, 10, 14, 18, ...] = [2; 4k+2]"];
Print["Denominators q_n = |y_n(-2)| (Bessel polynomials!)\n"];

Table[
  c = getConvergents[n];
  p = Numerator[c]; q = Denominator[c];
  eApprox = (p + q)/(p - q);
  err = Abs[N[eApprox - E, 100]];
  digits = If[err == 0, ">99", Round[-Log10[err], 0.1]];
  Print["n=", n, ": q_n=", q, " (", IntegerLength[q], " digit",
        If[IntegerLength[q] > 1, "s", ""], "), accuracy: ", digits, " digits"];
  , {n, 1, 12}
];

Print["\n=== COMPARISON: TERMS FOR TARGET ACCURACY ===\n"];

(* Taylor series *)
taylorPartial[n_] := Sum[1/k!, {k, 0, n}];

Print["Target\tTaylor\tcoth CF\tRatio"];
Print["-" ~StringRepeat~ 40];

Table[
  nTaylor = SelectFirst[Range[200],
    Abs[N[taylorPartial[#] - E, d + 10]] < 10^(-d) &];
  nCF = SelectFirst[Range[100],
    Abs[N[eFromCF[#] - E, d + 10]] < 10^(-d) &];

  ratio = If[nCF > 0, N[nTaylor/nCF, 3], "∞"];
  Print[d, " digits\t", nTaylor, "\t", nCF, "\t", ratio, "×"];
  , {d, {10, 20, 30, 50, 100}}
];

Print["\n=== THEORETICAL ANALYSIS ===\n"];

Print["Taylor series: e = Σ 1/n!"];
Print["  Error after n terms: ~ 1/(n+1)!"];
Print["  For d digits: need n ~ d·ln(10)/ln(n) ~ 1.1·d terms\n"];

Print["coth(1/2) CF: [2; 6, 10, 14, ...]"];
Print["  Denominators q_n ~ |y_n(-2)| ~ (2n-1)!! / 2^n"];
Print["  Error: ~ 1/q_n² (standard CF theory)"];
Print["  For d digits: need n ~ d/2.7 terms\n"];

Print["Ratio: CF needs ~2.5× fewer terms than Taylor!"];

Print["\n=== WHY coth CF IS SUPERIOR ===\n"];

Print["The CF denominators grow as double factorial:"];
Table[
  q = Abs[Denominator[getConvergents[n]]];
  dfact = (2 n - 1)!! / 2^n // N;
  ratio = q / dfact // N;
  Print["n=", n, ": q_n = ", q, ", (2n-1)!!/2^n ≈ ", Round[dfact],
        ", ratio ≈ ", Round[ratio, 0.01]];
  , {n, 2, 8}
];

Print["\nDouble factorial grows faster than n! asymptotically:"];
Print["  (2n-1)!! = (2n)! / (2^n n!) ~ √2 (2n/e)^n √(πn)"];
Print["  So q_n² grows ~super-exponentially → ultra-fast convergence"];
