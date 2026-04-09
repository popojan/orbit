(* Key insight: A = L · U where U is uniform block transfer *)
(* Delta = T - A = T - L·U *)
(* L is prefix-sum matrix at the final dimension *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

blockTransfer[d_, pattern_] := Module[{m = d - 1, mat = IdentityMatrix[d]},
  Do[
    mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}];
    m++;
    If[w > 1, mat = MatrixPower[Lmat[m], w - 1] . mat],
    {w, pattern}];
  mat
]

(* Compute A (actual), U (uniform), T (Toeplitz), and verify A = L·U *)
Do[
  Print["===== a1=", a1, " ====="];
  pattern = Append[Table[ww, a1 - 1], ww + 1];
  uniPattern = Table[ww, a1];

  A = blockTransfer[a1 + 1, pattern];
  U = blockTransfer[a1 + 1, uniPattern];
  dim = Dimensions[A][[1]]; (* = 2a1+1 *)

  (* L at final dimension *)
  L = Lmat[dim - 1];

  (* Verify A = L · U *)
  diff = A - L . U;
  Print["A = L·U? ", diff === Table[0, dim, a1 + 1]];

  (* Toeplitz *)
  p1 = ww a1 + 1;
  T = Table[Binomial[p1 - 1 + j - s, j - s], {j, 0, dim - 1}, {s, 0, a1}];

  (* Delta = T - A = T - L·U *)
  Delta = T - A;

  (* Now: T - L·U. Can we express T in terms of U? *)
  (* T corresponds to linear boundary at slope 1/w going p1 columns *)
  (* U corresponds to uniform staircase going w*a1 columns *)
  (* A = L·U adds one column (prefix sum), going w*a1+1 = p1 columns *)
  (* So A and T both span p1 columns, but T uses linear boundary *)

  (* Compute U entries for the first column to understand structure *)
  Print["First column of U (s=0): ", U[[All, 1]]];
  Print["First column of A (s=0): ", A[[All, 1]]];
  Print["First column of T (s=0): ", T[[All, 1]]];
  Print[""];

  (* Correction at j=a1+2 (first nonzero row of Delta) *)
  If[a1 + 3 <= dim,
    corrRow = Delta[[a1 + 3]];
    Print["Correction at j=", a1 + 2, ": ", corrRow];
    (* What about U at this row? *)
    Print["U row ", a1 + 2, ": ", U[[a1 + 3]]];
    Print["A row ", a1 + 2, ": ", A[[a1 + 3]]];
    Print["T row ", a1 + 2, ": ", T[[a1 + 3]]];
    Print["T - T_shifted = Delta? Let's check"];
    Print[""];
  ];

  (* Key: since A = L·U, we have Delta = T - L·U *)
  (* If we define T' s.t. T = L·T', then Delta = L·(T' - U) *)
  (* But T is generally NOT of the form L·something nice *)

  (* Instead: Delta[i,s] = T[i,s] - Σ_{j=0}^{i} U[j,s] *)
  (* = C(p1-1+i-s, i-s) - Σ_{j=s}^{i} U[j,s] *)

  (* So the key is: what is Σ_{j=s}^{i} U[j,s] ? *)
  (* And does it telescope or simplify? *)
  ,
  {ww, 3}, {a1, 2, 4}];

(* === Direct computation: does U have a closed form? === *)
Print["===== U (uniform block) for w=3, a1=3 ====="];
U33 = blockTransfer[4, {3, 3, 3}];
Print["U dimensions: ", Dimensions[U33]];
Print["U entries:"];
Do[Print["  row ", j, ": ", U33[[j + 1]]], {j, 0, 6}];
Print[""];

(* Check: U[i,s] = C(3*3+i-s-1, 3*3-1) = C(8+i-s, 8) for i≤3? *)
Print["Expected C(8+i-s, 8) for i<=3:"];
Do[
  expected = Table[Binomial[8 + i - s, 8], {s, 0, 3}];
  actual = U33[[i + 1]];
  Print["  i=", i, " actual=", actual, " expected=", expected, " match=", actual === expected],
  {i, 0, 3}];
Print[""];

(* For i>3, U is truncated. What's the pattern? *)
Print["U at i=4,5,6 (boundary effects):"];
Do[Print["  i=", i, ": ", U33[[i + 1]]], {i, 4, 6}];
Print[""];

(* Now compute the partial sums Σ_{j=0}^{i} U[j,s] *)
Print["Partial sums of U columns (= A entries):"];
A33 = Lmat[6] . U33;
Do[Print["  i=", i, ": ", A33[[i + 1]]], {i, 0, 6}];
Print[""];

(* Compare with Toeplitz *)
T33 = Table[Binomial[9 + i - s, i - s], {i, 0, 6}, {s, 0, 3}];
Delta33 = T33 - A33;
Print["Delta = T - A:"];
Do[
  row = Delta33[[i + 1]];
  If[row =!= {0, 0, 0, 0},
    Print["  i=", i, ": ", row]],
  {i, 0, 6}];
