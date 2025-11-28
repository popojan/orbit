(* Σsigns for ω(k) = 3: products of 3 distinct primes *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;

signSum[k_] := Module[{primLobes},
  primLobes = Select[Range[2, k-1], isPrimitiveLobe[#, k] &];
  Total[(-1)^(# - 1) & /@ primLobes]
];

(* Collect data for 3-prime products *)
Print["=== Σsigns for p₁ × p₂ × p₃ ===\n"];

data3 = {};
Do[
  k = p1 p2 p3;
  ss = signSum[k];
  (* Compute all pairwise modular inverses *)
  inv12 = PowerMod[p1, -1, p2];
  inv13 = PowerMod[p1, -1, p3];
  inv21 = PowerMod[p2, -1, p1];
  inv23 = PowerMod[p2, -1, p3];
  inv31 = PowerMod[p3, -1, p1];
  inv32 = PowerMod[p3, -1, p2];
  AppendTo[data3, <|
    "k" -> k,
    "p1" -> p1, "p2" -> p2, "p3" -> p3,
    "ss" -> ss,
    "inv12" -> inv12, "inv13" -> inv13,
    "inv21" -> inv21, "inv23" -> inv23,
    "inv31" -> inv31, "inv32" -> inv32,
    "parities" -> {Mod[inv12,2], Mod[inv13,2], Mod[inv21,2],
                   Mod[inv23,2], Mod[inv31,2], Mod[inv32,2]}
  |>],
  {p1, {3}},
  {p2, Prime[Range[3, 8]]},
  {p3, Prime[Range[4, 10]]}
];

(* Filter valid (p1 < p2 < p3) *)
data3 = Select[data3, #["p1"] < #["p2"] < #["p3"] &];

(* Display *)
Do[
  Print[d["k"], " = ", d["p1"], "×", d["p2"], "×", d["p3"],
        ": Σsigns = ", d["ss"],
        ", parities = ", d["parities"]],
  {d, Take[data3, 20]}
];

(* Group by Σsigns value *)
Print["\n=== Distribution ==="];
Tally[#["ss"] & /@ data3] // Sort // Print;

(* Look for pattern in parities *)
Print["\n=== Σsigns vs parity sum ==="];
Do[
  paritySum = Total[d["parities"]];
  Print[d["k"], ": Σsigns=", d["ss"], ", Σparities=", paritySum],
  {d, Take[data3, 15]}
];
