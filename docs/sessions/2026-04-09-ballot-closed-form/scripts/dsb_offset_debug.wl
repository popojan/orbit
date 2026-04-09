(* Debug: find the correct A offset for different irrationals *)

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

testOffset[alpha_, name_] := Module[
  {cf, w, p0, q0, p1, q1, p2, q2, a2,
   initDim, startPos, d0, sb, tRef, dSB, corrRows, preRise,
   xS, xE, prevSt, nCorr, pBlock},

  cf = ContinuedFraction[alpha, 5]; w = cf[[1]];
  {p0, q0} = Through[{Numerator, Denominator}[Convergents[alpha, 1][[1]]]];
  {p1, q1} = Through[{Numerator, Denominator}[Convergents[alpha, 2][[2]]]];
  {p2, q2} = Through[{Numerator, Denominator}[Convergents[alpha, 3][[3]]]];
  a2 = cf[[3]];

  Print["===== ", name, " ====="];
  Print["CF=[", w, ";", cf[[2]], ",", a2, ",...] w=", w, " p1=", p1,
    " q1=", q1, " a2=", a2];

  initDim = q1 + q2 + 1;
  startPos = p1 + p2;
  d0 = initDim;

  (* Build SB1 *)
  xS = startPos; xE = startPos + p1;
  sb = blockTransferActual[d0, alpha, xS, xE];
  pBlock = p1;
  nCorr = q1;

  tRef = Table[toep[pBlock - 1, j, s],
    {j, 0, Dimensions[sb][[1]] - 1}, {s, 0, d0 - 1}];
  dSB = tRef - sb;

  corrRows = Select[Range[Length[dSB]],
    dSB[[#]] =!= Table[0, d0] &] - 1;
  Print["d0=", d0, " SB1 correction rows: ", corrRows];

  (* Pre-rise *)
  prevSt = Floor[xS/alpha]; preRise = 0;
  Do[If[Floor[x/alpha] > prevSt, Break[], preRise++]; prevSt = Floor[x/alpha],
    {x, xS + 1, xE}];
  Print["preRise=", preRise];

  (* Show first correction row *)
  If[corrRows =!= {},
    Print["First correction row ", corrRows[[1]], ": ",
      dSB[[corrRows[[1]] + 1, 1 ;; Min[6, d0]]]]];

  (* Brute-force search for A *)
  Print["Searching for A:"];
  Do[
    aTest = aVal;
    firstRow = aTest + 2;
    If[firstRow < corrRows[[1]] || firstRow > corrRows[[1]] + 2, Continue[]];

    allMatch = True;
    Do[
      d = j - firstRow;
      If[d < 0 || d >= nCorr, Continue[]];
      predicted = Table[
        Sum[vLin[pBlock - w m, w, d - m + 1] *
          Binomial[aTest + m (w + 1) - s, m w - 1], {m, 1, d + 1}],
        {s, 0, d0 - 1}];
      actual = dSB[[j + 1]];
      If[predicted =!= actual, allMatch = False; Break[]],
      {j, corrRows}];
    If[allMatch,
      Print["  A=", aTest, " (d0-", d0 - aTest, ", preRise-",
        preRise - (d0 - aTest), "): ALL MATCH ***"]],
    {aVal, d0 - 20, d0}];
  Print[""];
]

testOffset[Sqrt[5], "sqrt(5)"];
testOffset[Sqrt[2], "sqrt(2)"];
testOffset[Pi, "Pi"];
testOffset[Im[ZetaZero[1]], "Im[ZetaZero[1]]"];
testOffset[Sqrt[3], "sqrt(3)"];
testOffset[GoldenRatio, "phi"];

Print["===== DONE ====="];
