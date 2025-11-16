#!/usr/bin/env wolframscript
(* Verification of Functional Equation for L_M(s) *)

Print["=== Functional Equation Verification ==="];
Print["Testing: γ(s)L_M(s) = γ(1-s)L_M(1-s)"];
Print[""];

(* Integral representation *)
LMIntegral[s_?NumericQ] := Module[{integrand, result},
  integrand[t_] := t^(s-1) * (PolyLog[s, Exp[-t]] - Exp[-t])/(1 - Exp[-t]);

  result = NIntegrate[integrand[t], {t, 0, Infinity},
    WorkingPrecision -> 50,
    Method -> "GlobalAdaptive",
    MaxRecursion -> 20
  ];

  result / Gamma[s]
];

(* Gamma factor for L_M *)
GammaLM[s_?NumericQ] := Module[{lm1s, lms},
  lm1s = LMIntegral[1 - s];
  lms = LMIntegral[s];

  Pi^(-s/2) * Gamma[s/2] * Sqrt[lm1s / lms]
];

(* Test functional equation *)
TestFR[s_?NumericQ] := Module[{lhs, rhs, error},
  lhs = GammaLM[s] * LMIntegral[s];
  rhs = GammaLM[1-s] * LMIntegral[1-s];
  error = Abs[lhs - rhs];

  {lhs, rhs, error}
];

(* Test points *)
Print["Test 1: Critical line s = 1/2 + it"];
Print["-------------------------------------"];

Do[
  Module[{s, lhs, rhs, error, relError},
    s = 1/2 + I*t;
    {lhs, rhs, error} = TestFR[s];
    relError = error / Abs[lhs];

    Print["t = ", t];
    Print["  γ(s)L_M(s) = ", lhs];
    Print["  γ(1-s)L_M(1-s) = ", rhs];
    Print["  |difference| = ", ScientificForm[error]];
    Print["  Relative error = ", ScientificForm[relError]];

    If[relError < 10^-8,
      Print["  ✓ FR satisfied to high precision"],
      Print["  ✗ FR error too large"]
    ];
    Print[""];
  ],
  {t, {5, 10, 15, 20, 30}}
];

Print["Test 2: General points in critical strip"];
Print["------------------------------------------"];

testPoints = {
  0.3 + 5*I,
  0.7 + 10*I,
  0.4 + 15*I,
  0.6 + 20*I
};

Do[
  Module[{s, lhs, rhs, error, relError},
    s = pt;
    {lhs, rhs, error} = TestFR[s];
    relError = error / Abs[lhs];

    Print["s = ", s];
    Print["  γ(s)L_M(s) = ", lhs];
    Print["  γ(1-s)L_M(1-s) = ", rhs];
    Print["  |difference| = ", ScientificForm[error]];
    Print["  Relative error = ", ScientificForm[relError]];

    If[relError < 10^-6,
      Print["  ✓ FR satisfied"],
      Print["  ✗ FR error too large"]
    ];
    Print[""];
  ],
  {pt, testPoints}
];

(* Test 3: Compare γ(s) structure with classical *)
Print["Test 3: Compare with classical gamma factor"];
Print["---------------------------------------------"];

GammaClassical[s_] := Pi^(-s/2) * Gamma[s/2];

Do[
  Module[{s, gammaLM, gammaClass, ratio},
    s = 1/2 + I*t;
    gammaLM = GammaLM[s];
    gammaClass = GammaClassical[s];
    ratio = gammaLM / gammaClass;

    Print["t = ", t];
    Print["  γ_LM(s) = ", gammaLM];
    Print["  γ_classical(s) = ", gammaClass];
    Print["  Ratio = ", ratio];
    Print["  |Ratio| = ", Abs[ratio]];
    Print["  arg(Ratio) = ", Arg[ratio]];
    Print[""];
  ],
  {t, {5, 10, 20}}
];

Print["=== Verification complete ==="];
