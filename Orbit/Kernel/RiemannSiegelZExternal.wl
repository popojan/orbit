(* ::Package:: *)

(* RiemannSiegelZExternal: Riemann-Siegel Z(t) multi-point sweeps via the *)
(* external `zetacalc` binary (../zeta, private fork of Bober's zetacalc). *)
(* Requires a built zetacalc executable -- load manually: *)
(*   Get["Orbit`RiemannSiegelZExternal`"] *)
(* (not auto-loaded by Orbit.wl, same convention as PellFactorBase/PARI). *)

BeginPackage["Orbit`"];

$ZetaCalcBinary::usage = "$ZetaCalcBinary is the user-configurable path to the zetacalc executable. Automatic (default) defers to ZetaCalcResolveBinary[]. When bridging through WSL (see $ExternalBinaryUseWSL), this must be the Linux-side path (e.g. \"/home/user/github/zeta/build/zetacalc\"), not a Windows path.";

$ExternalBinaryUseWSL::usage = "$ExternalBinaryUseWSL controls whether zetacalc and zzz are both launched through \"wsl.exe -e <linux-path> <args>\" rather than directly -- a native-Windows process can't exec a Linux ELF binary built inside WSL on its own. Automatic (default) enables this iff $OperatingSystem === \"Windows\"; set True/False to override. Has no effect on Linux/macOS. Unverified on an actual Windows+WSL box as of this writing -- built from the documented wsl.exe CLI contract, not yet tested end to end.";

ZetaCalcResolveBinary::usage = "ZetaCalcResolveBinary[] returns the zetacalc binary path that RiemannSiegelZSweep will try to run, in priority order: $ZetaCalcBinary (if set), the ZETACALC_BINARY environment variable, the sibling ../zeta/build/zetacalc checkout, or a bare \"zetacalc\" looked up on $PATH. When bridging through WSL (see $ExternalBinaryUseWSL), the sibling-checkout guess is resolved against the WSL side's own $HOME (queried through wsl.exe, since there is no correspondence between a Windows-side paclet install path and the WSL Linux filesystem) instead of this paclet's own location. Does not verify the binary runs -- use ZetaCalcAvailableQ[] for that.";

ZetaCalcAvailableQ::usage = "ZetaCalcAvailableQ[] returns True if the resolved zetacalc binary can actually be launched (checked with a quick --help call, bridged through wsl.exe first if $ExternalBinaryUseWSL applies), without raising messages. Use to guard code paths that would otherwise fail when zetacalc is not installed/built.";

ZetaCalcCudaAvailableQ::usage = "ZetaCalcCudaAvailableQ[] returns True if the resolved zetacalc binary actually supports --stage2-kernel cuda on this machine -- a real, cheap single-point probe call, memoized for the session (clear with ZetaCalcCudaAvailableQ[] =. if you rebuild/reconfigure mid-session). zetacalc's own --help text lists \"cuda\" unconditionally regardless of how the binary was actually built, so this is the only way to know at run time; used by RiemannSiegelZSweep's \"StageKernel\" -> \"Auto\".";

RiemannSiegelZSweep::usage = "RiemannSiegelZSweep[t0, n, delta] computes the Riemann-Siegel Z function at the n grid points t0, t0+delta, ..., t0+(n-1)*delta in a single zetacalc process call (zetacalc's multi-point sweeps are nearly free relative to one point). Returns a list of {height, Z[height]} pairs with height built from exact/high-precision WL arithmetic on t0 and delta (not by re-parsing zetacalc's own lower-precision offset column). Returns $Failed (with a message) if the binary is missing, exits non-zero, or its stdout does not match the documented \"offset value 0\" contract -- this never fails silently. Options: \"BinaryPath\" (Automatic), \"Threads\" (Automatic = zetacalc's own default of all hardware threads), \"Kmin\", \"GridCorrection\" (\"on\"/\"off\"), \"StageKernel\" (Automatic = omit the flag, zetacalc's own default \"fused\"; \"fused\"/\"reference\"/\"cuda\" pass that value through as-is; \"Auto\" opts into ZetaCalcCudaAvailableQ[]'s probe and uses cuda only if it actually works on this machine -- not the bare default, since the CUDA backend has a real ~1.7s per-process context cost per zeta/README.md that only pays off at very large heights, and defaulting to it unconditionally would silently regress small/quick sweeps), \"HeightDigits\" (decimal digits used to format t0/delta for zetacalc, Automatic = 60), \"Terse\" (True), \"ExtraArguments\" (extra raw CLI args, {}).";

RiemannSiegelZetaSweep::usage = "RiemannSiegelZetaSweep[t0, n, delta] computes zeta(1/2+i*height) at the same grid as RiemannSiegelZSweep, by combining zetacalc's Z(height) with the rotation factor Exp[-I*RiemannSiegelTheta[height]] computed natively in WL, at working precision scaled to theta's own magnitude (theta(t) ~ (t/2)*Log[t/2pi] is as large as t itself, so MachinePrecision's relative error would otherwise become an absolute phase error far bigger than zetacalc's Z(t) error). Returns a list of {height, zeta[height]} pairs, or $Failed. Accepts the same options as RiemannSiegelZSweep.";

RiemannSiegelZZeros::usage = "RiemannSiegelZZeros[t0, n, delta] finds sign changes of Z in an n-point zetacalc sweep and refines each to high precision by N-ary sweep-search, not binary bisection: each refinement round re-sweeps the CURRENT bracket at \"RefineWidth\" points in a single zetacalc call and keeps the adjacent pair whose sign differs, narrowing the bracket by ~RefineWidth per round instead of 2x. This matters because zetacalc's fixed per-call setup cost dominates its marginal per-point cost within one sweep by ~80-90x (measured directly: 5 separate single-point calls at t=1e14 took 8.5s; one 200-point sweep at the same height took under 2s) -- classic bisection paid that fixed cost on every single halving (15-20 separate process launches per zero), where sweep-search needs only 1-3 batched-sweep launches for the same tolerance. Returns a sorted list of t-values where Z(t) == 0, i.e. zeros of zeta(1/2+it) on the critical line (Z is constructed so that a sign change in the real Z is exactly a zero of the complex zeta -- unlike Re[zeta] or Im[zeta], which cross zero at many unrelated points and are not by themselves zero markers). CAUTION: only sign changes resolved by the initial grid are found -- if delta is coarser than the local zero spacing (~2*Pi/Log[t/(2 Pi)]), an even number of zeros between two consecutive grid points will be missed (the classical zero-counting caveat also relevant to Turing's method / zetacalc's own blfi tool, which this function does not use). Options: \"Tolerance\" (Automatic = 10^-6, a fixed absolute width in t independent of height -- worth tightening well past this default now that sweep-search makes it cheap: confirmed directly at t ~ 1e12 that the residual |Z| at the returned zero shrinks cleanly and proportionally as Tolerance tightens from 1e-6 to 1e-9 to 1e-12 (6*10^-7 -> 4*10^-11 -> 1*10^-13), reaching zetacalc's own genuine noise floor rather than plateauing at some fixed digit count -- past that floor, further tightening just fails instead of helping), \"MaxIterations\" (10, max refinement rounds -- generous headroom, since even reaching 1e-9 from a typical bracket width takes only 1-5 rounds at the default \"RefineWidth\"), \"RefineWidth\" (200, points per refinement sweep -- raising it trades a slightly more expensive sweep for fewer rounds; only matters for exotic cases, the default already captures most of the available speedup), plus all RiemannSiegelZSweep options.";

RiemannSiegelZPlot::usage = "RiemannSiegelZPlot[{tmin, tmax}] plots the Riemann-Siegel Z function over [tmin, tmax] using a single zetacalc sweep (bypassing Wolfram's native RiemannSiegelZ). The x-axis is height-tmin, not absolute t (tmin itself always sits at x=0, tmax at x=tmax-tmin) -- required, not cosmetic: at heights where tmax-tmin is a tiny fraction of tmin's own magnitude (already true past t ~ 1e15 for a window a few units wide), handing Graphics absolute t-coordinates collapses every x-coordinate to the same machine double before rendering even starts, since ListLinePlot's own machinery works in machine floats regardless of how precisely a height was computed symbolically. The absolute tmin is shown once, in the top FrameLabel slot (\"t = <tmin> + ...\"), and the frame ticks are labeled as matching small offsets, matplotlib-style. Any GridLines/Epilog/etc. you supply must therefore use height-tmin coordinates too, not absolute t. Option \"PlotPoints\" (200) sets the sweep size; \"ShowZeros\" -> True (default False) marks the zeros with GridLines (already shifted to the height-tmin frame), computed via RiemannSiegelZZeros on its own grid (sized off the local zero spacing, independent of \"PlotPoints\") -- off by default because, unlike sweeping, zero-refinement costs one zetacalc process launch per bisection step, so this can turn a quick plot into a multi-second one. All RiemannSiegelZSweep options are also accepted, and so is any option of ListLinePlot (e.g. an explicit GridLines -> {{0.3, 0.7}, {0}} at those height-tmin offsets, which takes priority over \"ShowZeros\"' own). Returns $Failed (with a message) on failure.";

RiemannSiegelZetaPlot::usage = "RiemannSiegelZetaPlot[{tmin, tmax}] plots zeta(1/2+i t) over [tmin, tmax] from a single zetacalc-backed sweep (RiemannSiegelZetaSweep). By default draws Re[zeta] and Im[zeta] against t as two lines (ListLinePlot with PlotLegends), styled to match built-in ReImPlot's own convention for a Re/Im pair -- same color, Re solid / Im dotted -- read at run time from an actual ReImPlot call rather than a hardcoded color/dashing literal, so it stays in step with the current $PlotTheme. In this line mode, the x-axis is height-tmin, not absolute t (see RiemannSiegelZPlot's docstring for why -- required at large heights, not cosmetic; the absolute tmin is shown once in the top FrameLabel), so any GridLines/Epilog/etc. you supply must use height-tmin coordinates. With \"Argand\" -> True it instead draws the parametric trace {Re[zeta[t]], Im[zeta[t]]} in the complex plane as t sweeps the range (ComplexListPlot, unaffected by any of this -- its axes are Re/Im, not t), where a zero of zeta shows up as the curve passing through the origin. \"ShowZeros\" -> True (default False, same cost caveat as RiemannSiegelZPlot) marks zeros with GridLines (already shifted to height-tmin) in the line-mode view; it is a no-op in Argand mode, where the origin itself already marks zeros. Option \"PlotPoints\" (200) sets the sweep size; all RiemannSiegelZSweep options are accepted, and so is any option of ListLinePlot or ComplexListPlot (whichever applies). Returns $Failed (with a message) on failure.";

Begin["`Private`"];

(* Captured at load time so it survives being called from deep inside Module[]. *)
zcKernelDir = DirectoryName[$InputFileName];

$ZetaCalcBinary = Automatic;
$ExternalBinaryUseWSL = Automatic;

(* ================================================================ *)
(* WSL bridging (Windows only; shared by RiemannSiegelZExternal and   *)
(* ZetaZeroLocate, same Orbit`Private` context, since zetacalc and    *)
(* zzz face the identical problem: a Linux ELF binary built inside    *)
(* WSL can't be launched directly by a native-Windows RunProcess --  *)
(* it has to run as "wsl.exe -e <linux-path> <args>"). Unverified     *)
(* against a real WSL install as of this writing.                    *)
(* ================================================================ *)

zcUseWSLQ[] := Which[
  $ExternalBinaryUseWSL === True, True,
  $ExternalBinaryUseWSL === False, False,
  True, $OperatingSystem === "Windows"
  ];

(* Memoized: wsl.exe has real per-call startup latency (a cold WSL2 VM
   boot can take seconds), and this would otherwise be paid on every
   single binary resolution/availability check. Clear with
   zcWSLAvailableQ[] =. (private, but harmless to reach into) if WSL
   state changes mid-session. *)
zcWSLAvailableQ[] := zcWSLAvailableQ[] = Module[{proc},
   proc = Quiet@RunProcess[{"wsl.exe", "-e", "true"}];
   AssociationQ[proc] && proc["ExitCode"] == 0
   ];

(* The Linux-side $HOME, queried through WSL itself -- there's no
   correspondence between a Windows-side paclet install path and the
   WSL Linux filesystem, so the sibling-checkout guess is resolved
   against this instead of $InputFileName when bridging. *)
zcWSLHomeDir[] := zcWSLHomeDir[] = Module[{proc},
   proc = Quiet@RunProcess[{"wsl.exe", "-e", "sh", "-c", "echo $HOME"}];
   If[AssociationQ[proc] && proc["ExitCode"] == 0, StringTrim[proc["StandardOutput"]], $Failed]
   ];

(* POSIX single-quote a string for safe inclusion in a shell command line:
   wrap in '...', escaping any embedded ' as '"'"' (close quote, literal
   quote, reopen quote). *)
zcShellQuote[s_String] := "'" <> StringReplace[s, "'" -> "'\"'\"'"] <> "'";

(* Full RunProcess argument list for invoking `binary args...`, bridged
   through WSL if applicable. Deliberately NOT "wsl.exe -e <path> <args>"
   -- wsl.exe's -e execs the target directly, skipping .bashrc/.profile,
   so any CUDA-related LD_LIBRARY_PATH/PATH setup done there (as WSL CUDA
   installs commonly require) would be silently absent even though the
   identical binary works fine from an interactive WSL shell -- exactly
   the failure mode reported: ZetaCalcCudaAvailableQ[] false on a machine
   confirmed to have a working CUDA build. Routing through "bash -lc"
   (a login shell) picks up the same environment an interactive session
   would have, at the cost of needing to shell-quote the command line
   ourselves instead of passing an argv list directly. *)
zcWSLCommand[binary_String, args_List] := If[zcUseWSLQ[] && zcWSLAvailableQ[],
   {"wsl.exe", "-e", "bash", "-lc", StringRiffle[zcShellQuote /@ Prepend[args, binary], " "]},
   Prepend[args, binary]
   ];

(* ================================================================ *)
(* Binary resolution                                                 *)
(* ================================================================ *)

ZetaCalcResolveBinary[] := Module[{envVar, siblingGuess, wslHome},
  envVar = Environment["ZETACALC_BINARY"];
  Which[
    $ZetaCalcBinary =!= Automatic, $ZetaCalcBinary,
    StringQ[envVar] && envVar =!= "", envVar,
    zcUseWSLQ[] && zcWSLAvailableQ[],
      wslHome = zcWSLHomeDir[];
      If[StringQ[wslHome], wslHome <> "/github/zeta/build/zetacalc", "zetacalc"],
    True,
      siblingGuess = Quiet@FileNameJoin[{ParentDirectory[zcKernelDir, 3], "zeta", "build", "zetacalc"}];
      If[Quiet[FileExistsQ[siblingGuess]] === True, siblingGuess, "zetacalc"]
  ]
];

ZetaCalcAvailableQ[] := Module[{proc},
  proc = Quiet@RunProcess[zcWSLCommand[ZetaCalcResolveBinary[], {"--help"}]];
  AssociationQ[proc] && proc["ExitCode"] == 0
];

ZetaCalcCudaAvailableQ[] := ZetaCalcCudaAvailableQ[] = Module[{proc},
  proc = Quiet@RunProcess[zcWSLCommand[ZetaCalcResolveBinary[],
     {"--t", "1000", "--N", "1", "--Z", "--terse", "--stage2-kernel", "cuda"}]];
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
  "StageKernel" -> Automatic,
  "HeightDigits" -> Automatic,
  "Terse" -> True,
  "ExtraArguments" -> {}
};

RiemannSiegelZSweep::nobin = "zetacalc binary not found or not runnable (tried `1`). Build it in the sibling zeta checkout (cmake -B build -S . && cmake --build build -j), or set $ZetaCalcBinary, the \"BinaryPath\" option, or the ZETACALC_BINARY environment variable.";
RiemannSiegelZSweep::exec = "zetacalc exited with code `1`: `2`";
RiemannSiegelZSweep::badout = "zetacalc produced a line that does not match the documented \"offset value 0\" contract: `1`. This may indicate stdout/stderr are no longer separated in this zetacalc build.";
RiemannSiegelZSweep::badcount = "zetacalc returned `1` output line(s) on stdout, expected `2`.";
RiemannSiegelZSweep::stagekernel = "unknown \"StageKernel\" -> `1` (expected \"fused\", \"reference\", \"cuda\", \"Auto\", or Automatic).";

RiemannSiegelZSweep[t0_?NumericQ, n_Integer?Positive, delta_?NumericQ, OptionsPattern[]] :=
 Module[{binary, digits, tStr, deltaStr, args, proc, exitCode, stdout, stderr,
   lines, parsed, badLine, stageKernel},
  digits = OptionValue["HeightDigits"];
  If[digits === Automatic, digits = 60];
  binary = If[OptionValue["BinaryPath"] =!= Automatic,
    OptionValue["BinaryPath"],
    ZetaCalcResolveBinary[]];
  tStr = zcDecimalString[t0, digits];
  deltaStr = zcDecimalString[delta, Max[digits, 20]];

  stageKernel = OptionValue["StageKernel"];
  If[stageKernel =!= Automatic && !MemberQ[{"fused", "reference", "cuda", "Auto"}, stageKernel],
   Message[RiemannSiegelZSweep::stagekernel, stageKernel];
   Return[$Failed]
   ];
  (* "Auto" opts into the real probe (ZetaCalcCudaAvailableQ) rather than
     unconditionally requesting cuda -- unlike a missing binary or a bad
     argument, requesting cuda on a non-CUDA build is a *clean* zetacalc-
     level failure (checked in its own source against stage2_cuda_available()),
     but still not something to hand the user by default. *)
  If[stageKernel === "Auto", stageKernel = If[ZetaCalcCudaAvailableQ[], "cuda", Automatic]];

  args = {"--t", tStr, "--N", ToString[n], "--delta", deltaStr, "--Z"};
  If[TrueQ[OptionValue["Terse"]], AppendTo[args, "--terse"]];
  If[OptionValue["Threads"] =!= Automatic,
    args = Join[args, {"--number_of_threads", ToString[OptionValue["Threads"]]}]];
  If[OptionValue["Kmin"] =!= Automatic,
    args = Join[args, {"--Kmin", ToString[OptionValue["Kmin"]]}]];
  If[OptionValue["GridCorrection"] =!= Automatic,
    args = Join[args, {"--grid-correction", OptionValue["GridCorrection"]}]];
  If[stageKernel =!= Automatic,
    args = Join[args, {"--stage2-kernel", stageKernel}]];
  args = Join[args, OptionValue["ExtraArguments"]];

  proc = Quiet[RunProcess[zcWSLCommand[binary, args]]];
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
  "MaxIterations" -> 10,
  "RefineWidth" -> 200
}];

RiemannSiegelZZeros::norefine = "no sign change found while refining a bracket (offset [`1`, `2`] from `3`); this should not happen if the original bracket was valid -- possible coincidental near-zero excursion between grid points, or a floating-point edge case.";

(* Same MachinePrecision-contamination guard as zcZerosInWindow's own
   delta fix (see there for the full mechanism): mixing a MachinePrecision
   number into arithmetic with an exact or high-precision one drags the
   *whole* result down to MachinePrecision, whose ULP can already exceed a
   refinement bracket's width at fairly moderate heights -- confirmed
   directly with a bare delta=0.01 at t=1e12 (ULP there is 2.22*10^-4,
   already bigger than the bracket after just one round of this module's
   own 200-way narrowing, which reaches that floor in far fewer rounds
   than the old 2x-per-round bisection did). Guarding t0/delta at entry
   protects the outer sweep and every refinement round that follows,
   rather than requiring every caller to remember to pass exact/rational
   height and delta. *)
zcSafePrecision[x_] := If[Precision[x] === MachinePrecision, SetPrecision[x, 30], x];

RiemannSiegelZZeros[t0_?NumericQ, n_Integer?Positive, delta_?NumericQ, opts : OptionsPattern[]] :=
 Module[{t0Safe = zcSafePrecision[t0], deltaSafe = zcSafePrecision[delta],
   sweepOpts, sweep, tol, maxIter, refineWidth, exactZeros, brackets, bisect, refined},
  sweepOpts = FilterRules[{opts}, Options[RiemannSiegelZSweep]];
  sweep = RiemannSiegelZSweep[t0Safe, n, deltaSafe, sweepOpts];
  If[FailureQ[sweep], Return[$Failed]];

  tol = OptionValue["Tolerance"];
  (* Fixed, height-independent: the local zero spacing shrinks only
     logarithmically with height, so a tolerance scaled *up* by height
     (an earlier version of this used 10^-12*height) becomes larger than
     any realistic bracket well before t ~ 1e9 -- refinement would then
     exit after zero rounds and silently return an unrefined,
     grid-resolution estimate. 10^-6 is comfortably tighter than any
     delta used in practice while staying cheap; tighten explicitly for
     more precision at very little extra cost now (see "RefineWidth"). *)
  If[tol === Automatic, tol = 10^-6];
  maxIter = OptionValue["MaxIterations"];
  refineWidth = OptionValue["RefineWidth"];

  (* A grid point landing exactly on a zero is its own answer -- no bracket
     needed (and Sign[0]*Sign[x] would never flag it as a sign change). *)
  exactZeros = Select[sweep, #[[2]] == 0 &][[All, 1]];

  brackets = Select[
    Table[{sweep[[k, 1]], sweep[[k + 1, 1]], sweep[[k, 2]], sweep[[k + 1, 2]]}, {k, Length[sweep] - 1}],
    (#[[3]]*#[[4]] < 0) &
    ];

  (* Refine in an offset from the bracket's own lower endpoint, not in
     absolute t: repeatedly working with two close *absolute* heights
     (both carrying the same large, unchanging integer part) is exactly
     the computation where high-precision inputs can still lose working
     precision to cancellation as the bracket narrows, and where
     MachinePrecision inputs hit a hard ULP floor set by the *absolute*
     magnitude rather than the (much finer) bracket width -- confirmed via
     ZetaZeroLocate at t ~ 3e10, where this floor was ~7e-6 in t, vs a
     documented zetacalc noise floor several orders of magnitude finer.
     ref only gets added back momentarily (to hand zetacalc an absolute
     height) and once at the end.

     N-ary sweep-search, not binary bisection: each round re-sweeps the
     *current* bracket at refineWidth points in a SINGLE zetacalc process
     call and keeps the adjacent pair whose sign differs, narrowing the
     bracket by ~refineWidth (not 2x) per round. Measured directly:
     zetacalc's fixed per-call setup cost (MPFR coefficient/stage
     computation) dominates its marginal per-point cost within one sweep
     by ~80-90x (5 separate single-point calls at t=1e14: 8.475s; one
     200-point sweep at the same height: well under 2s) -- classic
     bisection paid that fixed cost on every single halving, so this
     turns what was O(log2(gap/tolerance)) separate process launches per
     zero into O(log_refineWidth(gap/tolerance)) batched-sweep launches:
     typically 1-3 rounds instead of 15-20. *)
  bisect[{tlo_, thi_, zlo_, zhi_}] := Module[{ref = tlo, a = 0, b, iter = 0, sub, offs, vals, zeroPos, k},
    b = thi - tlo;
    While[(b - a) > tol && iter < maxIter,
     sub = RiemannSiegelZSweep[ref + a, refineWidth, (b - a)/(refineWidth - 1), sweepOpts];
     If[FailureQ[sub], Return[$Failed]];
     offs = sub[[All, 1]] - ref;
     vals = sub[[All, 2]];
     zeroPos = FirstPosition[vals, x_ /; x == 0];
     If[zeroPos =!= Missing["NotFound"],
      a = b = offs[[zeroPos[[1]]]];
      Break[]
      ];
     k = SelectFirst[Range[refineWidth - 1], Sign[vals[[#]]] != Sign[vals[[# + 1]]] &];
     If[MissingQ[k],
      Message[RiemannSiegelZZeros::norefine, N[a], N[b], N[ref]];
      Return[$Failed]
      ];
     a = offs[[k]];
     b = offs[[k + 1]];
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
  (* gap only needs to be right in order of magnitude (it just sizes the
     grid), but the bare N[tmin] above makes gap -- and delta below --
     MachinePrecision-tagged regardless. Mixing a MachinePrecision number
     into arithmetic with a high-precision tmin (inside RiemannSiegelZSweep's
     t0 + (k-1)*delta, called from RiemannSiegelZZeros below) drags the
     *whole computation* down to MachinePrecision -- confirmed directly:
     at t ~ 1e18 this collapsed every returned zero to the exact same
     double, making "ShowZeros"'s zeros - tmin come out identically 0
     everywhere. SetPrecision (not Rationalize -- tried first, but an
     *exact* rationalized delta gets reused in every sweep/bisection step
     downstream, and its denominator only grows from there, making the
     whole computation minutes slower, and rendering as a stacked
     fraction rather than a decimal in tick labels) gives delta a
     genuine, bounded-size arbitrary-precision tag instead of
     MachinePrecision, which stops it from dragging tmin's own precision
     down when added to it, without either side effect. *)
  delta = SetPrecision[gap/20, 30];
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
(* Tick POSITIONS are returned relative to tmin (0 .. tmax-tmin), matching
   the plotted data below (which is *also* shifted to height-tmin before
   being handed to ListLinePlot) -- not tmin + step*(k-1). It isn't just
   the label text that breaks at huge absolute heights: ListLinePlot's own
   rendering ultimately works in machine floats regardless of how
   precisely a position was computed symbolically, and at t ~ 1e18 a
   window of width 2 is ~1.2*10^-17 of tmin's own magnitude -- *below*
   double epsilon (2.22*10^-16). Handing Graphics absolute x-coordinates
   at that point doesn't just look "compressed"; confirmed by direct
   test, the auto-computed PlotRange comes back outright wrong (e.g.
   {0., 3.4*10^17} for a window that should read {tmin, tmin+2}), because
   bare N[] on the whole data structure collapses every t-coordinate to
   the *same* double before plotting even starts. Every offset computed
   from step alone (never from a subtraction of two near-equal huge
   numbers) sidesteps this at any height, for both the ticks and the data. *)
zcHeightTicks[tmin_?NumericQ, tmax_?NumericQ, numTicks_Integer : 6] := Module[
  {step, digits},
  step = (tmax - tmin)/(numTicks - 1);
  digits = Max[0, Ceiling[-Log10[Max[Abs[step], 10^-6]]] + 2];
  Table[
   With[{off = step*(k - 1)},
    {off,
     If[off == 0, "0",
      (* off is exact whenever tmin/tmax are (the common case for plain
         integer/rational bounds) and the window width doesn't divide
         evenly by numTicks-1 -- confirmed directly: NumberForm on an
         exact Rational renders a stacked fraction, not a decimal, no
         matter what digit count is requested; only N[] first fixes that.
         Skipped for already-approximate off (which N[] alone, with no
         explicit digit count, would instead collapse to MachinePrecision
         -- the exact reqsigz-class bug fixed earlier in this file). *)
      "+" <> ToString[NumberForm[
         If[Precision[off] === Infinity, N[off, digits + 10], off],
         {Infinity, digits}, ExponentFunction -> (Null &)]]]}
    ],
   {k, numTicks}
   ]
  ];

(* An Epilog placed with Scaled coordinates just outside [0,1] (e.g. y=1.04,
   just above the frame) gets clipped by the image bounding box more often
   than not -- confirmed by actually rendering and looking, not assumed.
   The FrameLabel "top" slot has guaranteed reserved layout space instead. *)
zcHeightReferenceLabel[tmin_?NumericQ] := Style[
  (* No bare N[tmin] here -- same MachinePrecision-collapse trap as
     zcHeightTicks above, just via NumberForm::reqsigz directly instead of
     a wrong tick value: at t ~ 1e18, tmin has ~19 integer digits but a
     bare N[] truncates it to MachinePrecision's ~16 significant digits,
     and NumberForm{Infinity,0} then can't show all the integer digits it
     was just asked for. NumberForm formats an exact or high-precision
     real directly, with no need for a pre-conversion that only discards
     information. *)
  "t = " <> If[IntegerQ[tmin], ToString[tmin],
    ToString[NumberForm[tmin, {Infinity, 0}, ExponentFunction -> (Null &)]]] <> " + ...",
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
   AppendTo[defaultOpts, GridLines -> {zeros - tmin, {0}}]
   ];
  (* Plotted x-coordinates are height-tmin, matching zcHeightTicks' now-
     relative positions -- see the comment there: at huge absolute
     heights, handing ListLinePlot's bare N[] the raw t-values (rather
     than an offset already small by construction) silently collapses
     every x-coordinate to the same double before rendering even starts. *)
  ListLinePlot[N[{#[[1]] - tmin, #[[2]]} & /@ data],
   Sequence @@ Normal[Join[Association[defaultOpts], Association[userPlotOpts]]]]
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
    AppendTo[defaultOpts, GridLines -> {zeros - tmin, {0}}]
    ];
   (* x-coordinates are height-tmin -- see the comment on zcHeightTicks:
      handing ListLinePlot absolute t at huge heights collapses every
      x-coordinate to the same double under its own bare N[], well before
      the tick labels even come into it. *)
   ListLinePlot[
    N[{{#[[1]] - tmin, Re[#[[2]]]} & /@ data, {#[[1]] - tmin, Im[#[[2]]]} & /@ data}],
    Sequence @@ Normal[Join[Association[defaultOpts], Association[userPlotOpts]]]]
   ]
  ];

End[];
EndPackage[];
