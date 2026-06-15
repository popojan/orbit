(* H1 first cut: resolution-gating of positivity detection on the genuine zeta
   spectrum. Baseline = true zeta zeros near T=100 (exact PSD Gram form). Plant
   an FE off-line quartet at gamma0=100, displacement delta. Find delta*(w) =
   smallest delta that makes the Weil form indefinite, vs test-function
   resolution w. Question: how does the detectable displacement shrink with
   resolution, and where (in the kappa-proxy gap*log X) does detection onset? *)

prec = 35;
T0   = 100;
offs = {-2, -1, 0, 1, 2};                 (* basis centers T0+offs, spacing 1 *)
mB   = Length[offs];

(* true zeta zeros with gamma in ~[80,120] (basis support) *)
idx    = Range[18, 52];
gammas = N[Im[ZetaZero[idx]], prec];
gammas = Select[gammas, 75 < # < 125 &];
Print["using ", Length[gammas], " true zeta zeros, gamma in ",
   N[{Min[gammas], Max[gammas]}, 6]];

Bamp[a_, b_, w_] := 2 Pi w^2 Exp[-w^2 (a - b)^2/4];
hval[a_, b_, w_, r_] := Bamp[a, b, w] Exp[-w^2 (r - (a + b)/2)^2];

Mzero[w_] := Module[{nu = T0 + offs},
  Table[Sum[hval[nu[[j]], nu[[k]], w, g] + hval[nu[[j]], nu[[k]], w, -g],
      {g, gammas}], {j, mB}, {k, mB}]];

quartet[w_, g0_, delta_] := Module[{nu = T0 + offs, d = delta},
  Table[Re[ hval[nu[[j]], nu[[k]], w, g0 + I d] + hval[nu[[j]], nu[[k]], w, g0 - I d]
          + hval[nu[[j]], nu[[k]], w, -g0 + I d] + hval[nu[[j]], nu[[k]], w, -g0 - I d]],
     {j, mB}, {k, mB}]];

minEig[w_, delta_] := Module[{M = Mzero[w] + quartet[w, T0, delta]},
  M = (M + Transpose[M])/2; Min[Eigenvalues[N[M, prec]]]];

gap = 2 Pi/Log[T0/(2 Pi)];               (* mean zero spacing at T0 *)
Print["mean gap at T=", T0, " : ", N[gap, 6], "\n"];

ws     = {2/5, 3/5, 9/10, 13/10, 9/5, 5/2, 7/2};
deltas = {1/100, 1/50, 3/100, 1/20, 2/25, 3/25, 1/5, 3/10, 2/5};
Print["w   | 1/w (r-res) | kappa~gap*2w | baseline minEig | delta*(first indefinite)"];
Do[Module[{base = minEig[w, 0], dstar = Infinity},
   Do[If[minEig[w, d] < 0 && dstar === Infinity, dstar = d], {d, deltas}];
   Print["  ", PaddedForm[N[w, 3], {4, 2}], " | ",
     PaddedForm[N[1/w, 3], {4, 2}], "       | ",
     PaddedForm[N[gap 2 w, 3], {5, 2}], "      | ",
     ScientificForm[N[base, 4]], "   | ",
     If[dstar === Infinity, "none<=0.4", ToString[N[dstar, 3]]]]],
  {w, ws}];

Print["\ninterpretation: delta* should shrink as resolution w grows;",
  " onset of fine detection vs kappa-proxy ~ pi is the H1 signal."];
Print["DONE."];
