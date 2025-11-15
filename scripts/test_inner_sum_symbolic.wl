#!/usr/bin/env wolframscript
(* Test: Can Wolfram compute inner sum symbolically? *)

Print["================================================================"];
Print["SYMBOLIC INNER SUM: Fixed d, sum over k"];
Print["================================================================"];
Print[""];

Print["Goal: Compute S_d = Sum_{k=0}^inf [(p-kd-d^2)^2 + eps]^(-alpha)"];
Print[""];

(* ============================================================================ *)
(* TEST 1: Simple case - specific values                                      *)
(* ============================================================================ *)

Print["[1/4] Specific values: p=5, d=2, alpha=3"];
Print[""];

p = 5;
d = 2;
alpha = 3;

Print["Inner sum: S_2 = Sum_{k=0}^inf [(5-2k-4)^2 + eps]^(-3)"];
Print["         = Sum_{k=0}^inf [(1-2k)^2 + eps]^(-3)"];
Print[""];

Print["Attempting symbolic sum (timeout 30s)..."];

result = TimeConstrained[
  Sum[((p - k*d - d^2)^2 + eps)^(-alpha), {k, 0, Infinity},
    Assumptions -> {eps > 0, p > 0, d > 0, alpha > 0}],
  30,
  "TIMEOUT"
];

Print["Result: ", result];
Print[""];

If[result =!= "TIMEOUT",
  Print["Taking limit eps -> 0..."];
  limitResult = Limit[result, eps -> 0];
  Print["Limit: ", limitResult];
  Print[""];
  Print["Numerical: ", N[limitResult, 20]];
,
  Print["Sum did not converge symbolically in 30s"];
];

Print[""];

(* ============================================================================ *)
(* TEST 2: General symbolic form                                              *)
(* ============================================================================ *)

Print["[2/4] General form: symbolic p, d, alpha"];
Print[""];

Print["Attempting: Sum_{k=0}^inf [(p-kd-d^2)^2 + eps]^(-alpha)"];
Print[""];

Print["This is equivalent to: Sum_{k=0}^inf [(c-kd)^2 + eps]^(-alpha)"];
Print["  where c = p - d^2"];
Print[""];

Print["Attempting symbolic sum (timeout 60s)..."];

generalResult = TimeConstrained[
  Sum[((c - k*d)^2 + eps)^(-alpha), {k, 0, Infinity},
    Assumptions -> {eps > 0, c > 0, d > 0, alpha > 1/2}],
  60,
  "TIMEOUT"
];

Print["Result: ", generalResult];
Print[""];

If[generalResult =!= "TIMEOUT",
  Print["SUCCESS! Wolfram found closed form."];
  Print[""];
  Print["Now taking limit eps -> 0..."];
  generalLimit = Limit[generalResult, eps -> 0];
  Print["Limit: ", generalLimit];
,
  Print["Wolfram cannot compute this sum symbolically"];
];

Print[""];

(* ============================================================================ *)
(* TEST 3: Simplified version - ignore c offset                               *)
(* ============================================================================ *)

Print["[3/4] Simplified: Sum_{k=0}^inf [(kd)^2 + eps]^(-alpha)"];
Print[""];

Print["(Ignoring the c offset to see if that helps)"];
Print[""];

Print["Attempting symbolic sum (timeout 60s)..."];

simplifiedResult = TimeConstrained[
  Sum[((k*d)^2 + eps)^(-alpha), {k, 0, Infinity},
    Assumptions -> {eps > 0, d > 0, alpha > 1/2}],
  60,
  "TIMEOUT"
];

Print["Result: ", simplifiedResult];
Print[""];

If[simplifiedResult =!= "TIMEOUT",
  Print["Taking limit eps -> 0..."];
  simplifiedLimit = Limit[simplifiedResult, eps -> 0, Assumptions -> {d > 0, alpha > 1/2}];
  Print["Limit: ", simplifiedLimit];
  Print[""];

  (* This should be related to Zeta function *)
  Print["Expected form: d^(-2*alpha) * Zeta(2*alpha)"];
  Print["For alpha=3: d^(-6) * Zeta(6) = d^(-6) * Pi^6/945"];
,
  Print["Cannot compute symbolically"];
];

Print[""];

(* ============================================================================ *)
(* TEST 4: Even simpler - no eps, just convergent sum                         *)
(* ============================================================================ *)

Print["[4/4] Direct sum (no eps): Sum_{k=1}^inf k^(-2*alpha)"];
Print[""];

Print["This should give: Zeta(2*alpha)"];
Print[""];

zetaTest = Sum[k^(-6), {k, 1, Infinity}];
Print["Sum_{k=1}^inf k^(-6) = ", zetaTest];
Print["Zeta(6) = ", Zeta[6]];
Print["Simplified: ", Together[Zeta[6]]];
Print["  = Pi^6 / 945"];
Print[""];

Print["Numerical: ", N[Zeta[6], 20]];
Print[""];

(* ============================================================================ *)
(* ANALYSIS                                                                    *)
(* ============================================================================ *)

Print["================================================================"];
Print["ANALYSIS: Can we interchange sum and limit?"];
Print["================================================================"];
Print[""];

Print["Original double sum:"];
Print["  F_p = Sum_d Sum_k [(p-kd-d^2)^2 + eps]^(-alpha)"];
Print[""];

Print["Option A: Sum first, then limit"];
Print["  F_p = lim_{eps->0} Sum_d Sum_k [...]"];
Print[""];

Print["Option B: Limit for each d, then sum"];
Print["  F_p = Sum_d lim_{eps->0} Sum_k [...]"];
Print["     = Sum_d Sum_k |p-kd-d^2|^(-2*alpha)"];
Print[""];

Print["These are EQUAL if we can apply dominated convergence theorem."];
Print[""];

Print["For our case with alpha=3:"];
Print["  - Each term ~ k^(-6) for large k (rapid decay)"];
Print["  - Sum over k converges uniformly in eps"];
Print["  - Sum over d also converges (d^(-11) decay)"];
Print["  => We CAN interchange sum and limit!"];
Print[""];

Print["CONCLUSION:"];
Print["  F_p(alpha, eps=0) = Sum_{d>=2} Sum_{k>=0} |p-kd-d^2|^(-2*alpha)"];
Print[""];
Print["This is a well-defined DOUBLE SUM (no limit needed)."];
Print[""];

Print["================================================================"];
Print["QUESTION: Is this sum RATIONAL?"];
Print["================================================================"];
Print[""];

Print["Each term is rational: m^(-6) where m = |p-kd-d^2|"];
Print[""];

Print["But INFINITE sum of rationals need NOT be rational!"];
Print["Examples:"];
Print["  - Zeta(6) = Sum k^(-6) = Pi^6/945 (IRRATIONAL)"];
Print["  - e = Sum 1/n! (TRANSCENDENTAL)"];
Print[""];

Print["Our sum has SPECIAL STRUCTURE:"];
Print["  F_p(alpha) = Sum_{m=1}^inf c_m(p) * m^(-2*alpha)"];
Print[""];

Print["where c_m(p) counts lattice representations."];
Print[""];

Print["HYPOTHESIS: Despite being infinite, F_p(alpha) might be"];
Print["            algebraic (or even rational) due to special"];
Print["            arithmetic structure of c_m(p)."];
Print[""];

Print["But we have NO PROOF of this!"];
Print[""];

Print["The '703166705641/351298031616' is just a NUMERICAL"];
Print["APPROXIMATION, not an exact value."];
Print[""];
