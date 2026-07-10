(* 13: what does the (m, p) pairing know about Prime[]?
   Claim: in the coordinate nu = Li(p), the unbiased estimator is unit translation
   nu -> nu + 1; its conserved quantity is C = Li(p) - m (minus the PNT error term);
   the invariant manifolds are the level curves Li(x) = m + C; and the raw errf=0
   ansatz translates by 1 - s(u) (the section-10 midpoint theorem in Li-units).
   True primes DRIFT in C -- that drift is pi - Li, the part provably invisible
   to this machinery (section 7). *)

GcfP[x_] := LogIntegral[x]^2/2 - x LogIntegral[x]/Log[x] + 2 LogIntegral[x^2] - x^2/Log[x];

nextPrimeGen[m_, p_, useEps_] := Module[{d0, q, y, u, rX, eps, A, B},
   d0[k_] := N[Log[k] LogIntegral[k]];
   q = Log[N[p]];
   y = p - (LogIntegral[N[p]] - m) q;
   y = y - (LogIntegral[y] - m) Log[y];
   u = Log[y];
   rX = (GcfP[y] + m/(2 u) - 1)/d0[m];
   eps = If[useEps, -(1/2 - 1/u - (Log[u] + 3/4)/u^2) (m + 2)/(2 y u d0[m + 2]), 0];
   A = (m + 1)/q (1/(2 d0[m + 2]) - 1/d0[m + 1]) +
     rX (1/2 - d0[m]/d0[m + 1] + d0[m]/(2 d0[m + 2]));
   B = (m + 2)/(2 d0[m + 2]);
   Exp[B/(eps - A)]];

Print["1) unit-translation check: Li(pred) - Li(p) for the unbiased map (should -> 1):"];
Do[
  p1 = Prime[m + 1];
  pred = nextPrimeGen[m, p1, True];
  Print[{m, N[LogIntegral[pred] - LogIntegral[N[p1]], 6]}],
  {m, {200, 1000, 5000, 20000, 100000}}];

Print[""];
Print["2) same input m, p displaced off the true prime by k mean gaps (not prime!) --"];
Print["   translation must not care where p sits (it only sees Li(p) and m):"];
Do[
  p1 = N[Prime[1001] + k Round[Log[Prime[1001]]]];
  pred = nextPrimeGen[1000, p1, True];
  Print[{k, N[LogIntegral[pred] - LogIntegral[p1], 6]}],
  {k, {-3, -1, 0, 1, 3}}];

Print[""];
Print["3) raw errf=0 ansatz: Li(pred) - Li(p) vs 1 - s(u)  (midpoint theorem in Li-units):"];
Do[
  p1 = Prime[m + 1]; u = Log[N[p1]];
  pred0 = nextPrimeGen[m, p1, False];
  Print[{m, N[LogIntegral[pred0] - LogIntegral[N[p1]], 5], " vs 1 - s_series = ",
     N[1 - (1/2 - 1/u - (Log[u] + 3/4)/u^2), 5]}],
  {m, {200, 1000, 5000, 20000}}];

Print[""];
Print["4) chained recurrence: seed one true prime, iterate; C = Li(p) - index."];
Do[
  Module[{m0 = mm, steps = 500, pcur, c0, cend, ctrue, pTrue},
   pcur = N[Prime[m0 + 1]];
   c0 = LogIntegral[pcur] - (m0 + 1);
   Do[pcur = nextPrimeGen[m0 + j, pcur, True], {j, 0, steps - 1}];
   pTrue = Prime[m0 + steps + 1];
   cend = LogIntegral[pcur] - (m0 + steps + 1);
   ctrue = LogIntegral[N[pTrue]] - (m0 + steps + 1);
   Print["m0=", m0, " steps=", steps, ":  pred ", N[pcur, 8], "  true ", pTrue,
     "  rel err ", N[(pcur - pTrue)/pTrue, 3]];
   Print["   C0 = ", N[c0, 5], "   C(chained) = ", N[cend, 5],
     "   C(true primes) = ", N[ctrue, 5]];
   Print["   map drift ", N[cend - c0, 3], " Li-units vs true-prime drift ",
     N[ctrue - c0, 3], " Li-units"]],
  {mm, {1000, 20000}}];
