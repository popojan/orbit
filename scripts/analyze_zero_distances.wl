#!/usr/bin/env wolframscript
(* Analyze when dist = n - kd - d^2 = 0 *)

Print["================================================================"];
Print["WHEN IS dist = n - kd - d^2 EXACTLY ZERO?"];
Print["================================================================"];
Print[""];

n = 5;

Print["For n=", n, " (prime):"];
Print[""];

Print["We need: n - kd - d^2 = 0"];
Print["  => kd = n - d^2"];
Print["  => k = (n - d^2) / d"];
Print[""];

Print["For k to be non-negative integer:"];
Print["  1. d must divide (n - d^2)"];
Print["  2. (n - d^2) / d >= 0  =>  d^2 <= n"];
Print[""];

Print["For n=5: d^2 <= 5  =>  d <= 2 (since d >= 2)"];
Print[""];

Print["Checking all valid d:"];
Print[""];

For[d = 2, d <= Floor[Sqrt[n]], d++,
  Module[{kVal},
    kVal = (n - d^2) / d;
    Print["d=", d, ":"];
    Print["  k = (", n, " - ", d^2, ") / ", d, " = ", kVal];
    If[IntegerQ[kVal] && kVal >= 0,
      Print["  => ZERO DISTANCE at (d=", d, ", k=", kVal, ")"];
      Print["  Verification: ", n, " - ", kVal, "*", d, " - ", d^2, " = ", n - kVal*d - d^2];
    ,
      Print["  => Not an integer or negative"];
    ];
    Print[""];
  ];
];

Print["CONCLUSION FOR PRIMES:"];
Print[""];
Print["For PRIME p, we have p - kd - d^2 = 0  <=>  kd = p - d^2"];
Print[""];
Print["If p is PRIME and d^2 < p < (d+1)^2, then:"];
Print["  p - d^2 = some value < 2d+1"];
Print[""];
Print["For this to equal kd:"];
Print["  - If d divides (p - d^2), then k = (p - d^2)/d"];
Print["  - But p is PRIME, so this is rare!"];
Print[""];

Print["Let's check for p=5 specifically:"];
Print["  d=2: p - d^2 = 5 - 4 = 1 = 1*2? NO (1 is not divisible by 2)"];
Print[""];
Print["So for p=5, there is NO exact factorization p = kd + d^2!");
Print[""];

Print["================================================================"];
Print["GENERAL CASE: When does p = kd + d^2 have solutions?"];
Print["================================================================"];
Print[""];

Print["This is equivalent to asking: when is p representable as"];
Print["  p = d(k + d) = d*m  where m = k + d"];
Print[""];

Print["For PRIME p:"];
Print["  p = d*m with d > 1  =>  Either d=1 or d=p"];
Print[""];
Print["  Case d=p: p = p*m  =>  m=1  =>  k+p=1  =>  k=1-p < 0 (invalid)"];
Print["  Case d=1: Not allowed (we start from d=2)"];
Print[""];

Print["THEREFORE: For ANY PRIME p, the equation p = kd + d^2"];
Print["           has NO SOLUTIONS with d >= 2 and k >= 0!"];
Print[""];

Print["This means:");
Print["  - ALL terms in the sum have dist != 0"];
Print["  - The sum includes INFINITELY MANY terms"];
Print["  - Terms decay as |dist|^(-6) where |dist| -> infinity"];
Print[""];

Print["================================================================"];
Print["MATHEMATICAL STATUS"];
Print["================================================================"];
Print[""];

Print["F_p(alpha) = Sum_{d>=2, k>=0} |p - kd - d^2|^(-2*alpha)"];
Print[""];

Print["For PRIMES p:"];
Print["  - No terms with dist=0 (no division by zero)"];
Print["  - INFINITE number of terms"];
Print["  - Each term is RATIONAL"];
Print["  - Series CONVERGES (for alpha > 1/2)"];
Print[""];

Print["QUESTION: Is the limit of this infinite series RATIONAL?"];
Print[""];

Print["This is NOT OBVIOUS! Examples:"];
Print["  - Sum_{n=1}^inf 1/n^2 = Pi^2/6 (IRRATIONAL)"];
Print["  - Sum_{n=1}^inf 1/n^6 = Pi^6/945 (IRRATIONAL)"];
Print[""];

Print["Our series: F_p(alpha) = Sum_{m=1}^inf c_m(p) / m^(2*alpha)"];
Print[""];

Print["Key difference: The coefficients c_m(p) are SPECIAL!"];
Print["  - They depend on lattice structure of p"];
Print["  - They are FINITE for each m"];
Print["  - They might have algebraic structure"];
Print[""];

Print["HYPOTHESIS: The special structure of c_m(p) makes the sum RATIONAL"];
Print[""];

Print["But we need to PROVE this, not just observe numerically!"];
Print[""];

Print["================================================================"];
Print["CONVERGENCE RATE"];
Print["================================================================"];
Print[""];

Print["Let's estimate how fast the tail vanishes:"];
Print[""];

n = 5;
alpha = 3;

Print["For large d (where d^2 >> n):"];
Print["  dist ≈ -d^2 - kd = -d(d + k)"];
Print[""];

Print["For fixed d, summing over k:"];
Print["  Sum_{k=0}^inf d^(-6) * (d+k)^(-6)"];
Print["  = d^(-6) * Sum_{m=d}^inf m^(-6)"];
Print["  ~ d^(-6) * integral_{d}^inf x^(-6) dx"];
Print["  = d^(-6) * [x^(-5)/(-5)]_{d}^inf"];
Print["  = d^(-6) * d^(-5) / 5"];
Print["  = d^(-11) / 5"];
Print[""];

Print["So contribution from d decays as d^(-11) - VERY FAST!"];
Print[""];

Print["Tail bound: Sum_{d=D}^inf d^(-11) ~ integral_D^inf x^(-11) dx"];
Print["                                    = D^(-10) / 10"];
Print[""];

Print["For D=10: tail < 10^(-10) / 10 = 10^(-11)"];
Print["For D=20: tail < 20^(-10) / 10 ~ 10^(-14)"];
Print[""];

Print["This confirms RAPID CONVERGENCE, but doesn't prove RATIONALITY!"];
Print[""];
