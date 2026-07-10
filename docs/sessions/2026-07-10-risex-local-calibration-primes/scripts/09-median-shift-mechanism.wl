(* 09: why does the raw A0 (errf=0) beat the Cramer baseline L in MEDIAN while
   losing in RMS?  Mechanism candidate: L targets the MEAN gap (1 expected prime),
   but the gap distribution is right-skewed (median < mean), so any downward shift
   improves the median.  A0 = A1 - 2q^2*dXcf shift, and dXcf < 0, i.e. A0 is
   exactly such a downward shift.  Check: (i) signed medians, (ii) skew of gaps,
   (iii) A0's shift size vs the empirically median-optimal constant shift. *)

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
Rcf[k_] := Module[{y = liInvW[k]}, (G[y] + k/(2 Log[y]) - 1)/N[Log[k] LogIntegral[k], wp]];
dXcf[k_] := (Rcf[k + 1] + Rcf[k - 1])/2 - Rcf[k];

D0[m_] := Log[m] LogIntegral[m];
BcoLi[m_] := N[(m + 2)/(2 D0[m + 2])];
AcoLi[m_, p_, rX_] := N[(m + 1)/p (1/(2 D0[m + 2]) - 1/D0[m + 1]) +
    rX (1/2 - D0[m]/D0[m + 1] + D0[m]/(2 D0[m + 2]))];

rows = {};
Do[
  p1 = Prime[m + 1]; p2 = Prime[m + 2]; g = p2 - p1;
  pl = Log[p1] // N;
  rX = RX[m];
  A = AcoLi[m, pl, rX]; B = BcoLi[m];
  predA0 = Exp[-B/A];
  predL = x /. Quiet[FindRoot[LogIntegral[x] - LogIntegral[N[p1]] == 1, {x, p1 + Log[p1]}]];
  AppendTo[rows, {m, p1, g, pl, (predA0 - p2)/p2, (predL - p2)/p2}],
  {m, mLo, mHi, step}];

Print["signed medians: A0 ", N[Median[rows[[All, 5]]], 4], "   L ", N[Median[rows[[All, 6]]], 4]];
gaps = rows[[All, 3]]; meang = Mean[gaps]; medg = Median[gaps];
Print["gap skew over scan primes: mean gap ", N[meang, 4], "  median gap ", N[medg, 4],
  "  median/mean ", N[medg/meang, 4]];

(* empirically median-optimal constant shift s (in units of log(p)/p = mean-gap/p) applied to L *)
sGrid = Range[0., 0.8, 0.02];
scores = Table[Median[Abs[rows[[All, 6]] - s rows[[All, 4]]/rows[[All, 2]]]], {s, sGrid}];
best = Ordering[scores, 1][[1]];
Print["optimal downward shift s* = ", sGrid[[best]], " (in units of logp/p);  median|err| L: ",
  N[Median[Abs[rows[[All, 6]]]], 4], " -> shifted: ", N[scores[[best]], 4]];

(* A0's built-in shift, same units: relShift = 2 q^2 |dXcf(m+1)|, s_A0 = relShift/(logp/p) *)
Print["A0's built-in shift in the same units, spot values:"];
Do[
  q2 = Log[Prime[mm + 2]] // N;
  sh = 2 q2^2 Abs[dXcf[mm + 1]];
  Print[{mm, "rel shift ", N[sh, 3], "  s_A0 = ", N[sh Prime[mm + 1]/Log[Prime[mm + 1]], 3]}],
  {mm, {500, 1000, 2000, 3500, 5000}}];

(* exponential-gap theory: median = ln2 * mean -> optimal s = 1 - ln2 *)
Print["exponential-gap prediction for s*: 1 - Log[2] = ", N[1 - Log[2], 4]];
