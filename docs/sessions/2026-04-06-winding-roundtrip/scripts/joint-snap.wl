(* ================================================================ *)
(* JOINT SNAP: global optimization instead of per-column snap       *)
(* Each column snapped to minimize GLOBAL residual ‖Θ - a⊗ℓ‖       *)
(* ================================================================ *)

sz = 200;
g = Table[N[Im[ZetaZero[n]], 15], {n, sz}];
lp = Table[Log[N[Prime[j], 15]], {j, sz}];
w = Table[Floor[g[[n]] lp[[j]] / (2 Pi)], {n, sz}, {j, sz}];
pExact = Table[Prime[j], {j, sz}];
th = N[w] + 0.5;

(* === Method 1: Independent snap (baseline) === *)
a = First[SingularValueDecomposition[th]][[All, 1]];
If[a[[1]] < 0, a = -a];
a = a * Norm[th, "Frobenius"] / Norm[a];
Do[
  el = Transpose[th] . a / (a . a);
  el = el * (Log[2.] / el[[1]]);
  el = Log[N[Max[2, Round[#]] & /@ Exp[el], 15]];
  a = th . el / (el . el), {10}];
pcIndep = Count[Table[Round[Exp[el[[j]]]] == pExact[[j]], {j, sz}], True];

(* === Method 2: Joint sweep (global residual per snap) === *)
a2 = First[SingularValueDecomposition[th]][[All, 1]];
If[a2[[1]] < 0, a2 = -a2];
a2 = a2 * Norm[th, "Frobenius"] / Norm[a2];
el2 = Table[0., sz];

Do[
  el2 = Transpose[th] . a2 / (a2 . a2);
  el2 = el2 * (Log[2.] / el2[[1]]);
  Do[
    Module[{nC = Max[2, Round[Exp[el2[[j]]]]], cands, best, bestErr = Infinity},
      cands = Select[Range[Max[2, nC - 3], nC + 3],
        If[j > 1, OddQ, True &]];
      Do[Module[{elTry = el2, aTry, err},
        elTry[[j]] = Log[N[k, 15]];
        aTry = th . elTry / (elTry . elTry);
        err = Norm[th - Outer[Times, aTry, elTry]];
        If[err < bestErr, bestErr = err; best = k]], {k, cands}];
      el2[[j]] = Log[N[best, 15]]];
    a2 = th . el2 / (el2 . el2),
  {j, sz}],
{3}];
pcJoint = Count[Table[Round[Exp[el2[[j]]]] == pExact[[j]], {j, sz}], True];

(* === Method 3: Joint sweep + roundtrip verification === *)
gammas3 = 2 Pi a2;
Do[
  Module[{nC = Round[Exp[el2[[j]]]], cands, scores, best},
    cands = Select[Range[Max[2, nC - 4], nC + 4],
      If[j > 1, OddQ, True &]];
    scores = Table[{
      Count[Table[Floor[gammas3[[n]] Log[N[k,15]]/(2 Pi)] != w[[n,j]],
        {n, sz}], True],
      Abs[Log[N[k,15]] - el2[[j]]]}, {k, cands}];
    best = cands[[First[Ordering[scores]]]];
    el2[[j]] = Log[N[best, 15]]],
{j, sz}];
a2 = th . el2 / (el2 . el2);
pcVerif = Count[Table[Round[Exp[el2[[j]]]] == pExact[[j]], {j, sz}], True];

Print["=== 200×200 SNAP COMPARISON ===\n"];
Print["Independent snap:          ", pcIndep, "/", sz];
Print["Joint sweep (3 passes):    ", pcJoint, "/", sz];
Print["Joint + roundtrip verify:  ", pcVerif, "/", sz];

(* Also test 300, 500 with joint snap *)
Print["\n=== Scaling ==="];
Do[
  gg = Table[N[Im[ZetaZero[n]], 15], {n, ssz}];
  llp = Table[Log[N[Prime[j], 15]], {j, ssz}];
  ww = Table[Floor[gg[[n]] llp[[j]] / (2 Pi)], {n, ssz}, {j, ssz}];
  tth = N[ww] + 0.5;
  aa = First[SingularValueDecomposition[tth]][[All, 1]];
  If[aa[[1]] < 0, aa = -aa];
  aa = aa * Norm[tth, "Frobenius"] / Norm[aa];
  Do[
    eel = Transpose[tth] . aa / (aa . aa);
    eel = eel * (Log[2.] / eel[[1]]);
    eel = Log[N[Max[2, Round[#]] & /@ Exp[eel], 15]];
    aa = tth . eel / (eel . eel), {10}];
  pc = Count[Table[Round[Exp[eel[[j]]]] == Prime[j], {j, ssz}], True];
  Print[ssz, "×", ssz, " independent: ", pc, "/", ssz],
{ssz, {100, 200, 300, 400, 500}}];
