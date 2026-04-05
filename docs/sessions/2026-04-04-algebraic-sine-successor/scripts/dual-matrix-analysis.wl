(* ================================================================ *)
(* Dual matrix analysis: W (integer) and M (interaction) together   *)
(* W^{-1}M, commutator [W,M], generalized eigenvalues              *)
(* ================================================================ *)

nz = 10; np = 10;
gammas = Table[N[Im[ZetaZero[n]], 15], {n, nz}];
lnP = Table[Log[N[Prime[j], 15]], {j, np}];

w = Table[Floor[gammas[[n]] lnP[[j]] / (2 Pi)], {n, nz}, {j, np}];
m = Table[Cos[gammas[[n]] lnP[[j]]], {n, nz}, {j, np}];

Print["=== W (winding, integer) ==="];
Print["det(W) = ", Det[w]];
Print["W invertible: ", Det[w] != 0];

(* === W^{-1} M === *)
Print["\n=== W⁻¹ M ===\n"];
If[Det[w] != 0,
  wInvM = Inverse[w] . m;
  Print["W⁻¹M (first 5×5):"];
  Print[NumberForm[#, {5, 3}] & /@ # & /@ wInvM[[1;;5, 1;;5]] // MatrixForm];

  eigWiM = Eigenvalues[N[wInvM]];
  Print["\nEigenvalues of W⁻¹M:"];
  Do[Print["  λ_", i, " = ", NumberForm[eigWiM[[i]], {6, 3}]], {i, Min[8, nz]}];

  Print["\n|Eigenvalues|: ", NumberForm[Abs[#], {4, 2}] & /@ SortBy[eigWiM, -Abs[#]&][[1;;5]]];
,
  Print["W is singular (det=0), using pseudoinverse"];
  wInvM = PseudoInverse[N[w]] . m;
];

(* === M W^{-1} === *)
Print["\n=== M W⁻¹ ===\n"];
If[Det[w] != 0,
  mWinv = m . Inverse[w];
  eigMwi = Eigenvalues[N[mWinv]];
  Print["Eigenvalues of MW⁻¹:"];
  Do[Print["  λ_", i, " = ", NumberForm[eigMwi[[i]], {6, 3}]], {i, Min[8, nz]}];

  Print["\nW⁻¹M and MW⁻¹ have same eigenvalues? ",
    Max[Abs[Sort[eigWiM] - Sort[eigMwi]]] < 0.001];
];

(* === Commutator [W, M] = WM - MW === *)
Print["\n=== Commutator [W, M] = WM - MW ===\n"];
comm = w . m - m . w;
Print["||[W,M]||_F = ", NumberForm[Norm[Flatten[comm]], {6, 2}]];
Print["||W||_F = ", NumberForm[Norm[Flatten[N[w]]], {6, 2}]];
Print["||M||_F = ", NumberForm[Norm[Flatten[m]], {6, 2}]];
Print["Relative: ||[W,M]|| / (||W|| ||M||) = ",
  NumberForm[Norm[Flatten[comm]] / (Norm[Flatten[N[w]]] Norm[Flatten[m]]), {4, 3}]];

Print["\n[W,M] corner (5×5):"];
Print[NumberForm[#, {5, 2}] & /@ # & /@ comm[[1;;5, 1;;5]] // MatrixForm];

(* Eigenvalues of commutator *)
eigComm = Eigenvalues[N[comm]];
Print["\nEigenvalues of [W,M]:"];
Do[Print["  λ_", i, " = ", NumberForm[eigComm[[i]], {6, 3}]], {i, Min[8, nz]}];

Print["\nAll purely imaginary? ", AllTrue[eigComm, Abs[Re[#]] < 0.01 Abs[Im[#]] &]];
Print["(Commutator of real matrices has pure-imaginary or conjugate-pair eigenvalues)"];

(* === Generalized eigenvalue problem: det(M - λW) = 0 === *)
Print["\n=== Generalized eigenvalues: M v = λ W v ===\n"];
genEigs = Eigenvalues[{N[m], N[w]}];
Print["Generalized eigenvalues (first 8):"];
Do[Print["  λ_", i, " = ", NumberForm[genEigs[[i]], {6, 4}]], {i, Min[8, nz]}];

(* === Scale with size === *)
Print["\n=== Scaling: commutator norm vs size ===\n"];
Do[
  g = Table[N[Im[ZetaZero[n]], 15], {n, sz}];
  lp = Table[Log[N[Prime[j], 15]], {j, sz}];
  ww = Table[Floor[g[[n]] lp[[j]] / (2 Pi)], {n, sz}, {j, sz}];
  mm = Table[Cos[g[[n]] lp[[j]]], {n, sz}, {j, sz}];
  cc = ww . mm - mm . ww;
  relComm = Norm[Flatten[N[cc]]] / (Norm[Flatten[N[ww]]] Norm[Flatten[mm]]);
  Print[sz, "×", sz,
    ": ||[W,M]||/(||W|| ||M||) = ", NumberForm[relComm, {4, 3}],
    If[relComm < 0.01, " ← nearly commute!", ""]],
{sz, {4, 6, 8, 10, 15, 20}}];
