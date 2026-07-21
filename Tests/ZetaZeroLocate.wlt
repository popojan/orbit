(* Tests for ZetaZeroLocate -- not auto-loaded by Orbit`, so this file
   loads it explicitly (which in turn Gets RiemannSiegelZExternal). Needs
   both a built ../zzz/build/zzz and ../zeta/build/zetacalc for the
   equivalence/integration section; that section is skipped (not failed)
   when either is unavailable, so this file is safe to run without either
   checkout. The no-silent-fail contract tests use plain coreutils
   (echo/true/false) as stand-in "binaries" and always run. *)

Get["Orbit`ZetaZeroLocate`"];

BeginTestSection["ZetaZeroLocate"]

(* ============ BINARY RESOLUTION (always runs) ============ *)

VerificationTest[
  StringQ[ZzzResolveBinary[]],
  True,
  TestID -> "ZZL-resolve-returns-string"
]

VerificationTest[
  BooleanQ[ZzzAvailableQ[]],
  True,
  TestID -> "ZZL-availableq-returns-boolean"
]

(* zzz shares the WSL-bridging helpers with zetacalc (RiemannSiegelZExternal`
   Private context) -- confirm ZzzResolveBinary respects the same forced
   override and degrades the same way when wsl.exe isn't actually present
   (this machine is Linux), rather than each module needing its own copy. *)
VerificationTest[
  Block[{Orbit`$ExternalBinaryUseWSL = True},
    {Orbit`Private`zcUseWSLQ[], StringQ[ZzzResolveBinary[]]}
  ],
  {True, True},
  TestID -> "ZZL-wsl-forced-true-still-resolves-a-string"
]

(* ============ NO-SILENT-FAIL CONTRACT (always runs, no real zzz/zetacalc needed) ============ *)

(* These calls pass BOTH positional arguments (n and count) explicitly --
   incidentally also the regression guard for a real bug found during
   development: "count_Integer?Positive : 1" parses as
   "count_Integer ? (Positive : 1)" (PatternTest binds looser than
   Optional's ":", not tighter), so the pattern silently never matched a
   2-argument call and the whole expression stayed unevaluated. If that
   regressed, these calls would return the unevaluated head instead of
   $Failed and fail below, rather than appearing to "pass" vacuously. *)

VerificationTest[
  ZetaZeroApprox[1000, 3, "BinaryPath" -> "/definitely/not/a/real/path/zzz-xyz"],
  $Failed,
  {ZetaZeroApprox::nobin},
  TestID -> "ZZL-approx-missing-binary-fails-loudly"
]

VerificationTest[
  ZetaZeroApprox[1000, 3, "BinaryPath" -> "false"],
  $Failed,
  {ZetaZeroApprox::exec},
  TestID -> "ZZL-approx-nonzero-exit-detected"
]

(* "echo" echoes argv as one line -- not a plain number. *)
VerificationTest[
  ZetaZeroApprox[1000, 3, "BinaryPath" -> "echo"],
  $Failed,
  {ZetaZeroApprox::badout},
  TestID -> "ZZL-approx-malformed-stdout-detected"
]

(* "true" exits 0 with no output at all: wrong line count. *)
VerificationTest[
  ZetaZeroApprox[1000, 3, "BinaryPath" -> "true"],
  $Failed,
  {ZetaZeroApprox::badcount},
  TestID -> "ZZL-approx-wrong-line-count-detected"
]

VerificationTest[
  ZetaZeroApprox[1000, 3, "Method" -> "NotAMethod"],
  $Failed,
  {ZetaZeroApprox::method},
  TestID -> "ZZL-approx-unknown-method-detected"
]

(* Failure at the zzz stage must propagate through ZetaZeroLocate. *)
VerificationTest[
  ZetaZeroLocate[1000, "ZzzOptions" -> {"BinaryPath" -> "/definitely/not/a/real/path/zzz-xyz"}],
  $Failed,
  {ZetaZeroApprox::nobin},
  TestID -> "ZZL-locate-propagates-zzz-failure"
]

(* Failure at the zetacalc refine stage must also propagate. *)
VerificationTest[
  ZetaZeroLocate[1000, "SweepOptions" -> {"BinaryPath" -> "/definitely/not/a/real/path/zetacalc-xyz"}],
  $Failed,
  {RiemannSiegelZSweep::nobin},
  TestID -> "ZZL-locate-propagates-zetacalc-failure"
]

(* A malformed (wrong-length) ZetaZeroApprox-shaped result must be treated
   as a hard failure, not indexed into -- direct regression guard for the
   bug above's second-order symptom (a garbage numeric answer instead of a
   clean failure, once the unevaluated expression got indexed into). *)
VerificationTest[
  ZetaZeroLocate[1000, "ZzzOptions" -> {"BinaryPath" -> "true"}],
  $Failed,
  {ZetaZeroApprox::badcount},
  TestID -> "ZZL-locate-malformed-approx-fails-cleanly"
]

(* ============ EQUIVALENCE, AT A HEIGHT BOTH TOOLS ACTUALLY VALIDATE ============ *)
(* zetacalc's own regime starts ~1e6 (see RiemannSiegelZExternal.wlt); zero
   #1000 sits at t ~ 1419, comfortably inside it and still fast enough for
   a native FindRoot cross-check (unlike, say, zero #10^9, where native
   RiemannSiegelZ itself becomes impractically slow -- exactly the gap this
   module exists to fill). Threads->1 for reproducibility. *)

If[ZzzAvailableQ[] && ZetaCalcAvailableQ[],

  VerificationTest[
    Module[{loc, root},
      loc = ZetaZeroLocate[1000, "SweepOptions" -> {"Threads" -> 1}];
      root = t /. FindRoot[RiemannSiegelZ[t] == 0, {t, loc}, WorkingPrecision -> 20];
      NumericQ[loc] && Abs[loc - root] < 10^-6
    ],
    True,
    TestID -> "ZZL-equivalence-n1000"
  ];

  (* n=1 is handled specially (no #0 to bracket against) -- exercise it. *)
  VerificationTest[
    NumericQ[ZetaZeroLocate[1, "SweepOptions" -> {"Threads" -> 1}]],
    True,
    TestID -> "ZZL-n1-edge-case-runs"
  ];

  (* The neighbor-bracket window must actually contain #n=1000: the
     zetacalc-confirmed zero should land inside [tlo, thi] computed from
     the zzz neighbor estimates, not merely "somewhere nearby". *)
  VerificationTest[
    Module[{approx, tlo, thi, loc},
      approx = ZetaZeroApprox[999, 3];
      tlo = (approx[[1]] + approx[[2]])/2;
      thi = (approx[[2]] + approx[[3]])/2;
      loc = ZetaZeroLocate[1000, "SweepOptions" -> {"Threads" -> 1}];
      tlo < loc < thi
    ],
    True,
    TestID -> "ZZL-window-contains-located-zero"
  ]

  ,

  VerificationTest[
    "skipped-no-zzz-or-zetacalc-binary",
    "skipped-no-zzz-or-zetacalc-binary",
    TestID -> "ZZL-integration-SKIPPED-no-binary"
  ]
]

EndTestSection[]
