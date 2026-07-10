(* 12: inversion-free final estimator -- NO FindRoot / numerical Li^-1 anywhere.
   Two replacements relative to script 11:
   (a) y = Li^-1(m): two EXPLICIT Newton steps seeded at the known prime p
       (forward LogIntegral only; p is itself a fluctuation-level sample of
       Li^-1 near the target, and rX only needs ~1% accuracy -- Newton gives ppm);
   (b) eps = dXcf(m+1): the section-10 closed-form series
       eps = -s(u) (m+2)/(2 y u D0(m+2)),  s(u) = 1/2 - 1/u - (log u + 3/4)/u^2.
   Result: the estimator is a single explicit formula in Log / LogIntegral. *)

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

(* reference: the FindRoot version from script 11 *)
liInvP[n_] := x /. Quiet[FindRoot[LogIntegral[x] == n,
     {x, Max[4, n (Log[n] + Log[Log[n]])]}], FindRoot::lstol];
nextPrimeCF[m_, p_] := Module[{d0, rcf, r0, r1, r2, rX, eps, A, B},
   d0[k_] := N[Log[k] LogIntegral[k]];
   rcf[k_] := Module[{y = liInvP[k]}, (GcfP[y] + k/(2 Log[y]) - 1)/d0[k]];
   {r0, r1, r2} = rcf /@ {m, m + 1, m + 2};
   rX = r0;
   eps = (r2 + r0)/2 - r1;
   A = (m + 1)/Log[p] (1/(2 d0[m + 2]) - 1/d0[m + 1]) +
     rX (1/2 - d0[m]/d0[m + 1] + d0[m]/(2 d0[m + 2]));
   B = (m + 2)/(2 d0[m + 2]);
   Exp[B/(eps - A)]];

Print["m | true | CF2 (inversion-free) rel err | CF (FindRoot) rel err | CF2-vs-CF rel diff"];
Do[
  p1 = Prime[m + 1]; p2 = Prime[m + 2];
  pr2 = nextPrimeCF2[m, p1]; pr1 = nextPrimeCF[m, p1];
  Print[{m, p2, N[(pr2 - p2)/p2, 4], N[(pr1 - p2)/p2, 4], N[(pr2 - pr1)/pr1, 3]}],
  {m, {200, 1000, 5000, 20000, 100000}}];

Print[""];
Print["Newton quality: y after two steps vs FindRoot Li^-1(m):"];
Do[
  p1 = Prime[m + 1]; q = Log[N[p1]];
  y1 = p1 - (LogIntegral[N[p1]] - m) q;
  y2 = y1 - (LogIntegral[y1] - m) Log[y1];
  yF = liInvP[m];
  Print[{m, "rel err 1 step ", N[(y1 - yF)/yF, 3], "  2 steps ", N[(y2 - yF)/yF, 3]}],
  {m, {200, 1000, 20000}}];

Print[""];
Print["scan m = 500..5000 step 100: median / RMS rel err:"];
e2 = {}; e1 = {};
Do[
  p1 = Prime[m + 1]; p2 = Prime[m + 2];
  AppendTo[e2, (nextPrimeCF2[m, p1] - p2)/p2];
  AppendTo[e1, (nextPrimeCF[m, p1] - p2)/p2],
  {m, 500, 5000, 100}];
Print["CF2: median|.| ", N[Median[Abs[e2]], 4], "   RMS ", N[Sqrt[Mean[e2^2]], 4]];
Print["CF : median|.| ", N[Median[Abs[e1]], 4], "   RMS ", N[Sqrt[Mean[e1^2]], 4]];
Print["max |CF2 - CF| relative over scan: ", N[Max[Abs[e2 - e1]], 3]];
