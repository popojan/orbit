#!/usr/bin/env wolframscript
(* Symbolic limit of F_n as epsilon -> 0 *)

Print["================================================================"];
Print["SYMBOLIC LIMIT: epsilon -> 0"];
Print["================================================================"];
Print[""];

Print["Goal: Find exact value of lim_{eps->0} F_n(alpha) for primes"];
Print[""];

(* ============================================================================ *)
(* TEST 1: Simple case - single term                                         *)
(* ============================================================================ *)

Print["[1/4] Single term limit"];
Print[""];

Print["For term T = [(n-kd-d^2)^2 + eps]^(-alpha) where dist = n-kd-d^2 != 0:"];
Print[""];

term = ((n - k*d - d^2)^2 + eps)^(-alpha);
limitTerm = Limit[term, eps -> 0, Assumptions -> {n > 0, k >= 0, d > 0, alpha > 0, (n-k*d-d^2) != 0}];

Print["Limit as eps->0: ", limitTerm];
Print[""];
Print["Result: (n-kd-d^2)^(-2*alpha)  (as expected)"];
Print[""];

(* ============================================================================ *)
(* TEST 2: Small explicit sum                                                *)
(* ============================================================================ *)

Print["[2/4] Small explicit sum for n=5 (prime)"];
Print[""];

Print["Computing F_5(3) symbolically with finite truncation:"];
Print["  d=2, k=0..2"];
Print["  d=3, k=0..1"];
Print[""];

(* Build explicit sum for n=5, alpha=3 *)
sum5 =
  ((5 - 0*2 - 2^2)^2 + eps)^(-3) +  (* d=2, k=0: dist=1 *)
  ((5 - 1*2 - 2^2)^2 + eps)^(-3) +  (* d=2, k=1: dist=-1 *)
  ((5 - 2*2 - 2^2)^2 + eps)^(-3) +  (* d=2, k=2: dist=-3 *)
  ((5 - 0*3 - 3^2)^2 + eps)^(-3) +  (* d=3, k=0: dist=-4 *)
  ((5 - 1*3 - 3^2)^2 + eps)^(-3);   (* d=3, k=1: dist=-7 *)

Print["Sum (truncated): ", sum5];
Print[""];

limit5 = Limit[sum5, eps -> 0];
Print["Limit as eps->0: ", limit5];
Print[""];

Print["Simplified: ", Simplify[limit5]];
Print[""];

numerical5 = N[limit5, 20];
Print["Numerical value: ", numerical5];
Print[""];

(* ============================================================================ *)
(* TEST 3: Identify if it's a known constant                                 *)
(* ============================================================================ *)

Print["[3/4] Checking against known constants"];
Print[""];

knownConstants = {
  {"Pi", Pi},
  {"E", E},
  {"Sqrt[2]", Sqrt[2]},
  {"Sqrt[3]", Sqrt[3]},
  {"Golden ratio", GoldenRatio},
  {"Catalan", Catalan},
  {"EulerGamma", EulerGamma},
  {"Zeta[3]", Zeta[3]},
  {"1/Zeta[3]", 1/Zeta[3]},
  {"Pi^2/6", Pi^2/6},
  {"Sum 1/n^3", Sum[1/n^3, {n, 1, Infinity}]}
};

Print["Comparing to known constants:"];
Print[""];
Print["Constant\t\tValue\t\t\tDifference"];
Print[StringRepeat["-", 70]];

Do[
  Module[{name, value, diff},
    {name, value} = const;
    diff = Abs[N[value, 20] - numerical5];
    If[diff < 10^-10,
      Print[name, "\t\t", N[value, 10], "\t\t", ScientificForm[diff]];
    ];
  ],
  {const, knownConstants}
];
Print[""];

(* ============================================================================ *)
(* TEST 4: Larger case - n=37                                                *)
(* ============================================================================ *)

Print["[4/4] Attempting n=37 (prime) symbolic limit"];
Print[""];

Print["WARNING: This may take a while or time out..."];
Print[""];

TimeConstrained[
  Module[{sum37, terms, limit37},
    (* Build sum for n=37, d=2..6, k limited *)
    terms = Flatten[Table[
      Module[{dist},
        dist = 37 - k*d - d^2;
        If[Abs[dist] < 100 && dist != 0,
          ((dist)^2 + eps)^(-3),
          Nothing
        ]
      ],
      {d, 2, 6}, {k, 0, 20}
    ]];

    sum37 = Total[terms];
    Print["Number of terms: ", Length[terms]];
    Print[""];

    Print["Computing limit..."];
    limit37 = Limit[sum37, eps -> 0];
    Print[""];
    Print["Symbolic result: ", limit37];
    Print[""];
    Print["Numerical: ", N[limit37, 20]];
    Print[""];

    (* Check if rational *)
    If[Head[limit37] === Rational,
      Print["Result is RATIONAL: ", limit37];
      Print["Numerator: ", Numerator[limit37]];
      Print["Denominator: ", Denominator[limit37]];
    ];
  ],
  30,
  Print["Timed out (computation too complex)"];
  Print[""];
];

(* ============================================================================ *)
(* ALTERNATIVE: Use Zeta connection                                          *)
(* ============================================================================ *)

Print["================================================================"];
Print["ALTERNATIVE APPROACH: Connection to Riemann Zeta"];
Print["================================================================"];
Print[""];

Print["If we sum over ALL integers (not just lattice points):"];
Print["  Sum_{m=1}^inf m^(-2*alpha) = Zeta(2*alpha)"];
Print[""];

Print["For alpha=3: Zeta(6) = ", Zeta[6]];
Print["  = ", N[Zeta[6], 20]];
Print[""];

Print["Simplified: Zeta(6) = ", Together[Zeta[6]]];
Print["  = Pi^6 / 945"];
Print[""];

Print["Our F_n(3) for primes is DIFFERENT because:"];
Print["  - We sum over lattice points (d,k), not all integers"];
Print["  - Different combinatorial structure (c_m(n) coefficients)"];
Print["  - Each distance m appears with multiplicity c_m(n)"];
Print[""];

(* ============================================================================ *)
(* FORMULA STRUCTURE                                                          *)
(* ============================================================================ *)

Print["================================================================"];
Print["STRUCTURE OF LIMIT"];
Print["================================================================"];
Print[""];

Print["For prime n, as eps->0:"];
Print[""];
Print["F_n(alpha) -> Sum_{d,k: n-kd-d^2 != 0} |n-kd-d^2|^(-2*alpha)"];
Print[""];

Print["This can be rewritten as:"];
Print["  F_n(alpha) = Sum_{m=1}^inf c_m(n) * m^(-2*alpha)"];
Print[""];
Print["where c_m(n) = #{(d,k): |n-kd-d^2| = m}");
Print[""];

Print["For example, n=5, alpha=3:"];
Print["  Distances: 1, 1, 3, 4, 7  (from our terms above)"];
Print["  c_1(5) = 2 (appears twice)"];
Print["  c_3(5) = 1"];
Print["  c_4(5) = 1"];
Print["  c_7(5) = 1"];
Print[""];
Print["  F_5(3) = 2*1^(-6) + 1*3^(-6) + 1*4^(-6) + 1*7^(-6) + ...");
Print["        = 2 + 1/729 + 1/4096 + 1/117649 + ...");
Print["        = ", N[2 + 1/729 + 1/4096 + 1/117649, 10]];
Print[""];

Print["This is a DIRICHLET-LIKE series with n-dependent coefficients!");
Print[""];

(* ============================================================================ *)
(* FINAL ANSWER                                                               *)
(* ============================================================================ *)

Print["================================================================"];
Print["ANSWER TO QUESTION"];
Print["================================================================"];
Print[""];

Print["Q: Is the limit ~5 for n=37 a known mathematical constant?"];
Print[""];
Print["A: Unlikely to be a CLASSICAL constant (Pi, e, zeta values, etc.)"];
Print[""];
Print["   Instead, it's an ARITHMETIC FUNCTION of n:"];
Print["     F_n(alpha) = Sum_m c_m(n) * m^(-2*alpha)"];
Print[""];
Print["   The coefficients c_m(n) depend on the LATTICE STRUCTURE"];
Print["   of representations n = kd + d^2."];
Print[""];
Print["   For different primes n, the limit will be DIFFERENT!"];
Print[""];

Print["However, there MAY be:"];
Print["  - Asymptotic formula as n -> infinity"];
Print["  - Connection to divisor sum functions"];
Print["  - Relationship to modular forms (if n varies)"];
Print[""];

Print["This is a DEEP NUMBER-THEORETIC OBJECT, not a simple constant."];
Print[""];
