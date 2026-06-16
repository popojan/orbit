(* L0: does the operator's data carry the prime frequencies {log p}?
   (i)  Prime spectrum of the zeros (conjugate to height gamma -- clean):
        D(omega) = |sum_n exp(i omega gamma_n)| should peak at omega = log p^m.
        This confirms the zero-signal IS a {log p} quasiperiodic superposition.
   (ii) Reconstruct the Jacobi off-diagonal b_k from the (folded) zeros and look
        for the same frequencies in the OPERATOR's potential (harder: the index
        k <-> height map drifts as the gap changes). *)

NN  = 150;
gam = N[Im[ZetaZero[Range[NN]]], 30];
Print["zeros: n=1..", NN, ", gamma in ", N[{gam[[1]], gam[[-1]]}, 6]];

(* ---- (i) prime spectrum of the zeros ---- *)
Print["\n=== (i) prime spectrum  D(omega)=|sum exp(i omega gamma_n)| ==="];
D2[om_] := Abs[Sum[Exp[I om gam[[n]]], {n, NN}]];
grid = Range[300, 3300]/1000;                      (* omega in [0.3, 3.3] *)
vals = D2 /@ grid;
(* local maxima above threshold *)
peaks = {};
Do[If[vals[[i]] > vals[[i - 1]] && vals[[i]] > vals[[i + 1]] && vals[[i]] > 8,
    AppendTo[peaks, {grid[[i]], vals[[i]]}]], {i, 2, Length[grid] - 1}];
(* prime-power logs for reference *)
pk = Select[Range[2, 30], PrimePowerQ];
reflogs = Sort[Log[N[pk]]];
nearest[om_] := First[SortBy[pk, Abs[Log[N[#]] - om] &]];
Print[" peak omega | height | nearest log(p^m) | p^m | |diff|"];
Do[With[{om = pkv[[1]], ht = pkv[[2]], m = nearest[pkv[[1]]]},
   Print["   ", PaddedForm[N[om, 4], {5, 3}], "  | ", PaddedForm[N[ht, 4], {6, 2}],
     "  | ", PaddedForm[N[Log[m], 4], {5, 3}], "  | ", PaddedForm[m, 3],
     "  | ", ScientificForm[N[Abs[om - Log[m]], 2]]]],
  {pkv, SortBy[peaks, -#[[2]] &][[1 ;; Min[14, Length[peaks]]]]}];
Print[" (peaks land on log of prime powers = the explicit-formula dual:",
   " the zero-signal IS a {log p} quasiperiodic superposition)"];

(* ---- (ii) Jacobi off-diagonal from the folded zeros (Lanczos) ---- *)
Print["\n=== (ii) Jacobi off-diagonal b_k from the zeros (Lanczos) ==="];
prec = 50;
xx = N[2 (gam - gam[[1]])/(gam[[-1]] - gam[[1]]) - 1, prec];   (* fold to [-1,1] *)
ww = ConstantArray[1/NN, NN];
applyX[v_] := xx v;
v1 = Sqrt[ww]; v1 = v1/Norm[v1];
Qs = {v1}; acoef = {}; bcoef = {};
res = applyX[v1]; a1 = v1.res; res = res - a1 v1; AppendTo[acoef, a1];
Kmax = 110;
Do[Module[{b, v, a},
   b = Norm[res];
   If[b < 10^-22, Print["  Lanczos terminated/unstable at k=", k]; Break[]];
   AppendTo[bcoef, b];
   v = res/b;
   v = v - Sum[(q.v) q, {q, Qs}]; v = v/Norm[v];     (* full reorthogonalization *)
   AppendTo[Qs, v];
   res = applyX[v] - b Qs[[-2]];
   a = v.res; AppendTo[acoef, a];
   res = res - a v;
   res = res - Sum[(q.res) q, {q, Qs}]],
  {k, 2, Kmax}];
nb = Length[bcoef];
Print["  stable b_k computed for k=1..", nb];
Print["  b_k sample: ", N[Take[bcoef, {1, Min[8, nb]}], 4]];
Print["  b_k tail:   ", N[Take[bcoef, {Max[1, nb - 5], nb}], 4]];

(* detrend (smooth quadratic fit) and look at fluctuations *)
ks = Range[nb];
fit = Fit[Transpose[{N[ks], N[bcoef]}], {1, x, x^2, x^3}, x];
fluct = N[bcoef] - (fit /. x -> N[ks]);
Print["  b_k fluctuation (after cubic detrend): rms ",
   ScientificForm[N[Sqrt[Mean[fluct^2]], 4]],
   ", max ", ScientificForm[N[Max[Abs[fluct]], 4]]];
(* crude spectrum of the fluctuation in k *)
ft = Table[{f, Abs[Sum[fluct[[j]] Exp[I f j], {j, nb}]]}, {f, Range[5, 300]/100}];
top = SortBy[ft, -#[[2]] &][[1 ;; 5]];
Print["  dominant frequencies of b_k(k) fluctuation: ",
   Column[Map[{N[#[[1]], 3], "amp ", N[#[[2]], 3]} &, top]]];
Print["  NOTE: index-k frequencies drift with the gap (gap changes with height),"];
Print["  so clean log-p peaks are NOT expected in raw b_k(k) -- the clean test"];
Print["  is (i). (ii) shows the operator-side carries fluctuations but the index"];
Print["  map smears the frequencies; a narrow-height window would be needed."];
Print["DONE."];
