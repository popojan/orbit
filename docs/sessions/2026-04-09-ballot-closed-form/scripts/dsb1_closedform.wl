(* Closed-form for dSB1: correction of the {3,2,2,2} stair pattern *)
(* Compare with Result 7 formula at various offsets A *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]
toep[a_, j_, s_] := If[j >= s, Binomial[a + j - s, j - s], 0]

blockTransferActual[initDim_, alpha_, xStart_, xEnd_] := Module[
  {mat = IdentityMatrix[initDim], m = initDim - 1,
   prevS = Floor[xStart/alpha], curS},
  Do[curS = Floor[x/alpha];
    If[curS == prevS, mat = Lmat[m] . mat,
      mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++];
    prevS = curS, {x, xStart + 1, xEnd}];
  mat
]

alpha = Sqrt[5]; ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4;

(* === Build dSB1 for several starting dimensions === *)
(* The stair pattern {3,2,2,2} is the same regardless of starting dim *)
(* (as long as the staircase is at the right phase) *)

Print["===== dSB1 at different starting dimensions ====="];
Print["Pattern: {3,2,2,2} (Sturmian for 9/4 at phase from position 47)"];
Print[""];

(* For dim d0, the sub-block goes from some position to position+p1 *)
(* The staircase phase depends on position, not dim *)
(* Let's test multiple positions that give the {3,2,2,2} pattern *)

(* Positions that start a level-2 sub-block for sqrt(5): *)
(* 47, 56, 65 (all give {3,2,2,2} pattern because Sturmian is periodic) *)

Do[
  startP = sp; d0 = Floor[startP/alpha] + 1;
  sb = blockTransferActual[d0, alpha, startP, startP + p1];
  tRef = Table[toep[p1 - 1, j, s], {j, 0, d0 + q1 - 1}, {s, 0, d0 - 1}];
  dSB = tRef - sb;

  corrRows = Select[Range[Length[dSB]],
    dSB[[#]] =!= Table[0, d0] &] - 1;

  Print["startPos=", startP, " d0=", d0, " dims=", Dimensions[sb]];
  Print["  Correction rows: ", corrRows];

  (* Print correction entries for first few columns *)
  Do[j = cr;
    row = dSB[[j + 1]];
    Print["  d[", j, ", 0..5] = ", row[[1 ;; Min[6, d0]]]],
    {cr, corrRows}];

  (* Test Result 7 formula with various A values *)
  Print[""];
  Print["  Testing Result 7 formula:"];
  Do[
    aTest = aVal;
    allMatch = True;
    Do[
      j = cr; d = j - (d0); (* correction depth: row = d0 + d *)
      predicted = Table[
        Sum[vLin[p1 - ww m, ww, d - m + 1] *
          Binomial[aTest + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}],
        {s, 0, d0 - 1}];
      actual = dSB[[j + 1]];
      If[predicted =!= actual, allMatch = False],
      {cr, corrRows}];
    If[allMatch,
      Print["  A=", aTest, " (= d0", If[aTest - d0 >= 0, "+", ""],
        aTest - d0, "): ALL MATCH!"],
      (* Check individually *)
      Do[j = cr; d = j - d0;
        predicted = Table[
          Sum[vLin[p1 - ww m, ww, d - m + 1] *
            Binomial[aTest + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}],
          {s, 0, d0 - 1}];
        actual = dSB[[j + 1]];
        If[predicted =!= actual,
          Print["  A=", aTest, " d=", d, ": MISMATCH at row ", j]],
        {cr, corrRows}]],
    {aVal, {d0 - 3, d0 - 2, d0 - 1, d0, q1}}];
  Print[""],
  {sp, {47, 56, 65}}];

(* === Now compare with the ORIGINAL level-1 block === *)
(* Pattern {1,2,2,2,2} from position 11, dim 5 *)
Print["===== Original level-1 block (position 11, dim 5) ====="];
Print["Pattern: {1,2,2,2} + 2 trailing"];
origSB = blockTransferActual[5, alpha, 11, 20];
origT = Table[toep[p1 - 1, j, s], {j, 0, 8}, {s, 0, 4}];
origD = origT - origSB;

corrRowsOrig = Select[Range[9], origD[[#]] =!= Table[0, 5] &] - 1;
Print["d0=5, Correction rows: ", corrRowsOrig];
Do[j = cr; Print["  d[", j, ", 0..4] = ", origD[[j + 1]]], {cr, corrRowsOrig}];
Print[""];

Do[
  aTest = aVal;
  allMatch = True;
  Do[j = cr; d = j - 5; (* d0 = 5 for original, but correction at row 6 => d=1? *)
    (* Actually: for original, first correction is at row q1+2=6, so d = j - (q1+2) + 0? *)
    (* In Result 7: row = A+2+d, so d = j - A - 2 *)
    (* If A = aTest: d = j - aTest - 2 *)
    d = j - aTest - 2;
    If[d < 0, Continue[]];
    predicted = Table[
      Sum[vLin[p1 - ww m, ww, d - m + 1] *
        Binomial[aTest + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}],
      {s, 0, 4}];
    actual = origD[[j + 1]];
    If[predicted =!= actual, allMatch = False;
      Print["  A=", aTest, " d=", d, " (row ", j, "): MISMATCH"]],
    {cr, corrRowsOrig}];
  If[allMatch, Print["  A=", aTest, ": ALL MATCH (with row=A+2+d convention)"]],
  {aVal, {q1, 3, 2, 5}}];
Print[""];

(* === KEY TEST: does the SAME formula work for {3,2,2,2} with row=d0+d? === *)
(* For SB1: correction at rows d0, d0+1, d0+2, d0+3 *)
(* If row = A+2+d, then d0 = A+2 => A = d0-2 *)
(* For original: correction at rows 6,7,8 = q1+2, q1+3, 2q1 *)
(* row = A+2+d with A=q1=4: row 6 => d=0, row 7 => d=1, row 8 => d=2 *)

Print["===== UNIFIED TEST: row = A + 2 + d convention ====="];
Print[""];

(* For SB1 at dim 22: A = 20, first correction at row 22 = A+2 = 22 *)
Print["SB1 (dim 22): A=20, rows 22-25 = A+2+{0,1,2,3}"];
sb1 = blockTransferActual[22, alpha, 47, 56];
t1 = Table[toep[p1 - 1, j, s], {j, 0, 25}, {s, 0, 21}];
d1 = t1 - sb1;

Do[d = dd;
  j = 20 + 2 + d; (* A + 2 + d *)
  predicted = Table[
    Sum[vLin[p1 - ww m, ww, d - m + 1] *
      Binomial[20 + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}],
    {s, 0, 21}];
  actual = d1[[j + 1]];
  Print["  d=", d, " (row ", j, "): match=", predicted === actual,
    "  pred[0..2]=", predicted[[1 ;; 3]], " act[0..2]=", actual[[1 ;; 3]]],
  {dd, 0, 3}];
Print[""];

(* For original (dim 5): A=4, rows 6-8 = A+2+{0,1,2} *)
Print["Original (dim 5): A=4=q1, rows 6-8 = A+2+{0,1,2}"];
Do[d = dd;
  j = 4 + 2 + d;
  predicted = Table[
    Sum[vLin[p1 - ww m, ww, d - m + 1] *
      Binomial[4 + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}],
    {s, 0, 4}];
  actual = origD[[j + 1]];
  Print["  d=", d, " (row ", j, "): match=", predicted === actual],
  {dd, 0, 2}];
Print[""];

(* === GENERAL PATTERN: A = d0 - 2 for {3,2,2,2} but A = q1 for {1,2,2,2}+trailing *)
(* What determines A? *)
(* Hypothesis: A = d0 - (first stair width). *)
(* {3,2,2,2}: first width = 3, d0 = 22, A = 22 - 3 + 1 = 20. Hmm, 22-2=20 too. *)
(* {1,2,2,2}+trailing: first width = 1, d0 = 5, A = 5 - 1 = 4 = q1! *)
(* Let me check: A = d0 - first_width? *)
(* SB1: d0=22, first_width=3, d0-first_width = 19 != 20 *)
(* Hmm. A = d0 - 2 for SB1, and d0 - 1 = 4 for original... *)

(* Actually for original: d0=5, A=4=d0-1. For SB1: d0=22, A=20=d0-2. *)
(* Difference: original has trailing within-stair (2 columns), SB1 doesn't. *)

(* Better hypothesis: A = d0 - w_first + w_trailing? Or simpler: *)
(* The correction offset depends on how many within-stair columns *)
(* PRECEDE the first rise. *)
(* SB1: 2 pre-rise columns. A = d0 - 2 = 20. *)
(* Original: 0 pre-rise columns (first column IS a rise). A = d0 - 1 = 4. *)
(* Wait, from the trace: original starts at 11, first event at x=12 is a rise. *)
(* So 0 pre-rise? But then A = d0 - 1 = 4. *)

(* Hypothesis: A = d0 - 1 - (pre-rise columns) *)
(* SB1: pre-rise = 2, A = 22 - 1 - 2 + 1 = 20? That gives 20. But 22-1-2 = 19. *)

(* Let me just test with pattern {2,2,2,3} (different rotation) *)
Print["===== Test with a DIFFERENT stair pattern ====="];
(* Position 20 to 29 gives what pattern? *)
Print["Pattern from position 20:"];
prevS20 = Floor[20/alpha];
Do[curS = Floor[x/alpha];
  If[curS > prevS20, Print["  rise at x=", x, " width=", x - lastR20];
    lastR20 = x]; prevS20 = curS,
  {x, 21, 29}] /. lastR20 -> 20;
Print[""];

(* Build sub-block from position 20 *)
d0test = Floor[20/alpha] + 1; (* should be 9+1=10? Floor[20/2.236]=8, so d0=9 *)
Print["d0 from pos 20: ", d0test];
sbTest = blockTransferActual[d0test, alpha, 20, 29];
tTest = Table[toep[p1 - 1, j, s], {j, 0, d0test + q1 - 1}, {s, 0, d0test - 1}];
dTest = tTest - sbTest;

corrRowsTest = Select[Range[Length[dTest]],
  dTest[[#]] =!= Table[0, d0test] &] - 1;
Print["Correction rows: ", corrRowsTest];

Do[j = cr; Print["  d[", j, ", 0..4] = ", dTest[[j + 1, 1 ;; Min[5, d0test]]]],
  {cr, corrRowsTest}];

(* Test formula with A = d0-1, d0-2, d0-3 *)
Do[aTest = aVal;
  allMatch = True;
  Do[j = cr; d = j - aTest - 2;
    If[d < 0, Continue[]];
    predicted = Table[
      Sum[vLin[p1 - ww m, ww, d - m + 1] *
        Binomial[aTest + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}],
      {s, 0, d0test - 1}];
    actual = dTest[[j + 1]];
    If[predicted =!= actual, allMatch = False],
    {cr, corrRowsTest}];
  Print["  A=", aTest, " (d0-", d0test - aTest, "): ",
    If[allMatch, "ALL MATCH", "mismatch"]],
  {aVal, {d0test - 1, d0test - 2, d0test - 3, q1}}];
Print[""];

(* === Test with yet another position to nail down the pattern === *)
Print["Pattern from position 29:"];
prevS29 = Floor[29/alpha];
rises29 = {};
Do[curS = Floor[x/alpha];
  If[curS > prevS29, AppendTo[rises29, x]]; prevS29 = curS,
  {x, 30, 38}];
Print["Rises: ", rises29, " widths: ", Differences[Prepend[rises29, 29]]];

d0test2 = Floor[29/alpha] + 1;
Print["d0 from pos 29: ", d0test2];
sbTest2 = blockTransferActual[d0test2, alpha, 29, 38];
tTest2 = Table[toep[p1 - 1, j, s], {j, 0, d0test2 + q1 - 1}, {s, 0, d0test2 - 1}];
dTest2 = tTest2 - sbTest2;

corrRowsTest2 = Select[Range[Length[dTest2]],
  dTest2[[#]] =!= Table[0, d0test2] &] - 1;
Print["Correction rows: ", corrRowsTest2];

Do[aTest = aVal;
  allMatch = True;
  Do[j = cr; d = j - aTest - 2;
    If[d < 0, Continue[]];
    predicted = Table[
      Sum[vLin[p1 - ww m, ww, d - m + 1] *
        Binomial[aTest + m (ww + 1) - s, m ww - 1], {m, 1, d + 1}],
      {s, 0, d0test2 - 1}];
    actual = dTest2[[j + 1]];
    If[predicted =!= actual, allMatch = False],
    {cr, corrRowsTest2}];
  Print["  A=", aTest, " (d0-", d0test2 - aTest, "): ",
    If[allMatch, "ALL MATCH", "mismatch"]],
  {aVal, {d0test2 - 1, d0test2 - 2, d0test2 - 3, q1}}];
Print[""];

Print["===== DONE ====="];
