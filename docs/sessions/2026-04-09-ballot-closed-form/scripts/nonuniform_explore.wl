(* Explore the non-uniform case: mixed stair widths between higher convergents *)
(* For Pi = [3; 7, 15, 1, 292, ...]:                                          *)
(*   Between p1=22 and p2=333: stair widths alternate 3 and 4 (Sturmian)     *)

Needs["Orbit`"];

(* Transfer matrix *)
Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

(* Ballot number *)
B[n_, k_] := If[k == 0, 1, Binomial[n + k - 1, k]/n]

(* Step-by-step transfer with full state vector tracking *)
dpTransferDetailed[alpha_, xMax_] := Module[
  {v = {1}, m = 0, prevS = 0, curS, results = {{1, 0, {1}}}},
  Do[
    curS = Floor[x/alpha];
    If[curS == prevS,
      v = Lmat[m] . v,
      v = Lmat[m + 1] . Append[v, 0]; m++];
    prevS = curS;
    AppendTo[results, {x, m, v}],
    {x, 2, xMax}];
  results
]

(* === Stair widths for Pi between convergents === *)
Print["=== Stair widths for Pi (first 120 columns) ==="];
stairWidths = {};
curWidth = 1;
Do[
  If[Floor[x/Pi] == Floor[(x - 1)/Pi],
    curWidth++,
    AppendTo[stairWidths, curWidth]; curWidth = 1],
  {x, 2, 120}];
AppendTo[stairWidths, curWidth];
Print["Widths: ", stairWidths];
Print["Distinct: ", Union[stairWidths]];
Print[""];

(* === Semi-convergents of Pi: between p1=22 and p2=333 === *)
(* CF of Pi = [3; 7, 15, 1, 292, ...] *)
(* p0=3, q0=1; p1=22, q1=7 *)
(* Semi-conv between p1 and p2: (p0 + j*p1)/(q0 + j*q1) for j=1..14 *)
semiConv2 = Table[{3 + 22 j, 1 + 7 j}, {j, 1, 14}];
Print["Semi-convergents between p1=22 and p2=333:"];
Do[Print["  ", sc[[1]], "/", sc[[2]], " = ", N[sc[[1]]/sc[[2]], 10]], {sc, semiConv2}];
Print["  p2 = 333/106"];
Print[""];

(* === Compute DP at semi-convergent positions === *)
Print["=== DP at semi-convergent positions (via BeattyBallotCount) ==="];
Print[""];
allPositions = Join[{{22, 7}}, semiConv2, {{333, 106}}];
Do[
  {p, q} = pq;
  dp = BeattyBallotCount[Pi, p];
  ballot = B[p, q];
  isShadow = (p/q < Pi);
  qActual = Floor[p/Pi];
  Print["p=", p, " q=", q,
    " S(p)=", qActual,
    " DP=", dp,
    " B(p,q)=", ballot,
    If[dp === ballot, "  MATCH", "  ..."],
    If[isShadow, " (shadow)", " (direct)"]],
  {pq, allPositions}];
Print[""];

(* === State vectors at semi-convergent positions === *)
Print["=== State vectors at first few semi-convergent positions ==="];
data = dpTransferDetailed[Pi, 70];
targetX = {22, 25, 47, 69};
Do[
  entry = Select[data, #[[1]] == x &][[1]];
  {xx, mm, vv} = entry;
  Print["x=", xx, " m=", mm, " |v|=", Length[vv],
    " DP=", Last[vv],
    " last5=", Take[vv, -Min[5, Length[vv]]]],
  {x, targetX}];
Print[""];

(* === Analyze stair structure between semi-convergents of 2nd level === *)
Print["=== Stair widths between consecutive semi-convergent positions ==="];
(* Between p1=22 and first semi-conv at p=25: 3 columns *)
(* Between 25 and 47: 22 columns, 7 rises *)
(* Between 47 and 69: 22 columns, 7 rises *)
Do[
  {pStart, pEnd} = {allPositions[[idx, 1]], allPositions[[idx + 1, 1]]};
  widths = {};
  curW = 0;
  Do[
    If[Floor[x/Pi] == Floor[(x - 1)/Pi],
      curW++,
      If[curW > 0, AppendTo[widths, curW]]; curW = 1],
    {x, pStart + 1, pEnd}];
  If[curW > 0, AppendTo[widths, curW]];
  qStart = allPositions[[idx, 2]];
  qEnd = allPositions[[idx + 1, 2]];
  Print["[", pStart, "..", pEnd, "] (", pEnd - pStart, " cols, ",
    qEnd - qStart, " rises): widths=", widths],
  {idx, 1, Min[6, Length[allPositions] - 1]}];
Print[""];

(* === Key test: within each 22-column block, is the pattern the same? === *)
Print["=== Pattern within 22-column blocks ==="];
Do[
  pStart = 22 + 22 (blk - 1) + 3; (* adjust: first block starts at 25 *)
  If[blk == 1, pStart = 23]; (* actually, let's trace from 23 *)
  pStart = 22 + (blk - 1) * 22 + If[blk == 1, 1, 1];
  (* Let me just trace stair widths in each 22-col block *)
  blockStart = 22 + (blk - 1) * 22 + 1; (* x = 23, 45, 67, ... *)
  If[blk >= 2, blockStart = 22 + 3 + (blk - 2) * 22 + 1]; (* 26, 48, 70, ... *)
  0, (* placeholder *)
  {blk, 1, 3}];

(* Simpler approach: just show all stair widths from x=22 to x=90 *)
Print["Stair widths from x=22 to x=90:"];
widthSeq = {};
prevS = Floor[22/Pi];
Do[
  curS = Floor[x/Pi];
  If[curS > prevS,
    AppendTo[widthSeq, {x, curS - prevS, curS}]]; (* rise at x, by how much, to height *)
  prevS = curS,
  {x, 23, 90}];
risePositions = widthSeq[[All, 1]];
Print["Rise positions: ", risePositions];
Print["Gaps between rises: ", Differences[risePositions]];
Print["Heights at rises: ", widthSeq[[All, 3]]];
