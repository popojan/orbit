(* Minimal debug: verify Toeplitz model for sub-blocks *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

blockTransferActual[initDim_, alpha_, xStart_, xEnd_] := Module[
  {mat = IdentityMatrix[initDim], m = initDim - 1,
   prevS = Floor[xStart/alpha], curS},
  Do[curS = Floor[x/alpha];
    If[curS == prevS, mat = Lmat[m] . mat,
      mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++];
    prevS = curS, {x, xStart + 1, xEnd}];
  mat
]

alpha = Sqrt[5];

(* === Test 1: original level-1 block (dim 5 -> 9, from Result 7) === *)
M1orig = blockTransferActual[5, alpha, 11, 20];
T1orig = Table[Binomial[8 + j - s, j - s], {j, 0, 8}, {s, 0, 4}];
D1orig = T1orig - M1orig;

Print["===== Original level-1 block (11->20, dim 5) ====="];
Print["Dims: ", Dimensions[M1orig]];
corrRows1 = Select[Range[9], D1orig[[#]] =!= Table[0, 5] &] - 1;
Print["Correction rows: ", corrRows1];
Print["(Expected: 6, 7, 8 = q1+2, q1+3, 2q1)"];
Print[""];

(* Verify first 6 rows match *)
Print["First 6 rows match Toeplitz? ", T1orig[[1 ;; 6]] === M1orig[[1 ;; 6]]];
Print[""];

(* === Test 2: SB1 within level 2 (dim 22, from 47 to 56, pattern {3,2,2,2}) === *)
SB1 = blockTransferActual[22, alpha, 47, 56];
TSB1 = Table[Binomial[8 + j - s, j - s], {j, 0, 25}, {s, 0, 21}];
DSB1 = TSB1 - SB1;

Print["===== SB1 (47->56, dim 22, pattern {3,2,2,2}) ====="];
Print["Dims: ", Dimensions[SB1]];
corrRowsSB1 = Select[Range[26], DSB1[[#]] =!= Table[0, 22] &] - 1;
Print["Correction rows: ", corrRowsSB1];
Print[""];

(* Check specific rows *)
Print["Row 0: SB1 = ", SB1[[1, 1 ;; 4]], " TSB1 = ", TSB1[[1, 1 ;; 4]]];
Print["Row 1: SB1 = ", SB1[[2, 1 ;; 4]], " TSB1 = ", TSB1[[2, 1 ;; 4]]];
Print["Row 21: SB1 = ", SB1[[22, 1 ;; 4]], " TSB1 = ", TSB1[[22, 1 ;; 4]]];
Print["Row 22: SB1 = ", SB1[[23, 1 ;; 4]], " TSB1 = ", TSB1[[23, 1 ;; 4]]];
Print[""];

(* Maybe the Toeplitz should be T(ncols-1) not T(p1-1)? *)
(* SB1 processes columns 48..56, but blockTransferActual starts processing *)
(* from xStart+1 = 48. It processes 56-47 = 9 columns. *)
(* Each column is either L or (extend+L). Total L-applications = 9. *)
(* So Toeplitz param should be 9-1 = 8? No, L^n has entries C(n-1+j-s, j-s). *)
(* L^9 has entries C(8+j-s, j-s) = T(8). This should be correct. *)

(* But wait: the rise operation is NOT just L. It's: *)
(* 1. Pad matrix with zero row *)
(* 2. Apply L_{m+1} *)
(* In infinite dims, pad is trivial, so rise = L. *)
(* But L_{m+1} has size (m+2)x(m+2), while the padded matrix is (m+2)x22. *)
(* For rows 0..m: L_{m+1}[j,t] = L_inf[j,t] for t <= m+1. *)
(* For row m+1: L_{m+1}[m+1,t] = 1 for t <= m+1. *)
(* The padded matrix has mat[m+1, s] = 0 for all s. *)
(* So after rise: row m+1 = sum of rows 0..m of padded = sum of rows 0..m of mat. *)
(* Row j < m: (L . padded)[j,:] = sum_{t=0}^{j} padded[t,:] = sum_{t=0}^{j} mat[t,:] *)
(* This is the same as (L . mat)[j,:] for j < m! *)

(* So the rise at height m does NOT affect rows j < m. *)
(* This means rows 0..21 of SB1 should equal L^9[0..21, 0..21] = T(8). *)

(* TEST: compute SB1 explicitly for rows 0..21 *)
Print["===== EXPLICIT CHECK: rows 0..21 ====="];
Print["SB1[0..21] == TSB1[0..21]? ", SB1[[1 ;; 22]] === TSB1[[1 ;; 22]]];
If[SB1[[1 ;; 22]] =!= TSB1[[1 ;; 22]],
  (* Find first mismatch *)
  firstMismatch = SelectFirst[Range[22], SB1[[#]] =!= TSB1[[#]] &] - 1;
  Print["First mismatch at row ", firstMismatch];
  Print["SB1[", firstMismatch, "] = ", SB1[[firstMismatch + 1, 1 ;; 6]]];
  Print["TSB1[", firstMismatch, "] = ", TSB1[[firstMismatch + 1, 1 ;; 6]]];

  (* Also check L^9 directly *)
  Print[""];
  Print["Direct L^9 check:"];
  L9 = MatrixPower[Lmat[25], 9]; (* use large enough L *)
  Print["L^9[", firstMismatch, ",0..5] = ", L9[[firstMismatch + 1, 1 ;; 6]]];
  Print["SB1[", firstMismatch, ",0..5] = ", SB1[[firstMismatch + 1, 1 ;; 6]]];
  Print["Are these the same? ", L9[[firstMismatch + 1, 1 ;; 22]] === SB1[[firstMismatch + 1, 1 ;; 22]]]];
Print[""];

(* === Direct L^9 comparison === *)
L9big = MatrixPower[Lmat[25], 9]; (* 26x26 *)
L9sub = L9big[[1 ;; 26, 1 ;; 22]]; (* 26x22 submatrix *)
Print["L^9[0..25, 0..21] == SB1? ", L9sub === SB1];
Print["L^9[0..25, 0..21] == TSB1? ", L9sub === TSB1];
Print[""];

(* === The KEY insight: L^9 != block transfer (different operation sequence!) === *)
(* Block transfer is NOT L^9 because the dimensions change during computation *)
(* The L operations happen at different sizes *)
Print["===== KEY: blockTransfer != L^9 ====="];
Print["L^9 is the product of 9 L_25 operations (all at same size 26)"];
Print["SB1 is the product of L_21^2, extend+L_22, L_22, extend+L_23, ...");
Print["These are DIFFERENT because L_21 != L_25 on vectors of size > 22"];
Print[""];

(* But: for rows j <= 21, L_21[j,:] = L_25[j,:] (same for small rows) *)
(* The DIFFERENCE arises because L_21 is 22x22, so the mat after L_21^2 is 22x22 *)
(* When we then pad to 23x22 and apply L_22, rows 0..21 see: *)
(* (L_22 . pad . L_21^2 . mat)[j,:] = sum_{t=0}^{j} (pad . L_21^2 . mat)[t,:] *)
(* For j <= 21: = sum_{t=0}^{j} L_21^2 . mat[t,:] (pad doesn't affect rows <= 21) *)
(* = (L * L_21^2 . mat)[j,:] where this L is restricted to rows 0..j *)
(* = L^3[j,:] restricted to the 22-column input *)

(* So for j <= 21, we should get L^9_inf restricted. Let me check CAREFULLY. *)
Print["===== CAREFUL TRACE ====="];
mat = IdentityMatrix[22]; (* 22x22 *)
Print["Initial mat[0] = ", mat[[1, 1 ;; 4]]];

(* x=48: L_21 . mat *)
mat = Lmat[21] . mat;
Print["After L_21: mat[0] = ", mat[[1, 1 ;; 4]], " mat[21] = ", mat[[22, 1 ;; 4]]];
Print["  dim = ", Dimensions[mat]];

(* x=49: L_21 . mat *)
mat = Lmat[21] . mat;
Print["After L_21^2: mat[0] = ", mat[[1, 1 ;; 4]], " mat[21] = ", mat[[22, 1 ;; 4]]];
Print["  dim = ", Dimensions[mat]];

(* x=50: rise. Pad, then L_22 *)
mat = Lmat[22] . ArrayPad[mat, {{0, 1}, {0, 0}}];
Print["After rise to 22: mat[0] = ", mat[[1, 1 ;; 4]],
  " mat[21] = ", mat[[22, 1 ;; 4]], " mat[22] = ", mat[[23, 1 ;; 4]]];
Print["  dim = ", Dimensions[mat]];

(* Compare with L^3 *)
L3 = MatrixPower[Lmat[25], 3]; (* 26x26 *)
Print["L^3[0] = ", L3[[1, 1 ;; 4]], " L^3[21] = ", L3[[22, 1 ;; 4]],
  " L^3[22] = ", L3[[23, 1 ;; 4]]];
Print["Match at row 0? ", mat[[1, 1 ;; 22]] === L3[[1, 1 ;; 22]]];
Print["Match at row 21? ", mat[[22, 1 ;; 22]] === L3[[22, 1 ;; 22]]];
Print["Match at row 22? ", mat[[23, 1 ;; 22]] === L3[[23, 1 ;; 22]]];
Print[""];

(* Continue: x=51 same *)
mat = Lmat[22] . mat;
(* x=52 rise *)
mat = Lmat[23] . ArrayPad[mat, {{0, 1}, {0, 0}}];
(* x=53 same *)
mat = Lmat[23] . mat;
(* x=54 rise *)
mat = Lmat[24] . ArrayPad[mat, {{0, 1}, {0, 0}}];
(* x=55 same *)
mat = Lmat[24] . mat;
(* x=56 rise *)
mat = Lmat[25] . ArrayPad[mat, {{0, 1}, {0, 0}}];

Print["Final SB1:"];
Print["dim = ", Dimensions[mat]];
Print["== SB1? ", mat === SB1];
Print[""];

(* Compare with L^9 at every row *)
L9 = MatrixPower[Lmat[25], 9];
Print["Row-by-row comparison SB1 vs L^9:"];
Do[
  match = mat[[j + 1, 1 ;; 22]] === L9[[j + 1, 1 ;; 22]];
  If[!match,
    diff = mat[[j + 1, 1 ;; 4]] - L9[[j + 1, 1 ;; 4]];
    Print["  Row ", j, ": DIFFER, diff[0..3] = ", diff],
    If[j <= 3 || j >= 21,
      Print["  Row ", j, ": match"]]],
  {j, 0, 25}];
Print[""];

Print["===== DONE ====="];
