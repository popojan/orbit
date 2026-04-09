(* FULL BORN EXPANSION for sqrt(5): verify all 4 orders *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
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
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;
a2 = 4; initDim = q1 + q2 + 1; A2 = q1 + q2 - 1;
startPos = p1 + p2;

(* Build sub-blocks and Toeplitz *)
SBlist = Table[
  blockTransferActual[initDim + (k - 1) q1, alpha,
    startPos + (k - 1) p1,
    If[k < a2, startPos + k p1, startPos + p2]],
  {k, 1, a2}];

TSBlist = Table[Module[{d0 = initDim + (k - 1) q1, param},
  param = If[k < a2, p1 - 1, p0 + p1 - 1];
  Table[toep[param, j, s],
    {j, 0, d0 + If[k < a2, q1, q0 + q1] - 1}, {s, 0, d0 - 1}]],
  {k, 1, a2}];

DSBlist = Table[TSBlist[[k]] - SBlist[[k]], {k, 1, a2}];

allT = TSBlist[[1]]; Do[allT = TSBlist[[k]] . allT, {k, 2, a2}];
t2ref = Table[toep[p2 - 1, j, s],
  {j, 0, Dimensions[allT][[1]] - 1}, {s, 0, initDim - 1}];
M2 = SBlist[[1]]; Do[M2 = SBlist[[k]] . M2, {k, 2, a2}];

totalCorr = allT - M2;

(* === Order 1: T...T.D_k.T...T for each k === *)
Print["===== BORN ORDERS 1-4 for sqrt(5) ====="];
Print["a2=", a2, ", max order=", a2];
Print[""];

bO1 = Table[Module[{mat = DSBlist[[k]]},
  Do[mat = mat . TSBlist[[j]], {j, k - 1, 1, -1}];
  Do[mat = TSBlist[[j]] . mat, {j, k + 1, a2}];
  mat], {k, 1, a2}];
born1 = Total[bO1];
Print["Order 1: 4 terms computed"];

(* === Order 2: pairs (k1, k2) with k1 < k2 === *)
bO2 = {};
Do[Module[{mat = DSBlist[[k1]]},
  Do[mat = mat . TSBlist[[j]], {j, k1 - 1, 1, -1}];
  Do[mat = TSBlist[[j]] . mat, {j, k1 + 1, k2 - 1}];
  mat = DSBlist[[k2]] . mat;
  Do[mat = TSBlist[[j]] . mat, {j, k2 + 1, a2}];
  AppendTo[bO2, mat]],
  {k1, 1, a2 - 1}, {k2, k1 + 1, a2}];
born2 = Total[bO2];
Print["Order 2: ", Length[bO2], " terms computed"];

(* === Order 3: triples (k1, k2, k3) === *)
bO3 = {};
Do[Module[{mat = DSBlist[[k1]]},
  Do[mat = mat . TSBlist[[j]], {j, k1 - 1, 1, -1}];
  Do[mat = TSBlist[[j]] . mat, {j, k1 + 1, k2 - 1}];
  mat = DSBlist[[k2]] . mat;
  Do[mat = TSBlist[[j]] . mat, {j, k2 + 1, k3 - 1}];
  mat = DSBlist[[k3]] . mat;
  Do[mat = TSBlist[[j]] . mat, {j, k3 + 1, a2}];
  AppendTo[bO3, mat]],
  {k1, 1, a2 - 2}, {k2, k1 + 1, a2 - 1}, {k3, k2 + 1, a2}];
born3 = Total[bO3];
Print["Order 3: ", Length[bO3], " terms computed"];

(* === Order 4: quadruple (1,2,3,4) === *)
Module[{mat = DSBlist[[1]]},
  Do[mat = TSBlist[[j]] . mat, {j, 2, 1}]; (* empty: k1=1, no T between 0 and 1 *)
  mat = DSBlist[[2]] . mat;
  Do[mat = TSBlist[[j]] . mat, {j, 3, 2}]; (* empty *)
  mat = DSBlist[[3]] . mat;
  Do[mat = TSBlist[[j]] . mat, {j, 4, 3}]; (* empty *)
  mat = DSBlist[[4]] . mat;
  born4 = mat];
Print["Order 4: 1 term computed"];
Print[""];

(* Verify full expansion *)
fullBorn = born1 - born2 + born3 - born4;
Print["born1 - born2 + born3 - born4 == totalCorr? ", fullBorn === totalCorr];
Print[""];

(* === MINIMUM ORDER ANALYSIS === *)
Print["===== MINIMUM ORDER NEEDED AT EACH d ====="];
Print["Format: d | minOrder | err(O1) | err(O1-O2) | err(O1-O2+O3)"];
Print[""];

Do[
  d = dd; j = A2 + 2 + d;
  If[j >= Length[totalCorr], Break[]];
  actual = totalCorr[[j + 1]];
  maxAct = Max[Abs[actual]];
  If[maxAct == 0, Continue[]];

  r1 = born1[[j + 1]];
  r12 = (born1 - born2)[[j + 1]];
  r123 = (born1 - born2 + born3)[[j + 1]];
  r1234 = fullBorn[[j + 1]];

  err1 = Max[Abs[actual - r1]];
  err12 = Max[Abs[actual - r12]];
  err123 = Max[Abs[actual - r123]];
  err1234 = Max[Abs[actual - r1234]];

  minOrd = Which[err1 === 0, 1, err12 === 0, 2, err123 === 0, 3, err1234 === 0, 4, True, 99];

  Print["d=", PaddedForm[d, 2], " minOrd=", minOrd,
    "  O1:", PaddedForm[N[err1/maxAct, 3], {5, 3}],
    "  O2:", PaddedForm[N[err12/maxAct, 3], {5, 3}],
    "  O3:", PaddedForm[N[err123/maxAct, 3], {5, 3}]],
  {dd, 0, 16}];
Print[""];

(* === First nonzero row of each order === *)
Print["===== FIRST NONZERO ROW OF EACH ORDER ====="];
Do[
  bOrd = Switch[ord, 1, born1, 2, born2, 3, born3, 4, born4];
  firstNZ = -1;
  Do[If[bOrd[[j]] =!= Table[0, initDim], firstNZ = j - 1; Break[]], {j, 1, Length[bOrd]}];
  Print["Order ", ord, ": first nonzero at row ", firstNZ,
    " = A2+2+", firstNZ - A2 - 2, " (predicted: d=(", ord - 1, ")*q1=", (ord - 1) q1, ")"],
  {ord, 1, 4}];
Print[""];

Print["===== DONE ====="];
