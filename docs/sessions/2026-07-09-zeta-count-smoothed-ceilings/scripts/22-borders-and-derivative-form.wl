(* 22: How do the strip BORDERS "know" the zeros? (follow-up to script 21)
   At w = i/2 the closure reads A_{i/2}(t) = G(t+i/2) - G(t-i/2): a difference of two
   RAY integrals of Log zeta anchored at sigma = 0 and sigma = 1 (the common tail
   (1,inf) cancels, leaving the strip cross-section).
   Hypotheses (stated before running):
   H1 (elementary chi modulus on the border): |chi(it)| = Sqrt[(t/2pi) Tanh[pi t/2]]
       exactly (from |Gamma(1+it)|^2 = pi t/sinh(pi t) and |sin(i pi t/2)| = sinh(pi t/2)).
   H2 (borders pointwise know only chi): log|zeta(1+it)| - log|zeta(it)| = -log|chi(it)|
       EXACTLY (functional equation + reflection) -- no zero content in the pointwise
       border values; smooth in t.
   H3 (derivative form -- where the zeros actually live): by Cauchy-Riemann,
       d/dt <arg zeta>_{sigma in (0,1)} = Int_0^1 d_sigma log|zeta| dsigma
                                        = log|zeta(1+it)| - log|zeta(it)|  (a.e., t != gamma)
       i.e. the a.e. derivative of the branch-tracked strip phase average is PURE BORDER
       DATA = -log|chi(it)| (H2), completely smooth-explicit; ALL arithmetic sits in the
       pi Sum delta(t - gamma) jump part (script 21). Verify the a.e. identity by finite
       differences of the unwrapped strip average between zeros. *)

Print["== H1: |chi(it)| = Sqrt[(t/2pi) Tanh[pi t/2]] =="];
chi[s_] := 2^s Pi^(s - 1) Sin[Pi s/2] Gamma[1 - s];
Do[Print["  t=", t, "  |chi(it)|=", N[Abs[chi[I t]], 12], "  closed form=",
    N[Sqrt[(t/(2 Pi)) Tanh[Pi t/2]], 12]], {t, {5, 20, 33.7}}];

Print["== H2: log|zeta(1+it)| - log|zeta(it)| + log|chi(it)| == 0 exactly =="];
Do[Print["  t=", t, "  residual=",
    N[Log[Abs[Zeta[1 + I t]]] - Log[Abs[Zeta[I t]]] + Log[Abs[chi[I t]]], 3]],
  {t, {14.5, 18., 20., 33.7}}];

Print["== H3: d/dt <arg zeta>_strip (a.e.) == -log|chi(it)| (finite differences) =="];
unwrapAvg[t_?NumericQ] := Module[{n = 8000, xs, args, out},
  xs = Range[1., 0., -1./n];
  args = Arg[Zeta[# + I t]] & /@ xs;
  out = FoldList[#2 + 2 Pi Round[(#1 - #2)/(2 Pi)] &, First[args], Rest[args]];
  Mean[out]];
Do[Module[{h = 0.005, fd, cf},
   fd = (unwrapAvg[t + h] - unwrapAvg[t - h])/(2 h);
   cf = -Log[Abs[chi[I t]]];
   Print["  t=", t, "  FD=", N[fd, 8], "  -log|chi(it)|=", N[cf, 8],
     "  diff=", N[fd - cf, 3]]],
  {t, {18., 20., 26.5}}];
Print["  (between zeros the derivative is EXACTLY this smooth border term: no S(t)"];
Print["   fluctuation survives; the zeros enter only as the pi-jumps of script 21,"];
Print["   i.e. as monodromy of the t-continuation, not as pointwise border data.)"];
