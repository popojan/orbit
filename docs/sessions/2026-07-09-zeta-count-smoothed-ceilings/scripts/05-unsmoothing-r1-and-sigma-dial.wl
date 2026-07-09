(* 05 -- UNSMOOTHING (Jan's question): what does the counter look like at r=1 (no blur),
   and why is r = 1/Sqrt[p] load-bearing?
   HYPOTHESES (stated before running):
   H1: the r=1 termwise limit is the SHARP sawtooth:
       waveXX[t,p,1] == FractionalPart[t Log[p]/(2 Pi)] - 1/2  (away from the lattice
       t Log[p] in 2 Pi Z). In ceiling form the term is t Log[p]/(2Pi) + 1/2 -
       ceilBook[t Log[p]/(2Pi)] -- a genuine unit-jump staircase, atom fully sharp.
   H2: its jumps sit at t = 2 Pi j/Log[p] -- exactly the zeros of the LOCAL Euler factor
       1 - p^{-s} on the line sigma=0 (p^{-I t} = 1 there). Perfect arithmetic
       progressions; true zeta zeros are NOT there.
   H3: the unsmoothed counter nt7 + Sum_p sawtooth has residual RMS ~ Sqrt[m/12] at the
       true zeros (each sawtooth ~ Uniform(-1/2,1/2), Var 1/12, quasi-independent by Weyl
       incommensurability of {Log p}), so the Ceiling snap collapses
       (P(|N(0,RMS)| < 1/2) ~ 60/300 at m=50).
   H4: sigma-dial r = p^{-sigma}: residual RMS at gamma_k is minimized AT sigma = 1/2 --
       the critical line is the matched filter (slight offset > 1/2 conceivable from the
       finite truncation; that would be a regularization artifact, record honestly).
   H5: for sigma > 1 the dial sum IS the Euler product:
       Sum_p waveXX[t,p,p^-sigma] == (1/Pi) Im Log Zeta[sigma + I t]
       (absolute convergence; principal branch safe at sigma=2 since Re Zeta > 0.35). *)

waveXX[x_, p_, r_] := 1/Pi ArcCot[Cot[x Log@p] - Csc[x Log@p]/r];
ceilBook[x_] := x + 1/2 + ArcTan[Cot[Pi x]]/Pi;
nt7[t_] := t/(2 Pi) Log[t/(2 Pi E)] + 7/8;

Print["=== H1: r=1 limit is the sharp sawtooth ==="];
Print["max |waveXX[t,p,1] - (FractionalPart[t Log p/(2Pi)] - 1/2)| over sweep: ",
  Max @ Flatten @ Table[Abs[N[waveXX[tt, pp, 1] - (FractionalPart[tt Log[pp]/(2 Pi)] - 1/2)]],
     {pp, {2, 3, 7, 41}}, {tt, {0.37, 1.9, 5.11, 14.2, 30.7}}]];
Print["ceiling form check, max |waveXX[t,p,1] - (t Log p/(2Pi) + 1/2 - ceilBook[t Log p/(2Pi)])|: ",
  Max @ Flatten @ Table[Abs[N[waveXX[tt, pp, 1] - (tt Log[pp]/(2 Pi) + 1/2 - ceilBook[tt Log[pp]/(2 Pi)])]],
     {pp, {2, 3, 7, 41}}, {tt, {0.37, 1.9, 5.11, 14.2, 30.7}}]];

Print["\n=== H2: jump lattice = zeros of the local Euler factor on sigma=0 ==="];
Print["|1 - p^(-I t)| at t = 2 Pi j/Log[p], (p,j)=(5,3),(11,7): ",
  {N[Abs[1 - 5^(-I (2 Pi 3/Log[5]))]], N[Abs[1 - 11^(-I (2 Pi 7/Log[11]))]]}];
Print["nearest true zero to the p=2 lattice points 2 Pi j/Log[2], j=2..5: ",
  Table[With[{tj = N[2 Pi j/Log[2]]}, {tj, N[Min[Abs[tj - Im[N[ZetaZero[#]] & /@ Range[20]]]], 3]}], {j, 2, 5}]];

kmax = 300;
gams = Table[N[Im[ZetaZero[k]], 20], {k, kmax}];

Print["\n=== H3: the unsmoothed counter collapses; RMS ~ Sqrt[m/12] ==="];
unsmoothed[t_, m_] := nt7[t] + Sum[FractionalPart[t Log[Prime[j]]/(2 Pi)] - 1/2, {j, m}];
Do[
  vals = Table[unsmoothed[gams[[k]], m] - (k - 1/2), {k, kmax}];
  Print["m=", m, "  RMS=", N[Sqrt[Mean[vals^2]], 4], "  predicted Sqrt[m/12]=", N[Sqrt[m/12], 4],
    "  Ceiling successes: ",
    Count[Table[Ceiling[unsmoothed[gams[[k]], m]] == k, {k, kmax}], True], "/", kmax],
  {m, {5, 20, 50, 168}}
];

Print["\n=== H4: the sigma dial -- is sigma=1/2 the matched filter? (m=50) ==="];
sigmaCount[t_, m_, sig_] := nt7[t] + Sum[waveXX[t, Prime[j], Prime[j]^-sig], {j, m}];
Do[
  vals = Table[sigmaCount[gams[[k]], 50, sig] - (k - 1/2), {k, kmax}];
  Print["sigma=", N[sig, 3], "  RMS=", N[Sqrt[Mean[vals^2]], 4],
    "  Ceiling successes: ",
    Count[Table[Ceiling[sigmaCount[gams[[k]], 50, sig]] == k, {k, kmax}], True], "/", kmax],
  {sig, {0.30, 0.40, 0.45, 0.50, 0.55, 0.60, 0.75, 1.00}}
];

Print["\n=== H5: sigma>1 -- the dial sum IS Im log Zeta via the Euler product (sigma=2) ==="];
Do[
  euler = Sum[waveXX[tt, p, p^-2.], {p, Select[Range[2, 4000], PrimeQ]}];
  direct = Im[Log[Zeta[2 + I tt]]]/Pi;
  Print["t=", tt, "  Euler-sum=", N[euler, 8], "  (1/Pi) Im Log Zeta=", N[direct, 8],
    "  diff=", N[euler - direct, 3]],
  {tt, {13.7, 50.3}}
];
