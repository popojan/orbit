(* 21: Box-smoothing over an IMAGINARY window w = i v.
   Continuing A_w(t) = (1/2w) Int_{t-w}^{t+w} Log zeta(1/2+ix) dx in w, the endpoints
   t +- iv map to sigma = 1/2 -+ v at fixed height: the t-box rotates onto the
   sigma-segment (1/2-v, 1/2+v); at v = 1/2 it spans the whole strip [0,1].
   Hypotheses (stated before running):
   H1 (exact FE split): on the symmetric segment the functional equation
       zeta(1-s) = zeta(s)/chi(s) kills the S(t) content of the Im channel EXACTLY:
       (a) pointwise, Im Log zeta(sigma+it) + Im Log zeta(1-sigma+it) = Im log chi(sigma+it)
           (mod 2pi branch), and
       (b) log|chi(sigma+it)| + log|chi(1-sigma+it)| = 0 exactly (chi(s) chi(1-s) = 1),
       so  A_{iv}(t) = <log|zeta|>_sigma + (i/2) <arg chi>_sigma  exactly:
       Im A is EXPLICIT (Gamma-factor only, no zeros), Re A is the modulus average.
   H2 (smooth closed form): (1/2)<arg chi>_sigma = -RiemannSiegelTheta(t) + O(v^2/t),
       and Im A is CONTINUOUS through a zero height (the two +-pi phase jumps of the
       half-segments cancel), while Re A dips: at t = gamma the well depth is
       log v - 1 + log|zeta'(rho)| + O(v) -- the sigma-twin of script 20's dip law.
   H3 (prime side anti-damps): averaging p^{-s} over the sigma-window gives weight
       sinh(m v ln p)/(m v ln p) >= 1 -- sinc rotates to sinh; the imaginary window
       AMPLIFIES the noisy band edge instead of damping it. *)

wp = 25; pg = 10;
chiLog[s_] := s Log[2] + (s - 1) Log[Pi] + Log[Sin[Pi s/2]] + LogGamma[1 - s];

Print["== H1a: pointwise FE phase pairing (expect 0, mod 2pi) =="];
Do[Module[{r = Im[Log[Zeta[s]]] + Im[Log[Zeta[1 - Conjugate[s]]]] - Im[chiLog[s]]},
   Print["  s=", s, "  residual=", N[Chop[r, 10^-12], 3]]],
  {s, {0.2 + 20. I, 0.35 + 20. I, 0.45 + 33.7 I, 0.05 + 50.1 I}}];

Print["== H1b: log|chi| exactly odd about sigma=1/2 (expect 0) =="];
Do[Print["  s=", s, "  Re chiLog(s)+Re chiLog(1-conj s)=",
    N[Re[chiLog[s]] + Re[chiLog[1 - Conjugate[s]]], 3]],
  {s, {0.2 + 20. I, 0.45 + 33.7 I, 0.01 + 100. I}}];

A[t_, v_, sing_: {}] := (1/(2 v)) NIntegrate[Log[Zeta[sig + I t]],
    Evaluate[Flatten[{sig, 1/2 - v, Sort[sing], 1/2 + v}]],
    WorkingPrecision -> wp, PrecisionGoal -> pg, MaxRecursion -> 15];
imChiAvg[t_, v_] := (1/(2 v)) NIntegrate[Im[chiLog[sig + I t]], {sig, 1/2 - v, 1/2 + v},
    WorkingPrecision -> wp, PrecisionGoal -> pg];

Print["== H1c: Im A_{iv} == (1/2)<Im log chi> (integral form) =="];
Do[Module[{a = A[t, v]},
   Print["  t=", t, " v=", v, "  Im A=", N[Im[a], 8], "  (1/2)<Im chi>=",
     N[imChiAvg[t, v]/2, 8], "  diff=", N[Im[a] - imChiAvg[t, v]/2, 3]]],
  {tv, {{20, 0.3}, {20, 0.5}, {33.7, 0.5}}}, {t, {tv[[1]]}}, {v, {tv[[2]]}}];

Print["== H2: (1/2)<arg chi> vs -theta(t); continuity through gamma_1; Re-dip law =="];
Do[Print["  t=", t, "  (1/2)<Im chi>=", N[imChiAvg[t, 1/2]/2, 8],
    "  -theta(t)=", N[-RiemannSiegelTheta[t], 8],
    "  diff=", N[imChiAvg[t, 1/2]/2 + RiemannSiegelTheta[t], 3]],
  {t, {20, 100}}];
g1 = N[Im[ZetaZero[1]], wp];
Do[Print["  Im A at gamma_1", If[d > 0, "+", ""], d, " = ",
    N[Im[A[g1 + d, 0.3]], 8]], {d, {-0.01, 0.01}}];
Module[{v = 0.3, lhs, rhs},
  lhs = Re[A[g1, v, {1/2}]];
  rhs = Log[v] - 1 + Log[Abs[Zeta'[1/2 + I g1]]];
  Print["  Re-dip at t=gamma_1, v=0.3: measured=", N[lhs, 6],
    "  log v - 1 + log|zeta'|=", N[rhs, 6], "  diff=", N[lhs - rhs, 3]]];

Print["== H2b: unwrapped branch: Im A jumps by EXACTLY pi across gamma_1 =="];
(* principal Log has cut artifacts near the zero (the failed integrals above); track the
   branch by unwrapping arg zeta along the segment, anchored at the tame right endpoint.
   Winding argument: as t sweeps the segment through a simple zero, <arg zeta> gains
   (1/2v)*Int_{-v}^{0} 2pi dx = pi exactly; between zeros the FE pairing leaves
   Im A - (1/2)<arg chi> CONSTANT (S(t) content cancels pointwise). *)
unwrapAvg[t_?NumericQ, v_] := Module[{n = 4000, xs, args, out},
  xs = Range[1/2 + v, 1/2 - v, -2 v/n];
  args = Arg[Zeta[# + I t]] & /@ xs;
  out = FoldList[#2 + 2 Pi Round[(#1 - #2)/(2 Pi)] &, First[args], Rest[args]];
  Mean[out]];
Module[{j1, j2, c1, c2},
  j1 = unwrapAvg[13.80, 0.3]; c1 = imChiAvg[13.80, 0.3]/2;
  j2 = unwrapAvg[14.43, 0.3]; c2 = imChiAvg[14.43, 0.3]/2;
  Print["  t=13.80 (below g1): <arg zeta>-(1/2)<arg chi> = ", N[j1 - c1, 6]];
  Print["  t=14.43 (above g1): <arg zeta>-(1/2)<arg chi> = ", N[j2 - c2, 6]];
  Print["  jump = ", N[(j2 - c2) - (j1 - c1), 6], "   (predicted: pi = ", N[Pi, 6], ")"]];
Print["  flatness between zeros (S content gone): residual at t=15.5, 18.0, 20.0:"];
Do[Print["    t=", t, "  ", N[unwrapAvg[t, 0.3] - imChiAvg[t, 0.3]/2 - Pi, 6]],
  {t, {15.5, 18.0, 20.0}}];

Print["== H3: sigma-window weight on p^{-s} is sinh, not sinc =="];
Print["  (1/2v) Int p^-u du == Sinh[v Log p]/(v Log p): ",
  Simplify[Integrate[p^-u, {u, -v, v}]/(2 v) == Sinh[v Log[p]]/(v Log[p]),
    Assumptions -> p > 1 && v > 0]];
Print["  weight at p=229, m=1, v=1/2: ",
  N[Sinh[Log[229]/2]/(Log[229]/2), 5], "  (real-window sinc would be <= 1)"];
