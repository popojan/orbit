(* 20: How does the box average of the UNTRUNCATED log zeta close?
   Hypotheses (stated before running):
   H1 (Littlewood/FTC closure): with G[tau] = Integrate[Log Zeta[sigma+I tau], {sigma,1/2,inf}],
       Integrate[Log Zeta[1/2+I x], {x, t-w, t+w}] == I (G[t+w] - G[t-w])
       -- i.e. the t-box average closes as a DIFFERENCE OF SIGMA-RAY INTEGRALS at the two
       window endpoints (contour: rectangle [1/2,inf)x[t-w,t+w], no pole inside, RH-zero
       terms vanish on the line; Im part is Littlewood's S1(t) = (1/pi) Int log|zeta| dsigma,
       attribution recalled, standard: Littlewood 1924 / Titchmarsh ch. 9).
       Expect agreement to NIntegrate tolerance both for a zero-free window and for a
       window CONTAINING a zero (both sides finite; log singularity integrable).
       Caveat: principal Log must be wrap-free on the contour -- checked by sampling.
   H2 (value at a zero): the smoothed modulus half at a zero closes locally as
       (1/2w) Int_{g-w}^{g+w} log|zeta(1/2+ix)| dx  =  log|zeta'(rho)| + log w - 1 + O(w^2),
       i.e. box-averaging converts the -inf spike into a finite dip of computable depth.
   H3 (prime side does NOT close): the all-primes dilog/sinc series inherits the
       divergence of log zeta's Dirichlet series on the line (pole term e^{v/2} beats the
       algebraic sinc ~ 1/(w v) damping) -- analytic, printed for the record, not computed. *)

wp = 30; pg = 12;
G[tau_?NumericQ] := NIntegrate[Log[Zeta[s + I tau]], {s, 1/2, 40},
    WorkingPrecision -> wp, PrecisionGoal -> pg, MaxRecursion -> 15];

wrapFree[t0_, w_] := Module[{args, d},
   args = Table[Arg[Zeta[1/2 + I x]], {x, t0 - w, t0 + w, 2 w/400.}];
   d = Max[Abs[Differences[args]]]; d < Pi];

vert[t0_, w_, sing_: {}] := NIntegrate[Log[Zeta[1/2 + I x]],
    Evaluate[Flatten[{x, t0 - w, Sort[sing], t0 + w}]],
    WorkingPrecision -> wp, PrecisionGoal -> pg, MaxRecursion -> 15];

Print["== H1: t-box of log zeta on the line == I*(G[t+w]-G[t-w]) =="];
g2 = N[Im[ZetaZero[2]], wp];   (* 21.022... *)
Do[Module[{t0 = c[[1]], w = c[[2]], sing = c[[3]], lhs, rhs},
   Print["  window t=", t0, " w=", w, "  wrap-free: ", wrapFree[t0, w]];
   lhs = vert[t0, w, sing];
   rhs = I (G[t0 + w] - G[t0 - w]);
   Print["    LHS (vertical) = ", N[lhs, 10]];
   Print["    RHS (sigma-ray endpoint diff) = ", N[rhs, 10]];
   Print["    |LHS-RHS| = ", N[Abs[lhs - rhs], 3]]],
  {c, {{20, 1/2, {}}, {21, 1/2, {g2}}}}];

Print["== H2: dip depth at a zero: (1/2w) Int log|zeta| = log|zeta'(rho)| + log w - 1 =="];
g1 = N[Im[ZetaZero[1]], wp];
Do[Module[{lhs, rhs},
   lhs = (1/(2 w)) NIntegrate[Log[Abs[Zeta[1/2 + I x]]], {x, g1 - w, g1, g1 + w},
      WorkingPrecision -> wp, PrecisionGoal -> pg, MaxRecursion -> 15];
   rhs = Log[Abs[Zeta'[1/2 + I g1]]] + Log[w] - 1;
   Print["  w=", w, "  measured=", N[lhs, 8], "  local model=", N[rhs, 8],
     "  diff=", N[lhs - rhs, 3]]],
  {w, {0.2, 0.1, 0.05}}];

Print["== H3 (analytic, for the record) =="];
Print["  all-primes sinc/dilog series on sigma=1/2: terms ~ e^{v/2}/(w v^2) after x=e^v,"];
Print["  pole-driven growth beats algebraic sinc damping -> no summable prime-side closure;"];
Print["  the sigma-ray integral IS the (regularized) value of Sum_p Li2(p^{-1/2-i tau})/ln p."];
