(* Quick test: Does ω=5 follow the same pattern? *)

Print["=== ω=5: Testing hierarchical pattern ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
epsilon[p_, q_] := If[EvenQ[PowerMod[p, -1, q]], 1, 0];

bVector[primes_List] := Module[{n = Length[primes]},
  Table[
    Module[{others = Delete[primes, i], prod},
      prod = Times @@ others;
      Mod[prod * PowerMod[prod, -1, primes[[i]]], 2]
    ],
    {i, n}
  ]
];

(* Generate ω=5 cases (will be slower) *)
Print["Computing ω=5 cases (this may take a while)...\n"];

data5 = {};
primeList = Prime[Range[2, 9]];  (* 3,5,7,11,13,17,19,23 *)

Do[
  If[p1 < p2 < p3 < p4 < p5,
    primes = {p1, p2, p3, p4, p5};
    k = Times @@ primes;
    ss5 = signSum[k];

    (* All 10 ε values *)
    eps = Table[epsilon[primes[[i]], primes[[j]]], {i, 1, 4}, {j, i+1, 5}] // Flatten;

    (* b at level 5 *)
    b5 = bVector[primes];

    (* All 5 b-vectors at level 4 *)
    b4s = Table[bVector[Delete[primes, i]], {i, 5}];

    (* All 10 b-vectors at level 3 *)
    b3s = Table[bVector[primes[[Complement[Range[5], {i, j}]]]],
                {i, 1, 4}, {j, i+1, 5}] // Flatten[#, 1] &;

    AppendTo[data5, <|
      "p" -> primes, "ss5" -> ss5,
      "eps" -> eps, "b5" -> b5,
      "b4s" -> b4s, "b3s" -> b3s
    |>]
  ],
  {p1, primeList[[1 ;; 4]]},
  {p2, primeList[[2 ;; 5]]},
  {p3, primeList[[3 ;; 6]]},
  {p4, primeList[[4 ;; 7]]},
  {p5, primeList[[5 ;; 8]]}
];

Print["Total ω=5 cases: ", Length[data5], "\n"];

(* Verify congruence *)
Print["=== Congruence check: ss₅ ≡ 1 - 2(5) = -9 ≡ 3 (mod 4) ===\n"];
violations = Select[data5, Mod[#["ss5"], 4] != 3 &];
Print["Violations: ", Length[violations], " / ", Length[data5]];
Print["ss₅ mod 4 values: ", Union[Mod[#["ss5"], 4] & /@ data5]];

(* Test: Does full pattern determine ss₅? *)
Print["\n=== Full pattern (ε, b5, all b4s, all b3s) ===\n"];
byFull = GroupBy[data5, {#["eps"], #["b5"], #["b4s"], #["b3s"]} &];
constantFull = True;
numConstant = 0;
Do[
  ssVals = Union[#["ss5"] & /@ byFull[key]];
  If[Length[ssVals] == 1, numConstant++, constantFull = False],
  {key, Keys[byFull]}
];
Print["Total patterns: ", Length[Keys[byFull]]];
Print["Constant patterns: ", numConstant];
Print["All constant? ", constantFull];

If[constantFull,
  Print["\n✓ Full hierarchical pattern DETERMINES ss₅!"];
  Print["The pattern continues for ω=5."];
];

(* What about simpler patterns? *)
Print["\n=== Simpler patterns ===\n"];

(* Just (ε, b5) *)
byEpsB5 = GroupBy[data5, {#["eps"], #["b5"]} &];
numConstantSimple = Count[
  (Length[Union[#["ss5"] & /@ byEpsB5[key]]] == 1 &) /@ Keys[byEpsB5],
  True
];
Print["(ε, b5) only: ", numConstantSimple, " / ", Length[Keys[byEpsB5]], " constant"];

(* (ε, b5, b4s) without b3s *)
byNoB3 = GroupBy[data5, {#["eps"], #["b5"], #["b4s"]} &];
numConstantNoB3 = Count[
  (Length[Union[#["ss5"] & /@ byNoB3[key]]] == 1 &) /@ Keys[byNoB3],
  True
];
Print["(ε, b5, b4s) without b3s: ", numConstantNoB3, " / ", Length[Keys[byNoB3]], " constant"];

Print["\n=== Complexity growth ===\n"];
Print["ω=2: 1 ε value"];
Print["ω=3: 3 ε + 3 b = 6 parameters"];
Print["ω=4: 6 ε + 4 b4 + 12 b3 = 22 parameters"];
Print["ω=5: 10 ε + 5 b5 + 20 b4 + 30 b3 = 65 parameters"];
Print["ω=6: 15 ε + 6 b6 + 30 b5 + 60 b4 + 60 b3 = 171 parameters"];
Print["\nGeneral: O(ω² + ω·2^ω) parameters needed!"];
