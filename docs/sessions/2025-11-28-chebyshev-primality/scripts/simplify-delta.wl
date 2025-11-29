(* Try to find simpler interpretation of δ *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* The δ formula *)
computeDelta[p1_, p2_, p3_] := Module[
  {M2, M3, e2, e3, c2, c3, inv12, inv13, inv23, delta},

  M2 = p1 p3; M3 = p1 p2;
  e2 = PowerMod[M2, -1, p2];
  e3 = PowerMod[M3, -1, p3];
  c2 = Mod[M2 e2, 2];
  c3 = Mod[M3 e3, 2];

  inv12 = Mod[PowerMod[p1, -1, p2], 2];
  inv13 = Mod[PowerMod[p1, -1, p3], 2];
  inv23 = Mod[PowerMod[p2, -1, p3], 2];

  delta = Mod[c2 + c3 + inv12 + inv13 + inv23, 2];
  {delta, {c2, c3, inv12, inv13, inv23}}
];

(* Try to find simpler formula for δ *)
Print["=== Exploring simpler characterization ===\n"];

(* Hypothesis: maybe δ relates to some Jacobi symbol product? *)
Print["Testing Jacobi symbol products:"];
data = {};
Do[
  If[p2 > 3 && p3 > p2,
    {delta, parts} = computeDelta[3, p2, p3];
    J12 = JacobiSymbol[3, p2];
    J13 = JacobiSymbol[3, p3];
    J23 = JacobiSymbol[p2, p3];
    prodJ = J12 J13 J23;

    (* Also try: product of all Jacobi symbols *)
    prodAll = J12 J13 J23 * JacobiSymbol[p2, 3] * JacobiSymbol[p3, 3] * JacobiSymbol[p3, p2];

    AppendTo[data, {p2, p3, delta, prodJ, prodAll}];
  ],
  {p2, Prime[Range[3, 12]]},
  {p3, Prime[Range[4, 20]]}
];

(* Check correlation *)
Print["δ vs J12*J13*J23:"];
grouped = GroupBy[data, #[[4]] &];
Do[
  deltas = #[[3]] & /@ grouped[key];
  Print["  prodJ=", key, " → δ ∈ ", Tally[deltas]],
  {key, Sort[Keys[grouped]]}
];

Print["\nδ vs product of ALL 6 Jacobi symbols:"];
grouped2 = GroupBy[data, #[[5]] &];
Do[
  deltas = #[[3]] & /@ grouped2[key];
  Print["  prodAll=", key, " → δ ∈ ", Tally[deltas]],
  {key, Sort[Keys[grouped2]]}
];

(* Try: count of odd inverses *)
Print["\n=== δ vs count of odd inverses ==="];
data2 = {};
Do[
  If[p2 > 3 && p3 > p2,
    {delta, parts} = computeDelta[3, p2, p3];
    (* parts = {c2, c3, inv12, inv13, inv23} *)
    numOddInv = parts[[3]] + parts[[4]] + parts[[5]];
    numOddC = parts[[1]] + parts[[2]];
    AppendTo[data2, {delta, numOddInv, numOddC, parts}];
  ],
  {p2, Prime[Range[3, 15]]},
  {p3, Prime[Range[4, 25]]}
];

grouped3 = GroupBy[data2, {#[[2]], #[[3]]} &];
Do[
  deltas = #[[1]] & /@ grouped3[key];
  Print["(numOddInv, numOddC)=", key, " → δ ∈ ", Union[deltas]],
  {key, Sort[Keys[grouped3]]}
];

(* Actually: δ = (c2+c3+invSum) mod 2 = (numOddC + numOddInv) mod 2 *)
Print["\n=== Simpler: δ = (numOddC + numOddInv) mod 2 ==="];
Print["This is: parity of (count of 'odd' among c2, c3, inv12, inv13, inv23)"];
