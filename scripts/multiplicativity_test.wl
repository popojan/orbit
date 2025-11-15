#!/usr/bin/env wolframscript
(* Test multiplicativity and find relation to zeta *)

Print["=== Multiplicativity Analysis ==="];

MFunc[n_Integer] := Floor[(DivisorSigma[0, n] - 1)/2];

(* Test if M is multiplicative *)
Print[""];
Print["Testing if M(ab) = M(a)*M(b) for coprime a,b:"];
testCases = {{2,3}, {2,5}, {3,5}, {2,7}, {3,7}, {5,7}, {4,9}, {4,25}};
Table[
  Module[{a, b, ab, Ma, Mb, Mab, product, sum},
    {a, b} = pair;
    If[GCD[a,b] != 1, Continue[]];
    ab = a*b;
    Ma = MFunc[a]; Mb = MFunc[b]; Mab = MFunc[ab];
    product = Ma * Mb;
    sum = Ma + Mb;
    Print["M(", a, "·", b, "=", ab, ") = ", Mab,
          ", M(", a, ")*M(", b, ") = ", product,
          ", M(", a, ")+M(", b, ") = ", sum,
          If[Mab == product, " [mult ✓]", ""],
          If[Mab == sum, " [add ✓]", ""]];
  ],
  {pair, testCases}
];

(* Analyze structure for prime powers *)
Print[""];
Print["=== Prime Power Structure ==="];
Print["M(p^k) = Floor[k/2]"];
Print[""];
Print["For n = p₁^a₁ · p₂^a₂ · ... :"];
Print["τ(n) = (a₁+1)(a₂+1).."];
Print["M(n) = ⌊(τ(n)-1)/2⌋"];
Print[""];

(* Test formula for products *)
Print["Test: Can we express M(p^a · q^b) from M(p^a), M(q^b)?"];
Print[""];
testProducts = {
  {{2,2}, {3,1}},  (* 4·3 = 12 *)
  {{2,3}, {3,1}},  (* 8·3 = 24 *)
  {{2,2}, {3,2}},  (* 4·9 = 36 *)
  {{2,1}, {3,1}, {5,1}}  (* 2·3·5 = 30 *)
};

Table[
  Module[{factors, n, tau, Mn, parts},
    n = Times @@ (Power @@@ factors);
    tau = Times @@ ((#[[2]] + 1)& /@ factors);
    Mn = MFunc[n];
    parts = Floor[#[[2]]/2]& /@ factors;

    Print["n = ", Row[Riffle[Power @@@ factors, "·"]], " = ", n];
    Print["  τ(n) = ", tau, ", M(n) = ", Mn];
    Print["  M-values from factors: ", parts];
    Print["  Sum of parts: ", Total[parts]];
    Print["  Product + interaction? ", Mn - Total[parts]];
  ],
  {factors, testProducts}
];

(* Try to find Dirichlet convolution *)
Print[""];
Print["=== Dirichlet Convolution Attempt ==="];
Print[""];
Print["Can we write M = f * g (Dirichlet convolution)?"];
Print[""];
Print["Trying M(n) ≈ sum over divisors of some function.."];

(* Compute first few values *)
Print["M(n) values:"];
Print[Table[{n, MFunc[n]}, {n, 2, 30}]];

Print[""];
Print["τ(n)/2 - corrections:"];
Print[Table[{n, DivisorSigma[0,n]/2, MFunc[n],
             N[DivisorSigma[0,n]/2 - MFunc[n]]}, {n, 2, 20}]];

(* Key insight: M relates to choosing divisor pairs *)
Print[""];
Print["=== KEY INSIGHT ==="];
Print[""];
Print["M(n) counts divisors d with 2 ≤ d ≤ √n"];
Print["This is NOT multiplicative because √(ab) ≠ √a · √b structurally"];
Print[""];
Print["But we CAN express via generating function!"];
Print[""];

(* Sum M(n)/n^s numerically *)
directSum = Sum[MFunc[n]/n^2.0, {n, 2, 10000}];
Print["Direct sum Σ M(n)/n² (n=2..10000) = ", N[directSum, 12]];

(* Try relation to zeta *)
zeta2 = Zeta[2]^2;
zeta2m1 = Zeta[2]^2 - 1;
Print[""];
Print["ζ(2)² = ", N[zeta2, 12]];
Print["ζ(2)² - 1 = ", N[zeta2m1, 12]];
Print["(ζ(2)² - 1)/2 = ", N[zeta2m1/2, 12]];
Print[""];
Print["Ratio [Σ M(n)/n²] / [(ζ(2)²-1)/2] = ", N[directSum / (zeta2m1/2), 12]];

(* Better: try subtracting primes *)
Print[""];
Print["=== Removing Prime Contribution ==="];
sumWithoutPrimes = Sum[If[PrimeQ[n], 0, MFunc[n]/n^2.0], {n, 2, 10000}];
Print["Σ M(n)/n² without primes = ", N[sumWithoutPrimes, 12]];
Print["Difference from full sum: ", N[directSum - sumWithoutPrimes, 12]];

Print[""];
Print["CONCLUSION: M(n) is inherently NON-multiplicative"];
Print["  → Cannot use standard Euler product"];
Print["  → Need different approach to connect to ζ(s)"];
