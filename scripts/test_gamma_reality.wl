#!/usr/bin/env wolframscript
(* TEST: Is gamma factor real or complex on critical line? *)

Print[StringRepeat["=", 80]];
Print["GAMMA FACTOR REALITY ON CRITICAL LINE"];
Print[StringRepeat["=", 80]];
Print[];

Print["Testing gamma(s) = pi^(-s/2) Gamma(s/2) on critical line s = 1/2 + it"];
Print[];

testPoints = {
  0.5 + 5*I,
  0.5 + 10*I,
  0.5 + 14.135*I,
  0.5 + 21.022*I
};

Print["s                  Re[gamma]       Im[gamma]       |gamma|        Is Real?"];
Print[StringRepeat["-", 80]];

Do[
  s = testPoints[[i]];
  gamma = Pi^(-s/2) * Gamma[s/2];

  isReal = Abs[Im[gamma]] < 10^(-10);

  Print[
    StringPadRight[ToString[N[s, 4]], 19],
    StringPadRight[ToString[N[Re[gamma], 6]], 16],
    StringPadRight[ToString[N[Im[gamma], 6]], 16],
    StringPadRight[ToString[N[Abs[gamma], 6]], 14],
    If[isReal, "YES", "NO"]
  ];
  ,
  {i, Length[testPoints]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["ANALYSIS:"];
Print[StringRepeat["-", 60]];
Print[];
Print["For s = 1/2 + it on critical line:"];
Print["  pi^(-s/2) = pi^(-1/4 - it/2) = pi^(-1/4) * e^(-i*t*log(pi)/2)"];
Print["  This has phase -t*log(pi)/2, so is COMPLEX (not real)"];
Print[];
Print["  Gamma((1/2 + it)/2) = Gamma(1/4 + it/2)"];
Print["  This is also complex for t != 0"];
Print[];
Print["Therefore: gamma(s) is COMPLEX on critical line"];
Print[];

Print[StringRepeat["=", 80]];
Print[];

Print["IMPLICATION FOR FUNCTIONAL EQUATION:"];
Print[StringRepeat["-", 60]];
Print[];
Print["On critical line s = 1/2 + it, we have 1-s = 1/2 - it = conj(s)"];
Print[];
Print["From Schwarz symmetry: L_M(conj(s)) = conj(L_M(s))"];
Print[];
Print["From FR: gamma(s)*L_M(s) = gamma(1-s)*L_M(1-s)"];
Print["              = gamma(conj(s))*L_M(conj(s))"];
Print["              = gamma(conj(s))*conj(L_M(s))  [by Schwarz]"];
Print[];
Print["So: gamma(s)*L_M(s) = gamma(conj(s))*conj(L_M(s))"];
Print[];
Print["This means:"];
Print["  |gamma(s)|^2 * |L_M(s)|^2 = |gamma(conj(s))|^2 * |L_M(s)|^2"];
Print[];
Print["If |gamma(s)| = |gamma(conj(s))| (symmetry in modulus), then OK."];
Print["Let's check:"];
Print[];

Print["s                  |gamma(s)|     |gamma(conj(s))|   Ratio"];
Print[StringRepeat["-", 70]];

Do[
  s = testPoints[[i]];
  gammaS = Pi^(-s/2) * Gamma[s/2];
  gammaConj = Pi^(-Conjugate[s]/2) * Gamma[Conjugate[s]/2];

  magS = Abs[gammaS];
  magConj = Abs[gammaConj];
  ratio = magS / magConj;

  Print[
    StringPadRight[ToString[N[s, 4]], 19],
    StringPadRight[ToString[N[magS, 6]], 16],
    StringPadRight[ToString[N[magConj, 6]], 19],
    N[ratio, 6]
  ];
  ,
  {i, Length[testPoints]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["CONCLUSION:"];
Print[StringRepeat["-", 60]];
Print[];
Print["If |gamma(s)| = |gamma(conj(s))|, then FR is COMPATIBLE with"];
Print["Schwarz symmetry on the critical line."];
Print[];
Print["For gamma(s) = pi^(-s/2) Gamma(s/2):"];
Print["  |gamma(1/2+it)| = |gamma(1/2-it)| due to reflection symmetry"];
Print["  So this gamma factor COULD work!"];
Print[];
Print["BUT: We already FALSIFIED classical FR numerically."];
Print["So the issue is NOT symmetry, but the SPECIFIC FORM of gamma."];
Print[];

Print[StringRepeat["=", 80]];
