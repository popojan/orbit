#!/usr/bin/env wolframscript
(* Search for patterns in REDUCED numerators using FindSequenceFunction *)

(* Compute reduced numerator for given k *)
ReducedNumerator[k_] := Module[{sum, reduced},
  sum = Sum[(-1)^j * j! / (2j + 1), {j, 1, k}];
  Numerator[sum]
];

(* Compute reduced denominator (should be primorial) *)
ReducedDenominator[k_] := Module[{sum},
  sum = Sum[(-1)^j * j! / (2j + 1), {j, 1, k}];
  Denominator[sum]
];

(* Primorial for comparison *)
Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["Computing reduced numerators and denominators..."];
data = Table[
  {
    "k" -> k,
    "m" -> 2k + 1,
    "A_k" -> ReducedNumerator[k],
    "B_k" -> ReducedDenominator[k],
    "Primorial(m)" -> Primorial[2k + 1],
    "B_k == Primorial?" -> (ReducedDenominator[k] == Primorial[2k + 1])
  },
  {k, 1, 12}
];

Print[Dataset[data]];

(* Extract just the numerators *)
numerators = Table[ReducedNumerator[k], {k, 1, 20}];
Print["\nReduced numerators A_k:"];
Print[numerators];

(* Try FindSequenceFunction *)
Print["\nSearching for closed form with FindSequenceFunction..."];
seqFunc = Quiet[FindSequenceFunction[numerators, k]];
If[seqFunc =!= $Failed,
  Print["Found closed form: ", seqFunc],
  Print["No simple closed form found"]
];

(* Try rational approximations and relationships *)
Print["\nAnalyzing ratios A_{k+1}/A_k:"];
ratios = Table[N[ReducedNumerator[k + 1]/ReducedNumerator[k]], {k, 1, 15}];
Print[ratios];

(* Try FindGeneratingFunction *)
Print["\nSearching for generating function..."];
genFunc = Quiet[FindGeneratingFunction[numerators, x]];
If[genFunc =!= $Failed && genFunc =!= Indeterminate,
  Print["Found generating function: ", genFunc],
  Print["No simple generating function found"]
];

(* Look for recurrence relations *)
Print["\nSearching for recurrence relation with FindLinearRecurrence..."];
recurrence = Quiet[FindLinearRecurrence[numerators]];
If[Length[recurrence] > 0 && Length[recurrence] < 10,
  Print["Found linear recurrence with coefficients: ", recurrence],
  Print["No simple linear recurrence found (or order > 10)"]
];

(* Analyze structure: prime factorizations *)
Print["\nPrime factorizations of A_k:"];
Do[
  Print["k=", k, ": ", FactorInteger[Abs[ReducedNumerator[k]]]],
  {k, 1, 10}
];

(* Check divisibility patterns *)
Print["\nDivisibility by small primes:"];
primesToCheck = {2, 3, 5, 7, 11, 13};
divTable = Table[
  {k, Table[Mod[ReducedNumerator[k], p], {p, primesToCheck}]},
  {k, 1, 15}
];
Print[Grid[Prepend[divTable, Prepend[primesToCheck, "k"]], Frame -> All]];

(* Check if there's a relationship to factorial or primorial *)
Print["\nRatios to factorials and primorials:"];
factRelations = Table[
  {
    "k" -> k,
    "A_k / k!" -> N[ReducedNumerator[k] / k!],
    "A_k / Primorial(2k+1)" -> N[ReducedNumerator[k] / Primorial[2k + 1]]
  },
  {k, 1, 10}
];
Print[Dataset[factRelations]];
