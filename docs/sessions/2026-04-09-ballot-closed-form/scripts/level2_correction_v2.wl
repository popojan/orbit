(* LEVEL-2 CORRECTION v2: use actual staircase, not Sturmian word *)
(* Fix: compute stair widths from the actual staircase *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]
vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]

(* Build transfer matrix by processing actual staircase column by column *)
blockTransferActual[initDim_, alpha_, xStart_, xEnd_] := Module[
  {mat = IdentityMatrix[initDim], m = initDim - 1,
   prevS = Floor[xStart/alpha], curS},
  Do[
    curS = Floor[x/alpha];
    If[curS == prevS,
      mat = Lmat[m] . mat,
      mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++];
    prevS = curS,
    {x, xStart + 1, xEnd}];
  mat
]

(* Also build from pattern (for comparison) *)
blockTransfer[d_, pattern_] := Module[{m = d - 1, mat = IdentityMatrix[d]},
  Do[
    mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}];
    m++;
    If[w > 1, mat = MatrixPower[Lmat[m], w - 1] . mat],
    {w, pattern}];
  mat
]

pathsRat[pp_, qq_, jj_] := Module[{S, dp},
  If[jj == 0, Return[1]]; If[jj < 0, Return[0]];
  S = Table[Min[Floor[qq x/pp], jj], {x, 1, pp}];
  If[jj > S[[pp]], Return[0]];
  dp = Table[0, {pp}, {jj + 1}];
  Do[Do[If[y <= S[[x]],
    dp[[x, y + 1]] = If[x == 1 && y == 0, 1, 0] +
      If[x > 1 && y <= S[[x - 1]], dp[[x - 1, y + 1]], 0] +
      If[y > 0, dp[[x, y]], 0]],
    {y, 0, Min[jj, S[[x]]]}], {x, 1, pp}];
  dp[[pp, jj + 1]]
]

alpha = Sqrt[5];
ww = 2; a1 = 4; a2 = 4;
p0 = 2; q0 = 1; p1 = 9; q1 = 4; p2 = 38; q2 = 17;

(* === STEP 0: Actual stair widths === *)
Print["=== Actual stair widths from Floor[x/sqrt(5)] ==="];
Print["Between 11 and 20 (level-1 block):"];
prevS = Floor[11/alpha];
widths1 = {};
Do[curS = Floor[x/alpha];
  If[curS > prevS,
    If[widths1 === {}, AppendTo[widths1, x - 11],
      AppendTo[widths1, x - Last[Accumulate[widths1]] - 11]]];
  prevS = curS, {x, 12, 20}];
(* Better: compute from rise positions *)
rises1 = {}; prevS = Floor[11/alpha];
Do[curS = Floor[x/alpha]; If[curS > prevS, AppendTo[rises1, x]]; prevS = curS, {x, 12, 20}];
widths1actual = Differences[Prepend[rises1, 11]];
widthsAfterLastRise = 20 - Last[rises1] + 1;
(* blockTransfer width = rise-to-rise gap, last entry = to end of block *)
Print["Rise positions: ", rises1];
Print["Widths (rise-to-rise): ", Differences[rises1]];
Print["Pre-rise columns: ", First[rises1] - 11 - 1];
Print["Post-last-rise: ", 20 - Last[rises1]];
Print[""];

(* === STEP 1: Level-1 block transfer (actual staircase) === *)
Print["=== Level-1: Actual transfer from v(11) to v(20) ==="];
M1actual = blockTransferActual[5, alpha, 11, 20];
Print["M1actual dims: ", Dimensions[M1actual]];

(* DP verification *)
v11 = Table[vLin[11, ww, j], {j, 0, 4}];
v20dp = Table[pathsRat[20, 9, j], {j, 0, 8}];
Print["M1actual . v(11) = v(20)? ", M1actual . v11 === v20dp];

(* Toeplitz decomposition *)
T1 = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, 8}, {s, 0, 4}];
D1 = T1 - M1actual;
Print["Delta1 nonzero rows:"];
Do[If[D1[[j + 1]] =!= Table[0, 5],
  Print["  j=", j, ": ", D1[[j + 1]]]], {j, 0, 8}];
Print[""];

(* === Compare with pattern-based blockTransfer === *)
Print["=== Pattern-based vs actual ==="];
M1pattern = blockTransfer[5, {2, 2, 2, 3}]; (* anomalous LAST *)
M1sturmian = blockTransfer[5, {3, 2, 2, 2}]; (* Sturmian word *)
Print["Pattern {2,2,2,3} matches actual? ", M1pattern === M1actual];
Print["Sturmian {3,2,2,2} matches actual? ", M1sturmian === M1actual];
Print[""];

(* === STEP 2: Level-2 actual block transfer === *)
Print["=== Level-2: Actual transfer from v(47) to v(85) ==="];
M2actual = blockTransferActual[22, alpha, 47, 85];
Print["M2actual dims: ", Dimensions[M2actual]];

(* DP verification *)
v47 = Table[pathsRat[47, 21, j], {j, 0, 21}];
v85dp = Table[pathsRat[85, 38, j], {j, 0, 38}];
v85formula = M2actual . v47;
Print["M2actual . v(47) = v(85)? ", v85formula === v85dp];
Print[""];

(* === STEP 3: Toeplitz + correction decomposition === *)
Print["=== Level-2 Toeplitz + Correction ==="];
{nrows2, ncols2} = Dimensions[M2actual];
T2 = Table[Binomial[p2 - 1 + j - s, j - s], {j, 0, nrows2 - 1}, {s, 0, ncols2 - 1}];
D2 = T2 - M2actual;

corrRows = {};
Do[If[D2[[j + 1]] =!= Table[0, ncols2], AppendTo[corrRows, j]],
  {j, 0, nrows2 - 1}];
Print["Correction rows: ", corrRows];
Print["Count: ", Length[corrRows], " (expected q2-1 = ", q2 - 1, ")"];
If[corrRows =!= {},
  Print["First: j=", First[corrRows], " (expected q2+2 = ", q2 + 2, ")"]];
Print[""];

(* Show correction values *)
Print["=== Delta2 values ==="];
Do[
  j = corrRows[[i]];
  d = j - First[corrRows];
  Print["j=", j, " d=", d, ": ", D2[[j + 1]]],
  {i, 1, Min[5, Length[corrRows]]}];
If[Length[corrRows] > 5, Print["..."]];
Print[""];

(* === STEP 4: d=0 row analysis === *)
Print["=== d=0 row: single binomial? ==="];
If[corrRows =!= {},
  d0row = D2[[First[corrRows] + 1]];
  Print["d=0: ", d0row];
  found = False;
  Do[
    test = Table[Binomial[a - s, b], {s, 0, ncols2 - 1}];
    If[test === d0row,
      Print["MATCH: C(", a, "-s, ", b, ")"];
      found = True; Break[]],
    {b, 1, 30}, {a, b + ncols2 - 1, 80}];
  If[!found, Print["No simple C(A-s, B) found"]]
];
Print[""];

(* === STEP 5: Binomial basis decomposition for all rows === *)
Print["=== Binomial basis decomposition ==="];
Print["Level-1 formula: Delta1[a1+2+d,s] = sum_m c*C(a1+m(w+1)-s, mw-1)"];
Print["  Basis: C(", a1, "+m*", ww + 1, "-s, m*", ww, "-1) = C(", a1, "+3m-s, 2m-1)"];
Print[""];

(* At level 2: try basis C(A1+m*A2-s, m*B2-1) for unknown A1, A2, B2 *)
(* From d=0: C(X-s, Y) tells us A1+A2 = X, B2 = Y+1 *)

If[corrRows =!= {} && Length[corrRows] >= 2,
  d0row = D2[[First[corrRows] + 1]];

  (* Find the d=0 binomial parameters *)
  d0A = -1; d0B = -1;
  Do[
    test = Table[Binomial[a - s, b], {s, 0, ncols2 - 1}];
    If[test === d0row, d0A = a; d0B = b; Break[]],
    {b, 1, 30}, {a, b + ncols2 - 1, 80}];

  If[d0A > 0,
    Print["d=0: C(", d0A, "-s, ", d0B, ")"];
    Print["  => A1 + A2 = ", d0A, ", B2 = ", d0B + 1];
    Print[""];

    (* Try decomposition: Delta2[j0+d, s] = sum_{m=1}^{d+1} c_m * C(A1+m*A2-s, m*B2-1) *)
    (* For d=0: just c_1 * C(A1+A2-s, B2-1) = C(d0A-s, d0B) => c_1 = 1 *)
    (* For d=1: c_1 * C(A1+A2-s, B2-1) + c_2 * C(A1+2*A2-s, 2*B2-1) = d1row *)

    (* We need to determine A1, A2, B2 individually *)
    (* Test candidates for A2 *)
    Print["Testing A2, B2 candidates from d=1 row:"];
    d1row = D2[[corrRows[[2]] + 1]];

    Do[
      a2cand = a2c;
      a1cand = d0A - a2cand;
      b2cand = d0B + 1;
      (* For d=1: c_1 * C(a1cand+a2cand-s, b2cand-1) + c_2 * C(a1cand+2*a2cand-s, 2*b2cand-1) = d1row *)
      basis1 = Table[Binomial[a1cand + a2cand - s, b2cand - 1], {s, 0, ncols2 - 1}];
      basis2 = Table[Binomial[a1cand + 2 a2cand - s, 2 b2cand - 1], {s, 0, ncols2 - 1}];
      (* Solve for c1, c2 using two entries *)
      det = basis1[[1]] basis2[[2]] - basis1[[2]] basis2[[1]];
      If[det =!= 0,
        c1test = (d1row[[1]] basis2[[2]] - d1row[[2]] basis2[[1]]) / det;
        c2test = (basis1[[1]] d1row[[2]] - basis1[[2]] d1row[[1]]) / det;
        (* Verify all entries *)
        pred = c1test basis1 + c2test basis2;
        If[pred === d1row,
          Print["  A2=", a2cand, " B2=", b2cand, ": c1=", c1test, " c2=", c2test, " MATCH!"];

          (* Continue with d=2 to verify *)
          If[Length[corrRows] >= 3,
            d2row = D2[[corrRows[[3]] + 1]];
            basis3 = Table[Binomial[a1cand + 3 a2cand - s, 3 b2cand - 1], {s, 0, ncols2 - 1}];
            (* Solve 3x3 system for d=2 *)
            mat3 = Transpose[{basis1, basis2, basis3}];
            (* Use first 3 columns as system *)
            sys = mat3[[1 ;; 3]];
            rhs3 = d2row[[1 ;; 3]];
            sol3 = LinearSolve[sys, rhs3];
            pred3 = sol3[[1]] basis1 + sol3[[2]] basis2 + sol3[[3]] basis3;
            If[pred3 === d2row,
              Print["  d=2: c=", sol3, " MATCH!"];

              (* d=3 *)
              If[Length[corrRows] >= 4,
                d3row = D2[[corrRows[[4]] + 1]];
                basis4 = Table[Binomial[a1cand + 4 a2cand - s, 4 b2cand - 1], {s, 0, ncols2 - 1}];
                sys4 = Transpose[{basis1, basis2, basis3, basis4}][[1 ;; 4]];
                rhs4 = d3row[[1 ;; 4]];
                sol4 = LinearSolve[sys4, rhs4];
                pred4 = sol4[[1]] basis1 + sol4[[2]] basis2 + sol4[[3]] basis3 + sol4[[4]] basis4;
                If[pred4 === d3row,
                  Print["  d=3: c=", sol4, " MATCH!"],
                  Print["  d=3: MISMATCH"]
                ]
              ],
              Print["  d=2: c=", sol3, " MISMATCH (residual)"]
            ]
          ]
        ]
      ],
      {a2c, 1, d0A - 1}]
  ]
];
Print[""];

(* === STEP 6: Also try PURE M2 (init dim = q2+1 = 18) === *)
Print["=== Pure M2 (init dim 18) with actual staircase ==="];
(* Build rational staircase transfer for p2/q2 = 38/17 starting from dim 18 *)
(* Use the rational staircase directly *)
blockTransferRat[initDim_, pp_, qq_] := Module[
  {mat = IdentityMatrix[initDim], m = initDim - 1,
   prevS = initDim - 1, curS},
  (* Process columns 1..pp, staircase = Floor[qq*x/pp] *)
  Do[
    curS = Min[Floor[qq x/pp], m + 1]; (* cap at current height + 1 *)
    If[curS > prevS,
      mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}]; m++];
    (* Within-stair *)
    If[curS == prevS,
      mat = Lmat[m] . mat];
    prevS = curS,
    {x, 1, pp}];
  mat
]

(* Actually, for the pure case, just use blockTransferActual with rational alpha *)
(* The staircase Floor[x/(p/q)] = Floor[q*x/p] *)
(* But we need a starting position where height = q2 *)
(* Position where height = q2: x = p2 = 38 (since Floor[q2*38/p2] = Floor[17] = 17) *)
(* Wait, for rational p/q, the staircase Floor[x*q/p] at x=p gives exactly q *)
(* So we want to compute from x=p2 to x=2*p2, starting at height q2 *)

(* Let me use a cleaner approach: for the PURE block, just compute blockTransfer *)
(* with the CORRECT stair pattern *)

(* Compute actual stair widths for rational staircase p/q starting from height q *)
(* Rise positions: ceil(p*(q+k)/q) for k=1,...,q *)
actualPattern[pp_, qq_] := Module[{rises, widths},
  rises = Table[Ceiling[pp k/qq], {k, 1, qq}];
  widths = Differences[Prepend[rises, 0]];
  widths
]

(* This gives widths starting from height 0. For starting from height q, *)
(* the pattern is the SAME (by periodicity of Sturmian word modulo shifts) *)
(* But actually, for the block transfer between semi-convergent positions, *)
(* the pattern might be a cyclic shift *)

(* Let me just directly compute: for the pure 38/17 block starting from dim 18, *)
(* what pattern gives the right answer? *)

Print["Sturmian pattern for 38/17: "];
sturmPattern = actualPattern[p2, q2];
Print[sturmPattern];

(* Build pure M2 with anomalous-LAST pattern *)
(* For 38/17 = [2; 4, 4]: the pattern should group as *)
(* {2,2,2,3, 2,2,2,3, 2,2,2,3, 2,2,2,2,3} (anomalous last in each sub-block) *)
patternAnomLast = Flatten[{Table[{ww, ww, ww, ww + 1}, {a2 - 1}],
  {Table[ww, q1 + q0 - 1], {ww + 1}}}];
Print["Anomalous-last pattern: ", patternAnomLast];

M2pure1 = blockTransfer[q2 + 1, sturmPattern];
M2pure2 = blockTransfer[q2 + 1, patternAnomLast];
Print["Sturmian M2 == anomLast M2? ", M2pure1 === M2pure2];

(* Verify each against some test *)
(* For the pure case starting from dim 18, the Toeplitz decomposition should be the same *)
T2p = Table[Binomial[p2 - 1 + j - s, j - s], {j, 0, 2 q2}, {s, 0, q2}];
D2p1 = T2p - M2pure1;
D2p2 = T2p - M2pure2;

corrP1 = Select[Range[0, 2 q2], D2p1[[# + 1]] =!= Table[0, q2 + 1] &];
corrP2 = Select[Range[0, 2 q2], D2p2[[# + 1]] =!= Table[0, q2 + 1] &];
Print["Sturmian corrections start at: ", If[corrP1 =!= {}, First[corrP1], "none"]];
Print["AnomLast corrections start at: ", If[corrP2 =!= {}, First[corrP2], "none"]];
Print[""];

(* === STEP 7: The ACTUAL transfer between semi-convergent positions === *)
Print["=== Actual stair widths between positions 47 and 85 ==="];
rises47to85 = {};
prevS = Floor[47/alpha];
Do[curS = Floor[x/alpha];
  If[curS > prevS, AppendTo[rises47to85, x]];
  prevS = curS, {x, 48, 85}];
Print["Rise positions: ", rises47to85];
preRise = First[rises47to85] - 48;
Print["Pre-rise columns: ", preRise];
Print["Stair widths (from rises): ", Differences[rises47to85]];
Print["Last stair to end: ", 85 - Last[rises47to85]];
Print[""];

(* The actual block: preRise within-stair columns, then rises with widths *)
(* In terms of stair operations: *)
(* 1. L_m^preRise (within current stair) *)
(* 2. For each rise: extend + L_{m+1}, then L_m^{width-1} *)

(* For the formula, what matters is the RATIONAL staircase at positions 47 and 85 *)
(* Floor Agreement: Floor[x/alpha] = Floor[q*x/p] for semi-convergent p/q *)
(* At position 47: q47 = 21, p47 = 47. Check: Floor[21*47/47] = 21 *)
(* So the staircase from 47 to 85 is Floor[21*x/47]... no, that's for position 47 *)

(* Actually: Floor Agreement at position 85 uses p=85, q=38 *)
(* Floor[x/alpha] = Floor[38*x/85] for x=1..85 *)
(* The transfer from v(47) to v(85) uses Floor[38*x/85] for x=48..85 *)

(* Let me verify: *)
Print["Floor Agreement test at x=85:"];
Do[
  fAlpha = Floor[x/alpha];
  fRat = Floor[38 x/85];
  If[fAlpha =!= fRat, Print["MISMATCH at x=", x, ": ", fAlpha, " vs ", fRat]],
  {x, 1, 85}];
Print["Floor Agreement verified for all x=1..85"];
Print[""];

(* So the ACTUAL transfer uses rational staircase 38/85 *)
(* But 85/38 is NOT in lowest terms: gcd(85,38)=1 (85=2*38+9, 38=4*9+2, 9=4*2+1) *)
(* So 85/38 is irreducible. *)
(* The transfer from v(47) to v(85) is computed via Floor[38x/85] *)

(* But the block transfer formula uses p2=38 as the "block width" *)
(* The actual processing is: from x=47 (height 21) to x=85 (height 38) *)
(* = 38 columns, 17 rises *)

Print["=== Direct computation via rational staircase ==="];
(* Build the transfer by processing Floor[38x/85] column by column from x=48 to x=85 *)
M2direct = blockTransferActual[22, 85/38, 47, 85];
Print["M2direct dims: ", Dimensions[M2direct]];
Print["M2direct . v(47) = v(85)? ", M2direct . v47 === v85dp];
Print[""];

(* Toeplitz decomposition of the CORRECT M2 *)
T2d = Table[Binomial[p2 - 1 + j - s, j - s], {j, 0, 38}, {s, 0, 21}];
D2d = T2d - M2direct;
corrDirect = Select[Range[0, 38], D2d[[# + 1]] =!= Table[0, 22] &];
Print["Correct M2 correction rows: ", corrDirect];
Print["Count: ", Length[corrDirect]];
If[corrDirect =!= {},
  Print["First: j=", First[corrDirect]];
  d0 = D2d[[First[corrDirect] + 1]];
  Print["d=0 row: ", d0];

  (* Is it a single binomial? *)
  found = False;
  Do[
    test = Table[Binomial[a - s, b], {s, 0, 21}];
    If[test === d0, Print["d=0 = C(", a, "-s, ", b, ")"];
      found = True; Break[]],
    {b, 1, 30}, {a, b + 21, 80}];
  If[!found,
    (* Try scalar multiple of binomial *)
    Do[
      test = Table[Binomial[a - s, b], {s, 0, 21}];
      If[test[[1]] =!= 0,
        ratio = d0[[1]] / test[[1]];
        If[IntegerQ[ratio] && ratio test === d0,
          Print["d=0 = ", ratio, " * C(", a, "-s, ", b, ")"];
          found = True; Break[]]],
      {b, 1, 30}, {a, b + 21, 80}];
    If[!found, Print["d=0: no binomial fit found"]]
  ]
];
Print[""];

(* Show all correction rows *)
Print["=== All correction rows of correct M2 ==="];
Do[
  j = corrDirect[[i]];
  d = j - First[corrDirect];
  Print["j=", j, " d=", d, ": ", D2d[[j + 1]]],
  {i, 1, Min[8, Length[corrDirect]]}];
