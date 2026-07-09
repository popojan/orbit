(* 17 -- Jan pasted a "wrong[]" plot (sigma=2, constant smoothing r=1/2 instead
   of p^-sigma) and asked to be shown wrong, noting the plot's dips "seem to
   know about zeros on the critical line". Diagnose the bugs AND test the
   observation adversarially (don't just assert look-elsewhere -- check it).
   HYPOTHESES (stated before running):
   H1: as literally pasted, wrong[sig_,lo_,hi_,m_] (4 params) called with 5
       args wrong[2,30,53,43,1] does not match the pattern and stays
       unevaluated (Head remains "wrong").
   H2: sigma is dead code -- the body never references it.
   H3: r=1/2 constant vs the correct p^-sigma is a huge amplitude mismatch,
       growing with p (no decay at all vs correct decay to ~0).
   H4: wrong[] collapses to a clean closed form: -Sum_p Log[1-(1/2)p^-(I t)],
       a Beurling-type Euler product with CONSTANT weight w_p=1/2 (not tied
       to p or sigma) -- a different L-function, not any slice of zeta.
   H5 (the adversarial check): the visual "dips near true zeros" is NOT pure
       look-elsewhere -- test true zero locations against a null model of
       random comparison points, same window, same "nearest local minimum"
       measure, many trials. *)

ceilC[x_, r_] := x + 1/2 + (I/Pi) Log[1 - r Exp[2 Pi I x]];
wrongSum[t_?NumericQ, m_] := I Pi Sum[
   ceilC[-t Log[p]/2/Pi, 1/2] + t Log[p]/2/Pi - 1/2, {p, Prime /@ Range[m]}];

Print["=== H1: literal 5-arg call vs 4-param definition ==="];
wrong[sig_, lo_, hi_, m_] := I Pi Sum[
   ceilC[-t Log[p]/2/Pi, 1/2] + t Log[p]/2/Pi - 1/2, {p, Prime /@ Range[m]}];
Print["Head[wrong[2,30,53,43,1]]: ", Head[wrong[2, 30, 53, 43, 1]],
  "  (stays symbolic -- no plot is produced by this exact call)"];

Print["\n=== H2: sigma never appears in the body ==="];
Print["FreeQ of the body w.r.t. sig: ",
  FreeQ[HoldForm[I Pi Sum[ceilC[-t Log[p]/2/Pi, 1/2] + t Log[p]/2/Pi - 1/2,
     {p, Prime /@ Range[m]}]], sig]];

Print["\n=== H3: amplitude mismatch, r=1/2 constant vs correct p^-sigma (sigma=2) ==="];
correctAmp[p_] := N[ArcSin[p^-2.]/Pi];
wrongAmp = N[ArcSin[0.5]/Pi];
Print["wrong's constant amplitude: ", wrongAmp];
Print["correct amplitude at p=2: ", correctAmp[2], "   at p=191: ", correctAmp[191]];
Print["ratio wrong/correct at p=191: ", wrongAmp/correctAmp[191]];

Print["\n=== H4: closed form ==="];
closedForm[t_?NumericQ, m_] := -Sum[Log[1 - (1/2) p^(-I t)], {p, Prime /@ Range[m]}];
SeedRandom[3];
Print["max|wrongSum - closedForm| over 30 random (t,m): ",
  Max@Table[
    With[{tt = RandomReal[{5, 60}], mm = RandomInteger[{1, 43}]},
     Abs[wrongSum[tt, mm] - closedForm[tt, mm]]], {30}]];

Print["\n=== Sanity: wrong[] is nowhere near Log Zeta on any line ==="];
m0 = 43;
Do[
  tt = N[t];
  Print["t=", tt, "  Re[wrong]=", N[Re[wrongSum[tt, m0]], 4],
    "  Re[LogZeta(2+it)]=", N[Re[Log[Zeta[2 + I tt]]], 4]],
  {t, {30, 40, 50, 53}}
];

Print["\n=== H5: adversarial check of the 'sees the zeros' claim ==="];
trueZeros = N[Im[ZetaZero[Range[10]]]];
zerosInRange = Select[trueZeros, 30 < # < 53 &];
fineGrid = Range[30., 53., 0.02];
vals = Table[Re[wrongSum[tv, m0]], {tv, fineGrid}];
localMinT = Table[
   If[vals[[i]] < vals[[i - 1]] && vals[[i]] < vals[[i + 1]], fineGrid[[i]], Nothing],
   {i, 2, Length[vals] - 1}];
Print["true zeros in (30,53): ", zerosInRange];
Print["number of Re[wrong] local minima found: ", Length[localMinT]];
nearestDist[z_] := Min[Abs[localMinT - z]];
avgTrue = Mean[nearestDist /@ zerosInRange];
Print["mean distance true-zero -> nearest wrong-dip: ", N[avgTrue, 4]];

SeedRandom[42];
avgRandTrials = Table[
   randomTargets = RandomReal[{30, 53}, Length[zerosInRange]];
   Mean[nearestDist /@ randomTargets],
   {200}];
Print["null model (200 trials, random comparison points, same window/measure): mean=",
  N[Mean[avgRandTrials], 4], " stdev=", N[StandardDeviation[avgRandTrials], 4]];
Print["fraction of random trials at least as good as the true zeros: ",
  N[Count[avgRandTrials, x_ /; x <= avgTrue]/200.],
  "  (small fraction => real, above-chance proximity, not look-elsewhere)"];
