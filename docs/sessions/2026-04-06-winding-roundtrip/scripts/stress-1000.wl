(* ================================================================ *)
(* STRESS TEST: 1000×1000 ALS + roundtrip sieve                    *)
(* ================================================================ *)

sz = 1000;
Print["Building ", sz, "×", sz, " winding matrix..."];
g = Table[N[Im[ZetaZero[n]], 15], {n, sz}];
lp = Table[Log[N[Prime[j], 15]], {j, sz}];
w = Table[Floor[g[[n]] lp[[j]] / (2 Pi)], {n, sz}, {j, sz}];
pExact = Table[Prime[j], {j, sz}];
Print["Done. Max entry: ", Max[w]];

(* ALS *)
Print["ALS..."];
th = N[w] + 0.5;
a = First[SingularValueDecomposition[th]][[All, 1]];
If[a[[1]] < 0, a = -a];
a = a * Norm[th, "Frobenius"] / Norm[a];
Do[
  el = Transpose[th] . a / (a . a);
  el = el * (Log[2.] / el[[1]]);
  el = Log[N[Max[2, Round[#]] & /@ Exp[el], 15]];
  a = th . el / (el . el), {10}];

pcALS = Count[Table[Round[Exp[el[[j]]]] == pExact[[j]], {j, sz}], True];
Print["ALS only: ", pcALS, "/", sz];

(* Roundtrip sieve *)
Print["Roundtrip sieve..."];
Do[
  gammas = 2 Pi a;
  Do[
    Module[{nC = Round[Exp[el[[j]]]], cands, scores, best},
      cands = Select[Range[Max[2, nC - 4], nC + 4],
        If[j > 1, OddQ, True &]];
      scores = Table[{
        Count[Table[Floor[gammas[[n]] Log[N[k, 15]] / (2 Pi)] != w[[n, j]],
          {n, sz}], True],
        Abs[Log[N[k, 15]] - el[[j]]]}, {k, cands}];
      best = cands[[First[Ordering[scores]]]];
      el[[j]] = Log[N[best, 15]]],
  {j, sz}];
  a = th . el / (el . el),
{5}];

pcSieve = Count[Table[Round[Exp[el[[j]]]] == pExact[[j]], {j, sz}], True];
gErr = Abs[2 Pi a - g];

Print["\n══════════════════════════════"];
Print["1000×1000 RESULTS"];
Print["══════════════════════════════"];
Print["ALS only:       ", pcALS, "/", sz];
Print["+ roundtrip:    ", pcSieve, "/", sz];
Print["γ max error:    ", NumberForm[Max[gErr], {4, 4}]];
Print["γ mean error:   ", NumberForm[Mean[gErr], {4, 4}]];

If[pcSieve < sz,
  wrong = Select[Range[sz], Round[Exp[el[[#]]]] != pExact[[#]] &];
  Print["Wrong: ", Length[wrong], " positions"];
  Print["First 10: ", Table[{j, pExact[[j]], "→", Round[Exp[el[[j]]]]},
    {j, wrong[[1 ;; Min[10, Length[wrong]]]]}]]];
