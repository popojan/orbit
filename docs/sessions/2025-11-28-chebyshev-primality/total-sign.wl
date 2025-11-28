(* What is the "total sign" for a prime tuple? *)

Print["=== Finding the 'sign' of a prime tuple ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
epsilon[p_, q_] := If[EvenQ[PowerMod[p, -1, q]], 1, 0];

bVector[primes_List] := Module[{k = Times @@ primes, n = Length[primes]},
  Table[
    Module[{others = Delete[primes, i], prod},
      prod = Times @@ others;
      Mod[prod * PowerMod[prod, -1, primes[[i]]], 2]
    ],
    {i, n}
  ]
];

(* For ω=2:
   ss₂ = 1 - 4*ε₁₂  (where ε₁₂ = 1 if p₁⁻¹ mod p₂ is even)
   ss₂ = +1 if ε₁₂ = 0  (no "inversion")
   ss₂ = -3 if ε₁₂ = 1  (one "inversion")

   The "sign" could be (-1)^ε₁₂

For ω=3:
   ss₃ = 11 - 4*(#inv + #b)
   where #inv = ε₁₂ + ε₁₃ + ε₂₃, #b = |b₃|

   If we want ss₃ = f(sign), what is sign?

   max(ss₃) = 11 (when #inv + #b = 0)
   min(ss₃) = 11 - 4*6 = -13 (when #inv + #b = 6)

   sign = (-1)^{#inv + #b mod 2}? *)

Print["=== ω=2: Sign structure ===\n"];
Print["ss₂ = 1 - 4*ε₁₂"];
Print["ss₂ ∈ {+1, -3}"];
Print["'sign' = (-1)^ε₁₂"];
Print[""];

Print["=== ω=3: Sign structure ===\n"];
Print["ss₃ = 11 - 4*(#inv + #b)"];
Print["#inv = ε₁₂ + ε₁₃ + ε₂₃"];
Print["#b = |{i : bᵢ = 1}|"];
Print[""];

(* Let's define "total parity" for ω=3 *)
Print["Total parity τ₃ = (#inv + #b) mod 2\n"];

(* For ω=4: what's the pattern? *)
Print["=== ω=4: Looking for sign pattern ===\n"];

data4 = {};
Do[
  If[p1 < p2 < p3 < p4,
    primes = {p1, p2, p3, p4};
    k = p1 p2 p3 p4;
    ss4 = signSum[k];

    (* ε values *)
    e12 = epsilon[p1, p2]; e13 = epsilon[p1, p3]; e14 = epsilon[p1, p4];
    e23 = epsilon[p2, p3]; e24 = epsilon[p2, p4]; e34 = epsilon[p3, p4];
    numInv = e12 + e13 + e14 + e23 + e24 + e34;

    (* b at all levels *)
    b4 = bVector[primes];
    b123 = bVector[{p1, p2, p3}];
    b124 = bVector[{p1, p2, p4}];
    b134 = bVector[{p1, p3, p4}];
    b234 = bVector[{p2, p3, p4}];

    numB4 = Total[b4];
    numB123 = Total[b123]; numB124 = Total[b124];
    numB134 = Total[b134]; numB234 = Total[b234];
    sumTripleB = numB123 + numB124 + numB134 + numB234;

    (* Different "total" candidates *)
    tau1 = Mod[numInv + numB4, 2];
    tau2 = Mod[numInv + numB4 + sumTripleB, 2];
    tau3 = Mod[numInv + sumTripleB, 2];

    AppendTo[data4, <|
      "p" -> primes, "ss4" -> ss4,
      "numInv" -> numInv, "numB4" -> numB4, "sumTripleB" -> sumTripleB,
      "tau1" -> tau1, "tau2" -> tau2, "tau3" -> tau3
    |>]
  ],
  {p1, Prime[Range[2, 6]]},
  {p2, Prime[Range[3, 8]]},
  {p3, Prime[Range[4, 10]]},
  {p4, Prime[Range[5, 12]]}
];

Print["Total cases: ", Length[data4], "\n"];

(* Check: Is ss4 mod 4 determined by some tau? *)
Print["=== ss₄ mod 4 by different τ ===\n"];

byTau1 = GroupBy[data4, #["tau1"] &];
Do[
  mods = Union[Mod[#["ss4"], 4] & /@ byTau1[t]];
  Print["τ₁ = ", t, " (numInv + numB4 mod 2): ss₄ mod 4 ∈ ", mods],
  {t, {0, 1}}
];

Print[""];
byTau2 = GroupBy[data4, #["tau2"] &];
Do[
  mods = Union[Mod[#["ss4"], 4] & /@ byTau2[t]];
  Print["τ₂ = ", t, " (numInv + numB4 + sumTripleB mod 2): ss₄ mod 4 ∈ ", mods],
  {t, {0, 1}}
];

Print[""];
byTau3 = GroupBy[data4, #["tau3"] &];
Do[
  mods = Union[Mod[#["ss4"], 4] & /@ byTau3[t]];
  Print["τ₃ = ", t, " (numInv + sumTripleB mod 2): ss₄ mod 4 ∈ ", mods],
  {t, {0, 1}}
];

(* Maybe the "sign" structure is inclusion-exclusion? *)
Print["\n=== Inclusion-Exclusion Sign ===\n"];

(* For permutations: sign = Π_{i<j} (σ(j)-σ(i))/(j-i)
   This is a PRODUCT over pairs.

   Our ε_ij is the "local sign" for pair (i,j).
   Total inversions = Σ ε_ij

   For ω=3: correction involves both inversions AND b-vector parity.

   Hypothesis: The "sign" is (-1)^{f(ε) + g(b)}
   where f counts inversions with some weighting
   and g counts b-contributions *)

(* For ω=4, using inclusion-exclusion:
   Level 2: 6 pairs, each contributes ε_ij
   Level 3: 4 triples, each contributes its b-sum?
   Level 4: the full b4 *)

incExcSign = Map[
  Module[{d = #, eps, numInv, b4, b123, b124, b134, b234},
    numInv = #["numInv"];
    (* Inclusion-exclusion weighted sum *)
    (* Level 2: +inversions *)
    (* Level 3: -triple_b_sums *)
    (* Level 4: +full_b4 *)
    incExc = numInv - #["sumTripleB"] + #["numB4"];
    Mod[incExc, 2]
  ] &,
  data4
];

data4IE = MapThread[Append[#1, "incExcSign" -> #2] &, {data4, incExcSign}];

Print["Inclusion-exclusion sign: τ = (numInv - sumTripleB + numB4) mod 2\n"];
byIE = GroupBy[data4IE, #["incExcSign"] &];
Do[
  mods = Union[Mod[#["ss4"], 4] & /@ byIE[t]];
  Print["τ_IE = ", t, ": ss₄ mod 4 ∈ ", mods],
  {t, {0, 1}}
];

(* What is ss4 mod 8? *)
Print["\n=== ss₄ mod 8 by τ_IE ===\n"];
Do[
  mods = Union[Mod[#["ss4"], 8] & /@ byIE[t]];
  Print["τ_IE = ", t, ": ss₄ mod 8 ∈ ", mods],
  {t, {0, 1}}
];

(* For ω, we have congruence ss ≡ 1 - 2ω (mod 4)
   For ω=4: ss₄ ≡ -7 ≡ 1 (mod 4)
   Let's verify *)
Print["\n=== Verifying congruence ss₄ ≡ 1 (mod 4) ===\n"];
violations = Select[data4, Mod[#["ss4"], 4] != 1 &];
Print["Violations: ", Length[violations], " / ", Length[data4]];
