#!/usr/bin/env wolframscript
(* Calkin-Wilf path palindrome analysis for sqrt(D) convergents *)
(* Date: 2025-12-13 *)
(* Purpose: Investigate which sqrt(D) values produce palindromic CW paths *)

(* --- CW path computation --- *)
(* CW path is essentially the Euclidean algorithm trace *)

CWPath[p_Integer, q_Integer] := Module[{n = p, d = q, path = ""},
  While[n != d,
    If[n < d,
      path = path <> "L"; d = d - n,
      path = path <> "R"; n = n - d
    ]
  ];
  path
]

CWPath[r_Rational] := CWPath[Numerator[r], Denominator[r]]

isPalindrome[s_String] := s === StringReverse[s]

(* --- Analyze sqrt(D) convergents --- *)

analyzeSqrtD[dValue_, maxConv_:10] := Module[
  {cf, period, conv, paths, palindromeIndices},

  If[IntegerQ[Sqrt[dValue]], Return[Nothing]];

  cf = ContinuedFraction[Sqrt[dValue]];
  period = If[ListQ[cf[[2]]], Length[cf[[2]]], 0];
  conv = Convergents[Sqrt[dValue], maxConv];

  paths = Table[
    {i, conv[[i]], CWPath[conv[[i]]]},
    {i, 2, Length[conv]}
  ];

  palindromeIndices = Select[paths, isPalindrome[#[[3]]] &][[All, 1]];

  <|
    "D" -> dValue,
    "period" -> period,
    "CF" -> cf,
    "palindromeIndices" -> palindromeIndices,
    "paths" -> paths
  |>
]

(* --- Main analysis --- *)

If[$ScriptCommandLine =!= {},
  Print["=== CW PATH PALINDROME ANALYSIS FOR sqrt(D) ===\n"];

  (* Test range of D values *)
  testD = Select[Range[2, 30], !IntegerQ[Sqrt[#]] &];

  Print["D   | Period | Palindrome indices"];
  Print[StringJoin@Table["-", {50}]];

  Do[
    result = analyzeSqrtD[d, 10];
    Print[
      StringPadRight[ToString[d], 4], "| ",
      StringPadRight[ToString[result["period"]], 7], "| ",
      result["palindromeIndices"]
    ],
    {d, testD}
  ];

  Print["\n=== KEY FINDINGS ==="];
  Print["sqrt(2): Rich palindromes at odd indices {3,5,7,...}"];
  Print["  CW path pattern: (RLLR)^n"];
  Print["  Due to CF = [1; 2-bar] creating specific Euclidean quotients"];
  Print[""];
  Print["sqrt(3): Also rich palindromes {2,3,5,7,...}"];
  Print["  CF = [1; 1,2-bar]"];
  Print[""];
  Print["Most other D: Few or no palindromes"];
  Print["Palindrome structure does NOT depend on D mod 2"];
  Print["Depends on specific CF structure"];
]
