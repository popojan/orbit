(* ::Package:: *)

(* Closed-Form Semiprime Factorization via Fractional Parts *)

BeginPackage["Orbit`"];

(* Usage messages *)
ForFacti::usage = "ForFacti[n] computes the sum formula using Pochhammer symbols: Sum[(-1)^i * Pochhammer[1-n,i] * Pochhammer[1+n,i] / (1+2i), {i, 1, Floor[(Sqrt[n]-1)/2]}].";

ForFactiMod::usage = "ForFactiMod[n] computes the same sum as ForFacti[n] but with Mod[_, 1] applied to each term. For semiprime n = p*q (p <= q), this returns (p-1)/p where p is the smaller factor.";

ExtractSmallerFactor::usage = "ExtractSmallerFactor[n] extracts the smaller factor p of semiprime n = p*q using ForFactiMod[n]. Returns p = 1/(1 - ForFactiMod[n]).";

FactorizeSemiprime::usage = "FactorizeSemiprime[n] returns {p, q} where n = p*q and p <= q, using the closed-form formula.";

VerifySemiprimeFactorization::usage = "VerifySemiprimeFactorization[n] verifies that the formula correctly factors semiprime n.";

(* Batch verification *)
BatchVerifySemiprimes::usage = "BatchVerifySemiprimes[semiprimes] verifies the factorization formula on a list of semiprimes.";

Begin["`Private`"];

(* Core formula: Sum with Pochhammer symbols *)
(* Original formula without Mod *)
ForFacti[n_Integer] := Module[{m},
  m = Floor[1/2 * (-1 + Sqrt[n])];
  Sum[
    ((-1)^i * Pochhammer[1 - n, i] * Pochhammer[1 + n, i])/(1 + 2*i),
    {i, 1, m}
  ]
];

(* Modified formula with Mod[_, 1] applied to each term in the sum *)
(* For semiprime n = p*q, this gives (q-1)/q where q >= p *)
ForFactiMod[n_Integer] := Module[{m},
  m = Floor[1/2 * (-1 + Sqrt[n])];
  Sum[
    Mod[((-1)^i * Pochhammer[1 - n, i] * Pochhammer[1 + n, i])/(1 + 2*i), 1],
    {i, 1, m}
  ]
];

(* Extract the smaller factor using the Mod formula *)
ExtractSmallerFactor[n_Integer] := Module[{result},
  result = ForFactiMod[n];
  (* result = (p-1)/p, so p = 1/(1 - result) *)
  If[result == 0,
    $Failed,
    Round[1/(1 - result)]
  ]
];

(* Complete factorization of semiprime *)
FactorizeSemiprime[n_Integer] := Module[{p, q},
  p = ExtractSmallerFactor[n];
  If[p === $Failed,
    $Failed,
    Module[{},
      q = n/p;
      If[IntegerQ[q] && p <= q,
        {p, q},
        $Failed
      ]
    ]
  ]
];

(* Standard factorization for comparison *)
StandardSemiprimeFactorization[n_Integer] := Module[{factors},
  factors = FactorInteger[n];
  If[Length[factors] == 2 && Total[factors[[All, 2]]] == 2,
    (* True semiprime *)
    Sort[factors[[All, 1]]],
    If[Length[factors] == 1 && factors[[1, 2]] == 2,
      (* Square of prime *)
      {factors[[1, 1]], factors[[1, 1]]},
      (* Not a semiprime *)
      $Failed
    ]
  ]
];

(* Verify the formula *)
VerifySemiprimeFactorization[n_Integer] := Module[{computed, standard, match},
  computed = FactorizeSemiprime[n];
  standard = StandardSemiprimeFactorization[n];
  match = (computed === standard);
  Association[{
    "n" -> n,
    "Computed" -> computed,
    "Standard" -> standard,
    "Match" -> match,
    "ForFacti[n]" -> ForFacti[n],
    "Fractional part" -> Mod[ForFacti[n], 1]
  }]
];

(* Batch verification *)
BatchVerifySemiprimes[semiprimes_List] := Module[{results},
  results = VerifySemiprimeFactorization /@ semiprimes;
  Association[{
    "Total tested" -> Length[results],
    "All match" -> AllTrue[results, #["Match"] &],
    "Failures" -> Select[results, !#["Match"] &],
    "Results" -> results
  }]
];

(* Generate test semiprimes *)
GenerateTestSemiprimes[count_Integer : 20] := Module[{primes, semiprimes},
  primes = Prime[Range[2, 20]];
  semiprimes = DeleteDuplicates[Flatten[Table[p*q, {p, primes}, {q, primes}]]];
  Take[Sort[semiprimes], UpTo[count]]
];

End[];
EndPackage[];
