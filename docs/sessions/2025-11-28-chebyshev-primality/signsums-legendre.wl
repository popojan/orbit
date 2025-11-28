(* Test: is Σsigns related to product of Legendre symbols? *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
semiprimeSign[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -1];

Print["=== Σsigns vs Legendre symbol products ===\n"];

Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    (* Legendre symbols *)
    L12 = JacobiSymbol[p1, p2];
    L13 = JacobiSymbol[p1, p3];
    L21 = JacobiSymbol[p2, p1];
    L23 = JacobiSymbol[p2, p3];
    L31 = JacobiSymbol[p3, p1];
    L32 = JacobiSymbol[p3, p2];

    (* Various products *)
    prodAll = L12 L13 L21 L23 L31 L32;
    prod123 = L12 L23 L31;  (* "cyclic" *)
    prod132 = L13 L32 L21;  (* other cyclic *)

    (* Semiprime signs *)
    s12 = semiprimeSign[p1, p2];
    s13 = semiprimeSign[p1, p3];
    s23 = semiprimeSign[p2, p3];
    prodS = s12 s13 s23;

    (* Combined *)
    combined = prodS * prod123;

    Print[k, " = ", p1, "×", p2, "×", p3, ": Σsigns=", ss];
    Print["  (L12,L13,L23)=(", L12, ",", L13, ",", L23, ")"];
    Print["  (s12,s13,s23)=(", s12, ",", s13, ",", s23, ")"];
    Print["  prodS=", prodS, ", prod123=", prod123, ", combined=", combined];
    Print[""];
  ],
  {p1, {3}},
  {p2, {5, 7, 11}},
  {p3, Prime[Range[4, 10]]}
];

Print["\n=== Simplified: does prodS * prod123 predict anything? ===\n"];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    s12 = semiprimeSign[p1, p2];
    s13 = semiprimeSign[p1, p3];
    s23 = semiprimeSign[p2, p3];
    L12 = JacobiSymbol[p1, p2];
    L23 = JacobiSymbol[p2, p3];
    L31 = JacobiSymbol[p3, p1];
    combo = s12 s13 s23 * L12 * L23 * L31;
    AppendTo[data, {k, ss, combo, s12 s13 s23, L12 L23 L31}];
  ],
  {p1, {3}},
  {p2, Prime[Range[3, 10]]},
  {p3, Prime[Range[4, 15]]}
];

(* Group by combo value *)
groups = GroupBy[data, #[[3]] &];
Do[
  ssVals = #[[2]] & /@ groups[key];
  Print["combo=", key, " → Σsigns ∈ ", Union[ssVals], " (", Length[ssVals], " cases)"],
  {key, Sort[Keys[groups]]}
];
