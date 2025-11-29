(* Verify: Δ = 0 iff (-1|q) = +1, and sign(Δ) = -(2|q) when (-1|q) = -1 *)

Print["=== VERIFICATION: Legendre Symbol Theory ===\n"];

analyzeQ[q_] := Module[{g, powers, evenK, oddK, evenKEven, oddKEven, delta,
                         leg1, leg2, signDelta},
  g = PrimitiveRoot[q];
  powers = Table[{k, PowerMod[g, k, q]}, {k, 0, q - 2}];
  evenK = Select[powers, EvenQ[#[[1]]] &];
  oddK = Select[powers, OddQ[#[[1]]] &];
  evenKEven = Count[evenK, p_ /; EvenQ[p[[2]]]];
  oddKEven = Count[oddK, p_ /; EvenQ[p[[2]]]];
  delta = oddKEven/Length[oddK] - evenKEven/Length[evenK];
  leg1 = JacobiSymbol[-1, q];
  leg2 = JacobiSymbol[2, q];
  signDelta = Sign[delta];
  {q, Mod[q, 8], leg1, leg2, delta == 0, signDelta, -leg2}
];

Print["Theory predicts:"];
Print["  Δ = 0 ⟺ (-1|q) = +1"];
Print["  sign(Δ) = -(2|q) when (-1|q) = -1\n"];

Print["q\tq%8\t(-1|q)\t(2|q)\tΔ=0?\tsign(Δ)\t-(2|q)\tMatch?"];
Print["----------------------------------------------------------"];

allMatch = True;
Do[
  If[Prime[i] > 3,
    r = analyzeQ[Prime[i]];
    {q, qMod, leg1, leg2, deltaZero, signD, negLeg2} = r;

    (* Theory: Δ=0 iff (-1|q)=+1 *)
    theory1 = (deltaZero == (leg1 == 1));

    (* Theory: when (-1|q)=-1, sign(Δ) = -(2|q) *)
    theory2 = If[leg1 == -1, signD == negLeg2, True];

    match = theory1 && theory2;
    If[!match, allMatch = False];

    Print[q, "\t", qMod, "\t", If[leg1 == 1, "+1", "-1"], "\t",
          If[leg2 == 1, "+1", "-1"], "\t",
          deltaZero, "\t", signD, "\t", negLeg2, "\t",
          If[match, "✓", "✗"]]
  ],
  {i, 3, 60}
];

Print["\n=== RESULT ==="];
If[allMatch,
  Print["✓ ALL PREDICTIONS CORRECT!"];
  Print[""];
  Print["THEOREM (verified for primes 5-277):"];
  Print[""];
  Print["Let g be a primitive root mod q, and define"];
  Print["  Δ(q) = P(g^k even | k odd) - P(g^k even | k even)"];
  Print[""];
  Print["Then:"];
  Print["  (1) Δ(q) = 0  ⟺  (-1|q) = +1  ⟺  q ≡ 1 (mod 4)"];
  Print["  (2) When q ≡ 3 (mod 4): sign(Δ) = -(2|q)"];
  Print["      i.e., Δ > 0 for q ≡ 3 (mod 8)"];
  Print["           Δ < 0 for q ≡ 7 (mod 8)"],
  Print["✗ SOME PREDICTIONS FAILED"]
];

(* Now connect to the original correlation *)
Print["\n=== CONNECTION TO ε vs (q|p) CORRELATION ===\n"];

Print["Recall:"];
Print["  ε = 1 iff p⁻¹ mod q is even"];
Print["  p = g^a mod q, so p⁻¹ = g^{q-1-a}"];
Print["  (q|p) = (q|g)^a = (-1)^a (since g is primitive root, hence NR)"];
Print[""];
Print["The correlation between ε and (q|p) arises because:"];
Print["  ε = 1 ⟺ g^{q-1-a} is even"];
Print["  (q|p) = (-1)^a depends on parity of a"];
Print[""];
Print["Since q-1 is even:"];
Print["  a even ⟺ q-1-a even"];
Print["  a odd ⟺ q-1-a odd"];
Print[""];
Print["So corr(ε, (q|p)) is determined by corr(parity of g^k, parity of k)"];
Print["which is exactly Δ(q)!"];
Print[""];
Print["Therefore:"];
Print["  q ≡ 1 (mod 4): Δ = 0 → NO correlation between ε and (q|p)"];
Print["  q ≡ 3 (mod 8): Δ > 0 → POSITIVE correlation (NR → more even p⁻¹)"];
Print["  q ≡ 7 (mod 8): Δ < 0 → NEGATIVE correlation (NR → fewer even p⁻¹)"];
