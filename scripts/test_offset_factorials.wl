#!/usr/bin/env wolframscript
(* Test (k-a)! starting from k=a to see if we can eliminate the factorial hammer *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=" ~~ StringRepeat["=", 70]];
Print["Testing Offset Factorial Sums: Can We Eliminate The Hammer?"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

(* Test for various offsets a *)
TestOffset[a_, mMax_: 41] := Module[
  {results},

  Print["Testing: (k-", a, ")! starting from k=", a];
  Print[StringRepeat["-", 70]];

  results = Table[
    Module[{kMax, sum, denom, prim, ratio},
      kMax = Floor[(m-1)/2];

      If[kMax < a,
        (* Not enough terms *)
        {m, "N/A", "N/A", "N/A"},

        (* Compute sum *)
        sum = Sum[(-1)^k * (k-a)!/(2k+1), {k, a, kMax}];
        denom = Denominator[sum];
        prim = Primorial[m];
        ratio = prim/denom;

        {m, denom, prim, ratio}
      ]
    ],
    {m, 3, mMax, 2}
  ];

  (* Filter out N/A rows *)
  validResults = Select[results, #[[2]] =!= "N/A" &];

  (* Check for consistent ratio *)
  If[Length[validResults] > 0,
    ratios = validResults[[All, 4]];
    integerRatios = Select[ratios, IntegerQ[#] && # > 0 &];
    uniqueRatios = DeleteDuplicates[integerRatios];

    (* Show first few and last few results *)
    Print["First results:"];
    Do[
      {m, denom, prim, ratio} = row;
      Print["  m=", m, ": ratio = ", ratio,
            If[IntegerQ[ratio] && ratio > 0,
              " (missing " <> ToString[FactorInteger[ratio][[All,1]]] <> ")",
              ""
            ]];
      ,
      {row, Take[validResults, UpTo[5]]}
    ];

    If[Length[validResults] > 10,
      Print["  ..."];
      Do[
        {m, denom, prim, ratio} = row;
        Print["  m=", m, ": ratio = ", ratio,
              If[IntegerQ[ratio] && ratio > 0,
                " (missing " <> ToString[FactorInteger[ratio][[All,1]]] <> ")",
                ""
              ]];
        ,
        {row, Take[validResults, -3]}
      ];
    ];

    Print["\nPattern:"];
    If[Length[uniqueRatios] == 1 && uniqueRatios[[1]] > 1,
      Print["  ✓ CONSISTENT! Ratio = ", uniqueRatios[[1]]];
      Print["  ✓ Formula gives: Primorial/", uniqueRatios[[1]]];
      Print["  ✓ Missing primes: ", FactorInteger[uniqueRatios[[1]]][[All, 1]]];
      ,
      If[AllTrue[ratios, # == 1 &],
        Print["  ✓ FULL PRIMORIAL!"];
        ,
        Print["  ✗ Inconsistent ratios: ", Take[uniqueRatios, UpTo[5]]];
      ]
    ];
  ];

  Print["\n"];
  validResults
];

(* Test a=0 through a=10 *)
Print["SYSTEMATIC TEST: Does larger offset eliminate the factorial?\n"];

summaryData = Table[
  results = TestOffset[a, 41];

  If[Length[results] > 0,
    ratios = results[[All, 4]];
    integerRatios = Select[ratios, IntegerQ[#] && # > 0 &];
    uniqueRatios = DeleteDuplicates[integerRatios];

    status = If[Length[uniqueRatios] == 1,
      If[uniqueRatios[[1]] == 1,
        "Full primorial",
        "Primorial/" <> ToString[uniqueRatios[[1]]]
      ],
      "Inconsistent"
    ];

    {a, Length[results], status}
    ,
    {a, "N/A", "N/A"}
  ]
  ,
  {a, 0, 10}
];

Print["=" ~~ StringRepeat["=", 70]];
Print["SUMMARY TABLE"];
Print["=" ~~ StringRepeat["=", 70]];
Print["Offset a | Terms tested | Result"];
Print[StringRepeat["-", 70]];
Do[
  {a, nTerms, status} = row;
  Print[StringPadRight[ToString[a], 8], " | ",
        StringPadRight[ToString[nTerms], 13], " | ", status];
  ,
  {row, summaryData}
];

Print["\n" ~~ StringRepeat["=", 70]];
Print["CONCLUSION: Can we eliminate the factorial hammer?"];
Print[StringRepeat["=", 70]];

(* Check if any offset gives consistent partial primorial *)
consistentOffsets = Select[summaryData,
  #[[3]] =!= "Inconsistent" && #[[3]] =!= "N/A" &
];

If[Length[consistentOffsets] > 0,
  Print["\n✓ YES! The following offsets work:"];
  Do[
    {a, nTerms, status} = row;
    Print["  a=", a, ": ", status, " (", nTerms, " values tested)"];
    ,
    {row, consistentOffsets}
  ];

  (* Check if we can use constant (no factorial) *)
  If[MemberQ[consistentOffsets[[All, 1]], _?( # >= 5 &)],
    Print["\n✓✓ MAJOR FINDING: Large offsets work!"];
    Print["   This suggests the factorial may not be essential for the tail!");
  ];
  ,
  Print["\n✗ No consistent patterns found beyond (k-1)!"];
];

Print["\nDone!"];
