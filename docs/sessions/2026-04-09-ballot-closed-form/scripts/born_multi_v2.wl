(* BORN EXPANSION: multi-irrational verification v2 *)
(* Fixes: proper zero matrix init, exact alpha handling *)

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

verifyBorn[alpha_, name_] := Module[
  {cf, w, p0, q0, p1, q1, p2, q2, a2,
   initDim, startPos, nSB, sbStarts, sbEnds,
   SBlist, TSBlist, DSBlist, M2,
   t2ref, d2actual, A2,
   allT, born1, mat, totalCorr, born2},

  cf = ContinuedFraction[alpha, 5];
  w = cf[[1]];
  {p0, q0} = {Numerator[#], Denominator[#]} & @ Convergents[alpha, 1][[1]];
  {p1, q1} = {Numerator[#], Denominator[#]} & @ Convergents[alpha, 2][[2]];
  {p2, q2} = {Numerator[#], Denominator[#]} & @ Convergents[alpha, 3][[3]];
  a2 = cf[[3]];

  Print["################################################################"];
  Print["# ", name];
  Print["# CF = [", w, "; ", cf[[2]], ",", a2, ",...]"];
  Print["# w=", w, " p1=", p1, " q1=", q1, " p2=", p2, " q2=", q2, " a2=", a2];
  Print["################################################################"];

  initDim = q1 + q2 + 1;
  startPos = p1 + p2;
  A2 = q1 + q2 - 1;
  nSB = a2;

  (* Sub-block boundaries *)
  sbStarts = Table[startPos + (k - 1) p1, {k, 1, nSB}];
  sbEnds = Table[startPos + k p1, {k, 1, nSB - 1}];
  AppendTo[sbEnds, startPos + p2];

  Print["Blocks: ", nSB, " (", nSB - 1, " standard + 1 anom), dim ", initDim];

  (* Build sub-blocks *)
  SBlist = Table[
    blockTransferActual[initDim + (k - 1) q1, alpha, sbStarts[[k]], sbEnds[[k]]],
    {k, 1, nSB}];

  (* Verify composition *)
  M2 = blockTransferActual[initDim, alpha, startPos, startPos + p2];
  Module[{comp = SBlist[[1]]},
    Do[comp = SBlist[[k]] . comp, {k, 2, nSB}];
    Print["Composition: ", If[comp === M2, "OK", "FAIL"]]];

  (* Toeplitz decomposition *)
  TSBlist = Table[Module[{d0 = initDim + (k - 1) q1, outDim, param},
    outDim = d0 + If[k < nSB, q1, q0 + q1];
    param = If[k < nSB, p1 - 1, p0 + p1 - 1];
    Table[toep[param, j, s], {j, 0, outDim - 1}, {s, 0, d0 - 1}]],
    {k, 1, nSB}];

  DSBlist = Table[TSBlist[[k]] - SBlist[[k]], {k, 1, nSB}];

  (* === D_SB formula verification === *)
  Print["D_SB formula:"];
  Do[Module[{d0 = initDim + (k - 1) q1, preRise, xS, xE, prevSt,
     pBlock, nCorr, aVal, allMatch},
    xS = sbStarts[[k]]; xE = sbEnds[[k]];
    pBlock = If[k < nSB, p1, p0 + p1];
    nCorr = If[k < nSB, q1, q0 + q1];
    (* Count pre-rise *)
    prevSt = Floor[xS/alpha]; preRise = 0;
    Do[If[Floor[x/alpha] > prevSt, Break[], preRise++]; prevSt = Floor[x/alpha],
      {x, xS + 1, xE}];
    (* Test A = d0 - preRise *)
    aVal = d0 - preRise;
    allMatch = True;
    Do[Module[{j = aVal + 2 + d, predicted, actual},
      If[j >= Length[DSBlist[[k]]], Continue[]];
      predicted = Table[
        Sum[vLin[pBlock - w m, w, d - m + 1] *
          Binomial[aVal + m (w + 1) - s, m w - 1], {m, 1, d + 1}],
        {s, 0, d0 - 1}];
      actual = DSBlist[[k, j + 1]];
      If[predicted =!= actual, allMatch = False]],
      {d, 0, nCorr - 1}];
    Print["  SB", k, " preRise=", preRise, " A=d0-", preRise,
      "=", aVal, ": ", If[allMatch, "ALL MATCH", "MISMATCH"]]],
    {k, 1, Min[nSB, 6]}];

  (* === All-Toeplitz product === *)
  allT = TSBlist[[1]];
  Do[allT = TSBlist[[k]] . allT, {k, 2, nSB}];
  t2ref = Table[toep[p2 - 1, j, s],
    {j, 0, Dimensions[allT][[1]] - 1}, {s, 0, initDim - 1}];
  Print["allT==T2 for rows 0..", initDim + q1 - 1, "? ",
    allT[[1 ;; initDim + q1]] === t2ref[[1 ;; initDim + q1]]];

  (* === First-order Born === *)
  Print["Born1:"];
  d2actual = t2ref - M2;

  (* Compute each born1 term *)
  born1 = Table[0, Dimensions[allT][[1]], initDim];
  Do[Module[{bMat},
    bMat = DSBlist[[k]];
    (* Right: T_{k-1}...T_1 *)
    Do[bMat = bMat . TSBlist[[j]], {j, k - 1, 1, -1}];
    (* Left: T_{k+1}...T_{nSB} *)
    Do[bMat = TSBlist[[j]] . bMat, {j, k + 1, nSB}];
    born1 += bMat],
    {k, 1, nSB}];

  (* Check accuracy row by row *)
  Do[Module[{d = dd, j = A2 + 2 + dd, actual, bornRow, maxAct, maxErr},
    If[j >= Length[d2actual], Return[]];
    actual = d2actual[[j + 1]];
    bornRow = born1[[j + 1]];
    maxAct = Max[Abs[actual]];
    maxErr = Max[Abs[actual - bornRow]];
    If[maxAct == 0, Null,
      If[maxErr === 0,
        Print["  d=", d, ": EXACT"],
        Print["  d=", d, ": err=", N[maxErr/maxAct, 3]]]]],
    {dd, 0, Min[2 q1 + 2, q2 - 3]}];

  (* === Full Born for small a2 === *)
  If[a2 <= 5,
    Print["Full Born (a2=", a2, "):"];
    totalCorr = allT - M2;
    (* Order 2 *)
    born2 = Table[0, Dimensions[allT][[1]], initDim];
    Do[Module[{bMat},
      bMat = DSBlist[[k1]];
      Do[bMat = bMat . TSBlist[[j]], {j, k1 - 1, 1, -1}];
      Do[bMat = TSBlist[[j]] . bMat, {j, k1 + 1, k2 - 1}];
      bMat = DSBlist[[k2]] . bMat;
      Do[bMat = TSBlist[[j]] . bMat, {j, k2 + 1, nSB}];
      born2 += bMat],
      {k1, 1, nSB - 1}, {k2, k1 + 1, nSB}];

    Module[{err1, err12},
      err1 = Max[Abs[totalCorr - born1]];
      err12 = Max[Abs[totalCorr - born1 + born2]];
      Print["  |totalCorr - born1| = ", err1];
      Print["  |totalCorr - born1 + born2| = ", err12];
      If[err12 > 0,
        Print["  (need order 3+)"],
        Print["  ORDER 2 SUFFICIENT for full precision!"]]]];

  Print[""];
]

(* === RUN === *)
Print["Timing each irrational..."];
Print[""];

{t1, Null} = AbsoluteTiming[verifyBorn[Sqrt[5], "sqrt(5)"]];
Print["sqrt(5) took ", t1, "s\n"];

{t2, Null} = AbsoluteTiming[verifyBorn[Sqrt[2], "sqrt(2)"]];
Print["sqrt(2) took ", t2, "s\n"];

{t3, Null} = AbsoluteTiming[verifyBorn[Pi, "Pi"]];
Print["Pi took ", t3, "s\n"];

(* Im[ZetaZero[1]] needs high-precision numerical alpha *)
zetaAlpha = Im[ZetaZero[1]];
{t4, Null} = AbsoluteTiming[verifyBorn[zetaAlpha, "Im[ZetaZero[1]]"]];
Print["ZetaZero took ", t4, "s\n"];

Print["===== ALL DONE ====="];
