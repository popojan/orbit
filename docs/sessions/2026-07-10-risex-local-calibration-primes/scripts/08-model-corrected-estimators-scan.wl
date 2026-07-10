(* 08: can the errf scheme be used BETTER than the diffX=0 ansatz?
   Candidates, all given primes <= Prime[m+1] only:
     A0: errf = 0                      (the original scheme, pipeline A)
     A1: errf = dXcf(m+1)              (subtract the CLOSED-FORM smooth model of diffX;
                                        still closed-form: q = B/(eps - A))
     A1m: same idea but with den = m   (tests whether den=Log*Li is even special
                                        once the model correction is explicit)
     A3: third difference = 0          (kills smooth part without any model)
     L:  localLiStep                   (Cramer/Poisson local-density baseline)
     Ng: naiveGap p + log p
   Hypotheses stated BEFORE the run (from script 07's decomposition):
     H1: noise dominates systematic ~2:1, so A1 improves A0 only ~10-20% in RMS;
     H2: A1 ~ A1m (den irrelevant once model-corrected);
     H3: nobody beats the boundary-gap noise floor: median |err|/gap stays O(1)
         and no estimator beats L by more than ~20% in median. *)

mLo = 500; mHi = 5000; step = 25;
mMax = mHi + 5;
SS = ConstantArray[0., mMax];
acc = 0.;
Do[acc += n/Log[Prime[n]] // N; SS[[n]] = acc, {n, 2, mMax - 1}];
Dden[k_] := N[Log[k] LogIntegral[k]];
RX[k_] := (-1 + SS[[k]])/Dden[k];

wp = 30;
liInvW[n_] := x /. Quiet[FindRoot[LogIntegral[x] == n,
    {x, N[Max[4, n (Log[n] + Log[Log[n]])], wp]}, WorkingPrecision -> wp, PrecisionGoal -> 20]];
G[x_] := LogIntegral[x]^2/2 - x LogIntegral[x]/Log[x] + 2 LogIntegral[x^2] - x^2/Log[x];
ScfEM[k_] := Module[{y = liInvW[k]}, G[y] + k/(2 Log[y])];
Rcf[k_] := (ScfEM[k] - 1)/N[Log[k] LogIntegral[k], wp];
dXcf[k_] := (Rcf[k + 1] + Rcf[k - 1])/2 - Rcf[k];
RcfM[k_] := (ScfEM[k] - 1)/k;
dXcfM[k_] := (RcfM[k + 1] + RcfM[k - 1])/2 - RcfM[k];

(* errf coefficients, Li den (script 01) and den=m analogue *)
D0[m_] := Log[m] LogIntegral[m];
BcoLi[m_] := N[(m + 2)/(2 D0[m + 2])];
AcoLi[m_, p_, rX_] := N[(m + 1)/p (1/(2 D0[m + 2]) - 1/D0[m + 1]) +
    rX (1/2 - D0[m]/D0[m + 1] + D0[m]/(2 D0[m + 2]))];
BcoM[m_] := 1./2;
AcoM[m_, p_, rX_] := N[(m + 1)/p (1/(2 (m + 2)) - 1/(m + 1)) +
    rX (1/2 - m/(m + 1) + m/(2 (m + 2)))];

res = {};
Do[
  p1 = Prime[m + 1]; p2 = Prime[m + 2]; g = p2 - p1;
  pl = Log[p1] // N;
  rX = RX[m]; rXm = (-1 + SS[[m]])/m;
  ALi = AcoLi[m, pl, rX]; BLi = BcoLi[m];
  predA0 = Exp[-BLi/ALi];
  predA1 = Exp[BLi/(dXcf[m + 1] - ALi)];
  AM = AcoM[m, pl, rXm]; BM = BcoM[m];
  predA1m = Exp[BM/(dXcfM[m + 1] - AM)];
  W = 3 RX[m + 1] - 3 RX[m] + RX[m - 1];
  predA3 = Exp[(m + 2)/(W Dden[m + 2] + 1 - SS[[m + 1]])];
  predL = x /. Quiet[FindRoot[LogIntegral[x] - LogIntegral[N[p1]] == 1, {x, p1 + Log[p1]}]];
  predN = p1 + pl;
  AppendTo[res, {m, g,
    (predA0 - p2)/p2, (predA1 - p2)/p2, (predA1m - p2)/p2, (predA3 - p2)/p2, (predL - p2)/p2, (predN - p2)/p2,
    (predA0 - p2)/g, (predA1 - p2)/g, (predA1m - p2)/g, (predA3 - p2)/g, (predL - p2)/g, (predN - p2)/g}],
  {m, mLo, mHi, step}];

names = {"A0 errf=0     ", "A1 errf=dXcf  ", "A1m den=m+model", "A3 3rd-diff   ", "L localLiStep ", "Ng naiveGap   "};
n = Length[res];
Print["scan m=", mLo, "..", mHi, " step ", step, "  (", n, " values)"];
Print[""];
Print["estimator | median|rel| | mean|rel| | RMS rel | median|err|/gap | mean signed rel (bias) | win-rate vs L"];
Do[
  rels = res[[All, 2 + j]]; gaps = res[[All, 8 + j]];
  Print[names[[j]], " | ", N[Median[Abs[rels]], 4], " | ", N[Mean[Abs[rels]], 4],
    " | ", N[Sqrt[Mean[rels^2]], 4], " | ", N[Median[Abs[gaps]], 4],
    " | ", N[Mean[rels], 4],
    " | ", N[Count[Range[n], k_ /; Abs[res[[k, 2 + j]]] < Abs[res[[k, 7]]]]/n, 3]],
  {j, 6}];

Print[""];
Print["pairwise: A1 vs A0 -- fraction of m where |A1 err| < |A0 err|: ",
  N[Count[Range[n], k_ /; Abs[res[[k, 4]]] < Abs[res[[k, 3]]]]/n, 3]];
Print["A1 vs A1m agreement -- median |predA1rel - predA1mrel|: ",
  N[Median[Abs[res[[All, 4]] - res[[All, 5]]]], 3]];

Print[""];
Print["subrange check (m-dependence of median |rel|):"];
Do[
  sub = Select[res, mLoS <= #[[1]] < mLoS + 1500 &];
  Print["m in [", mLoS, ",", mLoS + 1500, "): ",
    Table[N[Median[Abs[sub[[All, 2 + j]]]], 3], {j, 6}]],
  {mLoS, {500, 2000, 3500}}];
