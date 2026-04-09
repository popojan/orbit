(* Express Delta in the "multi-level binomial basis" *)
(* B_m(s) = C(a1 + m(w+1) - s, mw - 1) for m = 1, 2, 3, ... *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

blockTransfer[d_, pattern_] := Module[{m = d - 1, mat = IdentityMatrix[d]},
  Do[
    mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}];
    m++;
    If[w > 1, mat = MatrixPower[Lmat[m], w - 1] . mat],
    {w, pattern}];
  mat
]

(* Decompose Delta row into B_m basis *)
decompose[deltaRow_, a1_, w_, d_] := Module[
  {nTerms = d + 1, nCols = a1 + 1, mat, rhs, coeffs, bm},
  (* Build system: Delta[s] = Σ c_m B_m(s) for s=0,...,a1 *)
  mat = Table[
    Binomial[a1 + m (w + 1) - s, m w - 1],
    {s, 0, a1}, {m, 1, nTerms}];
  rhs = deltaRow;
  (* Solve least squares (should be exact) *)
  coeffs = LinearSolve[mat, rhs];
  (* Verify *)
  If[mat . coeffs === rhs, coeffs, $Failed]
]

(* === Compute for various (w, a1) === *)
Do[
  Print["===== w=", ww, " ====="];
  Do[
    M = blockTransfer[a1 + 1, Append[Table[ww, a1 - 1], ww + 1]];
    p1 = ww a1 + 1;
    dim = Dimensions[M][[1]];
    MToep = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, dim - 1}, {s, 0, a1}];
    Delta = MToep - M;

    nCorr = a1 - 1; (* number of correction rows *)
    Print["a1=", a1, ":"];
    Do[
      j = a1 + 2 + d;
      If[j + 1 <= dim,
        row = Delta[[j + 1]];
        If[row =!= Table[0, a1 + 1],
          coeffs = decompose[row, a1, ww, d];
          If[coeffs =!= $Failed,
            Print["  d=", d, " c=", coeffs],
            Print["  d=", d, " DECOMPOSITION FAILED for row ", row]
          ]
        ]
      ],
      {d, 0, nCorr - 1}];
    Print[""],
    {a1, 2, 9}],
  {ww, 1, 4}];
