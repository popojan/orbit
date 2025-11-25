#!/usr/bin/env wolframscript

(* Egypt Executable Test Suite
   Tests all invariants for egyptian fraction decomposition
   Usage: scripts/test_egypt.wls <num_tests> <max_bits> *)

If[Length[$ScriptCommandLine] < 3,
  Print["Usage: scripts/test_egypt.wls <num_tests> <max_bits>"];
  Exit[0]
];

testnum = ToExpression[$ScriptCommandLine[[2]]];
testmag = ToExpression[$ScriptCommandLine[[3]]];

For[i = 1, i <= testnum, i++,
  (* Generate random rational *)
  original = Divide @@ RandomInteger[{1, 2^testmag}, 2];

  WriteString["stdout", "\rTesting " <> ToString[i]];

  (* Run egypt executable *)
  output = RunProcess[
    Join[{"./egypt"}, NumeratorDenominator[original]],
    "StandardOutput"
  ];

  (* Parse output *)
  fractions = ReadList[StringToStream[output], {Number, Number}];

  (* Invariant 1: All numerators are 1 (except possibly first for integer part) *)
  error = If[Not @ AllTrue[Rest[First /@ fractions], # == 1 &],
    Print[{original, "bad numerator"}];
    True,
    False
  ];

  (* Invariant 2: No duplicate denominators *)
  error = error || If[Not @ DuplicateFreeQ[Last /@ fractions],
    Print[{original, Commonest[Last /@ fractions], "duplicates"}];
    True,
    False
  ];

  (* Invariant 3: At most one integer part (denominator = 1) *)
  error = error || If[Count[Last /@ fractions, 1] > 1,
    Print[{original, "multiple integers"}];
    True,
    False
  ];

  (* Invariant 4: Sum equals original *)
  recovered = Divide @@@ fractions // Total;
  error = error || If[recovered != original,
    Print[{original, "wrong sum"}];
    True,
    False
  ];

  If[error, Exit[1]];
];

Print["\nDone."];
