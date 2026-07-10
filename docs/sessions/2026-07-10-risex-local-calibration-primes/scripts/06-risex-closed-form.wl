(* Fix for the §4 NIntegrate fragility: Integrate[Li(x)/(Log x)^2, x] has an exact
   elementary+Li antiderivative that WL's Integrate does not find on its own.
   Two integrations by parts (using Integrate[1/(Log x)^2,x] = Li(x)-x/Log(x) and
   Integrate[x/Log(x),x] = Li(x^2)) give:

     G(x) := Li(x)^2/2 - x Li(x)/Log(x) + 2 Li(x^2) - x^2/Log(x)     G'(x) = Li(x)/(Log x)^2

   so SmApprox(m) = G(y) - G(x0) exactly, y := Li^-1(m), x0 := Li^-1(2) (a fixed
   constant, computed once). This removes NIntegrate (and its singularity-adjacent
   failure mode from script 04) entirely -- the only numerics left is one exact,
   well-conditioned monotone FindRoot for Li^-1(m) itself. *)

liInv[n_] := x /. Quiet[FindRoot[LogIntegral[x] == n, {x, Max[4, n (Log[n] + Log[Log[n]])]}]];

G[x_] := LogIntegral[x]^2/2 - x LogIntegral[x]/Log[x] + 2 LogIntegral[x^2] - x^2/Log[x];

Print["Verify G'(x) == LogIntegral[x]/Log[x]^2 (numeric spot check, 20 digits):"];
Do[Print[{xx, N[D[G[x], x] /. x -> xx, 20], N[LogIntegral[xx]/Log[xx]^2, 20]}],
  {xx, {5, 50, 1000, 1000000}}];

Sm[m_] := Sum[n/Log[Prime[n]] // N, {n, 2, m}];
riseX[m_] := (-1 + Sm[m])/(Log[m] LogIntegral[m] // N);

x0 = liInv[2];
Gx0 = G[x0] // N; (* fixed constant, computed once: G[x0] since Li(x0)=2 exactly *)

(* SmClosed(m) = G(y) - G(x0), with G(y) simplified using Li(y) = m exactly *)
SmClosed[m_] := Module[{y = liInv[m]}, m^2/2 - y*m/Log[y] + 2 LogIntegral[y^2] - y^2/Log[y] - Gx0];
riseXClosed[m_] := (-1 + SmClosed[m])/(Log[m] LogIntegral[m] // N);

(* old NIntegrate version, for the accuracy/speed comparison *)
SmApproxOld[m_] := NIntegrate[LogIntegral[x]/Log[x]^2, {x, x0, liInv[m]},
   WorkingPrecision -> 20, PrecisionGoal -> 12];
riseXApproxOld[m_] := (-1 + SmApproxOld[m])/(Log[m] LogIntegral[m] // N);

Print[""];
Print["x0 = ", N[x0, 15], "   G[x0] = ", N[Gx0, 15]];
Print[""];
Print["riseX (true) vs riseXClosed (new) vs riseXApproxOld (NIntegrate):"];
Do[
  rTrue = riseX[m]; rClosed = riseXClosed[m]; rOld = riseXApproxOld[m];
  Print[{m, "true=", N[rTrue, 10], "closed=", N[rClosed, 10], "old(NIntegrate)=", N[rOld, 10],
     "closed relErr vs true=", N[(rClosed - rTrue)/rTrue, 6],
     "closed-vs-old diff=", N[rClosed - rOld, 10]}],
  {m, {10, 50, 200, 1000, 5000, 20000}}
];

Print[""];
Print["timing, single call at m=5000:"];
Print["closed form: ", AbsoluteTiming[riseXClosed[5000]][[1]], " s"];
Print["NIntegrate : ", AbsoluteTiming[riseXApproxOld[5000]][[1]], " s"];
