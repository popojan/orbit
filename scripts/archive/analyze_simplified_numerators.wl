#!/usr/bin/env wolframscript
(* Analyze numerators of the simplified (non-alternating, 1/6 factor) formula *)

(* Simplified formula for k >= 4 *)
SimplifiedFormula[k_] := (1/6) * Sum[j! / (2j + 1), {j, 1, k}];

(* Primorial *)
Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=== Numerators of simplified formula (1/6, no alternating sign) ===\n"];

(* Compute numerators for k=4 to 20 *)
numerators = Table[Numerator[SimplifiedFormula[k]], {k, 4, 20}];

Print["N'_k for simplified formula:"];
Print[numerators];

(* Compare with alternating formula numerators *)
AlternatingFormula[k_] := (1/2) * Sum[(-1)^j * j! / (2j + 1), {j, 1, k}];
numeratorsAlt = Table[Numerator[AlternatingFormula[k]], {k, 4, 20}];

Print["\nN_k for alternating formula:"];
Print[numeratorsAlt];

(* Analyze structure *)
Print["\n=== Structural comparison ===\n"];
comparison = Table[
  {
    "k" -> k,
    "N'_k (simplified)" -> Numerator[SimplifiedFormula[k]],
    "N_k (alternating)" -> Numerator[AlternatingFormula[k]],
    "Ratio N'/N" -> N[Numerator[SimplifiedFormula[k]] / Numerator[AlternatingFormula[k]]],
    "Prime factors N'" -> Length[FactorInteger[Abs[Numerator[SimplifiedFormula[k]]]]],
    "Prime factors N" -> Length[FactorInteger[Abs[Numerator[AlternatingFormula[k]]]]]
  },
  {k, 4, 12}
];
Print[Dataset[comparison]];

(* Search for patterns in simplified numerators *)
Print["\n=== Pattern search in simplified numerators ===\n"];

seqFunc = Quiet[FindSequenceFunction[numerators, k]];
If[seqFunc =!= $Failed,
  Print["Found closed form: ", seqFunc],
  Print["No simple closed form found"]
];

(* Try FindLinearRecurrence *)
Print["\nSearching for linear recurrence..."];
recurrence = Quiet[FindLinearRecurrence[numerators]];
If[Length[recurrence] > 0 && Length[recurrence] < 10,
  Print["Found linear recurrence with order ", Length[recurrence]],
  Print["Coefficients: ", recurrence],
  Print["No simple linear recurrence found (or order > 10)"]
];

(* Prime factorizations *)
Print["\n=== Prime factorizations of N'_k ===\n"];
Do[
  Print["k=", k, ": ", FactorInteger[Abs[Numerator[SimplifiedFormula[k]]]]],
  {k, 4, 12}
];

(* Check if simplified numerators are "simpler" *)
Print["\n=== Simplicity metrics ===\n"];
simplicity = Table[
  Module[{nSimp, nAlt, factSimp, factAlt},
    nSimp = Abs[Numerator[SimplifiedFormula[k]]];
    nAlt = Abs[Numerator[AlternatingFormula[k]]];
    factSimp = FactorInteger[nSimp];
    factAlt = FactorInteger[nAlt];
    {
      "k" -> k,
      "Digits(N')" -> IntegerLength[nSimp],
      "Digits(N)" -> IntegerLength[nAlt],
      "# Prime factors N'" -> Length[factSimp],
      "# Prime factors N" -> Length[factAlt],
      "Max exponent N'" -> If[Length[factSimp] > 0, Max[factSimp[[All, 2]]], 0],
      "Max exponent N" -> If[Length[factAlt] > 0, Max[factAlt[[All, 2]]], 0]
    }
  ],
  {k, 4, 15}
];
Print[Dataset[simplicity]];

(* Divisibility patterns *)
Print["\n=== Divisibility by small primes ===\n"];
Print["For simplified numerators N'_k:"];
primesToCheck = {2, 3, 5, 7, 11, 13};
divTableSimp = Table[
  {k, Table[Mod[Numerator[SimplifiedFormula[k]], p], {p, primesToCheck}]},
  {k, 4, 15}
];
Print[Grid[Prepend[divTableSimp, Prepend[primesToCheck, "k"]], Frame -> All]];
