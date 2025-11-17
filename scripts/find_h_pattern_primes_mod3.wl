#!/usr/bin/env wolframscript
(* PATTERN: For n = p*q (mod 8 = 3), what determines h? *)

Print[StringRepeat["=", 80]];
Print["PATTERN: n = p*q with n ≡ 3, M=1  ->  h = ?"];
Print[StringRepeat["=", 80]];
Print[];

M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

ClassNumber[n_] := Module[{factors},
  factors = FactorInteger[n];
  If[Max[factors[[All, 2]]] > 1, Return[Missing["NotSquareFree"]]];
  NumberFieldClassNumber[Sqrt[n]]
]

(* Collect *)
data = Table[
  If[Mod[n, 8] == 3 && OddQ[n] && !IntegerQ[Sqrt[n]],
    Module[{h, m, factors, p, q},
      m = M[n];
      factors = FactorInteger[n];
      If[m == 1 && Length[factors] == 2,
        h = ClassNumber[n];
        p = factors[[1, 1]];
        q = factors[[2, 1]];
        If[!MissingQ[h],
          {n, h, p, q, Mod[p, 8], Mod[q, 8]},
          Nothing
        ],
        Nothing
      ]
    ],
    Nothing
  ],
  {n, 3, 400}
];

data = DeleteCases[data, Nothing];

Print["Found ", Length[data], " cases: n = p*q with n ≡ 3, M=1"];
Print[];

(* Display *)
Print["DATA:"];
Print[StringRepeat["-", 70]];
Print["n       h    p    q      p mod 8  q mod 8  pattern"];
Print[StringRepeat["-", 70]];

Do[
  {n, h, p, q, pmod, qmod} = data[[i]];
  pattern = ToString[pmod] <> "×" <> ToString[qmod];
  Print[
    StringPadRight[ToString[n], 8],
    StringPadRight[ToString[h], 5],
    StringPadRight[ToString[p], 5],
    StringPadRight[ToString[q], 7],
    StringPadRight[ToString[pmod], 9],
    StringPadRight[ToString[qmod], 9],
    pattern
  ];
  ,
  {i, Length[data]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Group by pattern *)
Print["GROUPING BY (p mod 8) × (q mod 8):"];
Print[StringRepeat["-", 60]];
Print[];

grouped = GroupBy[data, {#[[5]], #[[6]]} &];
patterns = Sort[Keys[grouped]];

Do[
  {pmod, qmod} = pattern;
  cases = grouped[pattern];
  hVals = Union[cases[[All, 2]]];

  Print["Pattern ", pmod, " × ", qmod, ": ", Length[cases], " cases"];
  Print["  h values: ", hVals];
  Print["  Mean h: ", N[Mean[cases[[All, 2]]], 3]];

  If[Length[hVals] == 1,
    Print["  DETERMINISTIC: h = ", First[hVals], " ✓"];
  ];

  (* Show examples *)
  Do[
    {n, h, p, q, pm, qm} = cases[[j]];
    Print["    n=", n, " (", p, "×", q, "): h=", h];
    ,
    {j, Min[3, Length[cases]]}
  ];

  Print[];
  ,
  {pattern, patterns}
];

Print[StringRepeat["=", 80]];
Print[];

Print["HYPOTHESIS:"];
Print[StringRepeat["-", 60]];
Print[];
Print["For n = p*q with n ≡ 3 (mod 8), M=1:"];
Print["  Does h depend on (p mod 8, q mod 8) pattern?"];
Print[];

Print[StringRepeat["=", 80]];
