(* 14: mis-calling nextPrimeCF2[m, Prime[m]] (slot expects Prime[m+1]) seems to
   return ~Prime[m+2] at m ~ 25-27.  Show this is a low-m artifact: the map
   advances the input prime by T(m) Li-units where T -> 1 (section 12) but has a
   large finite-size excess at small m (T ~ 1.4), AND the 97..113 stretch is a
   dense cluster (local gaps 2,4 << mean gap 4.6) -- so T*meanGap ~ TWO local
   gaps exactly there.  Asymptotically the same call advances one mean gap,
   i.e. lands near Prime[m+1], with only gap-noise scatter. *)

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

Print["A) the observation, reproduced (mis-called with p = Prime[m]):"];
Print["m | input | pred | Prime[m+1] | Prime[m+2] | Li-translation T"];
Do[
  p0 = Prime[m]; pred = nextPrimeCF2[m, p0];
  Print[{m, p0, N[pred, 6], Prime[m + 1], Prime[m + 2],
    N[LogIntegral[pred] - LogIntegral[N[p0]], 4]}],
  {m, 24, 31}];

Print[""];
Print["B) the local cluster: gaps of primes 89..127 vs mean gap log p ~ 4.6:"];
Print[Differences[Table[Prime[k], {k, 24, 33}]]];

Print[""];
Print["C) statistics of the same mis-call at three heights (100 consecutive m each):"];
Do[
  res = Table[Module[{p0 = Prime[m], pred},
     pred = nextPrimeCF2[m, p0];
     {LogIntegral[pred] - LogIntegral[N[p0]],
      PrimePi[Floor[pred]] - m,
      Abs[pred - Prime[m + 1]]/Log[Prime[m + 1]],
      Abs[pred - Prime[m + 2]]/Log[Prime[m + 1]]}], {m, lo, lo + 99}];
  Print["m in [", lo, ",", lo + 99, "]:"];
  Print["   mean Li-translation T = ", N[Mean[res[[All, 1]]], 4]];
  Print["   primes actually passed (tally): ", Sort[Tally[res[[All, 2]]]]];
  Print["   median dist to Prime[m+1] = ", N[Median[res[[All, 3]]], 3],
    " mean gaps;  to Prime[m+2] = ", N[Median[res[[All, 4]]], 3], " mean gaps"],
  {lo, {25, 1000, 20000}}];
