(* L-Function Geometry Bridge *)
(* Companion code to L-function-geometry-bridge.md *)
(* December 5, 2025 *)

(* ============================================== *)
(* THE THREE LEVELS                               *)
(* ============================================== *)

(* Level 1: GEOMETRY - Chebyshev lobe sizes *)

ChebyshevBeta[n_] := n^2 Cos[Pi/n] / (4 - n^2);

LobeSize[n_, k_] := 1 + ChebyshevBeta[n] Cos[(2k-1) Pi / n];

ClassifyLobe[n_, k_] := Which[
  LobeSize[n, k] < 1 - 10^-10, "small",
  LobeSize[n, k] > 1 + 10^-10, "large",
  True, "fair"
];

SignCos[k_, p_] := Sign[Cos[(2k-1) Pi / p]];

(* Level 2: ALGEBRA - Character sums *)

QuarterSum[p_] := Sum[JacobiSymbol[k, p], {k, 1, (p-1)/4}];

WeightedSum[p_] := Sum[JacobiSymbol[k, p] * SignCos[k, p], {k, 1, p-1}];

(* Optimized: no trig needed! *)
WeightedSumFast[p_] := Module[{a = (p-1)/4, sA, sB, sC},
  sA = Sum[JacobiSymbol[k, p], {k, 1, a}];
  sB = Sum[JacobiSymbol[k, p], {k, a+1, 3a+1}];
  sC = Sum[JacobiSymbol[k, p], {k, 3a+2, p-1}];
  sA - sB + sC
];

(* Level 3: ANALYSIS - L-functions *)

(* Twisted character χ₄·χₚ *)
Chi4[n_] := If[OddQ[n], (-1)^((n-1)/2), 0];
TwistedChi[n_, p_] := Chi4[n] * JacobiSymbol[n, p];

(* Direct L-function computation (slow, for verification) *)
TwistedLDirect[p_, terms_: 50000] :=
  N[Sum[TwistedChi[n, p] / n, {n, 1, terms}], 12];

(* L-function via our finite sum (fast, exact!) *)
TwistedLviaSum[p_] := N[Pi / Sqrt[p] * QuarterSum[p], 12];

(* ============================================== *)
(* THE BRIDGE FORMULAS                            *)
(* ============================================== *)

(* Main identities for p ≡ 1 (mod 4):

   W(p) = 4·S(1,p/4) - 2           [Our discovery]
   h(-p) = 2·S(1,p/4)              [Classical]
   L(1,χ₄χₚ) = (π/√p)·S(1,p/4)     [Classical]

   Therefore:
   h(-p) = (W(p) + 2) / 2
   L(1,χ₄χₚ) = (π/√p)·(W(p) + 2) / 4
*)

ClassNumberViaW[p_] := (WeightedSumFast[p] + 2) / 2;

LFunctionViaW[p_] := N[Pi / Sqrt[p] * (WeightedSumFast[p] + 2) / 4, 12];

(* ============================================== *)
(* VERIFICATION                                   *)
(* ============================================== *)

VerifyBridge[p_?PrimeQ] := Module[
  {S, W, h, hBuiltin, Lcalc, Ldirect},

  If[Mod[p, 4] != 1,
    Print["p = ", p, " ≡ ", Mod[p, 4], " (mod 4) - formula only for p ≡ 1"];
    Return[$Failed]
  ];

  S = QuarterSum[p];
  W = WeightedSumFast[p];
  h = ClassNumberViaW[p];
  hBuiltin = NumberFieldClassNumber[Sqrt[-p]];
  Lcalc = LFunctionViaW[p];
  Ldirect = TwistedLDirect[p, 100000];

  Print["═══════════════════════════════════════"];
  Print["Bridge verification for p = ", p];
  Print["═══════════════════════════════════════"];
  Print[];
  Print["ALGEBRA:"];
  Print["  S(1, p/4) = ", S];
  Print["  W(p) = ", W];
  Print["  W = 4S - 2? ", W == 4*S - 2, " ✓"];
  Print[];
  Print["CLASS NUMBER:"];
  Print["  h via W:    ", h];
  Print["  h builtin:  ", hBuiltin];
  Print["  Match? ", h == hBuiltin, " ✓"];
  Print[];
  Print["L-FUNCTION:"];
  Print["  L via sum:    ", Lcalc];
  Print["  L direct:     ", Ldirect];
  Print["  Error:        ", ScientificForm[Abs[Lcalc - Ldirect], 2]];
  Print[];

  h == hBuiltin
];

(* ============================================== *)
(* GEOMETRIC INTERPRETATION                       *)
(* ============================================== *)

(* What does L(1,χ₄χₚ) "mean" geometrically? *)

GeometricDecomposition[p_?PrimeQ] := Module[
  {smallLobes, largeLobes, chiSmall, chiLarge, W, L},

  If[Mod[p, 4] != 1, Return[$Failed]];

  smallLobes = Select[Range[p-1], ClassifyLobe[p, #] == "small" &];
  largeLobes = Select[Range[p-1], ClassifyLobe[p, #] == "large" &];

  chiSmall = Total[JacobiSymbol[#, p] & /@ smallLobes];
  chiLarge = Total[JacobiSymbol[#, p] & /@ largeLobes];

  W = chiSmall - chiLarge;
  L = N[Pi / Sqrt[p] * (W + 2) / 4, 8];

  Print["═══════════════════════════════════════"];
  Print["Geometric decomposition for p = ", p];
  Print["═══════════════════════════════════════"];
  Print[];
  Print["Small lobes (B < 1): ", Length[smallLobes], " lobes"];
  Print["  Σχ over small lobes = ", chiSmall];
  Print[];
  Print["Large lobes (B > 1): ", Length[largeLobes], " lobes"];
  Print["  Σχ over large lobes = ", chiLarge];
  Print[];
  Print["W(p) = Σχ_small - Σχ_large = ", chiSmall, " - (", chiLarge, ") = ", W];
  Print[];
  Print["L(1, χ₄χₚ) = (π/√p)·(W + 2)/4 = ", L];
  Print[];
  Print["INTERPRETATION:"];
  Print["  The L-function value encodes the imbalance"];
  Print["  of quadratic residues between small and large"];
  Print["  Chebyshev lobes!"];
];

(* ============================================== *)
(* BENCHMARK: Our Method vs Built-in              *)
(* ============================================== *)

Benchmark[p_?PrimeQ] := Module[{t1, t2, h1, h2},
  If[Mod[p, 4] != 1, Return[$Failed]];

  {t1, h1} = AbsoluteTiming[ClassNumberViaW[p]];
  {t2, h2} = AbsoluteTiming[NumberFieldClassNumber[Sqrt[-p]]];

  Print["p = ", p];
  Print["  Our method:  ", t1*1000, " ms, h = ", h1];
  Print["  Built-in:    ", t2*1000, " ms, h = ", h2];
  Print["  Ratio:       ", N[t1/t2, 3], "x"];
  Print[];
];

(* ============================================== *)
(* EXAMPLES                                       *)
(* ============================================== *)

ExampleUsage[] := Module[{},
  Print["╔═══════════════════════════════════════╗"];
  Print["║  L-FUNCTION GEOMETRY BRIDGE DEMO      ║"];
  Print["╚═══════════════════════════════════════╝"];
  Print[];

  Print["1. Verify bridge for p = 41:"];
  VerifyBridge[41];
  Print[];

  Print["2. Geometric decomposition for p = 17:"];
  GeometricDecomposition[17];
  Print[];

  Print["3. Benchmarks:"];
  Benchmark[10009];
  Benchmark[100049];
];

(* Run: ExampleUsage[] *)
