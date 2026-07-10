(* 15: the Occam question -- is CF2's deviation from p + log p signal or noise?
   d = (CF2 - (p+q))/q is computable from the input alone; e = (p2 - (p+q))/q is
   the naive estimator's true error (gap units).  If corr(d, e) > 0 within
   m-windows, the algebraic form points in the CORRECT direction and lambda*
   amplification could beat p + log p; if ~0, pure p + log p wins by Occam.
   Hypothesis stated before running: corr ~ 0 (within 2/sqrt(n)); lambda*
   meaningless; RMS improvement negligible -- the deviation is smooth
   deterministic drift (approximation bias), and section 7 says the next-gap
   information simply is not in the inputs. *)

GcfP[x_] := LogIntegral[x]^2/2 - x LogIntegral[x]/Log[x] + 2 LogIntegral[x^2] - x^2/Log[x];

nextPrimeCF2[m_, p_] := Module[{d0, q, y, u, rX, eps, A, B},
   d0[k_] := N[Log[k] LogIntegral[k]];
   q = Log[N[p]];
   y = p - (LogIntegral[N[p]] - m) q;
   y = y - (LogIntegral[y] - m) Log[y];
   u = Log[y];
   rX = (GcfP[y] + m/(2 u) - 1)/d0[m];
   eps = -(1/2 - 1/u - (Log[u] + 3/4)/u^2) (m + 2)/(2 y u d0[m + 2]);
   A = (m + 1)/q (1/(2 d0[m + 2]) - 1/d0[m + 1]) +
     rX (1/2 - d0[m]/d0[m + 1] + d0[m]/(2 d0[m + 2]));
   B = (m + 2)/(2 d0[m + 2]);
   Exp[B/(eps - A)]];

lo = 500; hi = 5000; step = 2;
dat = Table[Module[{p1 = Prime[m + 1], p2 = Prime[m + 2], q, pred},
    q = Log[N[p1]];
    pred = nextPrimeCF2[m, p1];
    {m, (pred - (p1 + q))/q, (p2 - (p1 + q))/q}], {m, lo, hi, step}];
n = Length[dat];
Print["n = ", n, "  (m = ", lo, "..", hi, " step ", step, ")"];
Print["raw corr(d, e) (smooth trends included) = ", N[Correlation[dat[[All, 2]], dat[[All, 3]]], 4]];

blocks = Partition[dat, 50];
resid = Flatten[Table[Module[{dd = b[[All, 2]], ee = b[[All, 3]]},
     Transpose[{dd - Mean[dd], ee - Mean[ee]}]], {b, blocks}], 1];
dr = resid[[All, 1]]; er = resid[[All, 2]];
Print["windowed (block-demeaned) corr(d_resid, e_resid) = ", N[Correlation[dr, er], 4],
  "   significance threshold 2/sqrt(n) = ", N[2/Sqrt[n], 3]];
Print["stdev d_resid = ", N[StandardDeviation[dr], 3], " gaps;  stdev e_resid = ",
  N[StandardDeviation[er], 3], " gaps"];

lam = Covariance[dr, er]/Variance[dr];
rms0 = Sqrt[Mean[er^2]];
rms1 = Sqrt[Mean[(er - lam dr)^2]];
Print["optimal amplification lambda* = ", N[lam, 4]];
Print["RMS(e_resid) ", N[rms0, 5], " -> with lambda*: ", N[rms1, 5],
  "  (improvement ", N[100 (1 - rms1/rms0), 3], "%)"];
Print["sign-agreement fraction (should be ~0.5 if no signal): ",
  N[Count[resid, {a_, b_} /; a b > 0]/Length[resid], 4]];

Print[""];
Print["point-prediction comparison, gap units:"];
Print["median |e|      (pure p + log p): ", N[Median[Abs[dat[[All, 3]]]], 4]];
Print["median |e - d|  (CF2)           : ", N[Median[Abs[dat[[All, 3]] - dat[[All, 2]]]], 4]];
