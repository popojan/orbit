(* A runnable near-miss: the "smooth counting operator" and its irreducible
   arithmetic error, and the failure of any cheap perturbation to reach the
   true zeros.

   (A) diag(t_n), t_n = smooth zero position (RiemannSiegelTheta[t]/Pi + 1 = n):
       self-adjoint, density-exact, eigenvalues = t_n -- but t_n != gamma_n.
       The gap is the arithmetic fluctuation S(t) (the primes). RH-blind.
   (B) try to "fix" it with a uniform off-diagonal coupling beta (the cheapest
       prime-free perturbation): scan beta, minimize RMS error to gamma_n. A
       single knob cannot reproduce 50 structured arithmetic deviations.
   (C) the only operator that works is diag(gamma_n) itself -- trivially
       self-adjoint, trivially right, trivially CIRCULAR (the answer is the
       input). It proves nothing. *)

NN   = 40;
gam  = N[Im[ZetaZero[Range[NN]]]];          (* machine precision is ample here *)

(* ---- (A) smooth positions and the irreducible error ---- *)
(* asymptotic Riemann-Siegel theta (fast, elementary): theta(t)/Pi + 1 = n *)
thA[t_] := (t/2) Log[t/(2 Pi)] - t/2 - Pi/8;
tsmooth[n_] := t /. FindRoot[thA[t] == Pi (n - 1), {t, gam[[n]] + 1}];
tt  = Table[tsmooth[n], {n, NN}];
err = tt - gam;
Print["=== (A) smooth counting operator diag(t_n): right density, wrong values ==="];
Print[" n  : gamma_n (true) | t_n (smooth) | t_n - gamma_n (the arithmetic S)"];
Do[Print["  ", PaddedForm[n, 2], " : ", PaddedForm[N[gam[[n]], 7], {8, 4}],
    "  | ", PaddedForm[N[tt[[n]], 7], {8, 4}], "  | ",
    PaddedForm[N[err[[n]], 4], {6, 4}]], {n, {1, 2, 3, 5, 10, 20, 35, 40}}];
Print[" |t_n - gamma_n|:  mean ", N[Mean[Abs[err]], 4],
   "   max ", N[Max[Abs[err]], 4],
   "  -- does NOT shrink (it is S(t), the primes). Operator is RH-blind."];

(* ---- (B) cheapest prime-free fix: one uniform off-diagonal knob beta ---- *)
Print["\n=== (B) try to reach the zeros with a single coupling beta ==="];
offd = DiagonalMatrix[ConstantArray[1., NN - 1], 1] + DiagonalMatrix[ConstantArray[1., NN - 1], -1];
Dmat   = DiagonalMatrix[tt];
rms[beta_] := Module[{ev = Sort[Eigenvalues[Dmat + beta offd]]},
   Sqrt[Mean[(ev - Sort[gam])^2]]];
betas = Range[0, 30]/10;                     (* coarse scan, machine precision *)
scan  = Table[{beta, rms[beta]}, {beta, betas}];
Print[" beta : RMS( eig(diag(t)+beta*offdiag) - gamma )"];
Do[Print["  ", PaddedForm[v[[1]], {4, 2}], " : ", PaddedForm[v[[2]], {6, 4}]],
  {v, scan[[1 ;; ;; 5]]}];
bmin = MinimalBy[scan, Last][[1]];
Print[" best RMS over beta in [0,3]: beta*=", PaddedForm[bmin[[1]], {4, 2}],
   "  RMS=", PaddedForm[bmin[[2]], {6, 4}],
   "   (baseline beta=0: RMS=", PaddedForm[rms[0], {6, 4}],
   "). One knob cannot fit ", NN, " structured deviations."];

(* ---- (C) the only exact operator is circular ---- *)
Print["\n=== (C) the operator that works ==="];
Print[" diag(gamma_n): eigenvalues = gamma_n exactly -> self-adjoint, RH-true by"];
Print[" fiat. But the zeros were the INPUT: circular, proves nothing about their"];
Print[" reality. A meaningful operator must produce gamma_n FROM the primes with"];
Print[" provable self-adjointness -- the wall."];

Print["\n=== lesson ==="];
Print[" The smooth operator is the integrable skeleton: correct density, RH-blind."];
Print[" The gap to the true zeros is the arithmetic (S(t) = the prime sum)."];
Print[" No cheap (low-parameter) perturbation closes it; only the full arithmetic"];
Print[" does, and putting the zeros in by hand is circular. 'Finding the operator'"];
Print[" = generating that arithmetic perturbation from the prime cocycle, with the"];
Print[" critical ellipticity (zero Lyapunov) that keeps the spectrum real = RH."];
Print["DONE."];
