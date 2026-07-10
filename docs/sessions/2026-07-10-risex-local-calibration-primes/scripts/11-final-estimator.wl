(* 11: THE FINAL PACKAGED ESTIMATOR.
   Given m and the one known prime p = Prime[m+1], estimate Prime[m+2] in closed
   form: solve errf = dXcf(m+1) (curvature-corrected = systematically unbiased),
   with the prime-free smooth Rcf standing in for riseX[m].  The only numerics is
   Li^-1 at the three integer arguments {m, m+1, m+2}; the prediction itself is
   one algebraic expression (errf is linear in 1/q).  Variants:
     eps = dXcf  -> unbiased (== Cramer local-density step; best RMS)     [default]
     eps = 0     -> raw A0 ansatz (implicit shift toward the gap midpoint)
     result - 0.22 Log[p]  -> median-tuned (empirical s* from script 09)  *)

liInvP[n_, wp_] := x /. Quiet[FindRoot[LogIntegral[x] == n,
    {x, N[Max[4, n (Log[n] + Log[Log[n]])], wp]},
    WorkingPrecision -> wp, PrecisionGoal -> If[wp === MachinePrecision, Automatic, wp - 10]],
   FindRoot::lstol];

GcfP[x_] := LogIntegral[x]^2/2 - x LogIntegral[x]/Log[x] +
   2 LogIntegral[x^2] - x^2/Log[x];

nextPrimeCF[m_, p_, wp_ : MachinePrecision] := Module[
   {d0, rcf, r0, r1, r2, rX, eps, A, B},
   d0[k_] := N[Log[k] LogIntegral[k], wp];
   rcf[k_] := Module[{y = liInvP[k, wp]}, (GcfP[y] + k/(2 Log[y]) - 1)/d0[k]];
   {r0, r1, r2} = rcf /@ {m, m + 1, m + 2};
   rX = r0;
   eps = (r2 + r0)/2 - r1;
   A = (m + 1)/Log[p] (1/(2 d0[m + 2]) - 1/d0[m + 1]) +
     rX (1/2 - d0[m]/d0[m + 1] + d0[m]/(2 d0[m + 2]));
   B = (m + 2)/(2 d0[m + 2]);
   Exp[B/(eps - A)]];

(* ---- verification ---- *)
localLiStep[p1_] := x /. Quiet[FindRoot[LogIntegral[x] - LogIntegral[N[p1]] == 1, {x, p1 + Log[p1]}]];

Print["m | true Prime[m+2] | nextPrimeCF | rel err | localLiStep rel err | CF-vs-L rel diff"];
Do[
  p1 = Prime[m + 1]; p2 = Prime[m + 2];
  pred = nextPrimeCF[m, p1];
  predL = localLiStep[p1];
  Print[{m, p2, N[pred, 9], N[(pred - p2)/p2, 4], N[(predL - p2)/p2, 4], N[(pred - predL)/predL, 3]}],
  {m, {10, 50, 200, 1000, 5000, 20000}}];

Print[""];
Print["median-tuned variant (subtract 0.22 Log[p]) at the same m:"];
Do[
  p1 = Prime[m + 1]; p2 = Prime[m + 2];
  pred = nextPrimeCF[m, p1] - 0.22 Log[p1];
  Print[{m, "rel err ", N[(pred - p2)/p2, 4]}],
  {m, {10, 50, 200, 1000, 5000, 20000}}];

Print[""];
Print["high-precision path (wp = 40) at m = 20000 (machine agrees to ~2e-8 rel, fine to m ~ 1e6 per section 2):"];
Print[N[nextPrimeCF[20000, Prime[20001], 40], 15]];

Print[""];
Print["scan sanity m = 500..5000 step 100: median/RMS rel err, CF vs localLiStep:"];
errsCF = {}; errsL = {};
Do[
  p1 = Prime[m + 1]; p2 = Prime[m + 2];
  AppendTo[errsCF, (nextPrimeCF[m, p1] - p2)/p2];
  AppendTo[errsL, (localLiStep[p1] - p2)/p2],
  {m, 500, 5000, 100}];
Print["CF : median|.| ", N[Median[Abs[errsCF]], 4], "   RMS ", N[Sqrt[Mean[errsCF^2]], 4]];
Print["L  : median|.| ", N[Median[Abs[errsL]], 4], "   RMS ", N[Sqrt[Mean[errsL^2]], 4]];
