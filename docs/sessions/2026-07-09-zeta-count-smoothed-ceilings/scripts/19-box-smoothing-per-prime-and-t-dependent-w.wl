(* 19 -- Jan's question: can w vary per prime, or with t?
   HYPOTHESES (stated before running):
   H1: per-prime w vs a single 1/(2w) factored across the sum are NOT the
       same constraint -- integration and summation commute, so a per-term
       1/(2w_p) is always legal; nothing about the current algebra forces a
       shared w.
   H2: the natural per-prime choice w_p = c/Log[p] (constant window in each
       prime's own phase x_p = t Log[p]/(2 Pi), matching this whole session's
       convention) makes EVERY prime's k-th harmonic get the identical weight
       sinc(k c), independent of p -- a clean ladder parallel to the §4.2.3
       necklace ladder.
   H3: despite H2's elegance, w_p=c/Log[p] performs WORSE than constant w,
       because it damps small primes (which carry almost all the real
       signal) by the same relative amount as large, low-amplitude primes --
       the wrong asymmetry.
   H4: a t-dependent w(t) = c/Log[t/(2 Pi)] (matched to the Riemann-von
       Mangoldt zero density ~1/log t) does not clearly beat the best
       constant w on the narrow window t in (13,33) -- log(t/2pi) barely
       varies there; likely needs a much wider/higher-t test, not concluded
       here either way. *)

boxSmoothed[t_?NumericQ, w_?NumericQ, m_] := Sum[
   (1/(2 w)) (I/Log[p]) (
     PolyLog[2, p^(-1/2 - I t - I w)] - PolyLog[2, p^(-1/2 - I t + I w)]),
   {p, Prime /@ Range[m]}];

m0 = 50;
trueZeros = N[Im[ZetaZero[Range[10]]]];
zerosInRange = Select[trueZeros, 13 < # < 33 &];
grid = Range[13.2, 32.8, 0.1];
trueVals = Log[Zeta[0.5 + I #]] & /@ grid;
nearMask = Table[Min[Abs[g - zerosInRange]] < 0.5, {g, grid}];
awayGrid = Pick[grid, Not /@ nearMask];
awayTrue = Pick[trueVals, Not /@ nearMask];

Print["=== H2: per-prime w_p=c/Log[p] gives a UNIFORM sinc(kc) ladder weight ==="];
perPrimeTerm[p_?NumericQ, t_?NumericQ, c_?NumericQ] := Module[{wp = c/Log[p]},
   (1/(2 wp)) (I/Log[p]) (
     PolyLog[2, p^(-1/2 - I t - I wp)] - PolyLog[2, p^(-1/2 - I t + I wp)])];
seriesCheck[p_, t_, c_, kmax_] := Sum[
   (p^(-k/2)/k) (Sin[k c]/(k c)) p^(-I k t), {k, 1, kmax}];
Print["|perPrimeTerm - seriesCheck(kmax=200)|, random (p,t,c): ",
  Max@Table[
    With[{pp = RandomChoice[{2, 3, 5, 11}], tt = RandomReal[{10, 30}], cc = RandomReal[{0.3, 2}]},
     Abs[perPrimeTerm[pp, tt, cc] - seriesCheck[pp, tt, cc, 200]]], {8}]];

perPrimeSmoothed[t_?NumericQ, c_?NumericQ, m_] := Sum[perPrimeTerm[p, t, c], {p, Prime /@ Range[m]}];
Print["\n=== H3: per-prime w_p=c/Log[p] sweep (compare to constant-w best 0.035) ==="];
Do[
  vals = perPrimeSmoothed[#, c, m0] & /@ awayGrid;
  Print["c=", c, "  median|diff|: ", N[Median[Abs[vals - awayTrue]], 5]],
  {c, {0.3, 0.5, 0.7, 0.9, 1.0, 1.2, 1.5, 2.0}}
];

Print["\n=== H4: t-dependent w(t) = c/Log[t/(2 Pi)] ==="];
tDepSmoothed[t_?NumericQ, c_?NumericQ, m_] := Sum[
   Module[{wt = c/Log[t/(2 Pi)]},
     (1/(2 wt)) (I/Log[p]) (
       PolyLog[2, p^(-1/2 - I t - I wt)] - PolyLog[2, p^(-1/2 - I t + I wt)])],
   {p, Prime /@ Range[m]}];
Do[
  vals = tDepSmoothed[#, c, m0] & /@ awayGrid;
  Print["c=", c, "  median|diff|: ", N[Median[Abs[vals - awayTrue]], 5]],
  {c, {0.5, 0.8, 1.0, 1.2, 1.5, 1.8, 2.0}}
];
