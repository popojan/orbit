(* FULL BORN EXPANSION: verify exactness at all orders for sqrt(5) *)
(* Then test: what's the MINIMUM order needed at each correction depth d? *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
toep[a_, j_, s_] := If[j >= s, Binomial[a + j - s, j - s], 0]
vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]

blockTransferActual[initDim_, alpha_, xStart_, xEnd_] := Module[
  {mat = IdentityMatrix[initDim], m = initDim - 1,
   prevS = Floor[xStart/alpha], curS},
  Do[curS = Floor[x/alpha];
    If[curS == prevS, mat = Lmat[m] . mat,
      mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++];
    prevS = curS, {x, xStart + 1, xEnd}];
  mat
]

(* === sqrt(5): a2=4, full 4-order expansion === *)
alpha = Sqrt[5]; ww = 2;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;
a2 = 4; initDim = q1 + q2 + 1; A2 = q1 + q2 - 1;
startPos = p1 + p2; nSB = a2;

(* Build sub-blocks *)
sbStarts = Table[startPos + (k - 1) p1, {k, 1, nSB}];
sbEnds = Join[Table[startPos + k p1, {k, 1, nSB - 1}], {startPos + p2}];
SBlist = Table[
  blockTransferActual[initDim + (k - 1) q1, alpha, sbStarts[[k]], sbEnds[[k]]],
  {k, 1, nSB}];

M2 = blockTransferActual[initDim, alpha, startPos, startPos + p2];

(* Toeplitz decomposition *)
TSBlist = Table[Module[{d0 = initDim + (k - 1) q1, outDim, param},
  outDim = d0 + If[k < nSB, q1, q0 + q1];
  param = If[k < nSB, p1 - 1, p0 + p1 - 1];
  Table[toep[param, j, s], {j, 0, outDim - 1}, {s, 0, d0 - 1}]],
  {k, 1, nSB}];
DSBlist = Table[TSBlist[[k]] - SBlist[[k]], {k, 1, nSB}];

allT = TSBlist[[1]];
Do[allT = TSBlist[[k]] . allT, {k, 2, nSB}];
t2ref = Table[toep[p2 - 1, j, s],
  {j, 0, Dimensions[allT][[1]] - 1}, {s, 0, initDim - 1}];

totalCorr = allT - M2; (* this is what born1 - born2 + born3 - born4 should equal *)

(* === Compute Born terms by order === *)
(* A "sandwich" for subset S = {k1 < k2 < ... < km} is: *)
(* T_{nSB}...T_{k_m+1} . D_{k_m} . T_{k_m-1}...T_{k_{m-1}+1} . D_{k_{m-1}} ... D_{k1} . T_{k1-1}...T_1 *)

sandwich[subset_] := Module[{mat, sorted = Sort[subset]},
  (* Start from the rightmost: T_{k1-1}...T_1 then D_{k1} *)
  mat = DSBlist[[sorted[[1]]]];
  Do[mat = mat . TSBlist[[j]], {j, sorted[[1]] - 1, 1, -1}];
  (* For each subsequent k in subset: T...T then D_k *)
  Do[
    Do[mat = TSBlist[[j]] . mat, {j, sorted[[i - 1]] + 1, sorted[[i]] - 1}];
    mat = DSBlist[[sorted[[i]]]] . mat,
    {i, 2, Length[sorted]}];
  (* Final: T_{nSB}...T_{k_m+1} *)
  Do[mat = TSBlist[[j]] . mat, {j, sorted[[-1]] + 1, nSB}];
  mat
]

Print["===== COMPUTING BORN ORDERS 1-4 ====="];

(* Order 1: 4 terms *)
{timeO1, bornO1} = AbsoluteTiming[
  Total[sandwich[{#}] & /@ Subsets[Range[nSB], {1}]]];
Print["Order 1: ", Length[Subsets[Range[nSB], {1}]], " terms, ", timeO1, "s"];

(* Order 2: 6 terms *)
{timeO2, bornO2} = AbsoluteTiming[
  Total[sandwich /@ Subsets[Range[nSB], {2}]]];
Print["Order 2: ", Length[Subsets[Range[nSB], {2}]], " terms, ", timeO2, "s"];

(* Order 3: 4 terms *)
{timeO3, bornO3} = AbsoluteTiming[
  Total[sandwich /@ Subsets[Range[nSB], {3}]]];
Print["Order 3: ", Length[Subsets[Range[nSB], {3}]], " terms, ", timeO3, "s"];

(* Order 4: 1 term *)
{timeO4, bornO4} = AbsoluteTiming[sandwich[Range[nSB]]];
Print["Order 4: 1 term, ", timeO4, "s"];
Print[""];

(* Verify: totalCorr == born1 - born2 + born3 - born4 *)
fullBorn = bornO1 - bornO2 + bornO3 - bornO4;
Print["Full Born == total correction? ", fullBorn === totalCorr];
Print[""];

(* === MINIMUM ORDER NEEDED AT EACH DEPTH d === *)
Print["===== MINIMUM ORDER FOR EXACT RESULT ====="];
d2actual = t2ref - M2;

Do[
  d = dd; j = A2 + 2 + d;
  If[j >= Length[d2actual], Break[]];
  actual = d2actual[[j + 1]];
  maxAct = Max[Abs[actual]];
  If[maxAct == 0, Continue[]];

  (* Check cumulative Born orders *)
  cumBorn = Table[0, initDim];
  minOrder = -1;
  Do[
    cumBorn += (-1)^(ord + 1) * Switch[ord,
      1, bornO1, 2, bornO2, 3, bornO3, 4, bornO4][[j + 1]];
    If[cumBorn === actual, minOrder = ord; Break[]],
    {ord, 1, 4}];

  (* Also compute relative error at each order *)
  err1 = Max[Abs[actual - bornO1[[j + 1]]]];
  err12 = Max[Abs[actual - (bornO1 - bornO2)[[j + 1]]]];
  err123 = Max[Abs[actual - (bornO1 - bornO2 + bornO3)[[j + 1]]]];

  Print["d=", d, " (row ", j, "): minOrder=", minOrder,
    "  err O1=", N[err1/maxAct, 3],
    "  O1-O2=", N[err12/maxAct, 3],
    "  O1-O2+O3=", If[err123 > 0, N[err123/maxAct, 3], "0"]],
  {dd, 0, 16}];
Print[""];

(* === KEY INSIGHT: at which d does each order FIRST contribute? === *)
Print["===== FIRST NONZERO ROW OF EACH BORN ORDER ====="];
Do[
  bornOrd = Switch[ord, 1, bornO1, 2, bornO2, 3, bornO3, 4, bornO4];
  firstNZ = SelectFirst[Range[Length[bornOrd]],
    bornOrd[[#]] =!= Table[0, initDim] &] - 1;
  lastNZ = Length[bornOrd] - SelectFirst[Reverse[Range[Length[bornOrd]]],
    bornOrd[[#]] =!= Table[0, initDim] &];
  Print["Order ", ord, ": first nonzero at row ", firstNZ,
    " (d=", firstNZ - A2 - 2, "), last at row ",
    Length[bornOrd] - 1 - lastNZ],
  {ord, 1, 4}];
Print[""];

(* === PATTERN: order k first contributes at d = (k-1)*q1 === *)
Print["Prediction: order k first contributes at d = (k-1)*q1 = ",
  Table[(k - 1) q1, {k, 1, 4}]];
Print["(Because k corrections each shift by q1 rows)"];

Print[""];
Print["===== DONE ====="];
