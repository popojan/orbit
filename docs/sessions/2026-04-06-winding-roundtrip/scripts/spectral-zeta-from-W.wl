(* ================================================================ *)
(* Can we extract ζ(s) from spectral properties of W?              *)
(*                                                                  *)
(* Ideas:                                                           *)
(* 1. Eigenvalues of W^(k) at special k                           *)
(* 2. tr(W^T W) / n as function of k                              *)
(* 3. det(W^(k)) near integer s → does it "know" ζ(s)?           *)
(* 4. Smith invariant factors                                      *)
(* ================================================================ *)

nSize = 20;  (* matrix size *)
gList = Table[N[Im[ZetaZero[n]], 20], {n, nSize}];
lpList = Table[Log[N[Prime[j], 20]], {j, nSize}];

fWM[k_] := Table[
  Floor[k gList[[n]] lpList[[j]] / (2 Pi)], {n, nSize}, {j, nSize}]

(* ================================================================ *)
(* 1. EIGENVALUE SPECTRUM at special k                              *)
(* ================================================================ *)
Print["╔══════════════════════════════════════════════════════╗"];
Print["║  SPECTRAL ANALYSIS OF W^(k) at k = ζ(s)            ║"];
Print["╚══════════════════════════════════════════════════════╝\n"];

Print["=== Eigenvalues at k = 1, ζ(3), 11/4, 2π ===\n"];
Do[
  {kv, kl} = kp;
  w = fWM[kv];
  eigs = Sort[Eigenvalues[N[w]], Abs[#1] > Abs[#2] &];
  Print[kl, ":"];
  Print["  λ_1 = ", NumberForm[eigs[[1]], {6, 2}],
    "  λ_2 = ", NumberForm[eigs[[2]], {6, 2}],
    "  λ_2/λ_1 = ", NumberForm[eigs[[2]]/eigs[[1]], {4, 4}]];
  Print["  det = ", Det[w],
    "  tr = ", Tr[w],
    "  |λ_n| = ", NumberForm[Abs[Last[eigs]], {4, 3}]];
  Print["  Π|λ_i| = ", NumberForm[Times @@ Abs[eigs], {6, 2}]];
  Print[""],
{kp, {{1, "k=1"}, {N[Zeta[3], 20], "k=ζ(3)"},
      {11/4, "k=11/4"}, {N[2 Pi, 20], "k=2π"}}}];

(* ================================================================ *)
(* 2. TRACE FORMULAS: do they encode ζ(s)?                         *)
(* ================================================================ *)
Print["=== Trace of W^T·W / normalization ===\n"];

Do[
  {kv, kl} = kp;
  w = fWM[kv];
  wtw = Transpose[w] . w;
  trWtW = Tr[wtw];
  (* Compare: Σ_j (Σ_n w_{nj})^2 *)
  colSums = Total[w];
  (* Theoretical: for rank-1, tr(W^T W) ≈ ||a||^2 ||ℓ||^2 *)
  a2 = Total[gList^2] / (2 Pi)^2;  (* Σ (γ_n/2π)^2 *)
  l2 = Total[lpList^2];            (* Σ (ln p_j)^2 *)
  Print[kl, ": tr(W^T W) = ", trWtW,
    "  k²·||a||²·||ℓ||² = ", NumberForm[kv^2 a2 l2, {8, 1}],
    "  ratio = ", NumberForm[trWtW / (kv^2 a2 l2), {5, 4}]],
{kp, {{1, "k=1"}, {N[Zeta[3], 20], "k=ζ(3)"},
      {11/4, "k=11/4"}, {N[2 Pi, 20], "k=2π"}}}];

(* ================================================================ *)
(* 3. KEY EXPERIMENT: det(W^(k)) as function of k near ζ(s)       *)
(* Does det "know" where ζ(s) values are?                          *)
(* ================================================================ *)
Print["\n\n=== det(W^(k)) near ζ(s) values ===\n"];

Do[
  zs = N[Zeta[s], 20];
  Print["--- Near ζ(", s, ") = ", NumberForm[zs, {10, 7}], " ---"];
  (* Sample det at k = ζ(s) ± ε *)
  dets = Table[
    {k, Det[fWM[k]]},
  {k, zs - 0.01, zs + 0.01, 0.001}];
  (* Find sign changes (zeros of det) *)
  signChanges = Count[
    Table[Sign[dets[[i, 2]]] != Sign[dets[[i + 1, 2]]] &&
      dets[[i, 2]] != 0 && dets[[i + 1, 2]] != 0,
    {i, Length[dets] - 1}], True];
  Print["  det@ζ(", s, ") = ", Det[fWM[zs]],
    "  sign changes in ±0.01: ", signChanges];
  Print["  det samples: ",
    Table[{NumberForm[d[[1]] - zs, {3, 3}], d[[2]]},
      {d, dets[[{1, 6, 11, 16, 21}]]}]],
{s, {2, 3, 4, 5, 6}}];

(* ================================================================ *)
(* 4. RATIOS: does det(W^(k))/det(W^(k')) give ζ values?          *)
(* ================================================================ *)
Print["\n\n=== Determinant ratios ===\n"];
detZ2 = Det[fWM[N[Zeta[2], 20]]];
detZ3 = Det[fWM[N[Zeta[3], 20]]];
det1 = Det[fWM[1]];
detE = Det[fWM[N[E, 20]]];
detPi = Det[fWM[N[Pi, 20]]];
det2Pi = Det[fWM[N[2 Pi, 20]]];

Print["det@ζ(2) = ", detZ2];
Print["det@ζ(3) = ", detZ3];
Print["det@1 = ", det1];
Print["det@e = ", detE];
Print["det@π = ", detPi];
Print["det@2π = ", det2Pi];
Print[""];
Print["Ratios:"];
Print["  det@ζ(2)/det@ζ(3) = ", If[detZ3 != 0, N[detZ2/detZ3], "undef"]];
Print["  det@2π/det@ζ(3) = ", If[detZ3 != 0, N[det2Pi/detZ3], "undef"]];

(* ================================================================ *)
(* 5. SMITH NORMAL FORM at k = ζ(3)                                *)
(* ================================================================ *)
Print["\n\n=== Smith Normal Form at k = ζ(s) ===\n"];
Do[
  zs = N[Zeta[s], 20];
  w = fWM[zs];
  d = Det[w];
  If[d != 0,
    snf = SmithDecomposition[w][[2]];
    diag = Table[snf[[i, i]], {i, nSize}];
    Print["ζ(", s, "): det=", d,
      "  Smith diag = ", Select[diag, # != 1 &],
      "  (", Count[diag, 1], " ones)"],
    Print["ζ(", s, "): SINGULAR"]],
{s, {2, 3, 4, 5}}];

(* Also for 11/4 and 2π *)
Do[
  {kv, kl} = kp;
  w = fWM[kv];
  d = Det[w];
  If[d != 0,
    snf = SmithDecomposition[w][[2]];
    diag = Table[snf[[i, i]], {i, nSize}];
    Print[kl, ": det=", d,
      "  Smith diag = ", Select[diag, # != 1 &],
      "  (", Count[diag, 1], " ones)"],
    Print[kl, ": SINGULAR"]],
{kp, {{11/4, "11/4"}, {N[2 Pi, 20], "2π"}}}];
