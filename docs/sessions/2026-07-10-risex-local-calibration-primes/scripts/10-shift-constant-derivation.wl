(* 10: derivation & large-m determination of the A0 shift constant.
   The A0-vs-A1 prediction shift, in mean-gap units, is exactly
     s(m) = 2 p q |dXcf(m+1)| * D0(m+2)/(m+2),   p ~ Li^-1(m), q = log p
   (script 09's spot values omitted the D0/m factor, 1.13-1.24 in the scan range;
   corrected here).  Asymptotically s = -y u R''(m) F2,  y = Li^-1(m), u = log y,
   F2 = D0(m)/m.  Question: does s -> 1 - ln2 = 0.3069 (A0 median-optimal by
   accident) or elsewhere?  Two independent attacks:
   Part A: exact R'' by implicit differentiation (y'[t] = log y[t]), evaluated at
           m up to 1e40 via the closed form -- NO primes needed anywhere;
   Part C: full symbolic asymptotic series from the Li expansions. *)

(* ---------- Part A ---------- *)
GG[w_] := LogIntegral[w]^2/2 - w LogIntegral[w]/Log[w] + 2 LogIntegral[w^2] - w^2/Log[w];
R[t_] := (GG[y[t]] + t/(2 Log[y[t]]) - 1)/(Log[t] LogIntegral[t]);
rpp = D[R[t], {t, 2}] /. {Derivative[2][y][t] -> Log[y[t]]/y[t], Derivative[1][y][t] -> Log[y[t]]};

wp = 60;
liInvW[n_] := xx /. FindRoot[LogIntegral[xx] == n,
    {xx, N[Max[4, n (Log[n] + Log[Log[n]])], wp]}, WorkingPrecision -> wp, PrecisionGoal -> 40];
sVal[m_] := Module[{y0 = liInvW[m], mm = N[m, wp], r2},
   r2 = rpp /. y[t] -> y0 /. t -> mm;
   -y0 Log[y0] r2 (Log[mm] LogIntegral[mm]/mm)];

(* consistency: discrete dXcf route at m = 5000 *)
Rcf[k_] := Module[{yy = liInvW[k]}, (GG[yy] + k/(2 Log[yy]) - 1)/(N[Log[k] LogIntegral[k], wp])];
dXcfD[k_] := (Rcf[k + 1] + Rcf[k - 1])/2 - Rcf[k];
sDisc[m_] := Module[{p1 = liInvW[m + 1], q1}, q1 = Log[p1];
   2 p1 q1 Abs[dXcfD[m + 1]] N[Log[m + 2] LogIntegral[m + 2]/(m + 2), wp]];
Print["m=5000 check:  s(exact R'') = ", N[sVal[5000], 10], "   s(discrete dXcf) = ", N[sDisc[5000], 10]];

Print[""];
Print["m | u = log Li^-1(m) | log u | s(m) | (1/2 - s) u"];
data = {};
Do[Module[{y0, u0, s0},
   y0 = liInvW[m]; u0 = Log[y0]; s0 = sVal[m];
   AppendTo[data, {u0, Log[u0], s0}];
   Print[{N[m // N, 3], N[u0, 6], N[Log[u0], 5], N[s0, 8], N[(1/2 - s0) u0, 6]}]],
  {m, {5000, 10^4, 10^5, 10^6, 10^8, 10^10, 10^12, 10^16, 10^20, 10^30, 10^40}}];

(* implied linear model (1/2 - s) u = c1 + c2 log u from the two largest points *)
{u1, l1, s1} = data[[-2]]; {u2, l2, s2} = data[[-1]];
c2i = ((1/2 - s2) u2 - (1/2 - s1) u1)/(l2 - l1);
c1i = (1/2 - s1) u1 - c2i l1;
Print["implied from m=1e30,1e40:  (1/2 - s) u  ~  ", N[c1i, 4], " + ", N[c2i, 4], " log u"];

(* ---------- Part C: symbolic series ---------- *)
(* drop the -1 and E-M half-term (both exponentially suppressed in 1/u) so the
   expression is exactly homogeneous in ys and we may set ys -> 1 *)
Rsym[t_] := GG[y[t]]/(Log[t] LogIntegral[t]);
rppS = D[Rsym[t], {t, 2}] /. {Derivative[2][y][t] -> Log[y[t]]/y[t], Derivative[1][y][t] -> Log[y[t]]};
K = 6;
f = Sum[k!/u^k, {k, 0, K}];
lam = Normal@Series[Log[f], {u, Infinity, K}];
LL = u - l + lam;                        (* log t ; l stands for log u *)
invL = Normal@Series[1/LL, {u, Infinity, K}];
F2 = Normal@Series[Sum[k! invL^k, {k, 0, K}], {u, Infinity, K}];
tS = ys f/u;
LiTS = tS invL F2;                       (* Li(t) = (t/L)(1 + 1/L + 2/L^2 + ...) *)
liY = ys f/u;
liY2 = Normal@Series[ys^2/(2 u) Sum[k!/(2 u)^k, {k, 0, K}], {u, Infinity, K + 1}];
subbed = rppS /. y[t] -> ys /.
    {Log[ys^2] -> 2 u, LogIntegral[ys^2] -> liY2, LogIntegral[ys] -> liY, Log[ys] -> u} /.
    {LogIntegral[t] -> LiTS, Log[t] -> LL, t -> tS};
sSym = -ys u subbed F2;
chk = Table[sSym /. {ys -> yv, u -> 37., l -> Log[37.]}, {yv, {2., 1000.}}];
Print[""];
Print["homogeneity check in ys (values must agree): ", chk];
ser = Series[sSym /. ys -> 1, {u, Infinity, 2}];
serN = Normal[ser] // Expand // Simplify;
Print["symbolic series for s(u), with l = log u:"];
Print[serN];

Print[""];
Print["series vs exact s at the sampled points:"];
Do[Print[{"u=", N[data[[i, 1]], 5], "  s exact ", N[data[[i, 3]], 7],
    "  series ", N[serN /. {u -> data[[i, 1]], l -> data[[i, 2]]}, 7]}],
  {i, Length[data]}];
