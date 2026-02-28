(* RunAllTests.wl — Test runner for Orbit paclet *)
(* Usage: wolframscript -file Tests/RunAllTests.wl *)

(* Load paclet *)
PacletDirectoryLoad[FileNameJoin[{DirectoryName[$InputFileName], "..", "Orbit"}]];
Needs["Orbit`"];

(* Collect all .wlt files *)
testFiles = FileNames["*.wlt", DirectoryName[$InputFileName]];

If[testFiles === {},
  Print["No .wlt test files found."];
  Exit[1]
];

Print["Running ", Length[testFiles], " test file(s)..."];
Print[""];

(* Run and report *)
report = TestReport[testFiles];

Print["Tests: ", report["TestsSucceededCount"], "/", report["TestsCount"], " passed"];

If[report["TestsFailedCount"] > 0,
  Print[""];
  Print["FAILURES:"];
  Do[
    With[{tr = report["TestResults"][id]},
      If[tr["Outcome"] =!= "Success",
        Print["  ", tr["TestID"], " (", tr["Outcome"], ")"];
        Print["    Expected: ", Short[tr["ExpectedOutput"], 3]];
        Print["    Actual:   ", Short[tr["ActualOutput"], 3]];
        If[tr["ExpectedMessages"] =!= {},
          Print["    Messages: ", tr["ExpectedMessages"]]
        ];
      ]
    ],
    {id, Keys[report["TestResults"]]}
  ];
  Exit[1],
  Exit[0]
]
