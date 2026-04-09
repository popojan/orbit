(* BORN EXPANSION: verification across multiple irrationals *)
(* Tests: sub-block decomposition, D_SB formula, Born accuracy *)

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

(* Get CF convergents from alpha *)
getCFdata[alpha_, nTerms_] := Module[{cf, convs, ps, qs},
  cf = ContinuedFraction[alpha, nTerms];
  convs = Convergents[alpha, nTerms];
  ps = Numerator /@ convs;
  qs = Denominator /@ convs;
  <|"cf" -> cf, "p" -> ps, "q" -> qs, "w" -> cf[[1]]|>
]

(* === Main verification function === *)
verifyBorn[alpha_, name_] := Module[
  {data, cf, w, p0, q0, p1, q1, p2, q2, a2,
   initDim, startPos, nSB, sbEnds,
   SBlist, TSBlist, DSBlist, M2, M2check,
   t2ref, d2actual, A2, corrRowsList,
   allT, born1list, born1, bornTotal,
   simpleF, preRise, offsetA},

  data = getCFdata[alpha, 5];
  cf = data["cf"]; w = data["w"];
  {p0, p1, p2} = data["p"][[1 ;; 3]];
  {q0, q1, q2} = data["q"][[1 ;; 3]];
  a2 = cf[[3]];

  Print["################################################################"];
  Print["# ", name, " = ", N[alpha, 10]];
  Print["# CF = [", cf[[1]], "; ", StringRiffle[ToString /@ cf[[2 ;;]], ","], ",...]"];
  Print["# w=", w, " p0=", p0, " q0=", q0, " p1=", p1, " q1=", q1,
    " p2=", p2, " q2=", q2, " a2=", a2];
  Print["################################################################"];
  Print[""];

  initDim = q1 + q2 + 1;
  startPos = p1 + p2;
  A2 = q1 + q2 - 1;
  nSB = a2; (* a2-1 standard + 1 anomalous *)

  Print["Level-2 block: pos ", startPos, " -> ", startPos + p2,
    ", dim ", initDim, " -> ", initDim + q2];

  (* Sub-block boundaries: (a2-1) standard of p1 cols + 1 anomalous of (p0+p1) cols *)
  sbEnds = Table[startPos + k p1, {k, 1, a2 - 1}];
  AppendTo[sbEnds, startPos + p2]; (* last = anomalous *)
  Print["Sub-block boundaries: ", Prepend[sbEnds, startPos]];
  Print["Column counts: ", Differences[Prepend[sbEnds, startPos]],
    " (expected: ", Join[Table[p1, a2 - 1], {p0 + p1}], ")"];
  Print[""];

  (* Build sub-blocks *)
  SBlist = {};
  Do[
    xS = If[k == 1, startPos, sbEnds[[k - 1]]];
    xE = sbEnds[[k]];
    d0 = initDim + (k - 1) q1;
    sb = blockTransferActual[d0, alpha, xS, xE];
    AppendTo[SBlist, sb],
    {k, 1, nSB}];

  Print["Sub-block dims: ", Dimensions /@ SBlist];

  (* Build actual M2 *)
  M2 = blockTransferActual[initDim, alpha, startPos, startPos + p2];

  (* Verify composition *)
  M2check = SBlist[[-1]];
  Do[M2check = M2check . SBlist[[k]], {k, nSB - 1, 1, -1}];
  Print["Composition check: ", M2check === M2];
  Print[""];

  (* Toeplitz decomposition *)
  TSBlist = {};
  DSBlist = {};
  Do[
    d0 = initDim + (k - 1) q1;
    outDim = d0 + q1;
    param = If[k < nSB, p1 - 1, p0 + p1 - 1]; (* standard vs anomalous *)
    tMat = Table[toep[param, j, s], {j, 0, outDim - 1}, {s, 0, d0 - 1}];
    dMat = tMat - SBlist[[k]];
    AppendTo[TSBlist, tMat];
    AppendTo[DSBlist, dMat],
    {k, 1, nSB}];

  (* Verify correction rows *)
  Print["Correction structure:"];
  Do[
    d0 = initDim + (k - 1) q1;
    nonzero = Select[Range[Length[DSBlist[[k]]]],
      DSBlist[[k, #]] =!= Table[0, d0] &] - 1;
    Print["  SB", k, " (d0=", d0, "): corr rows = ", nonzero,
      If[k < nSB, " (standard)", " (anomalous)"]],
    {k, 1, nSB}];
  Print[""];

  (* === Verify D_SB formula (R7 with shifted A) === *)
  Print["===== D_SB FORMULA VERIFICATION ====="];
  Do[
    d0 = initDim + (k - 1) q1;
    (* Determine pre-rise: count columns before first rise *)
    xS = If[k == 1, startPos, sbEnds[[k - 1]]];
    xE = sbEnds[[k]];
    prevSt = Floor[xS/alpha];
    preRise = 0;
    Do[curSt = Floor[x/alpha];
      If[curSt > prevSt, Break[], preRise++]; prevSt = curSt,
      {x, xS + 1, xE}];

    (* Test A = d0-1 and A = d0-2 *)
    Do[
      aTest = aVal;
      nCorr = If[k < nSB, q1, q0 + q1]; (* standard vs anomalous *)
      allMatch = True;
      Do[
        d = dd;
        j = aTest + 2 + d;
        If[j >= Length[DSBlist[[k]]], Continue[]];
        predicted = Table[
          Sum[vLin[If[k < nSB, p1, p0 + p1] - w m, w, d - m + 1] *
            Binomial[aTest + m (w + 1) - s, m w - 1], {m, 1, d + 1}],
          {s, 0, d0 - 1}];
        actual = DSBlist[[k, j + 1]];
        If[predicted =!= actual, allMatch = False],
        {dd, 0, nCorr - 1}];
      If[allMatch,
        Print["  SB", k, " (preRise=", preRise, "): A=", aTest,
          " (d0-", d0 - aTest, ") ALL MATCH"]],
      {aVal, {d0 - 1, d0 - 2, d0 - preRise}}],
    {k, 1, Min[nSB, 5]}]; (* check first 5 sub-blocks *)
  Print[""];

  (* === All-Toeplitz product === *)
  allT = TSBlist[[-1]];
  Do[allT = allT . TSBlist[[k]], {k, nSB - 1, 1, -1}];
  t2ref = Table[toep[p2 - 1, j, s],
    {j, 0, initDim + q2 - 1}, {s, 0, initDim - 1}];
  Print["allT == T(p2-1)? ", allT === t2ref];
  If[allT =!= t2ref,
    disc = Select[Range[Length[allT]], allT[[#]] =!= t2ref[[#]] &] - 1;
    Print["First discrepancy at row ", First[disc],
      " (expected: >= ", initDim + q1, " = d01+q1)"]];
  Print[""];

  (* === First-order Born === *)
  Print["===== FIRST-ORDER BORN ====="];
  born1list = Table[0 allT, {nSB}]; (* initialize as zero matrices *)
  Do[
    (* born1_k = T_{nSB}...T_{k+1} . D_k . T_{k-1}...T_1 *)
    mat = DSBlist[[k]];
    (* Right: multiply by T_{k-1}...T_1 *)
    Do[mat = mat . TSBlist[[j]], {j, k - 1, 1, -1}];
    (* Left: multiply by T_{k+1}...T_{nSB} *)
    Do[mat = TSBlist[[j]] . mat, {j, k + 1, nSB}];
    born1list[[k]] = mat,
    {k, 1, nSB}];
  born1 = Total[born1list];

  d2actual = t2ref - M2;

  (* Check accuracy *)
  Print["Row-by-row Born1 accuracy:"];
  Do[
    d = dd; j = A2 + 2 + d;
    If[j >= Length[d2actual], Break[]];
    actual = d2actual[[j + 1]];
    bornRow = born1[[j + 1]];
    maxAct = Max[Abs[actual]];
    maxErr = Max[Abs[actual - bornRow]];
    If[maxAct == 0,
      Print["d=", d, " (row ", j, "): zero"],
      If[maxErr === 0,
        Print["d=", d, " (row ", j, "): EXACT"],
        Print["d=", d, " (row ", j, "): err/act = ",
          N[maxErr/maxAct, 4]]]],
    {dd, 0, Min[2 q1 + 2, q2 - 3]}];
  Print[""];

  (* === Full Born expansion (if a2 is small enough) === *)
  If[a2 <= 6,
    Print["===== FULL BORN (a2=", a2, ", max order ", a2, ") ====="];
    (* Compute by expanding the product directly *)
    (* M2 = prod (T_i - D_i) = sum over subsets S of (-1)^|S| prod_{i in S} D_i prod_{i not in S} T_i *)
    (* More efficient: compute iteratively *)
    (* Start from the right: accumulated = I *)
    (* At each step k (from 1 to a2): *)
    (*   new_accT = T_k . old_accT  (Toeplitz path) *)
    (*   new_accD = T_k . old_accD - D_k . old_accT (correction) *)
    (* Then M2 = allT - totalD where totalD accumulates all correction terms *)

    (* Actually let's just compute allT - M2 and check it equals born1 - born2 + ... *)
    totalCorr = allT - M2;
    bornErr = totalCorr - born1;
    bornErrRows = Select[Range[Length[bornErr]],
      bornErr[[#]] =!= Table[0, initDim] &] - 1;
    Print["Born1 error (= higher orders) nonzero at rows: ",
      If[Length[bornErrRows] > 10,
        Join[bornErrRows[[1 ;; 5]], {"...", Last[bornErrRows]}],
        bornErrRows]];

    (* Check: does adding born2 fix it? *)
    born2 = 0 allT;
    Do[
      mat = DSBlist[[k2]] . DSBlist[[k1]];
      Do[mat = mat . TSBlist[[j]], {j, k1 - 1, 1, -1}];
      (* Insert T between k1 and k2 *)
      Do[mat = TSBlist[[j]] . mat, {j, k1 + 1, k2 - 1}];
      Do[mat = TSBlist[[j]] . mat, {j, k2 + 1, nSB}];
      born2 += mat,
      {k1, 1, nSB - 1}, {k2, k1 + 1, nSB}];
    (* Hmm, this double-counts. Let me use the proper sandwich formula. *)
    (* Actually, born2_{k1,k2} = T_nSB...T_{k2+1} . D_{k2} . T_{k2-1}...T_{k1+1} . D_{k1} . T_{k1-1}...T_1 *)

    born2 = 0 allT;
    Do[
      mat = DSBlist[[k1]];
      (* Right of k1: multiply by T_{k1-1}...T_1 *)
      Do[mat = mat . TSBlist[[j]], {j, k1 - 1, 1, -1}];
      (* Between k1 and k2: multiply by T_{k1+1}...T_{k2-1} *)
      Do[mat = TSBlist[[j]] . mat, {j, k1 + 1, k2 - 1}];
      (* D_{k2} *)
      mat = DSBlist[[k2]] . mat;
      (* Left of k2: multiply by T_{k2+1}...T_nSB *)
      Do[mat = TSBlist[[j]] . mat, {j, k2 + 1, nSB}];
      born2 += mat,
      {k1, 1, nSB - 1}, {k2, k1 + 1, nSB}];

    bornErr2 = totalCorr - born1 + born2;
    bornErr2Rows = Select[Range[Length[bornErr2]],
      bornErr2[[#]] =!= Table[0, initDim] &] - 1;
    Print["After born2: residual nonzero at rows: ",
      If[Length[bornErr2Rows] > 10,
        Join[bornErr2Rows[[1 ;; 5]], {"...", Last[bornErr2Rows]}],
        bornErr2Rows]];

    If[a2 <= 4,
      (* Also compute born3 and born4 *)
      born3 = 0 allT;
      Do[
        mat = DSBlist[[k1]];
        Do[mat = mat . TSBlist[[j]], {j, k1 - 1, 1, -1}];
        Do[mat = TSBlist[[j]] . mat, {j, k1 + 1, k2 - 1}];
        mat = DSBlist[[k2]] . mat;
        Do[mat = TSBlist[[j]] . mat, {j, k2 + 1, k3 - 1}];
        mat = DSBlist[[k3]] . mat;
        Do[mat = TSBlist[[j]] . mat, {j, k3 + 1, nSB}];
        born3 += mat,
        {k1, 1, nSB - 2}, {k2, k1 + 1, nSB - 1}, {k3, k2 + 1, nSB}];

      born4 = 0 allT;
      If[a2 >= 4,
        Do[
          mat = DSBlist[[k1]];
          Do[mat = mat . TSBlist[[j]], {j, k1 - 1, 1, -1}];
          Do[mat = TSBlist[[j]] . mat, {j, k1 + 1, k2 - 1}];
          mat = DSBlist[[k2]] . mat;
          Do[mat = TSBlist[[j]] . mat, {j, k2 + 1, k3 - 1}];
          mat = DSBlist[[k3]] . mat;
          Do[mat = TSBlist[[j]] . mat, {j, k3 + 1, k4 - 1}];
          mat = DSBlist[[k4]] . mat;
          Do[mat = TSBlist[[j]] . mat, {j, k4 + 1, nSB}];
          born4 += mat,
          {k1, 1, nSB - 3}, {k2, k1 + 1, nSB - 2},
          {k3, k2 + 1, nSB - 1}, {k4, k3 + 1, nSB}]];

      fullBorn = born1 - born2 + born3 - born4;
      Print["Full Born (orders 1-4) == total correction? ",
        fullBorn === totalCorr];
    ];
    Print[""];
  ];

  Print[""];
]

(* === RUN VERIFICATIONS === *)

(* sqrt(5) — reference case *)
verifyBorn[Sqrt[5], "sqrt(5)"];

(* sqrt(2) *)
verifyBorn[Sqrt[2], "sqrt(2)"];

(* Pi — big a2 = 15 *)
verifyBorn[Pi, "Pi"];

(* Im[ZetaZero[1]] *)
verifyBorn[N[Im[ZetaZero[1]], 50], "Im[ZetaZero[1]]"];

Print["===== ALL DONE ====="];
