(* Transfer matrix verification for DP between convergents *)
(* L_m = (m+1)x(m+1) lower triangular all-ones matrix *)
(* Within stair: v(a+j) = L^j . v(a) *)
(* At rise: extend vector by one entry (copy of top) then apply L *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

(* Transfer through one complete stair of width w at height m *)
(* Input: vector v of length m+1 *)
(* Output: vector after w steps, still length m+1 *)
stairTransfer[v_, w_, m_] := MatrixPower[Lmat[m], w] . v

(* Rise operation: apply one L step in the new (m+2)-dimensional space *)
(* Input: vector v of length m+1 (end of stair at height m) *)
(* Output: vector of length m+2 (start of next stair at height m+1) *)
riseTransfer[v_] := With[{m = Length[v] - 1},
  Lmat[m + 1] . Append[v, 0]
]

(* Full DP computation via transfer matrices *)
(* stairWidths = list of stair widths {w0, w1, w2, ...} *)
dpViaTransfer[stairWidths_List] := Module[
  {v, results = {}, m = 0, x = 1},
  v = {1}; (* start: dp(1,0) = 1, height 0 *)

  Do[
    (* Within this stair: compute DP at each position *)
    Do[
      With[{vj = MatrixPower[Lmat[m], j] . v},
        AppendTo[results, {x + j, m, Last[vj]}]
      ],
      {j, 0, w - 1}];
    (* Transfer to end of stair *)
    v = stairTransfer[v, w, m];
    x += w;
    (* Rise to next height *)
    v = riseTransfer[v];
    m++;,
    {w, stairWidths}];
  (* First position of next stair *)
  AppendTo[results, {x, m, Last[v]}];
  results
]

(* === Test: alpha = Pi, stairs from x=1 to x=25 === *)
(* Pi = [3; 7, 15, ...] *)
(* Between p0=3 and p1=22: seven stairs of width 3 *)
(* Then stair at S=7 has width 4 (until semi-convergent 25) *)

Print["=== Alpha = Pi: transfer matrix vs DP ==="];
Print[""];

(* Stair widths: 7 stairs of width 3, then one of width 4 *)
widths = Join[Table[3, 7], {4}];
Print["Stair widths: ", widths];
Print[""];

tmResults = dpViaTransfer[widths];

(* Compare with direct DP *)
Print["x | S(x) | Transfer matrix | Direct DP | Match?"];
Print[StringJoin[Table["-", 55]]];

directDP = Table[
  {x, Floor[x/Pi]},
  {x, 1, 26}];

Do[
  With[{x = r[[1]], m = r[[2]], dpTM = r[[3]]},
    With[{dpDirect = If[x <= 26,
      (* quick direct computation *)
      Module[{S, dp},
        S = Table[Floor[xx/Pi], {xx, 1, x}];
        dp = Table[0, {x}, {Max[S] + 2}];
        dp[[1, 1]] = 1;
        Do[Do[
          If[y <= S[[xx]],
            dp[[xx, y + 1]] =
              If[xx == 1 && y == 0, 1, 0] +
              If[xx > 1 && y <= S[[xx - 1]], dp[[xx - 1, y + 1]], 0] +
              If[y > 0 && y - 1 <= S[[xx]], dp[[xx, y]], 0]],
          {y, 0, S[[xx]]}], {xx, 1, x}];
        dp[[x, S[[x]] + 1]]
      ], "?"]},
      Print[x, " | ", m, " | ", dpTM, " | ", dpDirect, " | ",
        If[dpTM === dpDirect, "OK", "MISMATCH"]]
    ]
  ],
  {r, tmResults}];

(* Show the transfer matrices *)
Print[""];
Print["=== Transfer matrices at each stair ==="];
Do[
  Print["L_", m, "^3 = ", MatrixForm[MatrixPower[Lmat[m], 3]]],
  {m, 0, 3}];

(* Show intermediate vectors *)
Print[""];
Print["=== State vectors at stair boundaries ==="];
v = {1}; m = 0;
Print["Start: v = ", v, " (height ", m, ")"];
Do[
  v = stairTransfer[v, 3, m];
  Print["After stair S=", m, " (width 3): v = ", v, " -> DP = ", Last[v]];
  v = riseTransfer[v];
  m++;
  Print["After rise to S=", m, ": v = ", v],
  {7}];
(* One more stair of width 4 *)
Print[""];
v4 = stairTransfer[v, 4, m];
Print["After stair S=", m, " (width 4): v = ", v4, " -> DP = ", Last[v4]];
