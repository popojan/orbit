(* Symbolic decomposition of correction rows *)
(* For w=1, we saw Delta[d, s] = C(2a1+2+d-s, d) — is this exact? *)

Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

blockTransfer[d_, pattern_] := Module[{m = d - 1, mat = IdentityMatrix[d]},
  Do[
    mat = Lmat[m + 1] . ArrayPad[mat, {{0, 1}, {0, 0}}];
    m++;
    If[w > 1, mat = MatrixPower[Lmat[m], w - 1] . mat],
    {w, pattern}];
  mat
]

(* === Test: for w=1, is Delta[a1+2+d, s] = C(2a1+2+d-s, d) exactly? === *)
Print["=== w=1: Testing Delta[a1+2+d, s] = C(2a1+2+d-s, d) ==="];
Do[
  M = blockTransfer[a1 + 1, Append[Table[1, a1 - 1], 2]];
  p1 = a1 + 1;
  MToep = Table[Binomial[p1 - 1 + j - s, j - s],
    {j, 0, Dimensions[M][[1]] - 1}, {s, 0, a1}];
  Delta = MToep - M;
  match = True;
  Do[
    row = Delta[[a1 + 2 + d + 1]];
    expected = Table[Binomial[2 a1 + 2 + d - s, d], {s, 0, a1}];
    If[row =!= expected,
      Print["MISMATCH at a1=", a1, " d=", d, ": got ", row, " expected ", expected];
      match = False],
    {d, 0, a1 - 2}];
  If[match, Print["a1=", a1, ": ALL MATCH for d=0..", a1 - 2]],
  {a1, 2, 10}];
Print[""];

(* === w=2: search for pattern === *)
Print["=== w=2: Express Delta in shifted binomial basis C(t+w+1, k) where t=a1-s ==="];
Do[
  M = blockTransfer[a1 + 1, Append[Table[2, a1 - 1], 3]];
  p1 = 2 a1 + 1;
  MToep = Table[Binomial[p1 - 1 + j - s, j - s],
    {j, 0, Dimensions[M][[1]] - 1}, {s, 0, a1}];
  Delta = MToep - M;
  Print["a1=", a1, ":"];
  Do[
    row = Delta[[a1 + 2 + d + 1]];
    (* Express row as polynomial in t = a1-s, in basis C(t+3, k) *)
    pts = Table[{a1 - s, row[[s + 1]]}, {s, 0, a1}];
    (* Fit polynomial in binomial basis C(t+3, 0), C(t+3, 1), ..., C(t+3, deg) *)
    deg = 2 d + 1; (* expected degree = w(d+1)-1 = 2d+1 *)
    (* Use forward differences of values at t=0,1,2,...  *)
    vals = Table[row[[a1 + 1 - t]], {t, 0, a1}]; (* values at t=0,1,...,a1 *)
    (* Transform to C(t+3, k) basis using shifted forward differences *)
    (* f(t) = Σ_k c_k C(t+3, k). Let u = t+3, then f(u-3) = Σ_k c_k C(u, k). *)
    (* Forward differences of f at u=3: Δ^k f(u=3) = c_k *)
    shiftedVals = Table[row[[a1 + 1 - (u - 3)]], {u, 3, a1 + 3}]; (* f at u=3,4,...,a1+3 *)
    fdiffs = shiftedVals;
    coeffs = {fdiffs[[1]]};
    Do[
      fdiffs = Differences[fdiffs];
      AppendTo[coeffs, fdiffs[[1]]],
      {Min[deg, Length[shiftedVals] - 1]}];
    Print["  d=", d, " coeffs(C(t+3,k)): ", coeffs],
    {d, 0, Min[a1 - 2, 4]}],
  {a1, 3, 8}];
Print[""];

(* === w=3: same analysis with basis C(t+4, k) === *)
Print["=== w=3: Express Delta in basis C(t+w+1, k) = C(t+4, k) ==="];
Do[
  M = blockTransfer[a1 + 1, Append[Table[3, a1 - 1], 4]];
  p1 = 3 a1 + 1;
  MToep = Table[Binomial[p1 - 1 + j - s, j - s],
    {j, 0, Dimensions[M][[1]] - 1}, {s, 0, a1}];
  Delta = MToep - M;
  Print["a1=", a1, ":"];
  Do[
    row = Delta[[a1 + 2 + d + 1]];
    vals = Table[row[[a1 + 1 - t]], {t, 0, a1}];
    shiftedVals = Table[row[[a1 + 1 - (u - (w + 1))]], {u, w + 1, a1 + w + 1}] /. w -> 3;
    fdiffs = shiftedVals;
    coeffs = {fdiffs[[1]]};
    Do[
      fdiffs = Differences[fdiffs];
      AppendTo[coeffs, fdiffs[[1]]],
      {Min[3 (d + 1) - 1, Length[shiftedVals] - 1]}];
    Print["  d=", d, " coeffs(C(t+4,k)): ", coeffs],
    {d, 0, Min[a1 - 2, 3]}],
  {a1, 3, 7}];
Print[""];

(* === w=4: same analysis === *)
Print["=== w=4: Express Delta in basis C(t+5, k) ==="];
Do[
  M = blockTransfer[a1 + 1, Append[Table[4, a1 - 1], 5]];
  p1 = 4 a1 + 1;
  MToep = Table[Binomial[p1 - 1 + j - s, j - s],
    {j, 0, Dimensions[M][[1]] - 1}, {s, 0, a1}];
  Delta = MToep - M;
  Print["a1=", a1, ":"];
  Do[
    row = Delta[[a1 + 2 + d + 1]];
    shiftedVals = Table[row[[a1 + 1 - (u - 5)]], {u, 5, a1 + 5}];
    fdiffs = shiftedVals;
    coeffs = {fdiffs[[1]]};
    Do[
      fdiffs = Differences[fdiffs];
      AppendTo[coeffs, fdiffs[[1]]],
      {Min[4 (d + 1) - 1, Length[shiftedVals] - 1]}];
    Print["  d=", d, " coeffs(C(t+5,k)): ", coeffs],
    {d, 0, Min[a1 - 2, 2]}],
  {a1, 3, 6}];
