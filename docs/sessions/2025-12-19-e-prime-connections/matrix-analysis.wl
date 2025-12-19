(* Matrix formulation of the recurrence *)

Print["=== MATRIX FORMULATION ===\n"];

(* s_n = (4n+2) s_{n-1} + s_{n-2} *)
(* In matrix form: [s_n; s_{n-1}] = M_n [s_{n-1}; s_{n-2}] *)
(* where M_n = [[4n+2, 1], [1, 0]] *)

matM[n_] := {{4 n + 2, 1}, {1, 0}};

(* Product M_n M_{n-1} ... M_1 gives transition from [s_0; s_{-1}] to [s_n; s_{n-1}] *)

(* For a full period mod p, we need product M_{2p-1} ... M_0 mod p *)

fullPeriodMatrix[p_] := Mod[
  Fold[Dot, IdentityMatrix[2], Table[matM[n], {n, 0, 2 p - 1}]],
  p
];

Print["Full period matrix mod p (should be identity for period 2p):"];
Do[
  fpm = fullPeriodMatrix[p];
  Print["p = ", p, ": ", fpm, " = I? ", fpm == IdentityMatrix[2]];
, {p, {7, 11, 13, 17, 19, 23}}];

(* Check if there's a pattern in partial products *)
Print["\n=== PARTIAL PRODUCTS (looking for when det = 0) ==="];

(* If det(M_n ... M_1) ≡ 0 (mod p), the orbit can collapse *)
partialDets[p_, maxN_] := Table[
  prod = Mod[Fold[Dot, IdentityMatrix[2], Table[matM[k], {k, 0, n}]], p];
  Mod[Det[prod], p]
, {n, 0, maxN}];

Print["Determinants of partial products:"];
Do[
  dets = partialDets[p, 2 p - 1];
  zeroAt = Position[dets, 0];
  Print["p = ", p, ": zeros at positions ", Flatten[zeroAt]];
, {p, {7, 11, 13, 17, 19, 23, 31}}];

(* Individual matrix determinants *)
Print["\n=== INDIVIDUAL MATRIX DETERMINANTS ==="];
Print["det(M_n) = (4n+2)*0 - 1*1 = -1 always"];
Print["So product of determinants = (-1)^n"];
Print["But mod p, orbit depends on trace too...\n"];

(* Trace analysis *)
Print["=== TRACE OF PARTIAL PRODUCTS ==="];
partialTraces[p_, maxN_] := Table[
  prod = Mod[Fold[Dot, IdentityMatrix[2], Table[matM[k], {k, 0, n}]], p];
  Mod[Tr[prod], p]
, {n, 0, maxN}];

Print["Traces of partial products:");
Do[
  traces = partialTraces[p, 2 p - 1];
  Print["p = ", p, ": traces = ", traces];
, {p, {7, 11}}];

(* The key insight: orbit hits zero iff... what? *)
Print["\n=== WHEN DOES ORBIT HIT ZERO? ==="];

(* Let P_n = M_{n-1} ... M_1 M_0 *)
(* Then [s_n; s_{n-1}] = P_n [s_0; s_{-1}] = P_n [1; 1] *)
(* s_n = 0 iff (P_n)_{11} + (P_n)_{12} ≡ 0 (mod p) *)

checkZeroCondition[p_] := Module[{prod, zeroN},
  prod = IdentityMatrix[2];
  zeroN = {};
  Do[
    prod = Mod[matM[n] . prod, p];
    If[Mod[prod[[1, 1]] + prod[[1, 2]], p] == 0,
      AppendTo[zeroN, n + 1]];  (* n+1 because we apply M_n to get s_{n+1} *)
  , {n, 0, 2 p - 1}];
  zeroN
];

Print["n where s_n ≡ 0 (from matrix product):"];
Do[
  zeroN = checkZeroCondition[p];
  Print["p = ", p, ": ", zeroN];
, {p, {7, 11, 13, 17, 19, 23, 31}}];
