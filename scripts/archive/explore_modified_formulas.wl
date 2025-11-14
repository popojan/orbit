#!/usr/bin/env wolframscript
(* Explore modified formulas to eliminate alternating sign *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=== Strategy 1: Start sum from j=4 (skip fragile terms) ===\n"];

(* Sum from j=4 onwards, no alternating sign *)
ModifiedSum1[k_] := (1/6) * Sum[j! / (2j + 1), {j, 4, k}] /; k >= 4;

Print["Testing: does Sum[j!/(2j+1), {j, 4, k}] give clean primorials?\n"];
test1 = Table[
  Module[{sum, denom, prim},
    sum = ModifiedSum1[k];
    denom = Denominator[sum];
    prim = Primorial[2k + 1];
    {
      "k" -> k,
      "m=2k+1" -> 2k + 1,
      "Denominator" -> denom,
      "Primorial(m)" -> prim,
      "Ratio D/Prim" -> N[denom/prim],
      "Match?" -> (denom == prim)
    }
  ],
  {k, 4, 15}
];
Print[Dataset[test1]];

Print["\n=== Strategy 2: Piecewise formula ===\n"];

(* For small m, use explicit values or alternating formula *)
(* For large m, use simplified formula *)

PrimorialPiecewise[m_] := Which[
  m == 3, 6,
  m == 5, 30,
  m == 7, 210,
  m >= 9 && OddQ[m], Denominator[(1/6) * Sum[j! / (2j + 1), {j, 1, (m-1)/2}]],
  True, "Invalid m"
];

Print["Testing piecewise formula:"];
test2 = Table[
  {
    "m" -> m,
    "Piecewise result" -> PrimorialPiecewise[m],
    "True Primorial" -> Primorial[m],
    "Match?" -> (PrimorialPiecewise[m] == Primorial[m])
  },
  {m, 3, 23, 2}
];
Print[Dataset[test2]];

Print["\n=== Strategy 3: Subtract fragile terms and add correction ===\n"];

(* Full sum minus fragile terms, then add corrected versions *)
CorrectedSum[k_] := Module[{fullSum, fragileTerms, correction},
  (* Non-alternating sum from j=1 *)
  fullSum = Sum[j! / (2j + 1), {j, 1, k}];

  (* Fragile terms j=1,2,3 without alternating sign *)
  fragileTerms = Sum[j! / (2j + 1), {j, 1, Min[3, k]}];

  (* Corrected fragile terms WITH alternating sign *)
  correction = Sum[(-1)^j * j! / (2j + 1), {j, 1, Min[3, k]}];

  (* Subtract bad, add good *)
  (1/6) * (fullSum - fragileTerms + correction)
] /; k >= 1;

Print["Testing corrected formula:"];
test3 = Table[
  Module[{corr, denom, prim},
    corr = CorrectedSum[k];
    denom = Denominator[corr];
    prim = Primorial[2k + 1];
    {
      "k" -> k,
      "m" -> 2k + 1,
      "Denominator" -> denom,
      "Primorial" -> prim,
      "Match?" -> (denom == prim)
    }
  ],
  {k, 1, 15}
];
Print[Dataset[test3]];

Print["\n=== Strategy 4: Factorial-based correction ===\n"];

(* Can we express the correction for m<9 as a simple formula? *)
AnalyzeCorrection[m_] := Module[{alt, noAlt},
  alt = (1/2) * Sum[(-1)^j * j! / (2j + 1), {j, 1, (m-1)/2}];
  noAlt = (1/6) * Sum[j! / (2j + 1), {j, 1, (m-1)/2}];
  {
    "m" -> m,
    "Denom (alt)" -> Denominator[alt],
    "Denom (no alt)" -> Denominator[noAlt],
    "Ratio" -> Denominator[noAlt] / Denominator[alt],
    "Extra factor" -> FactorInteger[Denominator[noAlt] / Denominator[alt]]
  }
];

Print["Analyzing correction needed for small m:"];
corrections = Table[AnalyzeCorrection[m], {m, 3, 11, 2}];
Print[Dataset[corrections]];

Print["\n=== Strategy 5: Recurrence for primorials ===\n"];

(* Can we derive: Primorial(p_{n+1}) from Primorial(p_n) using the sum structure? *)
Print["Ratio of consecutive primorials (should be next prime):"];
ratios = Table[
  Module[{p1, p2},
    p1 = Primorial[Prime[n]];
    p2 = Primorial[Prime[n+1]];
    {
      "n" -> n,
      "p_n" -> Prime[n],
      "Primorial(p_n)" -> p1,
      "Primorial(p_{n+1})" -> p2,
      "Ratio" -> p2/p1,
      "Should be" -> Prime[n+1]
    }
  ],
  {n, 3, 10}
];
Print[Dataset[ratios]];

Print["\n=== Strategy 6: Express as product formula ===\n"];

(* Is there a product representation of the sum that makes primorial structure explicit? *)
Print["Investigating product structure...\n"];

(* Compute partial products in the sum *)
PartialProductAnalysis[k_] := Module[{terms},
  terms = Table[j! / (2j + 1), {j, 1, k}];
  {
    "k" -> k,
    "Terms" -> terms,
    "Denominators" -> Denominator /@ terms,
    "LCM of denoms" -> LCM @@ (Denominator /@ terms),
    "Primorial" -> Primorial[2k + 1]
  }
];

Print["LCM of all term denominators vs Primorial:"];
lcmAnalysis = Table[
  Module[{terms, denoms, lcm, prim},
    terms = Table[j! / (2j + 1), {j, 1, k}];
    denoms = Denominator /@ terms;
    lcm = LCM @@ denoms;
    prim = Primorial[2k + 1];
    {
      "k" -> k,
      "LCM" -> lcm,
      "Primorial" -> prim,
      "Ratio" -> N[lcm/prim]
    }
  ],
  {k, 1, 10}
];
Print[Dataset[lcmAnalysis]];
