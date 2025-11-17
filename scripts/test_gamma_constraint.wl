#!/usr/bin/env wolframscript
(* TEST GAMMA FUNCTION CONSTRAINT from FR substitution *)

Print[StringRepeat["=", 80]];
Print["GAMMA FUNCTION CONSTRAINT VERIFICATION"];
Print[StringRepeat["=", 80]];
Print[];

Print["When we substitute self-referential gamma(s) into FR:"];
Print["  gamma(s) = pi^(-s/2) Gamma(s/2) * sqrt[L_M(1-s)/L_M(s)]"];
Print[];
Print["Into:"];
Print["  gamma(s) * L_M(s) = gamma(1-s) * L_M(1-s)"];
Print[];
Print["The L_M terms cancel, leaving:"];
Print["  pi^(-s/2) Gamma(s/2) = pi^(-(1-s)/2) Gamma((1-s)/2)"];
Print[];
Print["Which simplifies to:"];
Print["  pi^(-s) Gamma(s/2) = pi^(-1/2) Gamma((1-s)/2)"];
Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Test this relation *)
Print["NUMERICAL VERIFICATION:"];
Print[StringRepeat["-", 60]];
Print[];

testPoints = {
  0.5 + 5*I,
  0.5 + 10*I,
  0.5 + 14.135*I,
  1.5 + 5*I,
  2 + 3*I,
  3 + 0*I,
  0.7 + 2*I
};

Print["Testing: pi^(-s) Gamma(s/2) ?= pi^(-1/2) Gamma((1-s)/2)"];
Print[];
Print["s                  LHS                  RHS                  Ratio"];
Print[StringRepeat["-", 80]];

Do[
  s = testPoints[[i]];

  lhs = Pi^(-s) * Gamma[s/2];
  rhs = Pi^(-1/2) * Gamma[(1-s)/2];

  ratio = lhs/rhs;

  Print[
    StringPadRight[ToString[N[s, 4]], 19],
    StringPadRight[ToString[N[lhs, 6]], 21],
    StringPadRight[ToString[N[rhs, 6]], 21],
    N[ratio, 6]
  ];
  ,
  {i, Length[testPoints]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Try to simplify using Gamma functional equation *)
Print["GAMMA FUNCTIONAL EQUATION ANALYSIS:"];
Print[StringRepeat["-", 60]];
Print[];

Print["Known: Gamma(z) * Gamma(1-z) = pi / sin(pi*z)"];
Print[];
Print["Let z = s/2. Then:"];
Print["  Gamma(s/2) * Gamma(1 - s/2) = pi / sin(pi*s/2)"];
Print[];
Print["Also: Gamma(1 - s/2) = Gamma((2-s)/2)"];
Print[];
Print["We need to relate Gamma((1-s)/2) to Gamma(s/2)"];
Print[];

(* Different approach: reflection formula *)
Print["Using Gamma reflection:"];
Print["  Gamma((1-s)/2) = pi / [sin(pi*(1-s)/2) * Gamma(1 - (1-s)/2)]"];
Print["                 = pi / [sin(pi*(1-s)/2) * Gamma((1+s)/2)]"];
Print[];

Print["Our constraint:");
Print["  pi^(-s) Gamma(s/2) = pi^(-1/2) Gamma((1-s)/2)"];
Print[];

Print["Multiply both sides by pi^s:"];
Print["  Gamma(s/2) = pi^(s-1/2) Gamma((1-s)/2)"];
Print[];

Print["Using reflection formula for Gamma((1-s)/2):"];
Print["  Gamma(s/2) = pi^(s-1/2) * pi / [sin(pi*(1-s)/2) * Gamma((1+s)/2)]"];
Print["  Gamma(s/2) = pi^(s+1/2) / [sin(pi*(1-s)/2) * Gamma((1+s)/2)]"];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* Test duplication formula *)
Print["GAMMA DUPLICATION FORMULA:"];
Print[StringRepeat["-", 60]];
Print[];
Print["Gamma(z) * Gamma(z + 1/2) = sqrt(pi) * 2^(1-2z) * Gamma(2z)"];
Print[];
Print["With z = s/2:"];
Print["  Gamma(s/2) * Gamma(s/2 + 1/2) = sqrt(pi) * 2^(1-s) * Gamma(s)"];
Print[];

(* Numerical test of constraint transformation *)
Print["TESTING TRANSFORMED CONSTRAINT:"];
Print[StringRepeat["-", 60]];
Print[];
Print["  Gamma(s/2) ?= pi^(s-1/2) Gamma((1-s)/2)"];
Print[];

Print["s                  LHS                  RHS                  Ratio"];
Print[StringRepeat["-", 80]];

Do[
  s = testPoints[[i]];

  lhs = Gamma[s/2];
  rhs = Pi^(s - 1/2) * Gamma[(1-s)/2];

  ratio = lhs/rhs;

  Print[
    StringPadRight[ToString[N[s, 4]], 19],
    StringPadRight[ToString[N[lhs, 6]], 21],
    StringPadRight[ToString[N[rhs, 6]], 21],
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
Print["The constraint simplifies to a pure Gamma function relation."];
Print["This does NOT seem to be a known identity."];
Print[];
Print["IF it holds for all s, it would be a NEW identity for Gamma!"];
Print["If NOT universal, then our gamma(s) is ONLY valid"];
Print["where the constraint is satisfied (possibly on critical line only)."];
Print[];

Print[StringRepeat["=", 80]];
