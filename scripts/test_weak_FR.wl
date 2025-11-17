#!/usr/bin/env wolframscript
(* WEAK FUNCTIONAL EQUATION EXPLORATION *)

Print[StringRepeat["=", 80]];
Print["WEAK FR: Structural Relations from Schwarz Symmetry"];
Print[StringRepeat["=", 80]];
Print[];

(* M(n) divisor count *)
M[n_] := Module[{sqrtN, count},
  sqrtN = Floor[Sqrt[n]];
  count = 0;
  Do[If[Mod[n, d] == 0, count++], {d, 2, sqrtN}];
  count
]

(* L_M(s) with N terms *)
LM[s_, N_] := Module[{sum},
  sum = 0;
  Do[sum += M[n] / n^s, {n, 2, N}];
  sum
]

(* Test points on critical line *)
testT = {5, 10, 14.135, 21.022, 25.011};
NMax = 1000;

Print["HYPOTHESIS 1: |L_M(s)| relates to |zeta(s)|"];
Print[StringRepeat["-", 70]];
Print[];
Print["Testing: |L_M(1/2+it)| vs |zeta(1/2+it)|"];
Print[];
Print["t         |L_M|      |zeta|      Ratio      |zeta|^2    Ratio2"];
Print[StringRepeat["-", 70]];

data1 = Table[
  s = 0.5 + I*t;
  LMval = LM[s, NMax];
  zetaVal = Zeta[s];

  magLM = Abs[LMval];
  magZeta = Abs[zetaVal];
  ratio1 = magLM / magZeta;
  ratio2 = magLM / magZeta^2;

  Print[
    StringPadRight[ToString[N[t, 6]], 10],
    StringPadRight[ToString[N[magLM, 4]], 9],
    StringPadRight[ToString[N[magZeta, 4]], 10],
    StringPadRight[ToString[N[ratio1, 4]], 11],
    StringPadRight[ToString[N[magZeta^2, 4]], 10],
    N[ratio2, 4]
  ];

  {t, magLM, magZeta, ratio1, ratio2}
  ,
  {t, testT}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["HYPOTHESIS 2: arg(L_M(s)) relates to arg(zeta(s))"];
Print[StringRepeat["-", 70]];
Print[];
Print["Testing phase relationship"];
Print[];
Print["t         arg(L_M)    arg(zeta)   Difference"];
Print[StringRepeat["-", 60]];

data2 = Table[
  s = 0.5 + I*t;
  LMval = LM[s, NMax];
  zetaVal = Zeta[s];

  argLM = Arg[LMval];
  argZeta = Arg[zetaVal];
  diff = argLM - argZeta;

  Print[
    StringPadRight[ToString[N[t, 6]], 10],
    StringPadRight[ToString[N[argLM, 4]], 12],
    StringPadRight[ToString[N[argZeta, 4]], 12],
    N[diff, 4]
  ];

  {t, argLM, argZeta, diff}
  ,
  {t, testT}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["HYPOTHESIS 3: L_M(s)/zeta(s)^2 is simpler?"];
Print[StringRepeat["-", 70]];
Print[];
Print["Testing: L_M(s)/zeta(s)^2 on critical line"];
Print[];
Print["t         Re[ratio]   Im[ratio]   |ratio|     arg(ratio)"];
Print[StringRepeat["-", 70]];

data3 = Table[
  s = 0.5 + I*t;
  LMval = LM[s, NMax];
  zetaVal = Zeta[s];

  ratio = LMval / zetaVal^2;

  Print[
    StringPadRight[ToString[N[t, 6]], 10],
    StringPadRight[ToString[N[Re[ratio], 4]], 13],
    StringPadRight[ToString[N[Im[ratio], 4]], 12],
    StringPadRight[ToString[N[Abs[ratio], 4]], 12],
    N[Arg[ratio], 4]
  ];

  {t, Re[ratio], Im[ratio], Abs[ratio], Arg[ratio]}
  ,
  {t, testT}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["HYPOTHESIS 4: Closed form approximation"];
Print[StringRepeat["-", 70]];
Print[];
Print["From theory: L_M(s) ~ zeta(s)^2 - zeta(s) for large Re(s)"];
Print["Testing: L_M(s) - [zeta(s)^2 - zeta(s)]"];
Print[];
Print["t         Re[error]   Im[error]   |error|"];
Print[StringRepeat["-", 60]];

data4 = Table[
  s = 0.5 + I*t;
  LMval = LM[s, NMax];
  zetaVal = Zeta[s];

  approx = zetaVal^2 - zetaVal;
  error = LMval - approx;

  Print[
    StringPadRight[ToString[N[t, 6]], 10],
    StringPadRight[ToString[N[Re[error], 4]], 13],
    StringPadRight[ToString[N[Im[error], 4]], 12],
    N[Abs[error], 4]
  ];

  {t, Re[error], Im[error], Abs[error]}
  ,
  {t, testT}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["ANALYSIS: Pattern detection"];
Print[StringRepeat["-", 60]];
Print[];

(* Check if ratios are approximately constant *)
ratios1 = data1[[All, 4]];
ratios2 = data1[[All, 5]];

meanRatio1 = Mean[ratios1];
stdRatio1 = StandardDeviation[ratios1];
cvRatio1 = stdRatio1 / meanRatio1;

meanRatio2 = Mean[ratios2];
stdRatio2 = StandardDeviation[ratios2];
cvRatio2 = stdRatio2 / meanRatio2;

Print["Ratio |L_M| / |zeta|:"];
Print["  Mean: ", N[meanRatio1, 4]];
Print["  Std:  ", N[stdRatio1, 4]];
Print["  CV:   ", N[cvRatio1, 3], " (coefficient of variation)"];
Print[];

Print["Ratio |L_M| / |zeta|^2:"];
Print["  Mean: ", N[meanRatio2, 4]];
Print["  Std:  ", N[stdRatio2, 4]];
Print["  CV:   ", N[cvRatio2, 3]];
Print[];

If[cvRatio1 < 0.1,
  Print["PROMISING: |L_M| / |zeta| is approximately constant!"];
  Print["  Suggests: |L_M(1/2+it)| ~ C * |zeta(1/2+it)|"];
  Print["  where C ~ ", N[meanRatio1, 4]];
];

If[cvRatio2 < 0.1,
  Print["PROMISING: |L_M| / |zeta|^2 is approximately constant!"];
  Print["  Suggests: |L_M(1/2+it)| ~ C * |zeta(1/2+it)|^2"];
  Print["  where C ~ ", N[meanRatio2, 4]];
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["CONCLUSION:"];
Print[StringRepeat["-", 60]];
Print[];
Print["Weak FR candidates to investigate further:"];
Print[];
Print["1. If |L_M| ~ C|zeta|^alpha: magnitude relation (no phase info)"];
Print["2. If L_M/zeta^2 ~ simple function: multiplicative reduction"];
Print["3. If error term has structure: asymptotic expansion"];
Print[];
Print["Next: test these hypotheses with larger dataset"];
Print[];

Print[StringRepeat["=", 80]];
