(* Deep analysis: Why does parity of g^k correlate with parity of k? *)

Print["=== Primitive Root Parity Structure ===\n"];

(* For prime q with primitive root g:
   - p = g^a mod q
   - p⁻¹ = g^{q-1-a} mod q
   - (q|p) = (-1)^a
   - ε = 1 iff g^{q-1-a} is even

   Since q-1 is even:
   - a even ⟺ q-1-a even
   - a odd ⟺ q-1-a odd

   So: correlation(ε, (q|p)) ⟺ correlation(parity of g^k, parity of k)
*)

analyzeQ[q_] := Module[{g, powers, evenK, oddK, evenKEven, oddKEven, delta},
  g = PrimitiveRoot[q];

  (* g^k for k = 0, 1, ..., q-2 *)
  powers = Table[{k, PowerMod[g, k, q]}, {k, 0, q - 2}];

  evenK = Select[powers, EvenQ[#[[1]]] &];
  oddK = Select[powers, OddQ[#[[1]]] &];

  evenKEven = Count[evenK, p_ /; EvenQ[p[[2]]]];
  oddKEven = Count[oddK, p_ /; EvenQ[p[[2]]]];

  delta = N[oddKEven/Length[oddK] - evenKEven/Length[evenK], 4];

  {q, Mod[q, 8], g, Length[evenK], evenKEven, Length[oddK], oddKEven, delta}
];

Print["q\tq%8\tg\t#even_k\teven_val\t#odd_k\todd_val\tΔ%"];
Print["----------------------------------------------------------------"];

results = Table[
  If[Prime[i] > 3,
    r = analyzeQ[Prime[i]];
    Print[r[[1]], "\t", r[[2]], "\t", r[[3]], "\t",
          r[[4]], "\t", r[[5]], "\t\t",
          r[[6]], "\t", r[[7]], "\t\t",
          NumberForm[100*r[[8]], {4, 1}], "%"];
    r,
    Nothing
  ],
  {i, 3, 50}
];

Print["\n=== Pattern by q mod 8 ===\n"];

byMod8 = GroupBy[results, #[[2]] &];
Do[
  If[KeyExistsQ[byMod8, m],
    data = byMod8[m];
    deltas = data[[All, 8]];
    Print["q ≡ ", m, " (mod 8): mean Δ = ", NumberForm[100*Mean[deltas], {4, 2}],
          "%, std = ", NumberForm[100*StandardDeviation[deltas], {4, 2}], "%"]
  ],
  {m, {1, 3, 5, 7}}
];

(* Key insight: For g=2, this is about distribution of powers of 2 *)
Print["\n=== Special case: g = 2 (2 is primitive root) ===\n"];

primesWithG2 = Select[results, #[[3]] == 2 &];
Print["Primes where 2 is primitive root:"];
Print["q\tq%8\tΔ%"];
Do[
  r = primesWithG2[[i]];
  Print[r[[1]], "\t", r[[2]], "\t", NumberForm[100*r[[8]], {4, 1}], "%"],
  {i, Min[15, Length[primesWithG2]]}
];

(* For g=2: g^k even iff k ≥ 1, so ALL g^k for k≥1 share factor 2...
   Wait, that's wrong. 2^k mod q cycles through all non-zero residues.
   Some are even, some odd. *)

Print["\n=== Detailed look: q=5, g=2 ===\n"];
q = 5; g = 2;
Print["k\t2^k mod 5"];
Do[Print[k, "\t", PowerMod[2, k, q]], {k, 0, 3}];

Print["\n=== Detailed look: q=13, g=2 ===\n"];
q = 13; g = 2;
Print["k\t2^k mod 13\tparity(k)\tparity(2^k)"];
Do[
  pk = PowerMod[2, k, q];
  Print[k, "\t", pk, "\t\t", If[EvenQ[k], "even", "odd"], "\t\t",
        If[EvenQ[pk], "even", "odd"]],
  {k, 0, 11}
];

evenKCount = Count[Range[0, 11], k_ /; EvenQ[k] && EvenQ[PowerMod[2, k, 13]]];
oddKCount = Count[Range[0, 11], k_ /; OddQ[k] && EvenQ[PowerMod[2, k, 13]]];
Print["\neven k → even value: ", evenKCount, "/6"];
Print["odd k → even value: ", oddKCount, "/6"];

(* The KEY question: What determines this distribution? *)
Print["\n=== Hypothesis: Order of 2 in Z_q* ===\n"];

(* If ord_q(2) = d, then 2^d ≡ 1 (mod q)
   The parity pattern of 2^k repeats with period d *)

Do[
  q = Prime[i];
  If[q > 3,
    ord2 = MultiplicativeOrder[2, q];
    g = PrimitiveRoot[q];
    isG2 = (g == 2);
    Print["q=", q, " (mod 8: ", Mod[q, 8], "): ord_q(2)=", ord2,
          ", (q-1)/ord=", (q-1)/ord2,
          If[isG2, " [2 is prim.root]", ""]]
  ],
  {i, 3, 25}
];
