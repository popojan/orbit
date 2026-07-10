(* 16: null-model control for script 15's suspicious in-sample corr = -0.18.
   d is (nearly) a deterministic function of C = Li(p) - m, and C random-walks;
   WINDOW-DEMEANING A WALK mechanically induces negative level-vs-next-increment
   correlation (the window mean contains the future).  Controls:
   (a) identical pipeline on SYNTHETIC primes with iid exponential gaps -- zero
       signal by construction: whatever corr survives is pure artifact;
   (b) causal version: trailing-window demeaning + out-of-sample lambda;
   (c) strict single-pair channel: corr(e, C) raw -- what one prime alone offers;
   (d) reference: direct autocorrelation of consecutive real gaps (the known,
       machinery-free signal that any trailing scheme repackages). *)

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

SeedRandom[20260710];
lo = 500; hi = 5000; step = 2;

real = Table[Module[{p1 = Prime[m + 1], p2 = Prime[m + 2], q, pred},
    q = Log[N[p1]];
    pred = nextPrimeCF2[m, p1];
    {m, (pred - (p1 + q))/q, (p2 - (p1 + q))/q, LogIntegral[N[p1]] - (m + 1)}],
   {m, lo, hi, step}];

(* synthetic walk: iid exponential gaps, mean log p -- no signal by construction *)
pstar = N[Prime[lo + 1]];
synthAll = Table[Module[{q = Log[pstar], g},
    g = -Log[RandomReal[]] q;
    r = {m, pstar, g};
    pstar = pstar + g;
    r], {m, lo, hi}];
null = Table[Module[{m = row[[1]], p1 = row[[2]], g = row[[3]], q, pred},
    q = Log[p1];
    pred = nextPrimeCF2[m, p1];
    {m, (pred - (p1 + q))/q, (g - q)/q}], {row, synthAll[[1 ;; -1 ;; step]]}];

windowedCorr[dat_] := Module[{blocks = Partition[dat, 50], resid},
   resid = Flatten[Table[Module[{dd = b[[All, 2]], ee = b[[All, 3]]},
       Transpose[{dd - Mean[dd], ee - Mean[ee]}]], {b, blocks}], 1];
   Correlation[resid[[All, 1]], resid[[All, 2]]]];

Print["(a) windowed in-sample corr(d_resid, e_resid):"];
Print["    real primes     : ", N[windowedCorr[real[[All, {1, 2, 3}]]], 4]];
Print["    iid-gap null    : ", N[windowedCorr[null], 4], "   <- pure demeaning artifact"];

(* (b) causal: trailing demeaning of d, lambda fit on first half, tested on second *)
w = 50;
causal[dat_] := Table[{dat[[t, 2]] - Mean[dat[[t - w ;; t - 1, 2]]], dat[[t, 3]]},
   {t, w + 1, Length[dat]}];
tr = causal[real];
trN = causal[null];
half = Floor[Length[tr]/2];
lamIS = Covariance[tr[[;; half, 1]], tr[[;; half, 2]]]/Variance[tr[[;; half, 1]]];
oos = tr[[half + 1 ;;]];
rms0 = Sqrt[Mean[oos[[All, 2]]^2]];
rms1 = Sqrt[Mean[(oos[[All, 2]] - lamIS oos[[All, 1]])^2]];
Print["(b) causal trailing-demeaned, real primes:"];
Print["    corr = ", N[Correlation[tr[[All, 1]], tr[[All, 2]]], 4],
  "  (null: ", N[Correlation[trN[[All, 1]], trN[[All, 2]]], 4], ")"];
Print["    in-sample lambda = ", N[lamIS, 4], ";  out-of-sample RMS ", N[rms0, 5],
  " -> ", N[rms1, 5], "  (", N[100 (1 - rms1/rms0), 3], "%)"];

(* (c) strict single-pair channel *)
Print["(c) strict one-pair channel: corr(e, C_raw) = ",
  N[Correlation[real[[All, 4]], real[[All, 3]]], 4],
  "   (2/sqrt(n) = ", N[2/Sqrt[Length[real]], 3], ")"];

(* (d) reference: plain consecutive-gap autocorrelation, no machinery *)
gaps = Table[(Prime[m + 2] - Prime[m + 1])/Log[Prime[m + 1]] // N, {m, lo, hi}];
Print["(d) direct corr(g_n, g_{n+1}) of real normalized gaps: ",
  N[Correlation[Most[gaps], Rest[gaps]], 4]];
