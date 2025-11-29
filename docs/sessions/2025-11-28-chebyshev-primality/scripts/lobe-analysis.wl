(* Chebyshev Lobe Analysis *)
(* Session: 2025-11-28-chebyshev-primality *)

(* === DEFINITIONS === *)

(* Lobe n spans θ ∈ [(n-1)π/k, nπ/k] *)
lobeArea[k_Integer, n_Integer] :=
  NIntegrate[Abs[Sin[k t]] Sin[t]^2, {t, (n-1) Pi/k, n Pi/k}];

(* All lobe areas for given k *)
allLobeAreas[k_Integer] := Table[lobeArea[k, n], {n, 1, k}];

(* Zero point n is primitive iff gcd(n, k) = 1 *)
isPrimitiveZero[n_Integer, k_Integer] := GCD[n, k] == 1;

(* Lobe n is primitive iff BOTH boundaries are primitive *)
isPrimitiveLobe[n_Integer, k_Integer] :=
  GCD[n-1, k] == 1 && GCD[n, k] == 1;

(* Count primitive zeros (should equal EulerPhi[k]) *)
countPrimitiveZeros[k_Integer] :=
  Count[Range[k-1], n_ /; isPrimitiveZero[n, k]];

(* Indices of primitive lobes *)
primitiveLobeIndices[k_Integer] :=
  Select[Range[k], isPrimitiveLobe[#, k] &];

(* === ANALYSIS FUNCTIONS === *)

(* Full analysis for a given k *)
analyzeK[k_Integer] := Module[{areas, primIdx, primArea, inhArea},
  areas = allLobeAreas[k];
  primIdx = primitiveLobeIndices[k];

  primArea = Total[areas[[primIdx]]];
  inhArea = 1 - primArea;

  <|
    "k" -> k,
    "factors" -> FactorInteger[k],
    "isPrime" -> PrimeQ[k],
    "numLobes" -> k,
    "numPrimitiveLobes" -> Length[primIdx],
    "numPrimitiveZeros" -> countPrimitiveZeros[k],
    "eulerPhi" -> EulerPhi[k],
    "primitiveArea" -> primArea,
    "inheritedArea" -> inhArea,
    "lobeAreas" -> areas
  |>
];

(* === VERIFICATION === *)

(* Verify: primitive zeros count = φ(k) *)
verifyPhiConjecture[kMax_Integer] := Module[{results},
  results = Table[
    {k, countPrimitiveZeros[k], EulerPhi[k],
     countPrimitiveZeros[k] == EulerPhi[k]},
    {k, 2, kMax}
  ];
  AllTrue[results, #[[4]] &]
];

(* Asymptotic constant for prime edge lobes *)
edgeLobeConstant = 2 (Pi^2 - 4);  (* ≈ 11.739 *)

(* Predicted edge area for prime p *)
predictedEdgeArea[p_?PrimeQ] := edgeLobeConstant / p^3;

(* === EXAMPLE USAGE === *)
(*
Print["Analysis for k=7 (prime):"];
Print[analyzeK[7]];

Print["\nAnalysis for k=12 (composite):"];
Print[analyzeK[12]];

Print["\nVerify φ conjecture for k ≤ 30: ", verifyPhiConjecture[30]];
*)
