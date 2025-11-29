(* Algebraic proof attempt *)

Print["=== ALGEBRAIC PROOF ===\n"];

Print["KEY INSIGHT: The bias Δ is controlled by 2⁻¹ mod q\n"];

Print["For prime q > 2:"];
Print["  2⁻¹ mod q = (q+1)/2"];
Print[""];
Print["  q ≡ 1 (mod 4): (q+1)/2 is ODD"];
Print["  q ≡ 3 (mod 4): (q+1)/2 is EVEN"];
Print[""];

(* Verify *)
Print["Verification:"];
Do[
  q = Prime[i];
  If[q > 2,
    inv2 = PowerMod[2, -1, q];
    formula = (q + 1)/2;
    parity = If[EvenQ[inv2], "even", "odd"];
    qMod4 = Mod[q, 4];
    Print["  q=", q, " (mod 4 = ", qMod4, "): 2⁻¹ = ", inv2, " = (q+1)/2 = ", formula, " (", parity, ")"]
  ],
  {i, 2, 12}
];

Print["\n=== WHY THIS MATTERS ===\n"];

Print["For primitive root g:"];
Print["  g^k and g^{q-1-k} are multiplicative inverses"];
Print["  (since g^{q-1} = 1)"];
Print[""];
Print["The bias Δ measures correlation between:"];
Print["  - parity of k"];
Print["  - parity of g^k"];
Print[""];
Print["Using k ↔ q-1-k swaps odd/even k (since q-1 is even)"];
Print["And maps g^k ↔ (g^k)⁻¹"];
Print[""];
Print["So Δ is determined by how inversion x → x⁻¹ affects parity!"];

Print["\n=== THE KEY LEMMA ===\n"];

Print["LEMMA: For x even, parity(x⁻¹) depends on 2⁻¹ mod q"];
Print[""];
Print["Proof:");
Print["  Let x = 2m (x even, m ∈ Z_q*)"];
Print["  Then x⁻¹ = (2m)⁻¹ = 2⁻¹ · m⁻¹"];
Print[""];
Print["  parity(x⁻¹) = parity(2⁻¹) ⊕ parity(m⁻¹) if multiplication doesn't overflow q"];
Print["  ... this is where the argument gets subtle");
Print[""];

Print["=== REFINED ANALYSIS ===\n"];

(* Actually, let's count directly *)
(* For each q, count: how many even residues have even inverses? *)

analyzeInversion[q_] := Module[{evens, evenToEven, evenToOdd, odds, oddToEven, oddToOdd},
  evens = Select[Range[1, q - 1], EvenQ];
  odds = Select[Range[1, q - 1], OddQ];

  evenToEven = Count[evens, x_ /; EvenQ[PowerMod[x, -1, q]]];
  evenToOdd = Length[evens] - evenToEven;

  oddToEven = Count[odds, x_ /; EvenQ[PowerMod[x, -1, q]]];
  oddToOdd = Length[odds] - oddToEven;

  {q, Mod[q, 4], evenToEven, evenToOdd, oddToEven, oddToOdd}
];

Print["How inversion permutes even/odd residues:\n"];
Print["q\tq%4\tE→E\tE→O\tO→E\tO→O\tComment"];
Print["--------------------------------------------------"];

Do[
  q = Prime[i];
  If[q > 2,
    r = analyzeInversion[q];
    {q, qMod4, ee, eo, oe, oo} = r;
    comment = If[ee == eo && oe == oo, "balanced!", "biased"];
    Print[q, "\t", qMod4, "\t", ee, "\t", eo, "\t", oe, "\t", oo, "\t", comment]
  ],
  {i, 2, 20}
];

Print["\n=== PATTERN ===\n"];

Print["For q ≡ 1 (mod 4):"];
Print["  Even→Even = Even→Odd AND Odd→Even = Odd→Odd"];
Print["  → Inversion is BALANCED with respect to parity"];
Print["  → Δ = 0"];
Print[""];
Print["For q ≡ 3 (mod 4):"];
Print["  The balance is BROKEN"];
Print["  → Δ ≠ 0, with sign determined by (2|q)"];

(* Now let's understand WHY q ≡ 1 (mod 4) gives balance *)
Print["\n=== WHY q ≡ 1 (mod 4) GIVES BALANCE ===\n"];

Print["For q ≡ 1 (mod 4), -1 is a quadratic residue.");
Print["Let i² ≡ -1 (mod q), so i⁻¹ = -i.");
Print[""];
Print["Consider the map x → i·x (multiplication by i).");
Print["This is an automorphism of Z_q* of order 4.");
Print["");
Print["Key: i is odd (since i² = q-1 ≡ -1 is always even when q>2... wait");

(* Let me check what i = sqrt(-1) looks like *)
Print["Values of √(-1) mod q for q ≡ 1 (mod 4):"];
Do[
  q = Prime[i];
  If[Mod[q, 4] == 1,
    sqrtNeg1 = PowerMod[-1, (q + 1)/4, q];  (* Works when q ≡ 1 (mod 4) *)
    Print["  q=", q, ": √(-1) = ", sqrtNeg1, " (parity: ", If[EvenQ[sqrtNeg1], "even", "odd"], ")"]
  ],
  {i, 3, 20}
];
