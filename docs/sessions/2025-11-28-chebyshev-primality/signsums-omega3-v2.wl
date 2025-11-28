(* Analyze Σsigns for ω=3 via semiprime decomposition *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* For semiprime, compute the "contribution" *)
semiprimeSign[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -1];

Print["=== Testing: Σsigns(p₁p₂p₃) vs product of semiprime signs ===\n"];

data = {};
Do[
  k = p1 p2 p3;
  ss = signSum[k];

  (* Individual semiprime "signs" based on inverse parity *)
  s12 = semiprimeSign[p1, p2];
  s13 = semiprimeSign[p1, p3];
  s23 = semiprimeSign[p2, p3];

  (* Try various combinations *)
  prod = s12 * s13 * s23;
  sumS = s12 + s13 + s23;

  AppendTo[data, {k, p1, p2, p3, ss, s12, s13, s23, prod, sumS}];
  Print[k, " = ", p1, "×", p2, "×", p3,
        ": Σsigns=", ss,
        ", (s12,s13,s23)=(", s12, ",", s13, ",", s23, ")",
        ", prod=", prod, ", sum=", sumS],
  {p1, {3}},
  {p2, {5, 7, 11, 13}},
  {p3, Prime[Range[4, 12]]}
];

(* Filter and analyze *)
data = Select[data, #[[2]] < #[[3]] < #[[4]] &];

Print["\n=== Pattern search ==="];
Print["Grouping by (prod, sum):"];
groups = GroupBy[data, {#[[9]], #[[10]]} &];
Do[
  ssValues = #[[5]] & /@ groups[key];
  Print["prod=", key[[1]], ", sum=", key[[2]], " → Σsigns ∈ ", Union[ssValues]],
  {key, Keys[groups]}
];

Print["\n=== Hypothesis: Σsigns = f(s12, s13, s23) ==="];
(* Check if (s12, s13, s23) uniquely determines Σsigns *)
groups2 = GroupBy[data, {#[[6]], #[[7]], #[[8]]} &];
Do[
  ssValues = #[[5]] & /@ groups2[key];
  If[Length[Union[ssValues]] > 1,
    Print["CONFLICT at ", key, ": ", Union[ssValues]],
    Print[key, " → ", First[ssValues]]
  ],
  {key, Keys[groups2]}
];
