#!/usr/bin/env wolframscript
(* Verify the key relationship: ν_p(k!) = ν_p(2k+1) - 1 at jump points *)

Print["=== FACTORIAL VALUATION RELATIONSHIP VERIFICATION ===\n"];

(* Load jump data and verify relationship *)
VerifyFactorialRelation[csvPath_, p_] := Module[{data, failures},
  Print["Prime p=", p];
  Print["Loading data from: ", csvPath];

  data = Import[csvPath];
  data = Rest[data]; (* Skip header *)

  Print["Verifying relationship ν_p(k!) = ν_p(2k+1) - 1 at ", Length[data], " jump points...\n"];

  failures = Select[data,
    Module[{k, m, nuD, nuN, diff, nuFact, nuM, expected},
      {k, m, nuD, nuN, diff} = #;

      (* Compute valuations *)
      nuFact = IntegerExponent[k!, p];
      nuM = IntegerExponent[m, p];
      expected = nuM - 1;

      (* Check if relationship holds *)
      nuFact != expected
    ] &
  ];

  If[Length[failures] == 0,
    Print["✓ Relationship holds at ALL ", Length[data], " jump points for p=", p];
    Print["  Confirmed: ν_", p, "(k!) = ν_", p, "(2k+1) - 1\n"];
  ,
    Print["✗ Relationship FAILS at ", Length[failures], " jump points:"];
    Print[failures[[;;Min[10, Length[failures]]]]];
    Print[];
  ];

  <|"Prime" -> p, "Verified" -> (Length[failures] == 0), "Failures" -> failures|>
]

(* Check all primes *)
primes = {3, 5, 7, 11};
results = Table[
  csvPath = FileNameJoin[{DirectoryName[$InputFileName], "..", "reports",
    "hybrid_jumps_p" <> ToString[p] <> ".csv"}];
  VerifyFactorialRelation[csvPath, p],
  {p, primes}
];

Print["=== SUMMARY ==="];
Print["Primes verified: ", primes];
allVerified = AllTrue[results, #["Verified"] &];
Print["All relationships verified? ", If[allVerified, "✓ YES", "✗ NO"]];

If[allVerified,
  Print["\n✓ The key relationship ν_p(k!) = ν_p(2k+1) - 1 holds at all jump points"];
  Print["✓ This suggests the proof strategy is correct"];
];
