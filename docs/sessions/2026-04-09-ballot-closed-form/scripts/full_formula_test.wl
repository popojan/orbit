(* FULL FORMULA: compute v_j(p) at ANY semi-convergent position *)
(* v_j(p) = uniform(p,j) - Delta(p,j) *)
(* where Delta comes from the block transfer correction *)

vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]

(* Correction at j-th entry of state vector after k blocks *)
(* At position p = p0 + k*p1, the correction comes from k-1 applications *)
(* of the block transfer, each introducing a correction *)

(* Actually: the state vector v(p) at semi-convergent position p *)
(* = M^k . v(p0) where M is the block transfer *)
(* v(p0) is exact (uniform formula) *)
(* The correction accumulates through each M application *)

(* For ONE block application: *)
(* v_j(p_next) = Σ_s M[j,s] v_s(p_prev) *)
(* M[j,s] = T[j,s] - Delta[j,s] where T is Toeplitz, Delta is our formula *)

(* Let's test: compute v(p0+p1) using the formula and compare with DP *)

pathsRat[pp_, qq_, jj_] := Module[{S, dp},
  If[jj == 0, Return[1]]; If[jj < 0, Return[0]];
  S = Table[Min[Floor[qq x/pp], jj], {x, 1, pp}];
  If[jj > S[[pp]], Return[0]];
  dp = Table[0, {pp}, {jj + 1}];
  Do[Do[If[y <= S[[x]],
    dp[[x, y + 1]] = If[x == 1 && y == 0, 1, 0] +
      If[x > 1 && y <= S[[x - 1]], dp[[x - 1, y + 1]], 0] +
      If[y > 0, dp[[x, y]], 0]],
    {y, 0, Min[jj, S[[x]]]}], {x, 1, pp}];
  dp[[pp, jj + 1]]
]

(* === Test for Pi: alpha ~ pi, w=3, a1=7, p0=3, p1=22, q1=7 === *)
Print["===== Full formula test for Pi ====="];
w = 3; a1 = 7; p0 = 3; p1 = 22; q0 = 1; q1 = 7;

(* State vector at p0+p1 = 25 (via DP) *)
p = p0 + p1; q = q0 + q1;
vDP = Table[pathsRat[p, q, j], {j, 0, q - 1}];
Print["v(25) via DP: ", vDP];

(* State vector at p0+p1 via uniform formula *)
vUnif = Table[vLin[p, w, j], {j, 0, q - 1}];
Print["v(25) via uniform: ", vUnif];
Print["Match: ", vDP === vUnif];
Print[""];

(* State vector at p0+2*p1 = 47 (via DP) *)
p2 = p0 + 2 p1; q2 = q0 + 2 q1;
vDP47 = Table[pathsRat[p2, q2, j], {j, 0, q2 - 1}];
Print["v(47) via DP: ", vDP47];
Print[""];

(* State vector at 47 via block transfer: M . v(25) *)
(* M[j,s] = C(p1-1+j-s, j-s) - Delta[j,s] *)
(* where Delta[j,s] = 0 for j <= a1+1 *)
(* and for j = a1+2+d, s: *)

deltaFormula[d_, s_, w_, a1_] := Sum[
  (w (a1 - d - 1) + 1)/(w (a1 - m) + 1) *
  Binomial[w (a1 - m) + d - m + 1, d - m + 1] *
  Binomial[a1 + m (w + 1) - s, m w - 1],
  {m, 1, d + 1}]

(* Compute v(47) using M = T - Delta *)
v25 = vDP;
v47formula = Table[
  Sum[
    (Binomial[p1 - 1 + j - s, j - s] -
      If[j >= a1 + 2,
        deltaFormula[j - a1 - 2, s, w, a1], 0]) *
    v25[[s + 1]],
    {s, 0, Length[v25] - 1}],
  {j, 0, q2 - 1}];
Print["v(47) via formula: ", v47formula];
Print["Match DP: ", v47formula === vDP47];
Print[""];

(* === Test for sqrt(5): w=2, a1=4 === *)
Print["===== Full formula test for sqrt(5) ====="];
w = 2; a1 = 4;
p0 = 2; p1 = 9; q0 = 1; q1 = 4;
p = p0 + p1; q = q0 + q1;

vDP11 = Table[pathsRat[p, q, j], {j, 0, q - 1}];
Print["v(11) via DP: ", vDP11];

p2 = p0 + 2 p1; q2 = q0 + 2 q1;
vDP20 = Table[pathsRat[p2, q2, j], {j, 0, q2 - 1}];
Print["v(20) via DP: ", vDP20];

v47formula = Table[
  Sum[
    (Binomial[p1 - 1 + j - s, j - s] -
      If[j >= a1 + 2,
        deltaFormula[j - a1 - 2, s, w, a1], 0]) *
    vDP11[[s + 1]],
    {s, 0, Length[vDP11] - 1}],
  {j, 0, q2 - 1}];
Print["v(20) via formula: ", v47formula];
Print["Match DP: ", v47formula === vDP20];
Print[""];

(* === Test for e: w=2, a1=1 (trivial, no correction) === *)
Print["===== Edge case: a1=1 (no correction) ====="];
w = 2; a1 = 1; p0 = 2; p1 = 3; q0 = 1; q1 = 1;
p = p0 + p1; q = q0 + q1;
vDP5 = Table[pathsRat[p, q, j], {j, 0, q - 1}];
vUnif5 = Table[vLin[p, w, j], {j, 0, q - 1}];
Print["v(5) DP: ", vDP5, " uniform: ", vUnif5, " match: ", vDP5 === vUnif5];

(* === Grand test: iterate the formula 3 times === *)
Print[""];
Print["===== Iterating block transfer 3 times for Pi ====="];
w = 3; a1 = 7; p1 = 22; q1 = 7; p0 = 3; q0 = 1;

(* Start with v(25) *)
v = Table[vLin[25, 3, j], {j, 0, 7}];
Print["v(25) = ", v];

(* Apply block transfer 3 times: v(47), v(69), v(91) *)
Do[
  pNext = p0 + (k + 1) p1;
  qNext = q0 + (k + 1) q1;
  vNext = Table[
    Sum[
      (Binomial[p1 - 1 + j - s, j - s] -
        If[j >= a1 + 2,
          deltaFormula[j - a1 - 2, s, w, a1], 0]) *
      v[[s + 1]],
      {s, 0, Length[v] - 1}],
    {j, 0, qNext - 1}];
  vDP = Table[pathsRat[pNext, qNext, j], {j, 0, qNext - 1}];
  Print["v(", pNext, ") formula matches DP: ", vNext === vDP];
  v = vNext,
  {k, 1, 3}];
