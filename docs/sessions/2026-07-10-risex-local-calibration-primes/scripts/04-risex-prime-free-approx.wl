(* riseX[m] currently needs the FULL prime table 2..m (via Sum[n/Log[Prime[n]]]).
   Substituting t=Li(x) in Integral_2^m t/Log[Li^-1(t)] dt turns that into a smooth,
   prime-free integral: Integral_{x0}^{Li^-1(m)} Li(x)/(Log x)^2 dx, x0 = Li^-1(2).

   Then compare four Prime[m+2]-prediction pipelines:
     A: errf with the TRUE riseX[m] and the TRUE p = Log[Prime[m+1]]   (original scheme)
     B: errf with the prime-free riseXApprox[m], TRUE p                (this session's ask)
     C: errf with riseXApprox[m] AND approx p = Log[Li^-1(m+1)]        (fully prime-free)
     D: classical Li^-1(m+2), no local information at all *)

Sm[m_] := Sum[n/Log[Prime[n]] // N, {n, 2, m}];
riseX[m_] := (-1 + Sm[m])/(Log[m] LogIntegral[m] // N);

errf[m_, p_, q_, rX_] :=
 -(1/(Log[1 + m] p LogIntegral[1 + m])) -
   m/(Log[1 + m] p LogIntegral[1 + m]) +
  rX (1/2 - (Log[m] LogIntegral[m])/(
       Log[1 + m] LogIntegral[1 + m]) + (Log[m] LogIntegral[m])/(
       2 Log[2 + m] LogIntegral[2 + m])) +
   1/(2 Log[2 + m] p LogIntegral[2 + m]) +
   m/(2 Log[2 + m] p LogIntegral[2 + m]) +
   1/(Log[2 + m] q LogIntegral[2 + m]) +
   m/(2 Log[2 + m] q LogIntegral[2 + m]);

(* NOTE: the naive guess n(Log[n]+Log[Log[n]]) sends FindRoot to a spurious root
   right next to LogIntegral's singularity at x=1 for small n (e.g. n=2 -> x~1.006).
   Clamping the guess away from 1 fixes it -- this bit the first pass. *)
liInv[n_] := x /. Quiet[FindRoot[LogIntegral[x] == n, {x, Max[4, n (Log[n] + Log[Log[n]])]}]];

x0 = liInv[2];
SmApprox[m_] := NIntegrate[LogIntegral[x]/Log[x]^2, {x, x0, liInv[m]},
   WorkingPrecision -> 20, PrecisionGoal -> 12];
riseXApprox[m_] := (-1 + SmApprox[m])/(Log[m] LogIntegral[m] // N);

Print["x0 = liInv[2] = ", N[x0, 10], "  (sanity: LogIntegral[x0] = ", N[LogIntegral[x0], 10], ")"];

Print[""];
Print["Step 1: riseXApprox[m] (prime-free) vs true riseX[m]:"];
Do[
  rTrue = riseX[m]; rApp = riseXApprox[m];
  Print[{m, "riseX=", N[rTrue, 8], "riseXApprox=", N[rApp, 8],
     "rel err=", N[(rApp - rTrue)/rTrue, 6]}],
  {m, {10, 50, 200, 1000, 5000, 20000}}
];

Print[""];
Print["Step 2: Prime[m+2] predictions, pipelines A-D:"];
Do[
  pTrue2 = Prime[m + 2];
  pKnownExact = Log[Prime[m + 1]];
  pKnownApprox = Log[liInv[m + 1]];
  rXtrue = riseX[m];
  rXapp = riseXApprox[m];

  qA = q /. Quiet[FindRoot[errf[m, pKnownExact, q, rXtrue] == 0, {q, Log[N[pTrue2]]}]];
  qB = q /. Quiet[FindRoot[errf[m, pKnownExact, q, rXapp] == 0, {q, Log[N[pTrue2]]}]];
  qC = q /. Quiet[FindRoot[errf[m, pKnownApprox, q, rXapp] == 0, {q, Log[N[pTrue2]]}]];
  classicalD = liInv[m + 2];

  predA = Exp[qA]; predB = Exp[qB]; predC = Exp[qC];
  relE[x_] := N[(x - pTrue2)/pTrue2, 6];
  Print[{m, "true=", pTrue2}];
  Print["  A errf(true riseX,true p)    : pred=", N[predA, 10], " relErr=", relE[predA]];
  Print["  B errf(approx riseX,true p)  : pred=", N[predB, 10], " relErr=", relE[predB]];
  Print["  C errf(approx riseX,approx p): pred=", N[predC, 10], " relErr=", relE[predC]];
  Print["  D classical liInv[m+2]       : pred=", N[classicalD, 10], " relErr=", relE[classicalD]],
  {m, {10, 50, 200, 1000, 5000, 20000}}
];
