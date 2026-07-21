(* ::Package:: *)

(* RiemannSiegelZExternal: Riemann-Siegel Z(t) multi-point sweeps via the *)
(* external `zetacalc` binary (../zeta, private fork of Bober's zetacalc). *)
(* Requires a built zetacalc executable -- load manually: *)
(*   Get["Orbit`RiemannSiegelZExternal`"] *)
(* (not auto-loaded by Orbit.wl, same convention as PellFactorBase/PARI). *)

BeginPackage["Orbit`"];

$ZetaCalcBinary::usage = "$ZetaCalcBinary is the user-configurable path to the zetacalc executable. Automatic (default) defers to ZetaCalcResolveBinary[].";

ZetaCalcResolveBinary::usage = "ZetaCalcResolveBinary[] returns the zetacalc binary path that RiemannSiegelZSweep will try to run, in priority order: $ZetaCalcBinary (if set), the ZETACALC_BINARY environment variable, the sibling ../zeta/build/zetacalc checkout (relative to this paclet), or a bare \"zetacalc\" looked up on $PATH. It does not verify the binary runs -- use ZetaCalcAvailableQ[] for that.";

ZetaCalcAvailableQ::usage = "ZetaCalcAvailableQ[] returns True if the resolved zetacalc binary can actually be launched (checked with a quick --help call), without raising messages. Use to guard code paths that would otherwise fail when zetacalc is not installed/built.";

RiemannSiegelZSweep::usage = "RiemannSiegelZSweep[t0, n, delta] computes the Riemann-Siegel Z function at the n grid points t0, t0+delta, ..., t0+(n-1)*delta in a single zetacalc process call (zetacalc's multi-point sweeps are nearly free relative to one point). Returns a list of {height, Z[height]} pairs with height built from exact/high-precision WL arithmetic on t0 and delta (not by re-parsing zetacalc's own lower-precision offset column). Returns $Failed (with a message) if the binary is missing, exits non-zero, or its stdout does not match the documented \"offset value 0\" contract -- this never fails silently. Options: \"BinaryPath\" (Automatic), \"Threads\" (Automatic = zetacalc's own default of all hardware threads), \"Kmin\", \"GridCorrection\" (\"on\"/\"off\"), \"HeightDigits\" (decimal digits used to format t0/delta for zetacalc, Automatic = 60), \"Terse\" (True), \"ExtraArguments\" (extra raw CLI args, {}).";

RiemannSiegelZetaSweep::usage = "RiemannSiegelZetaSweep[t0, n, delta] computes zeta(1/2+i*height) at the same grid as RiemannSiegelZSweep, by combining zetacalc's Z(height) with the rotation factor Exp[-I*RiemannSiegelTheta[height]] computed natively in WL, at working precision scaled to theta's own magnitude (theta(t) ~ (t/2)*Log[t/2pi] is as large as t itself, so MachinePrecision's relative error would otherwise become an absolute phase error far bigger than zetacalc's Z(t) error). Returns a list of {height, zeta[height]} pairs, or $Failed. Accepts the same options as RiemannSiegelZSweep.";

RiemannSiegelZZeros::usage = "RiemannSiegelZZeros[t0, n, delta] finds sign changes of Z in an n-point zetacalc sweep and refines each to high precision by bisection (further single-point zetacalc calls at shrinking brackets -- sweeps and single points cost about the same, so this needs no interpolation machinery). Returns a sorted list of t-values where Z(t) == 0, i.e. zeros of zeta(1/2+it) on the critical line (Z is constructed so that a sign change in the real Z is exactly a zero of the complex zeta -- unlike Re[zeta] or Im[zeta], which cross zero at many unrelated points and are not by themselves zero markers). CAUTION: only sign changes resolved by the initial grid are found -- if delta is coarser than the local zero spacing (~2*Pi/Log[t/(2 Pi)]), an even number of zeros between two consecutive grid points will be missed (the classical zero-counting caveat also relevant to Turing's method / zetacalc's own blfi tool, which this function does not use). Options: \"Tolerance\" (Automatic = 10^-6, a fixed absolute width in t independent of height -- tighten at the cost of roughly one extra zetacalc process launch per ~3 further decimal digits), \"MaxIterations\" (60), plus all RiemannSiegelZSweep options.";

RiemannSiegelZPlot::usage = "RiemannSiegelZPlot[{tmin, tmax}] plots the Riemann-Siegel Z function over [tmin, tmax] using a single zetacalc sweep (bypassing Wolfram's native RiemannSiegelZ). Option \"PlotPoints\" (200) sets the sweep size; \"ShowZeros\" -> True (default False) marks the zeros with GridLines, computed via RiemannSiegelZZeros on its own grid (sized off the local zero spacing, independent of \"PlotPoints\") -- off by default because, unlike sweeping, zero-refinement costs one zetacalc process launch per bisection step, so this can turn a quick plot into a multi-second one. All RiemannSiegelZSweep options are also accepted, and so is any option of ListLinePlot (e.g. an explicit GridLines -> {zeros, {0}}, which takes priority over \"ShowZeros\"' own). Returns $Failed (with a message) on failure.";

RiemannSiegelZetaPlot::usage = "RiemannSiegelZetaPlot[{tmin, tmax}] plots zeta(1/2+i t) over [tmin, tmax] from a single zetacalc-backed sweep (RiemannSiegelZetaSweep). By default draws Re[zeta] and Im[zeta] against t as two lines (ListLinePlot with PlotLegends), styled to match built-in ReImPlot's own convention for a Re/Im pair -- same color, Re solid / Im dotted -- read at run time from an actual ReImPlot call rather than a hardcoded color/dashing literal, so it stays in step with the current $PlotTheme. With \"Argand\" -> True it instead draws the parametric trace {Re[zeta[t]], Im[zeta[t]]} in the complex plane as t sweeps the range (ComplexListPlot), where a zero of zeta shows up as the curve passing through the origin. \"ShowZeros\" -> True (default False, same cost caveat as RiemannSiegelZPlot) marks zeros with GridLines in the line-mode view; it is a no-op in Argand mode, where the origin itself already marks zeros. Option \"PlotPoints\" (200) sets the sweep size; all RiemannSiegelZSweep options are accepted, and so is any option of ListLinePlot or ComplexListPlot (whichever applies). Returns $Failed (with a message) on failure.";

Begin["`Private`"];

(* Captured at load time so it survives being called from deep inside Module[]. *)
zcKernelDir = DirectoryName[$InputFileName];

$ZetaCalcBinary = Automatic;

(* ================================================================ *)
(* Binary resolution                                                 *)
(* ================================================================ *)

ZetaCalcResolveBinary[] := Module[{envVar, siblingGuess},
  envVar = Environment["ZETACALC_BINARY"];
  siblingGuess = Quiet@FileNameJoin[{ParentDirectory[zcKernelDir, 3], "zeta", "build", "zetacalc"}];
  Which[
    $ZetaCalcBinary =!= Automatic, $ZetaCalcBinary,
    StringQ[envVar] && envVar =!= "", envVar,
    Quiet[FileExistsQ[siblingGuess]] === True, siblingGuess,
    True, "zetacalc"
  ]
];

ZetaCalcAvailableQ[] := Module[{proc},
  proc = Quiet@RunProcess[{ZetaCalcResolveBinary[], "--help"}];
  AssociationQ[proc] && proc["ExitCode"] == 0
];

(* ================================================================ *)
(* Numeric -> plain decimal-with-"e"-exponent string (never *^)      *)
(* zetacalc parses --t/--delta with MPFR's plain strtod-style        *)
(* reader, which accepts "1.23e16" but not Mathematica's "1.23*^16". *)
(* ================================================================ *)

zcDecimalString[x_?NumericQ, digitsIn_Integer] := Module[
  {digits = Max[digitsIn, 2], xExact, xN, sign, mag, rd, exponent, mantissa},
  (* Approximate reals (machine or limited-precision) only carry as many
     true digits as their own precision; asking N/RealDigits for more than
     that pads with Indeterminate rather than inventing digits. Rationalize
     to the exact underlying value first so "more digits than the input
     actually has" means "exact trailing zeros of that same double", not
     garbage. *)
  xExact = If[Precision[x] === Infinity, x, Rationalize[x, 0]];
  xN = N[xExact, digits];
  If[xN == 0, Return["0"]];
  sign = If[xN < 0, "-", ""];
  mag = Abs[xN];
  {rd, exponent} = RealDigits[mag, 10, digits];
  mantissa = StringJoin[ToString /@ rd];
  sign <> StringTake[mantissa, 1] <> "." <> StringDrop[mantissa, 1] <>
    "e" <> ToString[exponent - 1]
];

(* ================================================================ *)
(* Output-contract parsing: each stdout line must be "offset val 0". *)
(* stderr (progress/diagnostics) is captured separately and never    *)
(* scanned for data -- this is the split zetacalc's CLI guarantees.  *)
(* ================================================================ *)

(* zetacalc's cout switches to scientific notation ("3.47e-05") for small
   magnitudes (routine right near a zero, which is exactly where
   RiemannSiegelZZeros samples). Mathematica's own literal syntax has no
   "e" exponent marker (that's "*^"), so plain ToExpression silently reads
   "e" as an undefined symbol -- caught by the NumericQ check below rather
   than accepted as a number, but it must be translated, not just rejected. *)
zcParseNumber[s_String] := Quiet@ToExpression[
   StringReplace[s, RegularExpression["[eE]([+-]?[0-9]+)"] -> "*^$1"]];

zcParseLine[line_String] := Module[{fields, nums},
  fields = StringSplit[StringTrim[line]];
  If[Length[fields] != 3, Return[$Failed]];
  nums = zcParseNumber /@ fields;
  If[!VectorQ[nums, NumericQ], Return[$Failed]];
  nums
];

(* ================================================================ *)
(* Core sweep                                                        *)
(* ================================================================ *)

Options[RiemannSiegelZSweep] = {
  "BinaryPath" -> Automatic,
  "Threads" -> Automatic,
  "Kmin" -> Automatic,
  "GridCorrection" -> Automatic,
  "HeightDigits" -> Automatic,
  "Terse" -> True,
  "ExtraArguments" -> {}
};

RiemannSiegelZSweep::nobin = "zetacalc binary not found or not runnable (tried `1`). Build it in the sibling zeta checkout (cmake -B build -S . && cmake --build build -j), or set $ZetaCalcBinary, the \"BinaryPath\" option, or the ZETACALC_BINARY environment variable.";
RiemannSiegelZSweep::exec = "zetacalc exited with code `1`: `2`";
RiemannSiegelZSweep::badout = "zetacalc produced a line that does not match the documented \"offset value 0\" contract: `1`. This may indicate stdout/stderr are no longer separated in this zetacalc build.";
RiemannSiegelZSweep::badcount = "zetacalc returned `1` output line(s) on stdout, expected `2`.";

RiemannSiegelZSweep[t0_?NumericQ, n_Integer?Positive, delta_?NumericQ, OptionsPattern[]] :=
 Module[{binary, digits, tStr, deltaStr, args, proc, exitCode, stdout, stderr,
   lines, parsed, badLine},
  digits = OptionValue["HeightDigits"];
  If[digits === Automatic, digits = 60];
  binary = If[OptionValue["BinaryPath"] =!= Automatic,
    OptionValue["BinaryPath"],
    ZetaCalcResolveBinary[]];
  tStr = zcDecimalString[t0, digits];
  deltaStr = zcDecimalString[delta, Max[digits, 20]];

  args = {"--t", tStr, "--N", ToString[n], "--delta", deltaStr, "--Z"};
  If[TrueQ[OptionValue["Terse"]], AppendTo[args, "--terse"]];
  If[OptionValue["Threads"] =!= Automatic,
    args = Join[args, {"--number_of_threads", ToString[OptionValue["Threads"]]}]];
  If[OptionValue["Kmin"] =!= Automatic,
    args = Join[args, {"--Kmin", ToString[OptionValue["Kmin"]]}]];
  If[OptionValue["GridCorrection"] =!= Automatic,
    args = Join[args, {"--grid-correction", OptionValue["GridCorrection"]}]];
  args = Join[args, OptionValue["ExtraArguments"]];

  proc = Quiet[RunProcess[Prepend[args, binary]]];
  If[!AssociationQ[proc],
   Message[RiemannSiegelZSweep::nobin, binary];
   Return[$Failed]
   ];

  exitCode = proc["ExitCode"];
  stdout = proc["StandardOutput"];
  stderr = proc["StandardError"];
  If[exitCode != 0,
   Message[RiemannSiegelZSweep::exec, exitCode, StringTrim[stderr]];
   Return[$Failed]
   ];

  lines = Select[StringSplit[stdout, "\n"], StringTrim[#] =!= "" &];

  badLine = SelectFirst[lines, zcParseLine[#] === $Failed &];
  If[StringQ[badLine],
   Message[RiemannSiegelZSweep::badout, badLine];
   Return[$Failed]
   ];

  If[Length[lines] != n,
   Message[RiemannSiegelZSweep::badcount, Length[lines], n];
   Return[$Failed]
   ];

  parsed = zcParseLine /@ lines;
  Table[{t0 + (k - 1)*delta, parsed[[k, 2]]}, {k, n}]
  ];

(* ================================================================ *)
(* Derived: zeta(1/2+i t) via the rotation factor                    *)
(* ================================================================ *)

Options[RiemannSiegelZetaSweep] = Options[RiemannSiegelZSweep];

(* theta(t) ~ (t/2) log(t/2pi) is itself as large as t -- MachinePrecision's
   *relative* ~1e-16 accuracy on theta becomes an *absolute* phase error of
   ~1e-16*theta radians, which for t ~ 1e6 is already ~1e-9: bigger than
   zetacalc's own Z(t) error. So theta must be evaluated at working
   precision scaled to its own magnitude, not left at MachinePrecision. *)
zcThetaDigits[h_] := Max[30, Ceiling[Log10[Max[Abs[N[h]], 1]]] + 30];

RiemannSiegelZetaSweep[t0_?NumericQ, n_Integer?Positive, delta_?NumericQ, opts : OptionsPattern[]] :=
 Module[{zvals},
  zvals = RiemannSiegelZSweep[t0, n, delta, opts];
  If[FailureQ[zvals], Return[$Failed]];
  {#[[1]], #[[2]]*Exp[-I*N[RiemannSiegelTheta[#[[1]]], zcThetaDigits[#[[1]]]]]} & /@ zvals
  ];

(* ================================================================ *)
(* Zero-finding: sign changes of the real Z, refined by bisection    *)
(* ================================================================ *)

Options[RiemannSiegelZZeros] = Join[Options[RiemannSiegelZSweep], {
  "Tolerance" -> Automatic,
  "MaxIterations" -> 60
}];

RiemannSiegelZZeros[t0_?NumericQ, n_Integer?Positive, delta_?NumericQ, opts : OptionsPattern[]] :=
 Module[{sweepOpts, sweep, tol, maxIter, exactZeros, brackets, bisect, zeroAt, refined},
  sweepOpts = FilterRules[{opts}, Options[RiemannSiegelZSweep]];
  sweep = RiemannSiegelZSweep[t0, n, delta, sweepOpts];
  If[FailureQ[sweep], Return[$Failed]];

  tol = OptionValue["Tolerance"];
  (* Fixed, height-independent: the local zero spacing shrinks only
     logarithmically with height, so a tolerance scaled *up* by height
     (an earlier version of this used 10^-12*height) becomes larger than
     any realistic bracket well before t ~ 1e9 -- bisection would then
     exit after zero iterations and silently return an unrefined,
     grid-resolution estimate. 10^-6 is comfortably tighter than any
     delta used in practice while staying cheap (few dozen zetacalc
     single-point calls per zero); tighten explicitly for more precision
     at the cost of one more process launch per ~3 extra decimal digits. *)
  If[tol === Automatic, tol = 10^-6];
  maxIter = OptionValue["MaxIterations"];

  (* A grid point landing exactly on a zero is its own answer -- no bracket
     needed (and Sign[0]*Sign[x] would never flag it as a sign change). *)
  exactZeros = Select[sweep, #[[2]] == 0 &][[All, 1]];

  brackets = Select[
    Table[{sweep[[k, 1]], sweep[[k + 1, 1]], sweep[[k, 2]], sweep[[k + 1, 2]]}, {k, Length[sweep] - 1}],
    (#[[3]]*#[[4]] < 0) &
    ];

  zeroAt[tt_] := Module[{s = RiemannSiegelZSweep[tt, 1, 1, sweepOpts]},
    If[FailureQ[s], $Failed, s[[1, 2]]]
    ];

  (* Bisect in an offset from the bracket's own lower endpoint, not in
     absolute t: repeatedly averaging two close *absolute* heights (both
     carrying the same large, unchanging integer part) is exactly the
     computation where high-precision inputs can still lose working
     precision to cancellation as the bracket narrows, and where
     MachinePrecision inputs hit a hard ULP floor set by the *absolute*
     magnitude rather than the (much finer) bracket width -- confirmed via
     ZetaZeroLocate at t ~ 3e10, where this floor was ~7e-6 in t, vs a
     documented zetacalc noise floor several orders of magnitude finer.
     ref only gets added back momentarily (to hand zetacalc an absolute
     height) and once at the end. *)
  bisect[{tlo_, thi_, zlo_, zhi_}] := Module[{ref = tlo, a = 0, b, fa = zlo, mid, fmid, iter = 0},
    b = thi - tlo;
    While[(b - a) > tol && iter < maxIter,
     mid = (a + b)/2;
     fmid = zeroAt[ref + mid];
     If[FailureQ[fmid], Return[$Failed]];
     If[fmid == 0, a = b = mid; Break[]];
     If[Sign[fmid] == Sign[fa], a = mid; fa = fmid, b = mid];
     iter++;
     ];
    ref + (a + b)/2
    ];

  refined = bisect /@ brackets;
  If[MemberQ[refined, $Failed], Return[$Failed]];

  Sort[Join[exactZeros, refined]]
  ];

(* ================================================================ *)
(* Convenience plots                                                 *)
(* ================================================================ *)

(* Any RiemannSiegelZSweep option or any ListLinePlot option can be passed
   through; user-supplied plot options take priority over our defaults
   (Association-merge, not positional Options precedence, so e.g. an
   explicit GridLines -> {zeros, {0}} from the caller isn't shadowed by our
   own default). "ShowZeros" -> True automates exactly that composition
   with its own appropriately-fine grid (sized off the local zero gap,
   independent of "PlotPoints", which is only about visual smoothness) --
   default False because, unlike sweeping, zero-refinement is NOT free:
   each bisection step is its own zetacalc process launch, so this can
   turn an otherwise-quick plot call into a multi-second one. *)
zcZerosInWindow[tmin_, tmax_, sweepOpts_] := Module[{gap, delta, n},
  gap = 2*Pi/Log[Max[Abs[N[tmin]], 10]/(2*Pi)];
  delta = gap/20;
  n = Max[8, Ceiling[(tmax - tmin)/delta] + 1];
  RiemannSiegelZZeros[tmin, n, delta, sweepOpts]
  ];

(* Match built-in ReImPlot's own visual convention for a Re/Im pair (same
   color, Re solid / Im dotted) by asking ReImPlot itself, at run time, what
   style it used -- not by hardcoding a color/dashing literal that would go
   stale the moment the current $PlotTheme or a future WL version changes it. *)
zcReImPlotStyle[] := Module[{g, colors, dashes, thick},
  g = ReImPlot[{Exp[I*x]}, {x, 0, 2*Pi}];
  colors = DeleteDuplicates[Cases[g, _RGBColor, Infinity]];
  dashes = DeleteDuplicates[Cases[g, _Dashing, Infinity]];
  thick = DeleteDuplicates[Cases[g, _AbsoluteThickness, Infinity]];
  {
   Directive[First[colors], Sequence @@ thick, dashes[[1]]],
   Directive[First[colors], Sequence @@ thick, dashes[[2]]]
   }
  ];

(* matplotlib-style "offset text" convention: every tick (including the
   two boundary ones) is labeled as a small offset from tmin -- repeating
   an ~13-digit absolute height on every single tick ("all ticks look the
   same") is worse than showing it ONCE as a reference and letting the
   ticks carry only the part that actually varies across the window. The
   reference itself is added separately, in the top FrameLabel slot -- see
   zcHeightReferenceLabel. *)
zcHeightTicks[tmin_?NumericQ, tmax_?NumericQ, numTicks_Integer : 6] := Module[
  {positions, step, digits},
  step = (tmax - tmin)/(numTicks - 1);
  positions = N[tmin + step*Range[0, numTicks - 1]];
  digits = Max[0, Ceiling[-Log10[Max[Abs[step], 10^-6]]] + 2];
  Table[
   With[{off = positions[[k]] - tmin},
    {positions[[k]],
     If[off == 0, "0", "+" <> ToString[NumberForm[off, {Infinity, digits}, ExponentFunction -> (Null &)]]]}
    ],
   {k, Length[positions]}
   ]
  ];

(* An Epilog placed with Scaled coordinates just outside [0,1] (e.g. y=1.04,
   just above the frame) gets clipped by the image bounding box more often
   than not -- confirmed by actually rendering and looking, not assumed.
   The FrameLabel "top" slot has guaranteed reserved layout space instead. *)
zcHeightReferenceLabel[tmin_?NumericQ] := Style[
  "t = " <> If[IntegerQ[tmin], ToString[tmin],
    ToString[NumberForm[N[tmin], {Infinity, 0}, ExponentFunction -> (Null &)]]] <> " + ...",
  GrayLevel[0.5], 10
  ];

Options[RiemannSiegelZPlot] = Join[Options[RiemannSiegelZSweep], Options[ListLinePlot], {"PlotPoints" -> 200, "ShowZeros" -> False}];

RiemannSiegelZPlot[{tmin_?NumericQ, tmax_?NumericQ}, opts : OptionsPattern[]] :=
 Module[{n, delta, sweepOpts, data, userPlotOpts, defaultOpts, zeros},
  n = OptionValue["PlotPoints"];
  delta = (tmax - tmin)/(n - 1);
  sweepOpts = FilterRules[{opts}, Options[RiemannSiegelZSweep]];
  data = RiemannSiegelZSweep[tmin, n, delta, sweepOpts];
  If[FailureQ[data], Return[$Failed]];
  userPlotOpts = FilterRules[{opts}, Options[ListLinePlot]];
  defaultOpts = {
    PlotRange -> All, Frame -> True, Axes -> False,
    FrameTicks -> {{Automatic, Automatic}, {zcHeightTicks[tmin, tmax], Automatic}},
    FrameLabel -> {{"Z(t)", None}, {"t", zcHeightReferenceLabel[tmin]}},
    PlotLabel -> "Riemann\[Dash]Siegel Z (zetacalc)"
    };
  If[TrueQ[OptionValue["ShowZeros"]],
   zeros = zcZerosInWindow[tmin, tmax, sweepOpts];
   If[FailureQ[zeros], Return[$Failed]];
   AppendTo[defaultOpts, GridLines -> {zeros, {0}}]
   ];
  ListLinePlot[N[data], Sequence @@ Normal[Join[Association[defaultOpts], Association[userPlotOpts]]]]
  ];

Options[RiemannSiegelZetaPlot] = Join[Options[RiemannSiegelZetaSweep], Options[ListLinePlot], Options[ComplexListPlot], {
  "PlotPoints" -> 200,
  "Argand" -> False,
  "ShowZeros" -> False
}];

RiemannSiegelZetaPlot[{tmin_?NumericQ, tmax_?NumericQ}, opts : OptionsPattern[]] :=
 Module[{n, delta, sweepOpts, data, argand, userPlotOpts, defaultOpts, zeros},
  n = OptionValue["PlotPoints"];
  delta = (tmax - tmin)/(n - 1);
  argand = TrueQ[OptionValue["Argand"]];
  sweepOpts = FilterRules[{opts}, Options[RiemannSiegelZSweep]];
  data = RiemannSiegelZetaSweep[tmin, n, delta, sweepOpts];
  If[FailureQ[data], Return[$Failed]];
  If[argand,
   (* the origin itself already marks zeros of zeta on an Argand trace --
      "ShowZeros" has nothing distinct to add here, so it's a no-op. *)
   userPlotOpts = FilterRules[{opts}, Options[ComplexListPlot]];
   defaultOpts = {
     Joined -> True, AspectRatio -> 1, Frame -> True, Axes -> False,
     FrameLabel -> {"Re[zeta]", "Im[zeta]"},
     PlotLabel -> "Riemann\[Dash]Siegel \[Zeta] (zetacalc), Argand trace"
     };
   ComplexListPlot[N[data[[All, 2]]], Sequence @@ Normal[Join[Association[defaultOpts], Association[userPlotOpts]]]]
   ,
   userPlotOpts = FilterRules[{opts}, Options[ListLinePlot]];
   defaultOpts = {
     PlotRange -> All, Frame -> True, Axes -> False,
     FrameTicks -> {{Automatic, Automatic}, {zcHeightTicks[tmin, tmax], Automatic}},
     FrameLabel -> {{"value", None}, {"t", zcHeightReferenceLabel[tmin]}},
     PlotStyle -> zcReImPlotStyle[],
     PlotLegends -> {"Re[zeta]", "Im[zeta]"},
     PlotLabel -> "Riemann\[Dash]Siegel \[Zeta] (zetacalc)"
     };
   If[TrueQ[OptionValue["ShowZeros"]],
    zeros = zcZerosInWindow[tmin, tmax, sweepOpts];
    If[FailureQ[zeros], Return[$Failed]];
    AppendTo[defaultOpts, GridLines -> {zeros, {0}}]
    ];
   ListLinePlot[
    N[{{#[[1]], Re[#[[2]]]} & /@ data, {#[[1]], Im[#[[2]]]} & /@ data}],
    Sequence @@ Normal[Join[Association[defaultOpts], Association[userPlotOpts]]]]
   ]
  ];

End[];
EndPackage[];
