(* Multiplicative Characters over Finite Fields *)
(* Reference: Ireland & Rosen, Chapter 8 *)

(* NOTE: Wolfram has built-in DirichletCharacter[modulus, index, n] *)
(* but uses different indexing convention (Conrey labeling).        *)
(* This file provides CharacterByOrder for order-based access.     *)

(* ============================================== *)
(* BASIC DEFINITIONS                              *)
(* ============================================== *)

(* Multiplicative character chi_j mod p, evaluated at a *)
(* j = index in {0, 1, ..., p-2} *)
(* a = element to evaluate *)
(* Returns: (p-1)-th root of unity, or 0 if a = 0 mod p *)

MultiplicativeCharacter[p_Integer?PrimeQ, j_Integer, a_Integer] :=
  Module[{g, omega, dlog},
    If[Mod[a, p] == 0, Return[0]];
    g = PrimitiveRoot[p];
    omega = Exp[2 Pi I / (p - 1)];
    (* Discrete log: find k such that g^k = a mod p *)
    dlog = SelectFirst[Range[0, p - 2], PowerMod[g, #, p] == Mod[a, p] &];
    omega^(j * dlog)
  ];

(* Order of character chi_j *)
CharacterOrder[p_Integer?PrimeQ, j_Integer] := (p - 1) / GCD[j, p - 1];

(* Character of specified order d (must have d | (p-1)) *)
CharacterByOrder[p_Integer?PrimeQ, d_Integer, a_Integer] :=
  Module[{j},
    If[Mod[p - 1, d] > 0,
      Message[CharacterByOrder::baddiv, d, p - 1];
      Return[$Failed]
    ];
    j = (p - 1) / d;
    MultiplicativeCharacter[p, j, a]
  ];

CharacterByOrder::baddiv = "Order `1` does not divide `2`.";

(* ============================================== *)
(* SPECIAL CASES                                  *)
(* ============================================== *)

(* Principal character (order 1, always returns 1) *)
PrincipalCharacter[p_Integer?PrimeQ, a_Integer] :=
  MultiplicativeCharacter[p, 0, a];

(* Quadratic character = Legendre symbol *)
QuadraticCharacter[p_Integer?PrimeQ, a_Integer] :=
  CharacterByOrder[p, 2, a];

(* Verify: QuadraticCharacter should equal JacobiSymbol *)
VerifyQuadraticCharacter[p_Integer?PrimeQ] :=
  Table[QuadraticCharacter[p, a] == JacobiSymbol[a, p], {a, 1, p - 1}] // And @@ # &;

(* ============================================== *)
(* CHARACTER TABLE                                *)
(* ============================================== *)

(* Generate full character table for prime p *)
(* Rows = characters chi_j, Columns = elements a *)
CharacterTable[p_Integer?PrimeQ] :=
  Table[
    MultiplicativeCharacter[p, j, a] // ExpToTrig // FullSimplify,
    {j, 0, p - 2}, {a, 1, p - 1}
  ];

(* Display character table with labels *)
DisplayCharacterTable[p_Integer?PrimeQ] :=
  Module[{table, header, rows},
    table = CharacterTable[p];
    header = Prepend[Range[1, p - 1], ""];
    rows = Table[
      Prepend[table[[j + 1]], Subscript[\[Chi], j]],
      {j, 0, p - 2}
    ];
    Grid[Prepend[rows, header], Frame -> All]
  ];

(* ============================================== *)
(* GAUSS SUMS                                     *)
(* ============================================== *)

(* Gauss sum: tau(chi_j) = sum_{a=1}^{p-1} chi_j(a) * e^(2*pi*i*a/p) *)
GaussSum[p_Integer?PrimeQ, j_Integer] :=
  Sum[
    MultiplicativeCharacter[p, j, a] * Exp[2 Pi I a / p],
    {a, 1, p - 1}
  ];

(* Quadratic Gauss sum *)
QuadraticGaussSum[p_Integer?PrimeQ] :=
  Sum[JacobiSymbol[a, p] * Exp[2 Pi I a / p], {a, 1, p - 1}];

(* Verify |tau|^2 = p for non-trivial characters *)
VerifyGaussSumNorm[p_Integer?PrimeQ, j_Integer] :=
  Module[{tau},
    If[j == 0, Return["Principal character: |tau|^2 = (p-1)^2"]];
    tau = GaussSum[p, j];
    {"|tau|^2", Abs[tau]^2 // FullSimplify, "Expected", p}
  ];

(* ============================================== *)
(* EXAMPLES                                       *)
(* ============================================== *)

ExampleUsage[] := Module[{},
  Print["=== Multiplicative Characters Demo ==="];
  Print[""];

  Print["1. Character table for p = 7:"];
  Print["   Orders: ", Table[{j, CharacterOrder[7, j]}, {j, 0, 6}]];
  Print["   chi_0 (order 1): ", Table[MultiplicativeCharacter[7, 0, a], {a, 1, 6}]];
  Print["   chi_3 (order 2): ", Table[MultiplicativeCharacter[7, 3, a] // Simplify, {a, 1, 6}]];
  Print["   JacobiSymbol:    ", Table[JacobiSymbol[a, 7], {a, 1, 6}]];
  Print[""];

  Print["2. Quadratic character verification:"];
  Print["   p=7:  ", VerifyQuadraticCharacter[7]];
  Print["   p=13: ", VerifyQuadraticCharacter[13]];
  Print["   p=17: ", VerifyQuadraticCharacter[17]];
  Print[""];

  Print["3. Gauss sum |tau|^2 = p:"];
  Print["   p=7, chi_1: ", VerifyGaussSumNorm[7, 1]];
  Print["   p=7, chi_3: ", VerifyGaussSumNorm[7, 3]];
  Print["   p=13, chi_6: ", VerifyGaussSumNorm[13, 6]];
  Print[""];

  Print["4. CharacterByOrder usage:"];
  Print["   Order 2 mod 7:  ", Table[CharacterByOrder[7, 2, a] // Simplify, {a, 1, 6}]];
  Print["   Order 3 mod 7:  ", Table[CharacterByOrder[7, 3, a] // ExpToTrig // Simplify, {a, 1, 6}]];
  Print["   Order 4 mod 13: ", Table[CharacterByOrder[13, 4, a] // ExpToTrig // Simplify, {a, 1, 12}]];
];

(* Run: ExampleUsage[] *)
