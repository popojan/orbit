#!/usr/bin/env wolframscript
(* FindLinearRecurrence + separate numerator/denominator *)

Print["=== FINDLINEARRECURRENCE + NUM/DEN APPROACH ===\n"];

Print["Part 1: Collect ratios as fractions (numerator/denominator)\n"];
Print["============================================================\n"];

(* Collect exact rational ratios for k=2..15 *)
ratioData = Table[
  n = Ceiling[kval/2];
  m = Floor[kval/2];

  tn = ChebyshevT[n, x+1] // Expand;
  deltaU = ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1] // Expand;
  product = Expand[tn * deltaU];
  coeffs = CoefficientList[product, x];

  Table[
    If[i >= 2 && i+1 <= Length[coeffs] && coeffs[[i]] != 0,
      ratio = coeffs[[i+1]] / coeffs[[i]];
      {kval, i, ratio, Numerator[ratio], Denominator[ratio]}
    ,
      Nothing
    ]
  , {i, 2, Min[kval, Length[coeffs]-1]}]
, {kval, 2, 15}] // Flatten[#, 1]&;

Print["Collected ", Length[ratioData], " data points\n"];
Print["First 10 (k, i, ratio, num, den):\n"];
Do[
  Print["  ", ratioData[[idx]]];
, {idx, 1, Min[10, Length[ratioData]]}];
Print[];

(* ============================================================ *)
Print["Part 2: Try FindLinearRecurrence on ratio values\n"];
Print["=================================================\n"];

ratios = ratioData[[All, 3]];
Print["Ratios (first 20): ", Take[ratios, Min[20, Length[ratios]]]];
Print[];

linRec = FindLinearRecurrence[ratios];
Print["FindLinearRecurrence[ratios]: ", linRec];
Print[];

If[linRec =!= {},
  Print["Found linear recurrence! Length: ", Length[linRec]];
  Print["Recurrence coefficients: ", linRec];
  Print[];

  (* Verify *)
  Print["Verification (using recurrence to predict next values):\n"];
  recLen = Length[linRec];
  Do[
    If[idx + recLen <= Length[ratios],
      predicted = Sum[linRec[[j]] * ratios[[idx + recLen - j]], {j, 1, recLen}];
      actual = ratios[[idx + recLen]];
      Print["  pos ", idx + recLen, ": predicted=", N[predicted],
            ", actual=", N[actual], ", match=", Abs[N[predicted - actual]] < 0.001];
    ];
  , {idx, 1, Min[10, Length[ratios] - recLen]}];
  Print[];
,
  Print["No linear recurrence found (or too complex)\n"];
  Print[];
];

(* ============================================================ *)
Print["Part 3: FindLinearRecurrence on NUMERATORS only\n"];
Print["================================================\n"];

numerators = ratioData[[All, 4]];
Print["Numerators (first 20): ", Take[numerators, Min[20, Length[numerators]]]];
Print[];

linRecNum = FindLinearRecurrence[numerators];
Print["FindLinearRecurrence[numerators]: ", linRecNum];
Print[];

If[linRecNum =!= {},
  Print["Found recurrence for numerators! Length: ", Length[linRecNum]];
  Print[];
];

(* ============================================================ *)
Print["Part 4: FindLinearRecurrence on DENOMINATORS only\n"];
Print["==================================================\n"];

denominators = ratioData[[All, 5]];
Print["Denominators (first 20): ", Take[denominators, Min[20, Length[denominators]]]];
Print[];

linRecDen = FindLinearRecurrence[denominators];
Print["FindLinearRecurrence[denominators]: ", linRecDen];
Print[];

If[linRecDen =!= {},
  Print["Found recurrence for denominators! Length: ", Length[linRecDen]];
  Print[];
];

(* ============================================================ *)
Print["Part 5: Try for FIXED k, varying i\n"];
Print["===================================\n"];

Print["For each k, find linear recurrence in i:\n"];

Do[
  dataForK = Select[ratioData, #[[1]] == kval &];

  If[Length[dataForK] >= 4,
    iVals = dataForK[[All, 2]];
    ratiosForK = dataForK[[All, 3]];

    linRecK = FindLinearRecurrence[ratiosForK];

    Print["k=", kval, " (", Length[dataForK], " points): ", linRecK];

    If[linRecK =!= {} && Length[linRecK] <= 3,
      Print["  Found short recurrence! Verifying...\n"];
      (* Verify *)
      recLen = Length[linRecK];
      Do[
        If[idx + recLen <= Length[ratiosForK],
          predicted = Sum[linRecK[[j]] * ratiosForK[[idx + recLen - j]], {j, 1, recLen}];
          actual = ratiosForK[[idx + recLen]];
          match = Abs[N[predicted - actual]] < 0.001;
          Print["    i=", iVals[[idx + recLen]], ": ", If[match, "✓", "✗"]];
        ];
      , {idx, 1, Min[3, Length[ratiosForK] - recLen]}];
    ];
  ];
, {kval, 4, 10}];

Print[];

(* ============================================================ *)
Print["Part 6: Compare with expected formula structure\n"];
Print["================================================\n"];

Print["Expected: ratio[k,i] = 2(k+i)(k-i+1) / ((2i)(2i-1))\n"];
Print[];

Print["Structure analysis:\n"];
Print["  Numerator: 2(k+i)(k-i+1) = 2(k² + k - ki + ki + i - i²+ k + i)\n"];
Print["                           = 2(k² + 2ki + 2k + 2i - i² - k²)\n"];
Print["                           = 2(k² - i² + 2i + 2k)\n"];
Print["  Denominator: (2i)(2i-1) = 4i² - 2i\n"];
Print[];

Print["For FIXED k, numerator is quadratic in i\n"];
Print["For FIXED k, denominator is quadratic in i\n"];
Print["Therefore ratio is rational function of i\n"];
Print[];

Print["This suggests linear recurrence SHOULD exist for fixed k!\n"];
Print[];

(* ============================================================ *)
Print["=== SUMMARY ===\n"];
Print["Collected ", Length[ratioData], " data points\n"];
Print["Tried FindLinearRecurrence on:\n"];
Print["  - Full ratio sequence\n"];
Print["  - Numerators only\n"];
Print["  - Denominators only\n"];
Print["  - Fixed k, varying i\n"];
Print[];
Print["If recurrence found → strong empirical evidence\n"];
Print["If not → may be too complex or need different organization\n"];
