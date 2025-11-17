#!/usr/bin/env wolframscript
(*
Focus on perfect square discriminant cases
*)

Print[StringRepeat["=", 70]];
Print["PERFECT SQUARE DISCRIMINANT ANALYSIS"];
Print[StringRepeat["=", 70]];
Print[];

pellc[n_, d_, c_, m_] := Module[
  {
   z = ChebyshevT[-1 + 2 m, Sqrt[d^2 n]]/
    ChebyshevU[-2 + 2 m, Sqrt[d^2 n]],
   gcd, sol
   },
  sol = {
    x -> z/(Sqrt[n] Sqrt[1 - n d^2 + z^2]),
    y -> 1/Sqrt[1 - n d^2 + z^2]
    };
  gcd = GCD[(x + c)^2, y^2, 1 + (x + c)^2 - x^2] /. sol;
  {n x^2 - (n d^2 - 1) y^2 == ((1 + (x + c)^2 - x^2)/gcd /. sol),
   Thread[{x, y} -> ({(x + c)/Sqrt[gcd], y/Sqrt[gcd]} /. sol)]}
]

Print["KEY INSIGHT: When nd² - 1 = k² (perfect square), solutions are rational"];
Print[StringRepeat["-", 70]];
Print[];

(* Search for perfect square discriminants *)
perfectSquareCases = {};

nRange = Join[
  Range[2, 10],
  Table[n/2, {n, 5, 21, 2}],
  Table[n/3, {n, 7, 20, 3}],
  Table[n/4, {n, 9, 25, 4}]
];

dRange = Join[
  Table[d/2, {d, 1, 5}],
  Table[d/3, {d, 2, 7}],
  Table[d/4, {d, 3, 9}]
];

Do[
  Do[
    Module[{disc, sqrtDisc, result, xVal, yVal, xSimp, ySimp},
      disc = ntest * dtest^2 - 1;
      sqrtDisc = Sqrt[disc];

      (* Check if perfect square *)
      If[(IntegerQ[sqrtDisc] || Head[sqrtDisc] === Rational) && disc != 0,
        result = pellc[ntest, dtest, 0, 2];
        xVal = x /. result[[2]];
        yVal = y /. result[[2]];
        xSimp = FullSimplify[xVal];
        ySimp = FullSimplify[yVal];

        If[(Head[xSimp] === Rational || IntegerQ[xSimp]) &&
           (Head[ySimp] === Rational || IntegerQ[ySimp]),
          AppendTo[perfectSquareCases, {ntest, dtest, disc, sqrtDisc, xSimp, ySimp}];
        ];
      ];
    ],
    {dtest, dRange}
  ],
  {ntest, nRange}
];

Print["Found ", Length[perfectSquareCases], " cases where nd² - 1 is a perfect square:"];
Print[];
Print["n\td\tnd²-1\t√(nd²-1)\tx\ty\ty-x\tVerify"];
Print[StringRepeat["-", 80]];

Do[
  Module[{n, d, disc, sqrtDisc, xv, yv, diff, verify},
    {n, d, disc, sqrtDisc, xv, yv} = case;
    diff = yv - xv;
    verify = n*xv^2 - (n*d^2 - 1)*yv^2;
    Print[n, "\t", d, "\t", disc, "\t", sqrtDisc, "\t", xv, "\t", yv, "\t", diff, "\t", verify];
  ],
  {case, perfectSquareCases}
];

Print[];

Print[StringRepeat["=", 70]];
Print["PATTERN ANALYSIS"];
Print[StringRepeat["=", 70]];
Print[];

(* Group by discriminant value *)
Print["Grouping by discriminant value:"];
Print[];

discriminants = DeleteDuplicates[perfectSquareCases[[All, 3]]];

Do[
  Module[{cases},
    cases = Select[perfectSquareCases, #[[3]] == discVal &];
    Print["Discriminant = ", discVal, " (√ = ", Sqrt[discVal], "):"];
    Do[
      Module[{n, d, x, y},
        {n, d, _, _, x, y} = c;
        Print["  n=", n, ", d=", d, " → x=", x, ", y=", y];
      ],
      {c, cases}
    ];
    Print[];
  ],
  {discVal, Sort[discriminants]}
];

Print[StringRepeat["=", 70]];
Print["FORMULA SEARCH"];
Print[StringRepeat["=", 70]];
Print[];

Print["For discriminant = 1 (nd² - 1 = 1, i.e., nd² = 2):"];
Print[];

disc1Cases = Select[perfectSquareCases, #[[3]] == 1 &];
If[Length[disc1Cases] > 0,
  Print["n\td\tn*d²\tx\ty"];
  Print[StringRepeat["-", 50]];
  Do[
    Module[{n, d, x, y, prod},
      {n, d, _, _, x, y} = c;
      prod = n * d^2;
      Print[n, "\t", d, "\t", prod, "\t", x, "\t", y];
    ],
    {c, disc1Cases}
  ];
  Print[];
];

Print["For discriminant = 9 (nd² - 1 = 9, i.e., nd² = 10):"];
Print[];

disc9Cases = Select[perfectSquareCases, #[[3]] == 9 &];
If[Length[disc9Cases] > 0,
  Print["n\td\tn*d²\tx\ty"];
  Print[StringRepeat["-", 50]];
  Do[
    Module[{n, d, x, y, prod},
      {n, d, _, _, x, y} = c;
      prod = n * d^2;
      Print[n, "\t", d, "\t", prod, "\t", x, "\t", y];
    ],
    {c, disc9Cases}
  ];
  Print[];
];

Print[StringRepeat["=", 70]];
Print["PARAMETRIC FAMILIES"];
Print[StringRepeat["=", 70]];
Print[];

Print["Family 1: nd² = 2 (discriminant = 1)"];
Print["Equation: nx² - y² = 1"];
Print[];

(* Test this family *)
testN2 = {1/2, 2/3, 1, 4/3, 3/2, 2, 5/2, 3};
Do[
  Module[{d, result, xv, yv},
    d = Sqrt[2/nt];
    If[Head[d] === Rational || IntegerQ[d],
      result = pellc[nt, d, 0, 2];
      xv = x /. result[[2]] // FullSimplify;
      yv = y /. result[[2]] // FullSimplify;

      If[(Head[xv] === Rational || IntegerQ[xv]) &&
         (Head[yv] === Rational || IntegerQ[yv]),
        Print["n=", nt, ", d=√(2/n)=", d, " → x=", xv, ", y=", yv];
        Print["  Verify: ", nt, "*", xv, "² - 1*", yv, "² = ", nt*xv^2 - yv^2];
      ];
    ];
  ],
  {nt, testN2}
];

Print[];

Print["Family 2: nd² = 10 (discriminant = 9)"];
Print["Equation: nx² - 9y² = 1"];
Print[];

testN10 = {5/2, 10/3, 5, 10};
Do[
  Module[{d, result, xv, yv},
    d = Sqrt[10/nt];
    If[Head[d] === Rational || IntegerQ[d],
      result = pellc[nt, d, 0, 2];
      xv = x /. result[[2]] // FullSimplify;
      yv = y /. result[[2]] // FullSimplify;

      If[(Head[xv] === Rational || IntegerQ[xv]) &&
         (Head[yv] === Rational || IntegerQ[yv]),
        Print["n=", nt, ", d=√(10/n)=", d, " → x=", xv, ", y=", yv];
        Print["  Verify: ", nt, "*", xv, "² - 9*", yv, "² = ", nt*xv^2 - 9*yv^2];
      ];
    ];
  ],
  {nt, testN10}
];

Print[];

Print[StringRepeat["=", 70]];
Print["MAIN CONCLUSION"];
Print[StringRepeat["=", 70]];
Print[];

Print["pellc gives RATIONAL solutions when discriminant nd² - 1 is a PERFECT SQUARE"];
Print[];
Print["Parametric families:"];
Print["  • nd² = k² + 1 for rational k → equation nx² - k²y² = 1"];
Print["  • This is classical Pell theory: ax² - by² = 1 rational iff b is perfect square"];
Print[];
Print["The Chebyshev closed form elegantly computes these rational solutions!"];
Print[];

Print[StringRepeat["=", 70]];
