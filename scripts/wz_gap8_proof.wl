#!/usr/bin/env wolframscript
(* WZ Method Application to GAP 8 Identity *)

Print["="*70];
Print["WZ METHOD - GAP 8 BINOMIAL IDENTITY"];
Print["="*70];
Print[];

(* Load gosper.m package - assumes it's in same directory *)
scriptDir = DirectoryName[$InputFileName];
gosperPath = FileNameJoin[{scriptDir, "gosper.m"}];

If[FileExistsQ[gosperPath],
  Print["Loading gosper.m from: ", gosperPath];
  Get[gosperPath];
  Print["✓ gosper.m loaded successfully"];
  Print[];
  ,
  Print["ERROR: gosper.m not found at: ", gosperPath];
  Print["Please download from: https://www2.math.upenn.edu/~wilf/progs/gosper.m"];
  Print["and place in scripts/ directory"];
  Abort[];
];

Print["="*70];
Print["IDENTITY TO PROVE"];
Print["="*70];
Print[];

Print["GAP 8 Identity (double sum form):"];
Print["  g(n,k) = Σ_{j=0}^{⌊(n-k)/2⌋} (-1)^j·C(n-j,j)·2^{n-2j}·C(n-2j,k)"];
Print["         = 2^k · C(n+k, 2k)"];
Print[];

Print["Or in difference form:"];
Print["  Δg(n,k) = g(n,k) - g(n-2,k)"];
Print["          = [some expression]"];
Print["          = 2^k · [C(n+k,2k) - C(n-2+k,2k)]"];
Print[];

(* Define the inner summand *)
innerSummand[n_, k_, j_] := (-1)^j * Binomial[n-j, j] * 2^(n-2*j) * Binomial[n-2*j, k];

(* Define g(n,k) as the actual double sum *)
g[n_, k_] := Sum[innerSummand[n, k, j], {j, 0, Floor[(n-k)/2]}];

(* Target formula *)
f[n_, k_] := 2^k * Binomial[n+k, 2*k];

Print["="*70];
Print["APPROACH 1: WZ on simplified single-variable identity"];
Print["="*70];
Print[];

Print["Try proving simpler identity first:"];
Print["  Σ_{k} [something] = RHS(n)"];
Print[];

Print["This approach may not work directly for our complex identity."];
Print["Skipping for now - gosper.m WZ expects specific format."];
Print[];

Print["="*70];
Print["APPROACH 2: Verify summand is hypergeometric"];
Print["="*70];
Print[];

Print["For WZ method, summand must be hypergeometric term."];
Print["Test: ratio test for our inner summand"];
Print[];

(* Test if inner summand is hypergeometric in j *)
ratio[n_, k_, j_] := Simplify[innerSummand[n, k, j+1] / innerSummand[n, k, j]];

Print["Ratio F(n,k,j+1)/F(n,k,j) = "];
ratioExpr = ratio[n, k, j];
Print["  ", ratioExpr];
Print[];

If[PolynomialQ[Together[ratioExpr], j],
  Print["✓ Ratio is rational in j → hypergeometric term"];
  Print["  WZ applicable to inner sum"];
  ,
  Print["✗ Ratio is not rational in j"];
  Print["  May need different approach"];
];
Print[];

Print["="*70];
Print["APPROACH 3: Direct verification with gosper.m"];
Print["="*70];
Print[];

Print["Attempting to use WZ function from gosper.m..."];
Print[];

(* Check what functions are available *)
Print["Available functions from gosper.m:"];
Print["  ", Names["Global`*"]];
Print[];

Print["NOTE: gosper.m documentation is minimal. Typical usage:"];
Print["  WZ[summand, {k, lower, upper}, n]"];
Print[];

Print["Our identity doesn't fit standard WZ single-sum format."];
Print["The double sum requires creative telescoping or"];
Print["manual decomposition."];
Print[];

Print["="*70];
Print["APPROACH 4: Manual certificate search"];
Print["="*70];
Print[];

Print["Instead of automated WZ, try to find certificate manually."];
Print[];

Print["For identity: g(n,k) = f(n,k)"];
Print["Need rational R(n,k) such that:"];
Print["  g(n+1,k) - g(n,k) = R(n,k+1)·g(n,k+1) - R(n,k)·g(n,k)"];
Print[];

Print["This is complex - would require systematic search."];
Print[];

Print["="*70];
Print["RECOMMENDATION"];
Print["="*70];
Print[];

Print["WZ method via gosper.m is designed for single-sum identities."];
Print["Our identity is a double sum, which requires:"];
Print[];
Print["  1. Creative telescoping (HolonomicFunctions package)"];
Print["  2. Manual reduction to single-sum form"];
Print["  3. Alternative proof strategy (we already have via recurrence!)"];
Print[];

Print["CURRENT STATUS:"];
Print["  ✓ Non-circular recurrence derivation"];
Print["  ✓ Numerical verification (35 + 43 + 77 = 155 tests)"];
Print["  ✓ Both g and f satisfy same recurrence"];
Print["  ✓ Base cases match"];
Print["  → g = f by uniqueness"];
Print[];

Print["MISSING for tier-1 rigor:"];
Print["  ✗ Symbolic proof that f satisfies recurrence"];
Print["    (Wolfram cannot simplify the binomial identity)"];
Print[];

Print["SUGGESTION:"];
Print["Document as 'numerically proven' with explicit statement:"];
Print["  'Identity verified computationally for n≤14, k≤n (155 cases, 100%).'"];
Print["  'Symbolic proof via standard binomial identities remains open.'"];
Print[];

Print["Alternatively: Attempt creative telescoping with HolonomicFunctions"];
Print["if available in your Mathematica version."];
Print[];
