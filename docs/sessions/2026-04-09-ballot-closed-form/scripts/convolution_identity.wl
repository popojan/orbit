(* CONVOLUTION IDENTITY: can we collapse the sum? *)
(* Phi(d, s) = Sum_{m=1}^{d+1} B(p-wm, d-m+1) * C(A+m(w+1)-s, mw-1) *)
(* where B(n,k) = C(n+k-1, k)/n *)
(*                                                                      *)
(* Expanding B: C(p-wm+d-m, d-m+1)/(p-wm)                             *)
(* So Phi = Sum_m C(p-wm+d-m, d-m+1) * C(A+m(w+1)-s, mw-1) / (p-wm)  *)
(*                                                                      *)
(* Substitution: let j = d-m+1, so m = d-j+1, j runs from 1 to d+1->0  *)
(* Phi = Sum_{j=0}^{d} C(p-w(d-j+1)+j, j) * C(A+(d-j+1)(w+1)-s, (d-j+1)w-1) / (p-w(d-j+1)) *)
(* This doesn't simplify obviously *)
(*                                                                      *)
(* Alternative: fix w, look at small cases, find pattern *)

vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]
B[n_, k_] := Binomial[n + k - 1, k]/n

(* === Small case: w=1 === *)
Print["===== w=1: Catalan case ====="];
(* For w=1: basis = C(A+2m-s, m-1), coefficients = v_j(p-m) *)
(* At level 1, w=1 collapses to single binomial (known from Result 7) *)
(* Delta = C(2a1+2+d-s, d) --- single term! *)
(* So for w=1, the sum MUST collapse. Let's verify. *)

Print["w=1, a1=5, p1=6:"];
w1 = 1; a1 = 5; p1 = 6; A1 = 5;
Do[
  row = Table[
    Sum[vLin[p1 - w1 m, w1, d - m + 1] *
      Binomial[A1 + m (w1 + 1) - s, m w1 - 1], {m, 1, d + 1}],
    {s, 0, 5}];
  single = Table[Binomial[2 a1 + 2 + d - s, d], {s, 0, 5}];
  Print["  d=", d, ": sum = single? ", row === single,
    "  = C(", 2 a1 + 2 + d, "-s, ", d, ")"],
  {d, 0, 3}];
Print[""];

(* === w=1 identity proof sketch === *)
(* For w=1: v_j(p-m) = (p-m-j)/(p-m) * C(p-m+j-1, j) *)
(* Basis: C(A+2m-s, m-1) *)
(* Sum_m v_{d-m+1}(p-m) C(A+2m-s, m-1) *)
(* = Sum_m (p-d-2)/(p-m) * C(p-m+d-m, d-m+1) * C(A+2m-s, m-1) *)
(* Factor out (p-d-2): *)
(* = (p-d-2) * Sum_m C(p+d-2m, d-m+1) * C(A+2m-s, m-1) / (p-m) *)
(* *)
(* For w=1: p = a1+1 = 6, A = a1 = 5 *)
(* Sum_m C(6+d-2m, d-m+1) * C(5+2m-s, m-1) / (6-m) *)
(* This should equal C(12+d-s, d) / (6-d-2) ... hmm *)

(* === General w: look for pattern in values === *)
Print["===== w=2, a1=4 (sqrt5 level 1) ====="];
w2 = 2; a12 = 4; p12 = 9; A12 = 4;
Print["Full correction rows:"];
Do[
  row = Table[
    Sum[vLin[p12 - w2 m, w2, d - m + 1] *
      Binomial[A12 + m 3 - s, 2 m - 1], {m, 1, d + 1}],
    {s, 0, 4}];
  Print["  d=", d, ": ", row],
  {d, 0, 2}];
Print[""];

(* === Try to express Phi as ratio of ballot numbers or binomials === *)
Print["===== Looking for closed form of Phi ====="];
Print[""];

(* For fixed s, Phi(d, s) might have a pattern *)
(* Let's tabulate Phi for level 2, sqrt(5): p=38, w=2, A=20 *)
p = 38; w = 2; A = 20;
Print["Phi(d, s) for p=38, w=2, A=20:"];
Print["(These are the correction values WITHOUT the (p-w(d+1)) factor)"];
Print[""];
Do[
  phiRow = Table[
    Sum[B[p - w m, d - m + 1] * Binomial[A + m (w + 1) - s, m w - 1],
      {m, 1, d + 1}],
    {s, 0, Min[5, 21]}];
  deltaRow = Table[
    Sum[vLin[p - w m, w, d - m + 1] * Binomial[A + m (w + 1) - s, m w - 1],
      {m, 1, d + 1}],
    {s, 0, Min[5, 21]}];
  factor = p - w (d + 1);
  Print["d=", d, ": factor=", factor, "  Phi=", phiRow, "  Delta=", deltaRow];
  If[factor =!= 0 && factor phiRow =!= deltaRow,
    Print["  WARNING: factor*Phi != Delta"]],
  {d, 0, 4}];
Print[""];

(* === Can we recognize Phi(d, s) as a known combinatorial quantity? === *)
Print["===== Pattern recognition for Phi ====="];
Print[""];

(* Phi(0, s) = B(p-w, 1) * C(A+w+1-s, w-1) *)
(* = C(p-w, 1)/(p-w) * C(A+w+1-s, w-1) *)
(* = 1 * C(A+w+1-s, w-1) = C(A+w+1-s, w-1) *)
phi0 = Table[B[p - w, 1] Binomial[A + w + 1 - s, w - 1], {s, 0, 5}];
Print["Phi(0,s) = ", phi0, " = C(", A + w + 1, "-s, ", w - 1, ")"];
Print["  This is just the d=0 basis function (coefficient = 1)"];
Print[""];

(* Phi(1, s): *)
phi1 = Table[
  B[p - w, 2] Binomial[A + w + 1 - s, w - 1] +
  B[p - 2 w, 1] Binomial[A + 2 (w + 1) - s, 2 w - 1],
  {s, 0, 5}];
Print["Phi(1,s) = ", phi1];
Print["  B(36,2)=", B[36, 2], " * C(23-s,1) + B(34,1)=", B[34, 1], " * C(26-s,3)"];
Print["  = ", B[36, 2], " * C(23-s,1) + C(26-s,3)"];
Print[""];

(* Is Phi(1,s) expressible as a single something? *)
(* Phi(1,s) = 17*C(23-s,1) + C(26-s,3) *)
(* = 17*(23-s) + C(26-s,3) *)
(* Try: is this C(X-s, Y) for some X, Y? *)
vals1 = Table[17 (23 - s) + Binomial[26 - s, 3], {s, 0, 5}];
Print["Phi(1,s) values: ", vals1];
Do[
  test = Table[Binomial[a - s, b], {s, 0, 5}];
  If[test === vals1, Print["  = C(", a, "-s, ", b, ")"]],
  {b, 1, 10}, {a, b + 5, 40}];
(* Probably not a single binomial *)

(* Try: a*C(X-s, Y) + b*C(X'-s, Y') *)
(* Already know it's 17*C(23-s,1) + C(26-s,3). That's our decomposition. *)
Print[""];

(* === Generating function approach === *)
Print["===== Generating function for Phi ====="];
(* Define f_d(x) = Sum_s Phi(d,s) * x^s *)
(* Phi(d,s) = Sum_m B(p-wm, d-m+1) * C(A+m(w+1)-s, mw-1) *)
(* *)
(* f_d(x) = Sum_m B(p-wm, d-m+1) * Sum_s C(A+m(w+1)-s, mw-1) x^s *)
(* The inner sum is the GF of C(N-s, k) which is x^{N-k} / (1-x)^{k+1} *)
(* No wait: Sum_s C(N-s, k) x^s = x^{N-k}/(1-1/x)^{k+1} ... hmm *)
(* *)
(* Actually: Sum_{s=0}^{N-k} C(N-s, k) x^s = coefficient extraction *)
(* This is the partial sum of the negative binomial *)

(* Let's try a different substitution *)
(* Let t = A + m(w+1) - s, then s = A + m(w+1) - t *)
(* C(t, mw-1) with t running from A+m(w+1) down to mw-1 *)

(* === Trying Zeilberger-style: does Sum_m ... satisfy a recurrence? === *)
Print["===== Recurrence in d for fixed s ====="];
(* Fix s=0 and compute Phi(d, 0) for several d *)
phiAtS0 = Table[
  Sum[B[p - w m, d - m + 1] Binomial[A + m (w + 1), m w - 1], {m, 1, d + 1}],
  {d, 0, 10}];
Print["Phi(d, 0) for d=0..10: ", phiAtS0];
Print[""];

(* Check ratios *)
Print["Ratios Phi(d+1,0)/Phi(d,0):"];
Do[
  If[phiAtS0[[d + 1]] =!= 0,
    Print["  d=", d, ": ", N[phiAtS0[[d + 2]]/phiAtS0[[d + 1]], 6]]],
  {d, 0, 9}];
Print[""];

(* Check if there's a linear recurrence *)
Print["Checking linear recurrence of order 2:"];
(* a*Phi(d+2) + b*Phi(d+1) + c*Phi(d) = 0? *)
Do[
  If[d + 2 < Length[phiAtS0],
    (* Solve: a*Phi(d+2) + b*Phi(d+1) + Phi(d) = 0 *)
    (* From two consecutive: *)
    (* a*Phi(2) + b*Phi(1) + Phi(0) = 0 *)
    (* a*Phi(3) + b*Phi(2) + Phi(1) = 0 *)
    sys = {{phiAtS0[[3]], phiAtS0[[2]]}, {phiAtS0[[4]], phiAtS0[[3]]}};
    rhs = {-phiAtS0[[1]], -phiAtS0[[2]]};
    sol = LinearSolve[sys, rhs];
    Print["  Candidate: a=", sol[[1]], " b=", sol[[2]]];
    (* Verify on all *)
    ok = True;
    Do[
      pred = sol[[1]] phiAtS0[[k + 3]] + sol[[2]] phiAtS0[[k + 2]] + phiAtS0[[k + 1]];
      If[pred =!= 0, ok = False; Print["  Fails at d=", k + 2, ": ", pred]],
      {k, 0, Length[phiAtS0] - 3}];
    If[ok, Print["  ORDER-2 RECURRENCE HOLDS!"]];
  ],
  {d, 0, 0}];
Print[""];

(* Also try order 3 *)
Print["Checking linear recurrence of order 3:"];
sys3 = Table[phiAtS0[[d + {4, 3, 2}]], {d, 0, 2}];
rhs3 = -Table[phiAtS0[[d + 1]], {d, 0, 2}];
sol3 = LinearSolve[sys3, rhs3];
Print["  Candidate: a=", sol3[[1]], " b=", sol3[[2]], " c=", sol3[[3]]];
ok3 = True;
Do[
  pred = sol3[[1]] phiAtS0[[k + 4]] + sol3[[2]] phiAtS0[[k + 3]] +
    sol3[[3]] phiAtS0[[k + 2]] + phiAtS0[[k + 1]];
  If[pred =!= 0, ok3 = False; Print["  Fails at d=", k + 3, ": ", pred]],
  {k, 0, Length[phiAtS0] - 4}];
If[ok3, Print["  ORDER-3 RECURRENCE HOLDS!"]];
