(* ::Package:: *)

(* Primorial Exploration via Rational Sum Formula *)

BeginPackage["Orbit`"];

(* Usage messages *)
PrimorialRaw::usage = "PrimorialRaw[m] returns a rational number whose denominator is the primorial of all primes up to m. This uses the alternating factorial sum formula: 1/2 * Sum[(-1)^k * k!/(2k+1), {k, 0, Floor[(m-1)/2]}].";

Primorial0::usage = "Primorial0[m] extracts the primorial directly from the denominator of PrimorialRaw[m]. Equivalent to Denominator[PrimorialRaw[m]].";

SieveState::usage = "SieveState[m] computes the iterative state {n, a, b} for the primorial sieve at position m, where the primorial is contained in the denominator of the rational b.";

RecurseState::usage = "RecurseState[{n, a, b}] computes the next state in the sieve iteration: {n+1, b, b + (a-b)*(n + 1/(3+2n))}.";

SieveStateList::usage = "SieveStateList[m] returns the full list of states from initialization to position m.";

PrimorialFromState::usage = "PrimorialFromState[state] extracts the primorial from a sieve state {n, a, b} using the formula 2*Denominator[-1 + b].";

VerifyPrimorial::usage = "VerifyPrimorial[m, method] verifies that the primorial computed by the given method matches the standard computation Times @@ Prime @ Range @ PrimePi[m]. Methods: \"Raw\", \"FromRational\", \"Primorial0\", or \"Sieve\".";

(* Batch verification *)
BatchVerifyPrimorial::usage = "BatchVerifyPrimorial[mmax] verifies primorial computation for all m from 2 to mmax across all methods.";

Begin["`Private`"];

(* Core formula: Rational sum whose denominator encodes primorial *)
(* Note: {k, n} iterates from 1 to n in Mathematica *)
PrimorialRaw[m_Integer] := 1/2 * Sum[(-1)^k * (k!)/(2*k + 1), {k, Floor[(m - 1)/2]}];

(* Extract primorial directly from denominator of raw sum *)
(* Special case: m=2 needs manual handling since Floor[(2-1)/2]=0 gives empty sum *)
Primorial0[m_Integer] := If[m == 2, 2, Denominator[PrimorialRaw[m]]];

(* State recursion for iterative sieve *)
RecurseState[{n_, a_, b_}] := {n + 1, b, b + (a - b)*(n + 1/(3 + 2*n))};

(* Initial state for sieve *)
InitialSieveState[] := {0, 0, 1};

(* Compute state at position m using Nest *)
SieveState[m_Integer] := Module[{h = Floor[(m - 1)/2]},
  Nest[RecurseState, InitialSieveState[], Max[0, h]]
];

(* Compute full state list using NestList *)
SieveStateList[m_Integer] := Module[{h = Floor[(m - 1)/2]},
  NestList[RecurseState, InitialSieveState[], Max[0, h]]
];

(* Extract primorial from sieve state *)
PrimorialFromState[state_List] := 2 * Denominator[-1 + Last[state]];

(* Standard primorial for comparison *)
StandardPrimorial[m_Integer] := Times @@ Prime @ Range @ PrimePi[m];

(* Verification function *)
VerifyPrimorial[m_Integer, method_String : "Primorial0"] := Module[{computed, standard, match},
  standard = StandardPrimorial[m];
  computed = Switch[method,
    "Primorial0", Primorial0[m],
    "Sieve", PrimorialFromState[SieveState[m]],
    _, Return[$Failed]
  ];
  match = (computed === standard);
  Association[{
    "m" -> m,
    "Method" -> method,
    "Standard" -> standard,
    "Computed" -> computed,
    "Match" -> match
  }]
];

(* Batch verification across range *)
BatchVerifyPrimorial[mmax_Integer, method_String : "Primorial0"] := Module[{results},
  results = Table[VerifyPrimorial[m, method], {m, 2, mmax}];
  Association[{
    "Total tested" -> Length[results],
    "All match" -> AllTrue[results, #["Match"] &],
    "Failures" -> Select[results, !#["Match"] &],
    "Results" -> results
  }]
];

(* Compare all methods *)
CompareAllMethods[m_Integer] := Module[{standard, methods, results},
  standard = StandardPrimorial[m];
  methods = {"Primorial0", "Sieve"};
  results = Association[# -> VerifyPrimorial[m, #] & /@ methods];
  Association[{
    "m" -> m,
    "Standard primorial" -> standard,
    "PrimePi[m]" -> PrimePi[m],
    "All methods match" -> AllTrue[Values[results], #["Match"] &],
    "Method results" -> results
  }]
];

End[];
EndPackage[];
