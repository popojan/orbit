(* H1.2: the off-line (sigma) channel vs the along-line (gamma) channel.
   Apples-to-apples response of the Weil/Gram form to a displacement d of a
   conjugate zero-pair, OFF the line (ordinate +-gamma0 +- i d, FE+conj quartet
   vs its d->0 doubled-pair limit) versus ALONG the line (pair +-gamma0 ->
   +-(gamma0+d)). Measure the response norm ||Delta M||_F and its scaling
   exponent in d.  Prediction from analyticity: along-line ~ d^1 (first order),
   off-line ~ d^2 (second order) -> the sigma channel is intrinsically the
   weaker one, so the line is NOT "more rigid"; off-line violations are HARDER
   to see (must overcome the d^2 smallness) -- which is why H1 saw off-line
   detection onset only at/above Nyquist. *)

prec = 40;
g0   = 100;
offs = {-2, -1, 0, 1, 2};
mB   = Length[offs];

hval[a_, b_, w_, r_] := 2 Pi w^2 Exp[-w^2 (a - b)^2/4] Exp[-w^2 (r - (a + b)/2)^2];
pairMat[w_, g_] := Module[{nu = g0 + offs},
   Table[hval[nu[[j]], nu[[k]], w, g] + hval[nu[[j]], nu[[k]], w, -g],
     {j, mB}, {k, mB}]];
quartMat[w_, gc_, d_] := Module[{nu = g0 + offs},
   Table[Re[hval[nu[[j]], nu[[k]], w, gc + I d] + hval[nu[[j]], nu[[k]], w, gc - I d]
          + hval[nu[[j]], nu[[k]], w, -gc + I d] + hval[nu[[j]], nu[[k]], w, -gc - I d]],
     {j, mB}, {k, mB}]];

Ron[w_, d_]  := Sqrt[Total[Flatten[(pairMat[w, g0 + d] - pairMat[w, g0])^2]]];
Roff[w_, d_] := Sqrt[Total[Flatten[(quartMat[w, g0, d] - quartMat[w, g0, 0])^2]]];

ds = {1/400, 1/200, 1/100, 1/50, 1/25, 2/25};
Print["=== channel response ||Delta M||_F vs displacement d ==="];
Do[
  Print["\n w = ", N[w, 3], "  (1/w = ", N[1/w, 3], ", mean gap@T=100 ~ 2.27)"];
  Print["   d      R_on(along-line)     R_off(off-line)     R_off/R_on"];
  Do[With[{ron = Ron[w, d], roff = Roff[w, d]},
     Print["   ", PaddedForm[N[d, 4], {6, 4}], "  ",
       ScientificForm[N[ron, 6]], "   ", ScientificForm[N[roff, 6]], "   ",
       ScientificForm[N[roff/ron, 4]]]],
    {d, ds}];
  (* fit log-log slopes on the small-d half *)
  Module[{dsm = Take[ds, 4], son, soff},
   son = Fit[Table[{Log[N[d, prec]], Log[Ron[w, d]]}, {d, dsm}], {1, x}, x];
   soff = Fit[Table[{Log[N[d, prec]], Log[Roff[w, d]]}, {d, dsm}], {1, x}, x];
   Print["   slope d log R_on  = ", N[Coefficient[son, x], 4],
         "   (expect ~1, first order)"];
   Print["   slope d log R_off = ", N[Coefficient[soff, x], 4],
         "   (expect ~2, second order)"]],
  {w, {1, 2}}];

Print["\nDONE."];
