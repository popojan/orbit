(* Transfer matrix — step by step, no batching errors *)
(* At each x: if same height -> v = L_m . v *)
(*            if rise       -> v = L_{m+1} . Append[v, 0] *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

B[n_, q_] := If[q == 0, 1, Binomial[n + q - 1, q]/n]

(* Step-by-step transfer *)
dpTransferAll[alpha_, nMax_] := Module[
  {v = {1}, m = 0, results = {{1, 0, 1}}, prevS = 0, curS},
  Do[
    curS = Floor[x/alpha];
    If[curS == prevS,
      (* Same stair: multiply by L_m *)
      v = Lmat[m] . v,
      (* Rise: extend and multiply by L_{m+1} *)
      v = Lmat[m + 1] . Append[v, 0];
      m++;
    ];
    AppendTo[results, {x, m, Last[v]}];
    prevS = curS,
    {x, 2, nMax}];
  results
]

(* Direct DP for comparison *)
dpDirect[alpha_, nMax_] := Module[{S, dp},
  S = Table[Floor[x/alpha], {x, 1, nMax}];
  dp = Table[0, {nMax}, {Max[S] + 2}];
  dp[[1, 1]] = 1;
  Do[Do[
    If[y <= S[[xx]],
      dp[[xx, y + 1]] =
        If[xx == 1 && y == 0, 1, 0] +
        If[xx > 1 && y <= S[[xx - 1]], dp[[xx - 1, y + 1]], 0] +
        If[y > 0 && y - 1 <= S[[xx]], dp[[xx, y]], 0]],
    {y, 0, S[[xx]]}], {xx, 1, nMax}];
  Table[{x, S[[x]], dp[[x, S[[x]] + 1]]}, {x, 1, nMax}]
]

(* === Verify Pi === *)
nMax = 50;
tmData = dpTransferAll[Pi, nMax];
dirData = dpDirect[Pi, nMax];

Print["=== Alpha = Pi: Transfer matrix vs Direct DP ==="];
allOK = True;
Do[
  If[tmData[[x]] =!= dirData[[x]],
    Print["MISMATCH at x=", x, ": TM=", tmData[[x, 3]], " Direct=", dirData[[x, 3]]];
    allOK = False],
  {x, 1, nMax}];
If[allOK, Print["ALL MATCH for x=1..", nMax]];

(* === Now the interesting part: show state vectors at convergent positions === *)
Print[""];
Print["=== State vectors at convergent/semi-convergent positions ==="];

v = {1}; m = 0; prevS = 0;
Do[
  curS = Floor[x/Pi];
  If[curS == prevS,
    v = Lmat[m] . v,
    v = Lmat[m + 1] . Append[v, 0]; m++];
  prevS = curS;
  (* Print at CF positions and ballot hits *)
  If[MemberQ[{3, 7, 10, 13, 16, 19, 22, 25, 47}, x],
    Print["x=", x, " S=", m, " DP=", Last[v],
      " B(x,S)=", B[x, m],
      If[Last[v] == B[x, m], " DIRECT",
        If[Last[v] == B[x, m + 1], " SHADOW", ""]],
      " v=", v]
  ],
  {x, 2, 50}];

(* === Batched version with L^(w-1) for efficiency === *)
Print[""];
Print["=== Batched transfer: stair by stair ==="];

v = {1}; m = 0; x = 1;
stairWidths = {};
curWidth = 1;
Do[
  If[Floor[xx/Pi] == Floor[(xx - 1)/Pi],
    curWidth++,
    AppendTo[stairWidths, curWidth]; curWidth = 1],
  {xx, 2, 50}];
AppendTo[stairWidths, curWidth];
Print["Stair widths: ", stairWidths];

v = {1}; m = 0; x = 1;
Do[
  (* Within stair: L^(w-1) *)
  If[w > 1, v = MatrixPower[Lmat[m], w - 1] . v];
  Print["End of stair S=", m, " width=", w, " at x=", x + w - 1,
    " DP=", Last[v], " v=", v];
  x += w;
  (* Rise *)
  If[k < Length[stairWidths],
    v = Lmat[m + 1] . Append[v, 0]; m++],
  {k, 1, Min[Length[stairWidths], 10]},
  {w, {stairWidths[[k]]}}];
