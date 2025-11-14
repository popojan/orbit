#!/usr/bin/env wolframscript
(* Investigate the role of the alternating sign in the primorial formula *)

(* Load local Orbit paclet *)
PacletDirectoryLoad[FileNameJoin[{DirectoryName[$InputFileName], "..", "Orbit"}]];
<< Orbit`

Print["=== ALTERNATING SIGN INVESTIGATION ===\n"];

(* Compute with and without alternating sign *)
ComputeBothVersions[kMax_] := Module[{withSign, withoutSign},
  (* With alternating sign: standard formula *)
  withSign = NestList[
    Function[{state},
      Module[{n, a, bn, bd, factorNum, factorDen, newN, newA, newBN, newBD},
        {n, a, {bn, bd}} = state;
        factorNum = (3 + 2*n)*n + 1;
        factorDen = 3 + 2*n;
        newN = n + 1;
        newA = bn/bd;
        newBN = bn*factorDen + (a*bd - bn)*factorNum;
        newBD = bd*factorDen;
        {newN, newA, {newBN, newBD}}
      ]
    ],
    {0, 0, {1, 1}},
    kMax
  ];

  (* Without alternating sign: all terms positive *)
  withoutSign = NestList[
    Function[{state},
      Module[{n, a, bn, bd, factorNum, factorDen, newN, newA, newBN, newBD},
        {n, a, {bn, bd}} = state;
        factorNum = (3 + 2*n)*n + 1;
        factorDen = 3 + 2*n;
        newN = n + 1;
        newA = bn/bd;
        (* Remove alternating sign: use + instead of (a*bd - bn) *)
        newBN = bn*factorDen + (a*bd + bn)*factorNum; (* Changed - to + *)
        newBD = bd*factorDen;
        {newN, newA, {newBN, newBD}}
      ]
    ],
    {0, 0, {1, 1}},
    kMax
  ];

  <|"WithSign" -> withSign, "WithoutSign" -> withoutSign|>
]

(* Compare valuations with and without alternating sign *)
CompareValuations[p_, kMax_] := Module[{results, withSign, withoutSign, comparison},
  Print["Analyzing prime p=", p, " up to k=", kMax];

  results = ComputeBothVersions[kMax];
  withSign = results["WithSign"];
  withoutSign = results["WithoutSign"];

  comparison = Table[
    Module[{stateWith, stateWithout, bnWith, bdWith, bnWithout, bdWithout,
            nuDWith, nuNWith, nuDWithout, nuNWithout, diffWith, diffWithout},

      stateWith = withSign[[k+1]];
      stateWithout = withoutSign[[k+1]];

      {_, _, {bnWith, bdWith}} = stateWith;
      {_, _, {bnWithout, bdWithout}} = stateWithout;

      nuDWith = IntegerExponent[bdWith, p];
      nuNWith = IntegerExponent[bnWith, p];
      nuDWithout = IntegerExponent[bdWithout, p];
      nuNWithout = IntegerExponent[bnWithout, p];

      diffWith = nuDWith - nuNWith;
      diffWithout = nuDWithout - nuNWithout;

      <|
        "k" -> k,
        "m" -> 2*k+1,
        "ν_D (with)" -> nuDWith,
        "ν_N (with)" -> nuNWith,
        "Diff (with)" -> diffWith,
        "ν_D (without)" -> nuDWithout,
        "ν_N (without)" -> nuNWithout,
        "Diff (without)" -> diffWithout,
        "Sign matters?" -> (diffWith != diffWithout)
      |>
    ],
    {k, 1, kMax}
  ];

  (* Count where sign matters *)
  signMatters = Count[comparison, _?#["Sign matters?"]&];

  Print["Cases where alternating sign matters: ", signMatters, "/", kMax];
  Print[];

  (* Show cases where sign matters *)
  If[signMatters > 0,
    Print["Cases where sign affects the difference:"];
    Print["k\tm\tDiff(with)\tDiff(without)\tΔ"];
    mattersRows = Select[comparison, #["Sign matters?"]&];
    Do[
      With[{row = mattersRows[[i]]},
        Print[row["k"], "\t", row["m"], "\t", row["Diff (with)"], "\t\t",
              row["Diff (without)"], "\t\t", row["Diff (with)"] - row["Diff (without)"]]
      ],
      {i, 1, Min[20, Length[mattersRows]]}
    ];
    Print[];
  ];

  (* Show first 20 regardless *)
  Print["First 20 terms (all cases):"];
  Print["k\tm\tν_D(w)\tν_N(w)\tD(w)\tν_D(wo)\tν_N(wo)\tD(wo)\tMatters?"];
  Do[
    With[{row = comparison[[i]]},
      Print[row["k"], "\t", row["m"], "\t", row["ν_D (with)"], "\t",
            row["ν_N (with)"], "\t", row["Diff (with)"], "\t",
            row["ν_D (without)"], "\t", row["ν_N (without)"], "\t",
            row["Diff (without)"], "\t", If[row["Sign matters?"], "YES", "no"]]
    ],
    {i, 1, Min[20, Length[comparison]]}
  ];
  Print[];

  comparison
]

(* Test for p=3 up to k=50 *)
Print[">>> Testing p=3 <<<\n"];
comp3 = CompareValuations[3, 50];

Print[">>> Testing p=5 <<<\n"];
comp5 = CompareValuations[5, 50];

Print[">>> Testing p=7 <<<\n"];
comp7 = CompareValuations[7, 50];

Print["=== SUMMARY ==="];
Print["✓ Analysis complete"];
Print["✓ This reveals whether alternating sign is truly essential for the p-adic structure"];
Print["   or only for convergence/rationality of the sum"];
