(* 07: WHY is riseX predictable despite accumulating all primes?
   Three-layer decomposition tested here:
   (a) log-compression: each term a_n = n/log p_n feels a one-gap shift of p_n
       only at relative level 1/p_n;
   (b) localization: in diffX = 2nd difference of T/D, the accumulated sum T
       enters ONLY through R*(B_R) with B_R = 1/2 + D(m)/(2D(m+2)) - D(m)/D(m+1)
       ~ (D'/D)^2 - D''/(2D) ~ 1/m^2 for smooth D  -- and this same bracket with
       D = Log*PrimePi jumps to O(1/D), explaining the PrimePi break quantitatively;
   (c) what remains of diffX is a SMOOTH curvature term, computable in closed form
       from G (script 06), plus boundary gap noise from just the two newest terms.
   Also: same decomposition for plain rise (den=m) -- prediction: the gap-noise
   residual is nearly identical, only the smooth part differs. *)

mTargets = {200, 500, 1000, 2000, 5000, 10000};
mMax = Max[mTargets] + 105;

(* exact prime sum, machine precision (abs noise ~1e-13 in diffX; signal >= 1e-8) *)
SS = ConstantArray[0., mMax + 1];
acc = 0.;
Do[acc += n/Log[Prime[n]] // N; SS[[n]] = acc, {n, 2, mMax}];
Dden[k_] := N[Log[k] LogIntegral[k]];
RX[k_] := (-1 + SS[[k]])/Dden[k];
dX[k_] := (RX[k + 1] + RX[k - 1])/2 - RX[k];

(* smooth discrete model: same sum with Prime[n] -> liInv[n] (Cramer smooth positions);
   isolates prime-fluctuation content exactly: dX - dXm = pure prime-noise effect *)
liInvM[n_] := x /. Quiet[FindRoot[LogIntegral[x] == n,
    {x, Max[4, n (Log[n] + Log[Log[n]])]}, PrecisionGoal -> 12]];
SSm = ConstantArray[0., mMax + 1];
acc = 0.;
Do[acc += n/Log[liInvM[n]]; SSm[[n]] = acc, {n, 2, mMax}];
RXm[k_] := (-1 + SSm[[k]])/Dden[k];
dXm[k_] := (RXm[k + 1] + RXm[k - 1])/2 - RXm[k];

(* closed-form model at WP30 (no sum at all): Scf = G(liInv m) + E-M half-term *)
wp = 30;
liInvW[n_] := x /. Quiet[FindRoot[LogIntegral[x] == n,
    {x, N[Max[4, n (Log[n] + Log[Log[n]])], wp]}, WorkingPrecision -> wp, PrecisionGoal -> 20]];
G[x_] := LogIntegral[x]^2/2 - x LogIntegral[x]/Log[x] + 2 LogIntegral[x^2] - x^2/Log[x];
RcfEM[k_] := Module[{y = liInvW[k]}, (G[y] + k/(2 Log[y]) - 1)/N[Log[k] LogIntegral[k], wp]];
Rcf0[k_] := (G[liInvW[k]] - 1)/N[Log[k] LogIntegral[k], wp];
dXcfEM[k_] := (RcfEM[k + 1] + RcfEM[k - 1])/2 - RcfEM[k];
dXcf0[k_] := (Rcf0[k + 1] + Rcf0[k - 1])/2 - Rcf0[k];

Print["m | dX true | dX smooth-discrete | dX closed-form(+EM) | dX closed-form(no EM) | noise = dX - dX_smooth-discrete"];
Do[
  Print[{m, N[dX[m], 6], N[dXm[m], 6], N[dXcfEM[m], 6], N[dXcf0[m], 6], N[dX[m] - dXm[m], 6]}],
  {m, mTargets}];

Print[""];
Print["systematic vs noise split over windows m0-100..m0+100:"];
Do[
  win = Range[mc - 100, mc + 100];
  resid = Table[dX[k] - dXm[k], {k, win}];
  sys = Table[dXm[k], {k, win}];
  Print["m~", mc, ": mean(dX_smooth)=", N[Mean[sys], 4],
    "  stdev(dX_smooth)=", N[StandardDeviation[sys], 4],
    "  stdev(noise)=", N[StandardDeviation[resid], 4],
    "  mean(noise)=", N[Mean[resid], 4]],
  {mc, {1000, 5000, 10000}}];

(* (b) the history multiplier *)
BR[k_] := 1/2 + Dden[k]/(2 Dden[k + 2]) - Dden[k]/Dden[k + 1];
Print[""];
Print["history multiplier, Li den: m, B_R, R(m), R*B_R  (how the WHOLE accumulated sum enters dX):"];
Do[Print[{m, N[BR[m], 4], N[RX[m], 6], N[RX[m] BR[m], 4]}], {m, {1000, 5000, 10000}}];

DPP[k_] := N[Log[k] PrimePi[k]];
BRPP[k_] := 1/2 + DPP[k]/(2 DPP[k + 2]) - DPP[k]/DPP[k + 1];
Print[""];
Print["same bracket with PrimePi den (script-03 break): primes in {m,m+1,m+2}, B_R^PP, R*B_R^PP:"];
Do[Print[{m, Select[{m, m + 1, m + 2}, PrimeQ], N[BRPP[m], 4], N[RX[m] BRPP[m], 4]}],
  {m, {29, 30, 31, 36, 40}}];

(* (a) per-term insensitivity *)
Print[""];
Print["log-compression: one-gap shift of p_n changes a_n=n/log p_n by rel. (g/p)/log p ~ 1/p:"];
Do[Print[{n, "p_n=", Prime[n], "  rel. wobble ~ ", N[1/Prime[n], 3]}], {n, {100, 1000, 10000}}];

(* control: plain rise (den = m) -- same decomposition *)
Rm[k_] := (-1 + SS[[k]])/k;
Rmm[k_] := (-1 + SSm[[k]])/k;
dm[k_] := (Rm[k + 1] + Rm[k - 1])/2 - Rm[k];
dmm[k_] := (Rmm[k + 1] + Rmm[k - 1])/2 - Rmm[k];
Print[""];
Print["control, den=m (plain rise): noise residual should be ~ identical, only smooth part differs:"];
Do[
  win = Range[mc - 100, mc + 100];
  rLi = Table[dX[k] - dXm[k], {k, win}];
  rM = Table[dm[k] - dmm[k], {k, win}];
  Print["m~", mc, ": stdev(noise,Li den)=", N[StandardDeviation[rLi], 4],
    "  stdev(noise,m den)=", N[StandardDeviation[rM], 4],
    "  corr=", N[Correlation[rLi, rM], 4],
    "  |mean smooth| Li vs m: ", N[Abs[Mean[Table[dXm[k], {k, win}]]], 4], " vs ",
    N[Abs[Mean[Table[dmm[k], {k, win}]]], 4]],
  {mc, {1000, 5000}}];
