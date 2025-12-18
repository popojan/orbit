(* KLÍČOVÉ SPOJENÍ: Besselovy polynomy a konvergenty pro coth(1/2) *)

Print["=== BESSEL POLYNOMIALS = COTH(1/2) CONVERGENTS ===\n"];

(* Besselovy polynomy y_n(-2) *)
y[-1] = 0; y[0] = 1;
y[n_] := y[n] = (2 n - 1) (-2) y[n - 1] + y[n - 2];

(* CF pro coth(1/2) = [2; 6, 10, 14, 18, ...] *)
a[0] = 2; a[n_] := 4 n + 2;
p[-1] = 1; p[0] = 2;
q[-1] = 0; q[0] = 1;
p[n_] := p[n] = a[n] p[n - 1] + p[n - 2];
q[n_] := q[n] = a[n] q[n - 1] + q[n - 2];

Print["Comparison:"];
Print["n\t|y_n(-2)|\t\tp_n\t\tq_n"];
Print["---------------------------------------------------"];
Table[
  Print[n, "\t", Abs[y[n]], "\t\t", p[n], "\t\t", q[n]];
  , {n, 0, 8}
];

Print["\nObservation:"];
Print["  |y_n(-2)| appears to match p_{n-1} for coth(1/2)!"];

Print["\n  Check: |y_{n+1}(-2)| vs p_n"];
Print["  n\t|y_{n+1}(-2)|\tp_n\tmatch?"];
Table[
  yn1 = Abs[y[n + 1]];
  pn = p[n];
  Print["  ", n, "\t", yn1, "\t\t", pn, "\t", yn1 == pn];
  , {n, 0, 7}
];

Print["\n=== REKURENCE COMPARISON ==="];
Print["\nBessel polynomial recurrence:"];
Print["  y_n(-2) = -(4n-2) y_{n-1}(-2) + y_{n-2}(-2)"];

Print["\nCF convergent recurrence:"];
Print["  p_n = (4n+2) p_{n-1} + p_{n-2}"];

Print["\nWait! Different coefficients:"];
Print["  Bessel: -(4n-2) = -2, -6, -10, -14, ... for n=1,2,3,4,..."];
Print["  CF:      (4n+2) =  6, 10, 14, 18, ... for n=1,2,3,4,..."];

Print["\nShift relation:"];
Print["  Let Y_n = y_{n+1}(-2). Then:"];
Print["  Y_n = y_{n+1}(-2) = -(4(n+1)-2) y_n(-2) + y_{n-1}(-2)"];
Print["       = -(4n+2) Y_{n-1} + Y_{n-2}   (almost!)");

(* Zkusme signed verzi *)
Print["\n=== SIGNED VERSION ==="];
Print["  If we define Y_n = (-1)^{n+1} y_{n+1}(-2):"];
Table[
  Yn = (-1)^(n + 1) y[n + 1];
  Print["  Y_", n, " = (-1)^", n + 1, " y_", n + 1, "(-2) = ", Yn];
  , {n, 0, 7}
];

Print["\n  Compare Y_n with p_n:"];
Table[
  Yn = (-1)^(n + 1) y[n + 1];
  pn = p[n];
  Print["  Y_", n, " = ", Yn, ", p_", n, " = ", pn];
  , {n, 0, 7}
];

Print["\n  Hmm, signs alternate differently. Let me try another approach."];

