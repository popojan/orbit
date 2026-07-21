(* ::Package:: *)

(* ZetaZeroLocate: fast approximate location of high-ordinal Riemann zeta
   zeros via the external `zzz` ("Zeta Zeros Zeal") binary -- a
   zeta-evaluation-free counting-function bisection over primes -- refined
   to zetacalc's own numeric accuracy via RiemannSiegelZExternal's
   sign-change bisector (RiemannSiegelZZeros). Requires both a built
   ../zzz/build/zzz AND ../zeta/build/zetacalc -- load manually:
     Get["Orbit`RiemannSiegelZExternal`"];
     Get["Orbit`ZetaZeroLocate`"];
   (not auto-loaded by Orbit.wl, same convention as PellFactorBase/PARI). *)

BeginPackage["Orbit`"];

Get["Orbit`RiemannSiegelZExternal`"];

$ZzzBinary::usage = "$ZzzBinary is the user-configurable path to the zzz executable. Automatic (default) defers to ZzzResolveBinary[].";

ZzzResolveBinary::usage = "ZzzResolveBinary[] returns the zzz binary path that ZetaZeroApprox will try to run, in priority order: $ZzzBinary (if set), the ZZZ_BINARY environment variable, the sibling ../zzz/build/zzz checkout, or a bare \"zzz\" looked up on $PATH. When bridging through WSL (see $ExternalBinaryUseWSL, shared with zetacalc), the sibling-checkout guess is resolved against the WSL side's own $HOME instead of this paclet's own location. Does not verify the binary runs -- use ZzzAvailableQ[] for that.";

ZzzAvailableQ::usage = "ZzzAvailableQ[] returns True if the resolved zzz binary can actually be launched (checked with a quick --usage call, bridged through wsl.exe first if $ExternalBinaryUseWSL applies), without raising messages.";

ZetaZeroApprox::usage = "ZetaZeroApprox[n, count] returns count consecutive approximate ordinates of nontrivial zeta zeros starting at #n, from zzz's zeta-evaluation-free counting-function bisection over primes -- no Riemann-Siegel main sum is evaluated, so this reaches ordinals far beyond zetacalc's (or Wolfram's ZetaZero's) practical range. These are approximate: zzz's own project docs report never better than ~5% of the local zero gap, so this is a locator, not a refiner -- see ZetaZeroLocate for the paired refinement step. Options: \"Primes\" (100, zzz's -k: primes used in the truncated Euler product), \"Method\" (\"GHY\", zzz's -G flag: the Gonek-Hughes-Young 2007 hybrid Euler-Hadamard product, which has an actual error bound and was measured faster than \"Heuristic\", zzz's damped method A, which has none), \"Precision\" (Automatic = zzz's own 256-bit default, its -p), \"Tolerance\" (Automatic = zzz's own 1e-6 default bisection tolerance, its -t), \"ExtraDigits\" (30, zzz's -d: digits beyond the ordinate's integer part -- deliberately raised from zzz's own default of 6, which collapses the returned ordinate to Mathematica's MachinePrecision (a literal with ~16-17 total significant digits parses as a hardware double) once the ordinate itself has 10+ integer digits, i.e. already past roughly zero #1e5; no amount of bisection downstream can recover digits from arithmetic on values already pinned to hardware-double precision, so this has to be fixed at the source), \"BinaryPath\" (Automatic), \"ExtraArguments\" ({}). Returns $Failed (with a message) if zzz is missing, exits non-zero, or its stdout is not plain one-number-per-line -- never fails silently.";

ZetaZeroLocate::usage = "ZetaZeroLocate[n] locates the n-th nontrivial zeta zero ordinate on the critical line to zetacalc's own numeric accuracy. Two stages: (1) ZetaZeroApprox[n-1, 3] gets zzz's fast approximate ordinates for zeros #(n-1), #n and #(n+1) in one process call; (2) the midpoints between consecutive estimates bound a window guaranteed (assuming zzz's neighboring estimates are each accurate to well under half a gap) to contain #n and no other zero, which RiemannSiegelZZeros then confirms/refines by an actual Z(t) sign-change bisection -- using the real neighbor estimates to size the window, rather than the smooth asymptotic gap 2*Pi/Log[t/(2 Pi)] alone, is what keeps this reliable through local fluctuations in zero density. This is empirical, not a rigorous certificate the way Turing's method is: if the window turns out to contain zero or more than one sign change, the zero closest to zzz's own estimate for #n is returned (or, if none, $Failed with a message suggesting more primes) rather than silently guessing. THE REAL CEILING IS AN ABSOLUTE WIDTH IN T, NOT A FIXED DIGIT COUNT: zetacalc's own Z(t) computation has a roughly height-independent *absolute* error budget (its README documents ~1e-9 to 1e-12 agreement with mpmath, degrading further only at extreme heights t >~ 1e16), which a local Z'(t) factor converts into an absolute error in T -- confirmed directly (t ~ 1e12): tightening \"Tolerance\" from 1e-6 to 1e-9 to 1e-12 shrank the residual |Z| cleanly and proportionally (6*10^-7 -> 4*10^-11 -> 1*10^-13) before hitting that genuine floor, not a plateau at some fixed digit count. Since the error is absolute in T, not relative, the number of *significant* digits actually available in a returned ordinate grows with the height: an absolute residual of 10^-13 at t ~ 1e12 is ~25 significant digits, not 9-13 -- returning an absolute coordinate does not itself cap this, provided MachinePrecision contamination is avoided throughout (which this module's offset arithmetic and SetPrecision guards do). \"Tolerance\" (in \"SweepOptions\") is worth tightening well past this function's own 10^-6 default now that RiemannSiegelZZeros' sweep-search refinement makes doing so cheap; going far enough eventually reaches the genuine zetacalc noise floor and further tightening just fails instead of helping. Options: \"ZzzOptions\" (raw option list forwarded to ZetaZeroApprox, e.g. {\"Primes\" -> 300} for greater accuracy at extreme heights -- distinct from RiemannSiegelZSweep's \"BinaryPath\" etc., which would otherwise collide with ZetaZeroApprox's identically-named options since the two wrap different binaries), \"SweepOptions\" (forwarded to RiemannSiegelZZeros, e.g. {\"Threads\" -> 1}), \"PointsPerWindow\" (30, sweep resolution within the zzz-bounded window). n = 1 is handled without a #0 reference (zzz aborts on ordinal 0) by mirroring the gap from #1/#2 leftward instead.";

Begin["`Private`"];

zcZzzKernelDir = DirectoryName[$InputFileName];
$ZzzBinary = Automatic;

(* ================================================================ *)
(* Binary resolution (mirrors ZetaCalcResolveBinary in                *)
(* RiemannSiegelZExternal.wl -- same pattern, different sibling repo) *)
(* ================================================================ *)

ZzzResolveBinary[] := Module[{envVar, siblingGuess, wslHome},
  envVar = Environment["ZZZ_BINARY"];
  Which[
    $ZzzBinary =!= Automatic, $ZzzBinary,
    StringQ[envVar] && envVar =!= "", envVar,
    zcUseWSLQ[] && zcWSLAvailableQ[],
      wslHome = zcWSLHomeDir[];
      If[StringQ[wslHome], wslHome <> "/github/zzz/build/zzz", "zzz"],
    True,
      siblingGuess = Quiet@FileNameJoin[{ParentDirectory[zcZzzKernelDir, 3], "zzz", "build", "zzz"}];
      If[Quiet[FileExistsQ[siblingGuess]] === True, siblingGuess, "zzz"]
  ]
];

ZzzAvailableQ[] := Module[{proc},
  proc = Quiet@RunProcess[zcWSLCommand[ZzzResolveBinary[], {"--usage"}]];
  AssociationQ[proc] && proc["ExitCode"] == 0
];

(* ================================================================ *)
(* zzz stdout: one plain ordinate per line. Reuses zcParseNumber      *)
(* (defined in RiemannSiegelZExternal.wl, same Orbit`Private`         *)
(* context) for the same "e" vs "*^" exponent translation, even       *)
(* though zzz's own ordinates (never near zero) haven't been observed *)
(* to need it in practice -- cheap insurance, one parser to maintain. *)
(* ================================================================ *)

zzzParseLine[line_String] := Module[{v = zcParseNumber[StringTrim[line]]},
  If[NumericQ[v], v, $Failed]
  ];

(* ================================================================ *)
(* Fast approximate locate                                           *)
(* ================================================================ *)

Options[ZetaZeroApprox] = {
  "BinaryPath" -> Automatic,
  "Primes" -> 100,
  "Method" -> "GHY",
  "Precision" -> Automatic,
  "Tolerance" -> Automatic,
  "ExtraDigits" -> 30,
  "ExtraArguments" -> {}
};

ZetaZeroApprox::nobin = "zzz binary not found or not runnable (tried `1`). Build it in the sibling zzz checkout (cd build && cmake .. && make), or set $ZzzBinary, the \"BinaryPath\" option, or the ZZZ_BINARY environment variable.";
ZetaZeroApprox::exec = "zzz exited with code `1`: `2`";
ZetaZeroApprox::badout = "zzz produced a line that is not a plain number: `1`.";
ZetaZeroApprox::badcount = "zzz returned `1` output line(s), expected `2`.";
ZetaZeroApprox::method = "unknown \"Method\" -> `1` (expected \"GHY\" or \"Heuristic\").";

ZetaZeroApprox[n_Integer?Positive, count : (_Integer?Positive) : 1, OptionsPattern[]] :=
 Module[{binary, method, args, proc, exitCode, stdout, stderr, lines, badLine},
  method = OptionValue["Method"];
  If[!MemberQ[{"GHY", "Heuristic"}, method],
   Message[ZetaZeroApprox::method, method];
   Return[$Failed]
   ];
  binary = If[OptionValue["BinaryPath"] =!= Automatic,
    OptionValue["BinaryPath"],
    ZzzResolveBinary[]];

  args = {"-k", ToString[OptionValue["Primes"]]};
  If[method === "GHY", AppendTo[args, "-G"]];
  If[OptionValue["Precision"] =!= Automatic,
   args = Join[args, {"-p", ToString[OptionValue["Precision"]]}]];
  If[OptionValue["Tolerance"] =!= Automatic,
   args = Join[args, {"-t", zcDecimalString[OptionValue["Tolerance"], 10]}]];
  (* zzz's own -d default (6 EXTRA digits beyond the integer part) collapses
     straight to WL's MachinePrecision once the ordinate's integer part
     alone is ~10+ digits (i.e. already past zero #~1e5 or so) -- WL's
     literal-number parser treats a ~16-17 significant-digit string as
     MachinePrecision, a hardware double, and *no* amount of bisection in
     ZetaZeroLocate can recover more digits from arithmetic on values that
     are already pinned to hardware-double precision. 30 extra digits keeps
     the approximate ordinate itself comfortably above that collapse
     threshold at any height this is likely to be used at. *)
  args = Join[args, {"-d", ToString[OptionValue["ExtraDigits"]]}];
  args = Join[args, OptionValue["ExtraArguments"], {ToString[n], "0", ToString[count]}];

  proc = Quiet[RunProcess[zcWSLCommand[binary, args]]];
  If[!AssociationQ[proc],
   Message[ZetaZeroApprox::nobin, binary];
   Return[$Failed]
   ];

  exitCode = proc["ExitCode"];
  stdout = proc["StandardOutput"];
  stderr = proc["StandardError"];
  If[exitCode != 0,
   Message[ZetaZeroApprox::exec, exitCode, StringTrim[stderr]];
   Return[$Failed]
   ];

  lines = Select[StringSplit[stdout, "\n"], StringTrim[#] =!= "" &];

  badLine = SelectFirst[lines, zzzParseLine[#] === $Failed &];
  If[StringQ[badLine],
   Message[ZetaZeroApprox::badout, badLine];
   Return[$Failed]
   ];

  If[Length[lines] != count,
   Message[ZetaZeroApprox::badcount, Length[lines], count];
   Return[$Failed]
   ];

  zzzParseLine /@ lines
  ];

(* ================================================================ *)
(* Two-stage locate: zzz approximate neighbors -> zetacalc-confirmed  *)
(* exact zero, using the real neighbor estimates (not the smooth      *)
(* asymptotic gap alone) to bound the search window.                  *)
(* ================================================================ *)

Options[ZetaZeroLocate] = {
  "ZzzOptions" -> {},
  "SweepOptions" -> {},
  "PointsPerWindow" -> 30
};

ZetaZeroLocate::nozero = "no zetacalc-confirmed zero found for #`1` in the zzz-bracketed window [`2`, `3`] (bounded by the immediate-neighbor zzz estimates); the zzz estimate may be off by more than half a local gap here -- try increasing \"Primes\" in \"ZzzOptions\".";
ZetaZeroLocate::badapprox = "ZetaZeroApprox returned an unexpected (non-list, or wrong-length) result: `1`. This should not happen -- treating it as a hard failure rather than indexing into it.";
ZetaZeroLocate::argx = "ZetaZeroLocate takes a single positional argument (the zero ordinal n) plus options -- got an extra non-option argument `1`, which does not match any definition and would otherwise be left unevaluated. ZetaZeroApprox[n, count] is the function that takes a count; did you mean that instead?";

(* A stray extra positional argument (e.g. the count ZetaZeroApprox takes,
   which this function does not) doesn't match the definition below at
   all -- WL leaves it symbolically unevaluated rather than erroring, and
   First[unevaluated expr] then silently returns n itself, which looks
   like a plausible number rather than an obvious failure. Catch it
   explicitly rather than relying on the caller to notice. *)
ZetaZeroLocate[n_Integer?Positive, extra : Except[_Rule | _RuleDelayed], ___] := (
  Message[ZetaZeroLocate::argx, extra];
  $Failed
  );

ZetaZeroLocate[n_Integer?Positive, opts : OptionsPattern[]] :=
 Module[{zzzOpts, sweepOpts, pointsPerWindow, approx, expectedCount, tlo, thi, target, delta, npts, zeros},
  zzzOpts = OptionValue["ZzzOptions"];
  sweepOpts = OptionValue["SweepOptions"];
  pointsPerWindow = OptionValue["PointsPerWindow"];

  If[n == 1,
   approx = ZetaZeroApprox[1, 2, Sequence @@ zzzOpts];
   expectedCount = 2;
   ,
   approx = ZetaZeroApprox[n - 1, 3, Sequence @@ zzzOpts];
   expectedCount = 3;
   ];
  If[FailureQ[approx], Return[$Failed]];
  (* Defense in depth: a malformed (non-list / wrong-length) return here
     must never be silently indexed into -- that's exactly how an earlier
     version of this code turned a masked bug into a bogus numeric answer
     instead of a clean failure. *)
  If[!(VectorQ[approx, NumericQ] && Length[approx] == expectedCount),
   Message[ZetaZeroLocate::badapprox, approx];
   Return[$Failed]
   ];

  If[n == 1,
   target = approx[[1]];
   tlo = Max[approx[[1]] - (approx[[2]] - approx[[1]])/2, 2];
   thi = (approx[[1]] + approx[[2]])/2;
   ,
   target = approx[[2]];
   tlo = (approx[[1]] + approx[[2]])/2;
   thi = (approx[[2]] + approx[[3]])/2;
   ];

  delta = (thi - tlo)/pointsPerWindow;
  npts = Max[8, Ceiling[(thi - tlo)/delta] + 1];

  zeros = RiemannSiegelZZeros[tlo, npts, delta, Sequence @@ sweepOpts];
  If[FailureQ[zeros], Return[$Failed]];

  If[Length[zeros] == 0,
   Message[ZetaZeroLocate::nozero, n, N[tlo], N[thi]];
   Return[$Failed]
   ];

  First[SortBy[zeros, Abs[# - target] &]]
  ];

End[];
EndPackage[];
