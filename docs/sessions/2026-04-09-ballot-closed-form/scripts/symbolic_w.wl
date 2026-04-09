(* Symbolic block transfer matrix for general w, fixed small a1 *)
(* Use L^k entries = C(i-j+k-1, k-1) symbolically *)

(* Lower-triangular all-ones matrix *)
Lsym[n_] := Table[If[i >= j, 1, 0], {i, 0, n}, {j, 0, n}]

(* L^k has entries C(i-j+k-1, k-1) for i>=j, 0 otherwise *)
LPow[n_, k_] := Table[If[i >= j, Binomial[i - j + k - 1, k - 1], 0], {i, 0, n}, {j, 0, n}]

(* Block transfer with SYMBOLIC width w *)
symBlockTransfer[d_, pattern_] := Module[{m = d - 1, mat = IdentityMatrix[d]},
  Do[
    (* Rise: extend by 0 row, multiply by L_{m+1} *)
    mat = Lsym[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}];
    m++;
    (* Within-stair: L_m^{width-1} *)
    If[width =!= 1, mat = LPow[m, width - 1] . mat],
    {width, pattern}];
  mat
]

(* === a1=2: pattern = {w, w+1}, dim=3 → output dim=5 === *)
Print["===== a1=2: Symbolic w ====="];
M2 = symBlockTransfer[3, {w, w + 1}];
p1 = 2 w + 1;
MToep2 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 4}, {s, 0, 2}];
Delta2 = Simplify[MToep2 - M2];
Print["Delta for a1=2:"];
Do[
  row = Delta2[[j + 1]];
  simplified = FullSimplify[row];
  If[simplified =!= {0, 0, 0},
    Print["  j=", j, ": ", simplified];
    (* Check if it equals C(w+3-s, w-1) *)
    expected = Table[Binomial[w + 3 - s, w - 1], {s, 0, 2}];
    Print["  Expected C(w+3-s,w-1): ", expected];
    Print["  Match: ", FullSimplify[simplified - expected] === {0, 0, 0}]
  ],
  {j, 0, 4}];
Print[""];

(* === a1=3: pattern = {w, w, w+1}, dim=4 → output dim=7 === *)
Print["===== a1=3: Symbolic w ====="];
M3 = symBlockTransfer[4, {w, w, w + 1}];
p1 = 3 w + 1;
MToep3 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 6}, {s, 0, 3}];
Delta3 = Simplify[MToep3 - M3];
Print["Delta for a1=3:"];
Do[
  row = FullSimplify[Delta3[[j + 1]]];
  If[row =!= Table[0, 4],
    Print["  j=", j, ": ", row]],
  {j, 0, 6}];
Print[""];

(* Try to express each row as known binomial combinations *)
Print["=== a1=3 correction analysis ==="];
Do[
  row = FullSimplify[Delta3[[j + 1]]];
  If[row =!= Table[0, 4],
    Print["j=", j, ":"];
    (* Test C(a1+w+1-s, w-1) for first row *)
    test1 = Table[Binomial[w + 4 - s, w - 1], {s, 0, 3}];
    If[FullSimplify[row - test1] === Table[0, 4],
      Print["  = C(w+4-s, w-1) ✓"]];
    (* For second row, try various forms *)
    Do[
      test = Table[Binomial[a - s, b], {s, 0, 3}];
      If[FullSimplify[row - test] === Table[0, 4],
        Print["  = C(", a, "-s, ", b, ")"]],
      {a, {2w+5, 2w+4, 2w+3, w+5, w+4}},
      {b, 0, 6}];
    (* Try sum of two binomials *)
    Do[
      test = Table[c1 Binomial[a1 - s, b1] + c2 Binomial[a2 - s, b2], {s, 0, 3}];
      If[FullSimplify[row - test] === Table[0, 4],
        Print["  = ", c1, " C(", a1f, "-s,", b1, ") + ", c2, " C(", a2f, "-s,", b2, ")"]],
      {a1f, {w+4, w+5, 2w+3, 2w+4, 2w+5}}, {b1, 0, 5},
      {a2f, {w+4, w+5, 2w+3, 2w+4, 2w+5}}, {b2, 0, 5},
      {c1, {1, -1}}, {c2, {1, -1}}]
  ],
  {j, 0, 6}];
Print[""];

(* === Instead, let Mathematica factor/simplify the correction directly === *)
Print["=== Direct simplification of correction entries ==="];
Print["a1=2, j=4:"];
Do[
  entry = FullSimplify[Delta2[[5, s + 1]]];
  Print["  s=", s, ": ", entry, " = ", FunctionExpand[entry]],
  {s, 0, 2}];
Print[""];

Print["a1=3 corrections:"];
Do[
  row = Delta3[[j + 1]];
  If[FullSimplify[row] =!= Table[0, 4],
    Print["j=", j, ":"];
    Do[
      entry = FullSimplify[Delta3[[j + 1, s + 1]]];
      Print["  s=", s, ": ", entry],
      {s, 0, 3}]],
  {j, 0, 6}];
Print[""];

(* === a1=4: pattern = {w, w, w, w+1} === *)
Print["===== a1=4: Symbolic w ====="];
M4 = symBlockTransfer[5, {w, w, w, w + 1}];
p14 = 4 w + 1;
MToep4 = Table[Binomial[p14 - 1 + j - s, j - s], {j, 0, 8}, {s, 0, 4}];
Delta4 = FullSimplify[MToep4 - M4];
Print["Delta for a1=4:"];
Do[
  row = Delta4[[j + 1]];
  If[row =!= Table[0, 5],
    Print["  j=", j, ": ", row]],
  {j, 0, 8}];
