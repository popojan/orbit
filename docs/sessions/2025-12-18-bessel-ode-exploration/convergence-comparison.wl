(* Comparison of convergence rates to e *)

Print["=== CONVERGENCE RATE COMPARISON ===\n"];

(* 1. Taylor series: e = Σ 1/n! *)
taylorPartial[n_] := Sum[1/k!, {k, 0, n}];

(* 2. Bessel polynomial: y_n(1)/[(2n-1)!!] → e *)
y[0, x_] := 1;
y[1, x_] := 1 + x;
y[n_, x_] := y[n, x] = (2 n - 1) x y[n - 1, x] + y[n - 2, x];
besselApprox[n_] := y[n, 1]/(2 n - 1)!!;

(* 3. coth(1/2) continued fraction: convergents p_n/q_n *)
(* coth(1/2) = (e+1)/(e-1) = [2; 6, 10, 14, ...] *)
cothCF = {2} ~Join~ Table[4 k + 2, {k, 1, 200}];
convergentsCoth[n_] := Convergents[cothCF, n + 1][[-1]];
(* From p/q = (e+1)/(e-1), we get e = (p+q)/(p-q) *)
eFromCoth[n_] := Module[{c = convergentsCoth[n], p, q},
  p = Numerator[c]; q = Denominator[c];
  (p + q)/(p - q)
];

(* 4. Our monotone series (Brothers' formula related) *)
(* e = 3 + Σ_{k=1}^∞ 1/((k+1)! - k!) - simplified form *)
monotonePartial[n_] := 3 + Sum[1/((k + 1)! - k!), {k, 1, n}];

Print["=== ERROR COMPARISON (digits of accuracy) ===\n"];
Print["n\tTaylor\t\tBessel\t\tcoth CF\t\tMonotone"];
Print["-" ~StringRepeat~ 70];

Table[
  eTaylor = taylorPartial[n];
  eBessel = besselApprox[n];
  eCoth = eFromCoth[n];
  eMono = monotonePartial[n];

  errTaylor = Abs[N[eTaylor - E, 50]];
  errBessel = Abs[N[eBessel - E, 50]];
  errCoth = Abs[N[eCoth - E, 50]];
  errMono = Abs[N[eMono - E, 50]];

  (* Convert to digits of accuracy *)
  digitsTaylor = If[errTaylor == 0, ">50", Round[-Log10[errTaylor], 0.1]];
  digitsBessel = If[errBessel == 0, ">50", Round[-Log10[errBessel], 0.1]];
  digitsCoth = If[errCoth == 0, ">50", Round[-Log10[errCoth], 0.1]];
  digitsMono = If[errMono == 0, ">50", Round[-Log10[errMono], 0.1]];

  Print["n=", n, "\t", digitsTaylor, "\t\t", digitsBessel, "\t\t",
        digitsCoth, "\t\t", digitsMono];
  , {n, {5, 10, 15, 20, 25, 30, 40, 50}}
];

Print["\n=== CONVERGENCE RATE ANALYSIS ===\n"];

(* Theoretical rates *)
Print["Taylor: error ~ 1/(n+1)! → ~n digits at n terms"];
Print["Bessel: error ~ O(1/n) correction to e^{1/x}"];
Print["coth CF: error ~ O(q_n^{-2}) where q_n ~ (2n-1)!! for large n"];
Print["Monotone: error ~ 1/((n+1)!-n!) ~ 1/(n·n!)"];

Print["\n=== TERMS NEEDED FOR 10, 20, 50 DIGITS ===\n"];

targetDigits = {10, 20, 50};
Table[
  (* Find n needed for each method *)
  nTaylor = SelectFirst[Range[100], Abs[N[taylorPartial[#] - E, 60]] < 10^(-d) &];
  nBessel = SelectFirst[Range[200], Abs[N[besselApprox[#] - E, 60]] < 10^(-d) &];
  nCoth = SelectFirst[Range[200], Abs[N[eFromCoth[#] - E, 60]] < 10^(-d) &];
  nMono = SelectFirst[Range[100], Abs[N[monotonePartial[#] - E, 60]] < 10^(-d) &];

  Print[d, " digits: Taylor=", nTaylor, ", Bessel=", nBessel,
        ", coth CF=", nCoth, ", Monotone=", nMono];
  , {d, targetDigits}
];

Print["\n=== ASYMPTOTIC GROWTH OF DENOMINATORS ===\n"];
Print["coth CF denominators (related to y_n(-2)):"];
Table[
  c = convergentsCoth[n];
  q = Denominator[c];
  Print["q_", n, " has ", IntegerLength[q], " digits"];
  , {n, {5, 10, 15, 20}}
];
