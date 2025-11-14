#!/usr/bin/env wolframscript
(* Explore formulas without alternating sign *)

(* Original formula WITH alternating sign *)
PrimorialWithSign[k_] := Module[{sum},
  sum = Sum[(-1)^j * j! / (2j + 1), {j, 1, k}];
  {Numerator[sum], Denominator[sum]}
];

(* Formula WITHOUT alternating sign *)
PrimorialNoSign[k_] := Module[{sum},
  sum = Sum[j! / (2j + 1), {j, 1, k}];
  {Numerator[sum], Denominator[sum]}
];

(* Formula WITHOUT alternating sign, scaled by 1/6 as user mentioned *)
PrimorialNoSignScaled[k_] := Module[{sum},
  sum = (1/6) * Sum[j! / (2j + 1), {j, 1, k}];
  {Numerator[sum], Denominator[sum]}
];

(* Primorial for comparison *)
Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=== Testing formula WITHOUT alternating sign ===\n"];

(* Test from k=1 to k=15 *)
Print["Comparing denominators with and without alternating sign:\n"];
comparisonTable = Table[
  Module[{withSign, noSign, noSignScaled, prim},
    withSign = PrimorialWithSign[k];
    noSign = PrimorialNoSign[k];
    noSignScaled = PrimorialNoSignScaled[k];
    prim = Primorial[2k + 1];
    {
      "k" -> k,
      "m=2k+1" -> 2k + 1,
      "With sign: B_k" -> withSign[[2]],
      "No sign: B_k" -> noSign[[2]],
      "No sign scaled: B_k" -> noSignScaled[[2]],
      "Primorial(m)" -> prim,
      "With sign = Prim?" -> (withSign[[2]] == prim),
      "No sign = Prim?" -> (noSign[[2]] == prim),
      "No sign scaled = Prim?" -> (noSignScaled[[2]] == prim)
    }
  ],
  {k, 1, 15}
];

Print[Dataset[comparisonTable]];

(* Focus on k >= 4 (after p=3 boundary) *)
Print["\n=== Analyzing k >= 4 (stable regime) ===\n"];
stableData = Table[
  Module[{withSign, noSign, prim, ratio},
    withSign = PrimorialWithSign[k];
    noSign = PrimorialNoSign[k];
    prim = Primorial[2k + 1];
    ratio = noSign[[2]] / prim;
    {
      "k" -> k,
      "B_k (no sign)" -> noSign[[2]],
      "Primorial(m)" -> prim,
      "Ratio B_k/Prim" -> ratio,
      "Factorization of ratio" -> If[IntegerQ[ratio], FactorInteger[ratio], "not integer"]
    }
  ],
  {k, 4, 12}
];

Print[Dataset[stableData]];

(* Check if there's a pattern in the ratio for no-sign formula *)
Print["\n=== Pattern in ratio for k >= 7 ===\n"];
ratioPattern = Table[
  Module[{noSign, prim, num, den, g},
    noSign = PrimorialNoSign[k];
    prim = Primorial[2k + 1];
    g = GCD[noSign[[1]], noSign[[2]]];
    {
      "k" -> k,
      "GCD(N,D)" -> g,
      "D/Primorial" -> noSign[[2]]/prim,
      "D/Primorial factored" -> FactorInteger[noSign[[2]]/prim]
    }
  ],
  {k, 7, 15}
];

Print[Dataset[ratioPattern]];

(* Modular arithmetic approach: compute A_k mod each prime *)
Print["\n=== Modular arithmetic approach ===\n"];

(* For small k, compute A_k mod each prime p <= 2k+1 *)
ReducedNumeratorModPrime[k_, p_] := Module[{sum, prim},
  If[p > 2k + 1, Return[Indeterminate]];
  sum = Sum[(-1)^j * j! / (2j + 1), {j, 1, k}];
  prim = Primorial[2k + 1];
  (* A_k = Numerator[sum] = sum * prim in lowest terms *)
  (* So A_k mod p = (sum * prim) mod p *)
  Mod[Numerator[sum], p]
];

Print["A_k mod p for k=5:"];
k = 5;
primesUpTo = Select[Range[2, 2k + 1], PrimeQ];
modData = Table[{p, ReducedNumeratorModPrime[k, p]}, {p, primesUpTo}];
Print[Grid[Prepend[modData, {"Prime p", "A_5 mod p"}], Frame -> All]];

(* Key insight: if we can compute A_k mod p for each prime efficiently,
   we can reconstruct A_k using CRT since we know the exact denominator *)

Print["\n=== Testing hybrid formula: alternating for k<=3, not for k>3 ===\n"];

HybridSum[kmax_] := Module[{sum1, sum2},
  (* Use alternating for k=1,2,3 *)
  sum1 = Sum[(-1)^j * j! / (2j + 1), {j, 1, Min[3, kmax]}];
  (* No alternating for k>3 *)
  If[kmax > 3,
    sum2 = Sum[j! / (2j + 1), {j, 4, kmax}];
    sum1 + sum2,
    sum1
  ]
];

Print["Hybrid formula test:"];
hybridTest = Table[
  Module[{hybrid, prim},
    hybrid = HybridSum[k];
    prim = Primorial[2k + 1];
    {
      "k" -> k,
      "Hybrid denominator" -> Denominator[hybrid],
      "Primorial(m)" -> prim,
      "Match?" -> (Denominator[hybrid] == prim)
    }
  ],
  {k, 1, 10}
];
Print[Dataset[hybridTest]];
