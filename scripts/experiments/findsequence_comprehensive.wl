#!/usr/bin/env wolframscript
(* FindSequenceFunction with comprehensive data *)

Print["=== FINDSEQUENCEFUNCTION COMPREHENSIVE TEST ===\n"];

Print["Part 1: Collect ratios for multiple k values\n"];
Print["==============================================\n"];

(* Collect ratios for k=1..12, all valid i *)
allRatios = Table[
  n = Ceiling[kval/2];
  m = Floor[kval/2];

  tn = ChebyshevT[n, x+1] // Expand;
  deltaU = ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1] // Expand;
  product = Expand[tn * deltaU];
  coeffs = CoefficientList[product, x];

  Table[
    If[i >= 2 && i+1 <= Length[coeffs] && coeffs[[i]] != 0,
      {kval, i, coeffs[[i+1]] / coeffs[[i]]}
    ,
      Nothing
    ]
  , {i, 2, Min[kval, Length[coeffs]-1]}]
, {kval, 1, 12}] // Flatten[#, 1]&;

Print["Collected ", Length[allRatios], " ratio data points\n"];
Print["First 10: ", Take[allRatios, Min[10, Length[allRatios]]]];
Print[];

(* ============================================================ *)
Print["Part 2: Try FindSequenceFunction on JUST ratios (no k, i)\n"];
Print["==========================================================\n"];

ratioValues = allRatios[[All, 3]];
Print["Ratio values (first 20): ", Take[ratioValues, Min[20, Length[ratioValues]]]];
Print[];

seqFunc = FindSequenceFunction[ratioValues, n];
Print["FindSequenceFunction[ratios, n]: ", seqFunc];
Print[];

If[seqFunc =!= FindSequenceFunction[ratioValues, n],
  Print["Found pattern! Testing...\n"];
  Do[
    predicted = seqFunc /. n -> idx;
    actual = ratioValues[[idx]];
    Print["  n=", idx, ": predicted=", N[predicted], ", actual=", N[actual],
          ", match=", Abs[predicted - actual] < 0.0001];
  , {idx, 1, Min[10, Length[ratioValues]]}];
,
  Print["No simple pattern found in raw sequence.\n"];
];

Print[];

(* ============================================================ *)
Print["Part 3: Try with (k, i) as bivariate\n"];
Print["======================================\n"];

Print["Expected formula: r[k, i] = 2(k+i)(k-i+1)/((2i)(2i-1))\n"];
Print[];

(* Extract k, i, ratio *)
dataPoints = allRatios;
Print["Sample data points (k, i, ratio):\n"];
Do[
  Print["  ", dataPoints[[idx]]];
, {idx, 1, Min[10, Length[dataPoints]]}];
Print[];

(* Try to find bivariate pattern *)
Print["Attempting bivariate FindSequenceFunction...\n"];

(* Create list of {i, ratio} for fixed k values *)
Print["\nApproach A: Fix k, vary i\n"];

Do[
  kfixed = kval;
  dataForK = Select[dataPoints, #[[1]] == kfixed &];

  If[Length[dataForK] >= 3,
    iValues = dataForK[[All, 2]];
    ratioValues_k = dataForK[[All, 3]];

    Print["k=", kfixed, ": ", Length[dataForK], " points"];
    Print["  i values: ", iValues];
    Print["  ratios: ", N[ratioValues_k]];

    seqFunc_k = FindSequenceFunction[ratioValues_k, i];
    Print["  FindSeq: ", seqFunc_k];

    (* Compare with expected *)
    If[seqFunc_k =!= FindSequenceFunction[ratioValues_k, i],
      Print["  Found pattern! Comparing with expected...\n"];
      Do[
        expected = 2*(kfixed+iVal)*(kfixed-iVal+1) / ((2*iVal)*(2*iVal-1));
        predicted = seqFunc_k /. i -> iVal;
        Print["    i=", iVal, ": pred=", N[predicted], ", exp=", N[expected]];
      , {iVal, iValues}];
    ];
    Print[];
  ];
, {kval, 2, 8}];

(* ============================================================ *)
Print["Part 4: Try symbolic ratios (exact)\n"];
Print["====================================\n"];

Print["Using exact rational arithmetic instead of floating point:\n"];

exactRatios = Table[
  n = Ceiling[kval/2];
  m = Floor[kval/2];

  tn = ChebyshevT[n, x+1] // Expand;
  deltaU = ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1] // Expand;
  product = Expand[tn * deltaU];
  coeffs = CoefficientList[product, x];

  Table[
    If[i >= 2 && i+1 <= Length[coeffs] && coeffs[[i]] != 0,
      coeffs[[i+1]] / coeffs[[i]]  (* Exact, not N[] *)
    ,
      Nothing
    ]
  , {i, 2, Min[kval, Length[coeffs]-1]}]
, {kval, 2, 12}] // Flatten;

Print["Exact ratios (first 20): ", Take[exactRatios, Min[20, Length[exactRatios]]]];
Print[];

seqFuncExact = FindSequenceFunction[exactRatios, n];
Print["FindSequenceFunction[exact ratios]: ", seqFuncExact];
Print[];

(* ============================================================ *)
Print["Part 5: Try odd/even separation\n"];
Print["================================\n"];

(* Separate by parity of i *)
oddI = Select[dataPoints, OddQ[#[[2]]] &];
evenI = Select[dataPoints, EvenQ[#[[2]]] &];

Print["Odd i data points: ", Length[oddI]];
Print["Even i data points: ", Length[evenI]];
Print[];

If[Length[oddI] >= 5,
  Print["Trying FindSequenceFunction on odd i values:\n"];
  oddRatios = oddI[[All, 3]];
  seqOdd = FindSequenceFunction[oddRatios, n];
  Print["  Result: ", seqOdd];
  Print[];
];

If[Length[evenI] >= 5,
  Print["Trying FindSequenceFunction on even i values:\n"];
  evenRatios = evenI[[All, 3]];
  seqEven = FindSequenceFunction[evenRatios, n];
  Print["  Result: ", seqEven];
  Print[];
];

(* ============================================================ *)
Print["=== SUMMARY ===\n"];
Print["Total data points collected: ", Length[allRatios]];
Print["FindSequenceFunction attempts: Multiple approaches tried\n"];
Print[];
Print["If FindSequenceFunction found pattern → empirical confirmation\n"];
Print["If not found → formula may be too complex for automatic detection\n"];
Print[];
Print["Note: Even if found, this is EMPIRICAL, not algebraic proof.\n"];
Print["But can give confidence + suggest proof strategy.\n"];
