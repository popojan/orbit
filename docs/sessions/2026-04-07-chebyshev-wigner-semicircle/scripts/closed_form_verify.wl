(* Verify closed-form formula for state vector entries *)
(* in the UNIFORM stair width case (all stairs width w) *)
(*
   Claim: v_j^(k) = (w(k-j)+1)/(wk+1) * Binomial[wk+j, j]
   where v_j^(k) = dp(position, j) at the k-th semi-convergent position
*)

(* Transfer matrix L_m: (m+1)x(m+1) lower triangular all-ones *)
Lmat[m_] := Table[If[i >= j, 1, 0], {i, 0, m}, {j, 0, m}]

(* Compute state vectors via transfer matrices for uniform width w *)
(* Returns list of {k, stateVector} *)
transferUniform[w_, kMax_] := Module[
  {v = {1}, m = 0, results = {{0, {1}}}},
  Do[
    (* Within stair: apply L_m^(w-1) *)
    If[w > 1, v = MatrixPower[Lmat[m], w - 1] . v];
    (* Rise: extend by 0, apply L_{m+1} *)
    v = Lmat[m + 1] . Append[v, 0];
    m++;
    AppendTo[results, {k, v}],
    {k, 1, kMax}];
  results
]

(* Closed-form candidate *)
vFormula[w_, k_, j_] := (w (k - j) + 1)/(w k + 1) * Binomial[w k + j, j]

(* === Test for several values of w === *)
Print["=== Closed-form verification: v_j^(k) = (w(k-j)+1)/(wk+1) * C(wk+j, j) ==="];
Print[""];

Do[
  Print["--- w = ", w, " ---"];
  data = transferUniform[w, 8];
  allOK = True;
  Do[
    {k, vec} = data[[idx]];
    If[k == 0, Continue[]];
    Do[
      actual = vec[[j + 1]]; (* 1-indexed *)
      predicted = vFormula[w, k, j];
      If[actual =!= predicted,
        Print["  MISMATCH: w=", w, " k=", k, " j=", j,
          " actual=", actual, " predicted=", predicted];
        allOK = False],
      {j, 0, k}],
    {idx, 2, Length[data]}];
  If[allOK,
    Print["  ALL MATCH for k=1..", Length[data] - 1]],
  {w, {1, 2, 3, 4, 5, 7, 10}}];

(* === Show the triangles for w=1 and w=3 === *)
Print[""];
Print["=== State vector triangle for w=1 (Catalan) ==="];
data1 = transferUniform[1, 6];
Do[
  {k, vec} = data1[[idx]];
  Print["k=", k, ": ", vec],
  {idx, 1, Length[data1]}];

Print[""];
Print["=== State vector triangle for w=3 (Pi-like) ==="];
data3 = transferUniform[3, 7];
Do[
  {k, vec} = data3[[idx]];
  Print["k=", k, ": ", vec, "  B=", Last[vec]],
  {idx, 1, Length[data3]}];

(* === Verify against actual BeattyBallotCount for Pi === *)
Print[""];
Print["=== Cross-check with BeattyBallotCount[Pi, x] ==="];
Needs["Orbit`"];
semiConvPi = {3, 4, 7, 10, 13, 16, 19, 22}; (* first batch for Pi, w=3 *)
Do[
  x = semiConvPi[[idx]];
  dpActual = BeattyBallotCount[Pi, x];
  k = idx - 1; (* semi-convergent index *)
  dpFormula = vFormula[3, k, k]; (* last entry = DP *)
  Print["x=", x, " k=", k, " DP=", dpActual,
    " formula=", dpFormula,
    If[dpActual === dpFormula, " OK", " MISMATCH"]],
  {idx, 1, Length[semiConvPi]}];

(* === Key identity: last entry = Fuss-Catalan === *)
Print[""];
Print["=== Fuss-Catalan check: v_k^(k) = C((w+1)k, k)/(wk+1) ==="];
Do[
  fc = Binomial[(w + 1) k, k]/(w k + 1);
  vk = vFormula[w, k, k];
  If[fc =!= vk,
    Print["MISMATCH: w=", w, " k=", k]],
  {w, {1, 2, 3, 5}}, {k, 1, 10}];
Print["All Fuss-Catalan identities verified."];

(* === The formula as ballot number === *)
Print[""];
Print["=== Interpretation: v_j^(k) = (w(k-j)+1) * B(wk+1, j) ==="];
Print["where B(n,k) = C(n+k-1,k)/n is the ballot number"];
B[n_, k_] := Binomial[n + k - 1, k]/n;
Do[
  lhs = vFormula[3, k, j];
  rhs = (3 (k - j) + 1) * B[3 k + 1, j];
  If[lhs =!= rhs, Print["MISMATCH at k=", k, " j=", j]],
  {k, 1, 7}, {j, 0, k}];
Print["Identity v_j^(k) = (w(k-j)+1) * B(wk+1, j) verified for w=3."];
