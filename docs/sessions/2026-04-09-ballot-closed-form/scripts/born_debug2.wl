(* Minimal Toeplitz verification *)
Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

(* L^n[j,s] = C(j-s+n-1, n-1) for j>=s. Verify: *)
L9 = MatrixPower[Lmat[25], 9];
Print["L^9[5,2] = ", L9[[6, 3]], " = C(5-2+8, 8) = ", Binomial[11, 8]];
Print["L^9[22,0] = ", L9[[23, 1]], " = C(22+8, 8) = ", Binomial[30, 8]];
Print["L^9[25,21] = ", L9[[26, 22]], " = C(4+8, 8) = ", Binomial[12, 8]];
Print[""];

(* Toeplitz T(8): entries C(8+j-s, j-s) *)
T8 = Table[Binomial[8 + j - s, j - s], {j, 0, 25}, {s, 0, 21}];
L9sub = L9[[1 ;; 26, 1 ;; 22]];
Print["L^9[0..25, 0..21] == T(8)? ", L9sub === T8];

(* Row-by-row check *)
Do[If[L9sub[[j + 1]] =!= T8[[j + 1]],
  Print["DIFFER at row ", j, ": L9=", L9sub[[j + 1, 1 ;; 3]],
    " T8=", T8[[j + 1, 1 ;; 3]]]],
  {j, 0, 25}];
Print[""];

(* Block transfer SB1 *)
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
SB1 = blockTransferActual[22, alpha, 47, 56];
Print["SB1 dims: ", Dimensions[SB1]];

(* Compare SB1 with T(8) row by row *)
Print["SB1 vs T(8):"];
Do[If[SB1[[j + 1]] =!= T8[[j + 1]],
  diff = SB1[[j + 1]] - T8[[j + 1]];
  nz = Select[Range[22], diff[[#]] =!= 0 &] - 1;
  Print["Row ", j, ": differs at cols ", nz,
    If[Length[nz] <= 3, " vals=" <> ToString[diff[[nz + 1]]], ""]]],
  {j, 0, 25}];
Print[""];

(* Also compare with L^9 (should be same as T(8)) *)
Print["SB1 vs L^9:"];
Do[If[SB1[[j + 1]] =!= L9sub[[j + 1]],
  diff = SB1[[j + 1]] - L9sub[[j + 1]];
  nz = Select[Range[22], diff[[#]] =!= 0 &] - 1;
  If[j <= 3 || j >= 20,
    Print["Row ", j, ": differs at cols ", nz,
      If[Length[nz] <= 3, " vals=" <> ToString[diff[[nz + 1]]], ""]]]],
  {j, 0, 25}];
Print[""];

(* === The right comparison: the ORIGINAL level-1 block transfer === *)
M1 = blockTransferActual[5, alpha, 11, 20];
T8small = Table[Binomial[8 + j - s, j - s], {j, 0, 8}, {s, 0, 4}];
Print["Original M1 vs T(8):"];
Do[If[M1[[j + 1]] =!= T8small[[j + 1]],
  Print["Row ", j, ": differs"]],
  {j, 0, 8}];
Print["(rows 0..5 match, rows 6-8 have correction)"];
Print[""];

(* === The answer: SB1 IS different from T(8) because the stair pattern *)
(*     within the block gives a different distribution of L operations. === *)
(* The CORRECT Toeplitz reference for SB1 is NOT T(8) = L^9, because  *)
(* the actual matrix is L_25 . pad . L_24^2 . pad . L_23^2 . pad .    *)
(* L_22^2 . pad . L_21^3 which != L_25^9.                              *)
(*                                                                       *)
(* What IS the Toeplitz of SB1? It should be the INFINITE-DIM LIMIT.    *)
(* In infinite dim, L_m = L for all m, so the product is L^9 = T(8).   *)
(* But for FINITE dims, the corrections start at different rows.        *)
(*                                                                       *)
(* KEY: for rows j <= 21 (= initDim-1), all L operations at dims >=22  *)
(* don't affect these rows. So SB1[j, :] = (L_21^3 padded and composed *)
(* with subsequent L ops)[j, :].                                        *)
(*                                                                       *)
(* But L_21 is 22x22, so L_21^3 only acts on heights 0..21. The       *)
(* composition with subsequent L_22, L_23, etc. for heights <= 21       *)
(* should give the same as L^9 for these rows. Unless... the padding   *)
(* operation changes something.                                          *)

(* Let me trace exactly what happens to row j=10 *)
Print["===== TRACE for row j=10 ====="];
mat = IdentityMatrix[22];
Print["Initial: mat[11, 1..4] = ", mat[[11, 1 ;; 4]]]; (* row 10, 1-indexed *)

(* x=48: L_21 *)
mat = Lmat[21] . mat;
Print["After L_21: ", mat[[11, 1 ;; 4]]];
(* x=49: L_21 *)
mat = Lmat[21] . mat;
Print["After L_21^2: ", mat[[11, 1 ;; 4]]];
(* x=50: rise *)
mat = Lmat[22] . ArrayPad[mat, {{0, 1}, {0, 0}}];
Print["After rise+L_22: ", mat[[11, 1 ;; 4]]];
(* x=51: L_22 *)
mat = Lmat[22] . mat;
Print["After L_22: ", mat[[11, 1 ;; 4]]];
(* x=52: rise *)
mat = Lmat[23] . ArrayPad[mat, {{0, 1}, {0, 0}}];
Print["After rise+L_23: ", mat[[11, 1 ;; 4]]];
(* x=53: L_23 *)
mat = Lmat[23] . mat;
Print["After L_23: ", mat[[11, 1 ;; 4]]];
(* x=54: rise *)
mat = Lmat[24] . ArrayPad[mat, {{0, 1}, {0, 0}}];
Print["After rise+L_24: ", mat[[11, 1 ;; 4]]];
(* x=55: L_24 *)
mat = Lmat[24] . mat;
Print["After L_24: ", mat[[11, 1 ;; 4]]];
(* x=56: rise *)
mat = Lmat[25] . ArrayPad[mat, {{0, 1}, {0, 0}}];
Print["After rise+L_25: ", mat[[11, 1 ;; 4]]];

Print["T(8)[10, 0..3] = ", T8[[11, 1 ;; 4]]];
Print["L^9[10, 0..3] = ", L9sub[[11, 1 ;; 4]]];
Print[""];

(* The L_m operation for row j <= m is: *)
(* (L_m . mat)[j, :] = sum_{t=0}^{j} mat[t, :] *)
(* This is INDEPENDENT of m (as long as m >= j)! *)
(* So L_21[10, :] = L_22[10, :] = L_inf[10, :] *)
(* And the padding doesn't affect row 10 either *)
(* So row 10 of SB1 should be EXACTLY row 10 of L^9 *)
(* Unless ArrayPad somehow affects row 10... it shouldn't *)

Print["===== DONE ====="];
