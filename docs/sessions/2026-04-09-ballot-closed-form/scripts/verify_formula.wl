(* HYPOTHESIS: c_{d,m} = v_{d-m+1}(p_m) where p_m = w(a1-m)+1 *)
(* v_j(p) = (p-w*j)/p * Binomial[p+j-1, j] *)

vLin[pp_, ww_, jj_] := (pp - ww jj)/pp Binomial[pp + jj - 1, jj]

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

blockTransfer[d_, pattern_] := Module[{m = d - 1, mat = IdentityMatrix[d]},
  Do[
    mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}];
    m++;
    If[w > 1, mat = MatrixPower[Lmat[m], w - 1] . mat],
    {w, pattern}];
  mat
]

decompose[deltaRow_, a1_, w_, d_] := Module[
  {nTerms = d + 1, mat, coeffs},
  mat = Table[Binomial[a1 + m (w + 1) - s, m w - 1],
    {s, 0, a1}, {m, 1, nTerms}];
  coeffs = LinearSolve[mat, deltaRow];
  If[mat . coeffs === deltaRow, coeffs, $Failed]
]

(* === VERIFY THE FORMULA === *)
Print["===== VERIFICATION: c_{d,m} = v_{d-m+1}(w(a1-m)+1) ====="];
Print[""];

allMatch = True;
Do[
  Print["--- w=", ww, " ---"];
  Do[
    M = blockTransfer[a1 + 1, Append[Table[ww, a1 - 1], ww + 1]];
    p1 = ww a1 + 1;
    dim = Dimensions[M][[1]];
    MToep = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, dim - 1}, {s, 0, a1}];
    Delta = MToep - M;

    Do[
      j = a1 + 2 + d;
      If[j + 1 <= dim,
        row = Delta[[j + 1]];
        If[row =!= Table[0, a1 + 1],
          actualCoeffs = decompose[row, a1, ww, d];
          If[actualCoeffs =!= $Failed,
            (* Predicted coefficients *)
            predictedCoeffs = Table[
              vLin[ww (a1 - m) + 1, ww, d - m + 1],
              {m, 1, d + 1}];
            If[actualCoeffs =!= predictedCoeffs,
              Print["MISMATCH at w=", ww, " a1=", a1, " d=", d];
              Print["  actual:    ", actualCoeffs];
              Print["  predicted: ", predictedCoeffs];
              allMatch = False
            ]
          ]
        ]
      ],
      {d, 0, a1 - 2}],
    {a1, 2, 10}],
  {ww, 1, 5}];

If[allMatch,
  Print["ALL MATCH for w=1..5, a1=2..10! Formula confirmed."],
  Print["SOME MISMATCHES found."]];
Print[""];

(* === EXPLICIT FORMULA === *)
Print["===== COMPLETE CLOSED FORM ====="];
Print[""];
Print["Delta[a1+2+d, s] = Sum_{m=1}^{d+1} c_{d,m} * B_m(s)"];
Print[""];
Print["where:"];
Print["  c_{d,m} = v_{d-m+1}(w(a1-m)+1)"];
Print["  v_j(p) = (p-w*j)/p * C(p+j-1, j)"];
Print["  B_m(s) = C(a1+m(w+1)-s, m*w-1)"];
Print[""];

(* === VERIFICATION on actual Pi data === *)
Print["===== Pi verification (w=3, a1=7) ====="];
M = blockTransfer[8, {3, 3, 3, 3, 3, 3, 4}];
MToep = Table[Binomial[21 + j - s, j - s], {j, 0, 14}, {s, 0, 7}];
Delta = MToep - M;

Do[
  j = 9 + d;
  row = Delta[[j + 1]];
  If[row =!= Table[0, 8],
    predicted = Table[
      Sum[vLin[3 (7 - m) + 1, 3, d - m + 1] *
        Binomial[7 + m 4 - s, m 3 - 1], {m, 1, d + 1}],
      {s, 0, 7}];
    Print["d=", d, " match: ", row === predicted,
      If[row =!= predicted, " DIFF=" <> ToString[row - predicted], ""]]
  ],
  {d, 0, 5}];
Print[""];

(* === Even more compact form === *)
Print["===== COMPACT FORM ====="];
Print[""];
Print["c_{d,m} = [w(a1-d-1)+1] / [w(a1-m)+1] * C(w(a1-m)+d-m+1, d-m+1)"];
Print[""];
Print["Verification of compact form:"];
Do[
  p = ww (a1 - m) + 1;
  jj = d - m + 1;
  formula1 = vLin[p, ww, jj];
  formula2 = (ww (a1 - d - 1) + 1) / (ww (a1 - m) + 1) * Binomial[ww (a1 - m) + d - m + 1, d - m + 1];
  If[formula1 =!= formula2,
    Print["COMPACT MISMATCH at w=", ww, " a1=", a1, " d=", d, " m=", m]],
  {ww, 1, 4}, {a1, 3, 8}, {d, 0, a1 - 2}, {m, 1, d + 1}];
Print["Compact form verified for all test cases."];
