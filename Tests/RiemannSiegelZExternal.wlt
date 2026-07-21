(* Tests for RiemannSiegelZExternal -- not auto-loaded by Orbit`, so this
   file loads it explicitly. Needs a built ../zeta/build/zetacalc for the
   equivalence/integration sections; those are skipped (not failed) when
   ZetaCalcAvailableQ[] is False, so this file is safe to run on a machine
   without the zeta checkout. The no-silent-fail contract tests use plain
   coreutils (echo/true/false) as stand-in "binaries" and always run. *)

Get["Orbit`RiemannSiegelZExternal`"];

BeginTestSection["RiemannSiegelZExternal"]

(* ============ BINARY RESOLUTION (always runs) ============ *)

VerificationTest[
  StringQ[ZetaCalcResolveBinary[]],
  True,
  TestID -> "RSZExt-resolve-returns-string"
]

VerificationTest[
  BooleanQ[ZetaCalcAvailableQ[]],
  True,
  TestID -> "RSZExt-availableq-returns-boolean"
]

VerificationTest[
  BooleanQ[ZetaCalcCudaAvailableQ[]],
  True,
  TestID -> "RSZExt-cudaavailableq-returns-boolean"
]

(* ============ WSL BRIDGING (always runs -- this machine is Linux, so *)
(* Automatic must be a complete no-op; forcing True must degrade *)
(* gracefully rather than break, since wsl.exe doesn't exist here) ============ *)

VerificationTest[
  Orbit`Private`zcUseWSLQ[],
  False,
  TestID -> "RSZExt-wsl-automatic-off-on-linux"
]

VerificationTest[
  Orbit`Private`zcRunPrefix[],
  {},
  TestID -> "RSZExt-wsl-runprefix-empty-by-default"
]

(* Forcing $ExternalBinaryUseWSL -> True on a box with no wsl.exe must not
   silently misbehave -- zcWSLAvailableQ[] should correctly report False,
   and zcRunPrefix[] must still come back empty (fall through to direct
   execution), not a broken {"wsl.exe", "-e"} prefix pointed at nothing. *)
VerificationTest[
  Block[{Orbit`$ExternalBinaryUseWSL = True},
    {Orbit`Private`zcUseWSLQ[], Orbit`Private`zcWSLAvailableQ[], Orbit`Private`zcRunPrefix[]}
  ],
  {True, False, {}},
  TestID -> "RSZExt-wsl-forced-true-degrades-gracefully-without-wsl-exe"
]

(* ============ STAGEKERNEL (always runs for validation; real calls below) ============ *)

VerificationTest[
  RiemannSiegelZSweep[1000, 3, 1/20, "StageKernel" -> "not-a-real-kernel"],
  $Failed,
  {RiemannSiegelZSweep::stagekernel},
  TestID -> "RSZExt-stagekernel-rejects-unknown-value"
]

(* ============ NO-SILENT-FAIL CONTRACT (always runs, no real zetacalc needed) ============ *)

(* Missing/bogus binary: must fail loudly with a specific message, not just $Failed. *)
VerificationTest[
  RiemannSiegelZSweep[1000, 3, 1/20, "BinaryPath" -> "/definitely/not/a/real/path/zetacalc-xyz"],
  $Failed,
  {RiemannSiegelZSweep::nobin},
  TestID -> "RSZExt-missing-binary-fails-loudly"
]

(* Nonzero exit code (no stdout at all): must surface exit code + stderr, not silently return {}. *)
VerificationTest[
  RiemannSiegelZSweep[1000, 3, 1/20, "BinaryPath" -> "false"],
  $Failed,
  {RiemannSiegelZSweep::exec},
  TestID -> "RSZExt-nonzero-exit-detected"
]

(* stdout/stderr contract violation: "echo" echoes the whole argv as one line,
   which cannot match the documented "offset value 0" shape. This is the
   direct regression guard for "correct parsing of the contract output". *)
VerificationTest[
  RiemannSiegelZSweep[1000, 3, 1/20, "BinaryPath" -> "echo"],
  $Failed,
  {RiemannSiegelZSweep::badout},
  TestID -> "RSZExt-malformed-stdout-detected"
]

(* Wrong output line count (zero, here): "true" exits 0 with no output at all. *)
VerificationTest[
  RiemannSiegelZSweep[1000, 3, 1/20, "BinaryPath" -> "true"],
  $Failed,
  {RiemannSiegelZSweep::badcount},
  TestID -> "RSZExt-wrong-line-count-detected"
]

(* Same three failure modes must propagate through the derived/plot wrappers
   too, not get swallowed on the way. *)
VerificationTest[
  RiemannSiegelZetaSweep[1000, 3, 1/20, "BinaryPath" -> "/definitely/not/a/real/path/zetacalc-xyz"],
  $Failed,
  {RiemannSiegelZSweep::nobin},
  TestID -> "RSZExt-zetasweep-propagates-failure"
]

VerificationTest[
  RiemannSiegelZPlot[{1000, 1001}, "BinaryPath" -> "/definitely/not/a/real/path/zetacalc-xyz"],
  $Failed,
  {RiemannSiegelZSweep::nobin},
  TestID -> "RSZExt-plot-propagates-failure"
]

(* ============ HEIGHT/DELTA STRING FORMATTING (always runs) ============ *)
(* Regression guard for the Indeterminate-digits bug: machine-precision
   inputs must not be padded with Indeterminate when more digits are
   requested than the input's own precision carries. *)

VerificationTest[
  StringFreeQ[Orbit`Private`zcDecimalString[0.05, 60], "Indeterminate"],
  True,
  TestID -> "RSZExt-decimalstring-machine-real-no-indeterminate"
]

(* zetacalc's MPFR reader accepts plain "e" exponents, not Mathematica's "*^". *)
VerificationTest[
  StringFreeQ[Orbit`Private`zcDecimalString[10^22 + 1/3, 50], "*^"],
  True,
  TestID -> "RSZExt-decimalstring-no-starcaret-notation"
]

VerificationTest[
  StringMatchQ[Orbit`Private`zcDecimalString[123456789, 40], RegularExpression["-?\\d\\.\\d+e-?\\d+"]],
  True,
  TestID -> "RSZExt-decimalstring-large-integer-shape"
]

VerificationTest[
  StringMatchQ[Orbit`Private`zcDecimalString[-0.05, 60], RegularExpression["-\\d\\.\\d+e-?\\d+"]],
  True,
  TestID -> "RSZExt-decimalstring-negative-machine-real-shape"
]

VerificationTest[
  Orbit`Private`zcDecimalString[0, 60],
  "0",
  TestID -> "RSZExt-decimalstring-zero"
]

(* ============ FRAME TICKS: matplotlib-style offset text, all ticks relative to tmin (always runs) ============ *)

VerificationTest[
  Module[{ticks = Orbit`Private`zcHeightTicks[29538618432.0, 29538618432.5]},
    {Length[ticks], ticks[[1, 1]], ticks[[-1, 1]]}
  ],
  {6, 29538618432.0, 29538618432.5},
  TestID -> "RSZExt-heightticks-endpoint-positions"
]

(* tmin's own tick is the reference itself -- labeled "0", not "+0" or the
   repeated absolute height (which is shown once, separately, via
   zcHeightReferenceLabel in the plot's top FrameLabel slot -- confirmed by
   actually rendering and looking: an Epilog placed just outside the [0,1]
   Scaled range was silently clipped by the image bounding box in an
   earlier version of this). Every other tick, including tmax's, is a
   small "+offset" from it -- repeating an ~13-digit absolute number on
   every tick ("all ticks look the same") is worse than showing it once. *)
VerificationTest[
  Orbit`Private`zcHeightTicks[29538618432.0, 29538618432.5][[1, 2]],
  "0",
  TestID -> "RSZExt-heightticks-tmin-is-zero"
]

VerificationTest[
  Module[{ticks = Orbit`Private`zcHeightTicks[29538618432.0, 29538618432.5]},
    AllTrue[ticks[[2 ;;, 2]], StringStartsQ[#, "+"] &]
  ],
  True,
  TestID -> "RSZExt-heightticks-rest-are-relative-offsets"
]

VerificationTest[
  Length[DeleteDuplicates[Orbit`Private`zcHeightTicks[29538618432.0, 29538618432.5][[All, 2]]]],
  6,
  TestID -> "RSZExt-heightticks-all-labels-distinguishable"
]

(* Regression guard: at a huge, genuinely high-precision height (mirroring
   what ZetaZeroApprox returns at t ~ 1e18) with a narrow window, an
   earlier version silently collapsed all tick positions to the same
   double (bare N[...] truncates Precision-47 input to MachinePrecision,
   whose ULP at this magnitude already exceeds the tick spacing) --
   producing identical "0" offsets everywhere and a NumberForm::reqsigz
   warning when the reference label tried to show more integer digits
   than that collapsed precision actually had. Neither should happen now
   that off is computed from step alone, never from a subtraction of two
   near-equal huge numbers. *)
VerificationTest[
  Module[{tmin, ticks},
    tmin = N[10^18 + 1/3, 47];
    ticks = Orbit`Private`zcHeightTicks[tmin, tmin + 2];
    Length[DeleteDuplicates[ticks[[All, 2]]]] == 6
  ],
  True,
  TestID -> "RSZExt-heightticks-distinguishable-at-huge-height"
]

VerificationTest[
  Module[{tmin},
    tmin = N[10^18 + 1/3, 47];
    Check[Orbit`Private`zcHeightReferenceLabel[tmin]; True, False, NumberForm::reqsigz]
  ],
  True,
  TestID -> "RSZExt-heightreference-no-reqsigz-at-huge-height"
]

(* The reference annotation carries the absolute height ticks no longer
   repeat, and doesn't choke on an exact-integer tmin (no stray "100." --
   NumberForm's default trailing decimal point for a converted Real). *)
VerificationTest[
  StringContainsQ[Orbit`Private`zcHeightReferenceLabel[10^11][[1]], "100000000000"],
  True,
  TestID -> "RSZExt-heightreference-shows-absolute-value"
]

VerificationTest[
  StringFreeQ[Orbit`Private`zcHeightReferenceLabel[10^11][[1]], "100000000000."],
  True,
  TestID -> "RSZExt-heightreference-integer-tmin-no-trailing-dot"
]

(* Regression guard: zetacalc's cout switches to scientific notation near a
   zero ("3.47e-05"), and plain ToExpression reads "e" as an undefined
   symbol (WL's own exponent marker is "*^"), not a number -- silently
   producing a non-numeric result rather than the intended value. *)
VerificationTest[
  Orbit`Private`zcParseNumber["3.4783581668189345e-05"],
  0.000034783581668189345,
  TestID -> "RSZExt-parsenumber-scientific-notation"
]

VerificationTest[
  Orbit`Private`zcParseNumber["-3.3494064751386756"],
  -3.3494064751386756,
  TestID -> "RSZExt-parsenumber-plain-decimal-unaffected"
]

VerificationTest[
  Orbit`Private`zcParseNumber["1e+06"],
  1000000,
  TestID -> "RSZExt-parsenumber-explicit-plus-exponent"
]

(* Failure must propagate through RiemannSiegelZZeros and
   RiemannSiegelZetaPlot too (both call RiemannSiegelZSweep internally). *)
VerificationTest[
  RiemannSiegelZZeros[1000, 3, 1/20, "BinaryPath" -> "/definitely/not/a/real/path/zetacalc-xyz"],
  $Failed,
  {RiemannSiegelZSweep::nobin},
  TestID -> "RSZExt-zeros-propagates-failure"
]

VerificationTest[
  RiemannSiegelZetaPlot[{1000, 1001}, "BinaryPath" -> "/definitely/not/a/real/path/zetacalc-xyz"],
  $Failed,
  {RiemannSiegelZSweep::nobin},
  TestID -> "RSZExt-zetaplot-propagates-failure"
]

(* ============ EQUIVALENCE WITH NATIVE Wolfram, AT VALIDATED HEIGHTS ============ *)
(* zetacalc targets t >~ 1e6 (its own scripts/ab_regress.py matrix starts at
   1e6; small t like ~100 is outside its validated/designed regime and was
   observed to disagree with native RiemannSiegelZ at the ~1e-6 level, not
   the ~1e-12 the tool documents for large t -- so these tests deliberately
   stay at heights actually covered by zeta/README.md's own claims).
   Heights are built from EXACT rational t0/delta on the WL side, not from
   re-parsing zetacalc's own (lower-precision) offset column -- see
   RiemannSiegelZSweep's docstring. Threads->1 for bit-reproducibility
   (thread merge order is otherwise nondeterministic per zeta's own
   ab_regress.py comments).
   Native reference values MUST request >= 20 digits: N[RiemannSiegelZ[t], 16]
   is silently wrong for t >~ 1e10 (zeta/README.md "Accuracy model"), so
   every reference call below asks for 30. *)

If[ZetaCalcAvailableQ[],

  VerificationTest[
    Module[{sweep, devs},
      sweep = RiemannSiegelZSweep[1000000, 5, 1/20, "Threads" -> 1];
      devs = Table[
        Abs[sweep[[k, 2]] - N[RiemannSiegelZ[sweep[[k, 1]]], 30]],
        {k, Length[sweep]}];
      Max[devs] < 10^-9
    ],
    True,
    TestID -> "RSZExt-equivalence-Z-t1e6"
  ];

  (* "StageKernel" -> "fused"/"reference" must both actually run (they're
     always available, unlike cuda) and agree with each other -- a real
     regression guard, not just "doesn't error", since a typo in the CLI
     mapping would silently fall through to zetacalc's own default instead
     of the requested kernel. *)
  VerificationTest[
    Module[{fused, ref},
      fused = RiemannSiegelZSweep[1000000, 3, 1/20, "Threads" -> 1, "StageKernel" -> "fused"];
      ref = RiemannSiegelZSweep[1000000, 3, 1/20, "Threads" -> 1, "StageKernel" -> "reference"];
      !FailureQ[fused] && !FailureQ[ref] && Max[Abs[fused[[All, 2]] - ref[[All, 2]]]] < 10^-9
    ],
    True,
    TestID -> "RSZExt-stagekernel-fused-and-reference-agree"
  ];

  (* "Auto" must not blow up when cuda isn't actually available (the normal
     case on this dev box) -- falls back to omitting the flag entirely. *)
  VerificationTest[
    Head[RiemannSiegelZSweep[1000000, 3, 1/20, "Threads" -> 1, "StageKernel" -> "Auto"]],
    List,
    TestID -> "RSZExt-stagekernel-auto-falls-back-cleanly"
  ];

  VerificationTest[
    Module[{sweep, devs},
      sweep = RiemannSiegelZSweep[10^10, 20, 1/20, "Threads" -> 1];
      devs = Table[
        Abs[sweep[[k, 2]] - N[RiemannSiegelZ[sweep[[k, 1]]], 30]],
        {k, Length[sweep]}];
      Max[devs] < 10^-9
    ],
    True,
    TestID -> "RSZExt-equivalence-Z-t1e10-sweep20"
  ];

  (* Regression guard for the offset-bisection fix. t0 here is a genuinely
     high-precision approximate real (Precision 40) -- not exact (which
     would sidestep the whole question) and not a MachinePrecision literal
     (which the fix can't help, since re-adding an offset to an already
     MachinePrecision reference re-collapses to its ULP regardless -- this
     mirrors ZetaZeroLocate's own "ExtraDigits" fix upstream, not this
     one). At t ~ 3e10, MachinePrecision's ULP is ~7e-6, which is exactly
     the floor bisecting in *absolute* t got stuck at before this fix; with
     it, a high-precision starting bracket should converge far tighter. *)
  VerificationTest[
    Module[{t0, zeros},
      t0 = N[29538618431 + 4/5, 40];
      zeros = RiemannSiegelZZeros[t0, 40, N[1/100, 40], "Threads" -> 1, "Tolerance" -> 10^-9];
      Length[zeros] > 0 && Min[Abs[N[RiemannSiegelZ[#]] & /@ zeros]] < 10^-6
    ],
    True,
    TestID -> "RSZExt-zeros-offset-bisection-beats-ulp-floor-t3e10"
  ];

  VerificationTest[
    Module[{sweep, devs},
      sweep = RiemannSiegelZetaSweep[1000000, 5, 1/20, "Threads" -> 1];
      devs = Table[
        Abs[sweep[[k, 2]] - N[Zeta[1/2 + I*sweep[[k, 1]]], 30]],
        {k, Length[sweep]}];
      Max[devs] < 10^-9
    ],
    True,
    TestID -> "RSZExt-equivalence-Zeta-t1e6"
  ];

  VerificationTest[
    Head[RiemannSiegelZPlot[{1000000, 1000010}, "PlotPoints" -> 20, "Threads" -> 1]],
    Graphics,
    TestID -> "RSZExt-plot-returns-graphics"
  ];

  (* User-supplied plot options must win over our own defaults (the
     Association-merge in RiemannSiegelZPlot/RiemannSiegelZetaPlot, not
     positional Options precedence, which would silently let our default
     shadow the caller's -- e.g. an explicit GridLines to mark zeros). *)
  VerificationTest[
    (PlotRange /. AbsoluteOptions[
        RiemannSiegelZPlot[{1000000, 1000001}, "Threads" -> 1, "PlotPoints" -> 10, PlotRange -> {-2, 2}],
        PlotRange])[[2]],
    {-2., 2.},
    TestID -> "RSZExt-plot-user-option-overrides-default"
  ];

  (* RiemannSiegelZZeros equivalence: each found zero must match a native
     FindRoot seeded from it, at a height zetacalc actually validates. *)
  VerificationTest[
    Module[{zeros, root},
      zeros = RiemannSiegelZZeros[1000000, 200, 0.01, "Threads" -> 1];
      root = t /. FindRoot[RiemannSiegelZ[t] == 0, {t, zeros[[1]]}, WorkingPrecision -> 20];
      Length[zeros] > 0 && Abs[zeros[[1]] - root] < 10^-6
    ],
    True,
    TestID -> "RSZExt-zeros-equivalence-t1e6"
  ];

  VerificationTest[
    Head[RiemannSiegelZetaPlot[{1000000, 1000002}, "PlotPoints" -> 20, "Threads" -> 1]],
    Legended,
    TestID -> "RSZExt-zetaplot-line-mode-returns-legended"
  ];

  VerificationTest[
    Head[RiemannSiegelZetaPlot[{1000000, 1000002}, "PlotPoints" -> 20, "Threads" -> 1, "Argand" -> True]],
    Graphics,
    TestID -> "RSZExt-zetaplot-argand-mode-returns-graphics"
  ];

  (* "ShowZeros" default False: no GridLines injected unless asked for. *)
  VerificationTest[
    (GridLines /. AbsoluteOptions[
        RiemannSiegelZPlot[{1000000, 1000005}, "Threads" -> 1, "PlotPoints" -> 50], GridLines]),
    None,
    TestID -> "RSZExt-plot-showzeros-default-off"
  ];

  (* "ShowZeros" -> True finds real, nonempty gridlines, sized off the local
     zero gap independent of "PlotPoints" (50, deliberately too coarse to
     resolve zeros itself). *)
  VerificationTest[
    Module[{gl},
      gl = (GridLines /. AbsoluteOptions[
          RiemannSiegelZPlot[{1000000, 1000005}, "Threads" -> 1, "PlotPoints" -> 50, "ShowZeros" -> True],
          GridLines])[[1]];
      Length[gl] > 0
    ],
    True,
    TestID -> "RSZExt-plot-showzeros-true-finds-zeros"
  ];

  VerificationTest[
    Head[RiemannSiegelZetaPlot[{1000000, 1000002}, "Threads" -> 1, "PlotPoints" -> 100, "ShowZeros" -> True]],
    Legended,
    TestID -> "RSZExt-zetaplot-showzeros-line-mode"
  ];

  (* A tiny window at a huge height (where the offset-tick scheme matters
     most -- an ~12-digit absolute height with only the last digit or two
     actually varying across the window) must still render cleanly. *)
  VerificationTest[
    Head[RiemannSiegelZetaPlot[{10^11, 10^11 + 1}, "ShowZeros" -> True, "Threads" -> 1, "PlotPoints" -> 100]],
    Legended,
    TestID -> "RSZExt-zetaplot-tiny-window-huge-height-renders"
  ];

  (* Regression guard for the clipped-Epilog bug: the reference label must
     actually be present in the rendered plot's own FrameLabel option
     (guaranteed layout space), not merely computable as an unused helper
     or attached via an Epilog that silently never appears on screen. *)
  VerificationTest[
    Module[{fl},
      fl = ToString[FrameLabel /. AbsoluteOptions[
          RiemannSiegelZPlot[{10^11, 10^11 + 1}, "Threads" -> 1, "PlotPoints" -> 10], FrameLabel]];
      StringContainsQ[fl, "100000000000"]
    ],
    True,
    TestID -> "RSZExt-plot-reference-label-actually-rendered"
  ];

  (* ShowZeros must fail loudly, not silently, if zetacalc goes away mid-plot. *)
  VerificationTest[
    RiemannSiegelZPlot[{1000, 1001}, "PlotPoints" -> 10, "ShowZeros" -> True,
      "BinaryPath" -> "/definitely/not/a/real/path/zetacalc-xyz"],
    $Failed,
    {RiemannSiegelZSweep::nobin},
    TestID -> "RSZExt-plot-showzeros-propagates-failure"
  ];

  (* RiemannSiegelZetaPlot's default line style should match built-in
     ReImPlot's own Re/Im convention (same color, solid vs dotted) rather
     than ListLinePlot's default distinct-color-per-series look. *)
  VerificationTest[
    Module[{style, refColors, refDashes},
      style = Orbit`Private`zcReImPlotStyle[];
      refColors = DeleteDuplicates[Cases[ReImPlot[{Exp[I*x]}, {x, 0, 1}], _RGBColor, Infinity]];
      refDashes = DeleteDuplicates[Cases[ReImPlot[{Exp[I*x]}, {x, 0, 1}], _Dashing, Infinity]];
      Length[style] == 2 && Length[refColors] == 1 &&
       MatchQ[style[[1]], Directive[Alternatives @@ refColors, ___]] &&
       MatchQ[style[[2]], Directive[Alternatives @@ refColors, ___]] &&
       MemberQ[style[[1]], refDashes[[1]]] && MemberQ[style[[2]], refDashes[[2]]]
    ],
    True,
    TestID -> "RSZExt-zetaplot-style-matches-native-reimplot"
  ];

  (* Documentation/canary: this is the exact pitfall the equivalence tests
     above are written to avoid. If a future Wolfram version fixes silent
     low-precision failure of RiemannSiegelZ at large t, this test's
     numeric assertion will simply start failing loud -- a correct prompt
     to revisit this comment, not a sign anything above is broken. *)
  VerificationTest[
    Abs[N[RiemannSiegelZ[10^10 + 1/1000000000], 16] - N[RiemannSiegelZ[10^10 + 1/1000000000], 30]] > 10^-6,
    True,
    TestID -> "RSZExt-canary-native-16digits-unreliable-at-1e10"
  ],

  (* No zetacalc binary on this machine: record that the integration section
     was skipped rather than silently omitting it or letting it fail. *)
  VerificationTest[
    "skipped-no-zetacalc-binary",
    "skipped-no-zetacalc-binary",
    TestID -> "RSZExt-integration-SKIPPED-no-binary"
  ]
]

EndTestSection[]
