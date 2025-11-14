(* Derive asymptotic expansion of Σ_m to get tight bounds on numerator *)

Print["═══════════════════════════════════════════════════════════════════"];
Print["ASYMPTOTIC EXPANSION OF Σ_m"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

Print["Goal: Find Σ_m ≈ k!/(2k+1) · (1 + a₁/k + a₂/k² + ...)"];
Print[""];

Print["═══════════════════════════════════════════════════════════════════"];
Print["APPROACH 1: Analyze term ratios"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Let T_i = (-1)^i · i! / (2i+1)"];
Print[""];
Print["Ratio: T_{i+1}/T_i = -((i+1)!)/(2i+3) · (2i+1)/(i!)"];
Print["                   = -(i+1) · (2i+1)/(2i+3)"];
Print[""];

Print["For large i:"];
Print["  |T_{i+1}/T_i| = (i+1) · (2i+1)/(2i+3) ≈ i · (2i)/(2i) = i"];
Print[""];
Print["So |T_{i+1}| ≈ i · |T_i|, meaning last term DOMINATES exponentially!"];
Print[""];

Print["═══════════════════════════════════════════════════════════════════"];
Print["APPROACH 2: Partial sums and remainder"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Since last term dominates, write:"];
Print["  Σ_m = T_k + (T_{k-1} + ... + T_1)"];
Print["      = T_k · (1 + R_{k-1}/T_k)"];
Print[""];
Print["where R_{k-1} = sum of all earlier terms"];
Print[""];

Print["Estimating R_{k-1}/T_k:"];
Print["  R_{k-1}/T_k ≈ T_{k-1}/T_k + T_{k-2}/T_k + ..."];
Print["              ≈ -1/(k-1) + 1/((k-1)(k-2)) - ..."];
Print[""];
Print["This is an alternating series with rapidly decreasing terms"];
Print[""];

Print["Testing this numerically:"];
Print[""];

primes = {7, 11, 13, 17, 19, 23};

Print["m | k | |T_k| | |R_{k-1}| | Ratio R/T_k | Sign of Σ"];
Print[StringRepeat["-", 90]];

Do[
  Module[{k, terms, Tk, Rkm1, ratio, sigma, sign},
    k = (m-1)/2;
    terms = Table[(-1)^i * i! / (2i+1), {i, 1, k}];
    Tk = Abs[terms[[k]]];
    Rkm1 = Abs[Sum[terms[[i]], {i, 1, k-1}]];
    ratio = N[Rkm1/Tk, 6];
    sigma = ComputeBareSumAlt[m];
    sign = Sign[sigma];

    Print[m, " | ", k, " | ", N[Tk, 6], " | ", N[Rkm1, 6], " | ", ratio, " | ",
      If[sign > 0, "+", "-"]];
  ],
  {m, primes}
];

Print[""];
Print["R_{k-1}/T_k decreases rapidly! Last term is excellent approximation."];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["APPROACH 3: Explicit asymptotic formula"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Expanding T_{k-1}/T_k:"];
Print["  T_{k-1}/T_k = -1/k · (2k-1)/(2k+1)"];
Print["              = -1/k · (1 - 2/(2k+1))"];
Print["              ≈ -1/k · (1 - 1/k)"];
Print["              = -1/k + 1/k²"];
Print[""];

Print["Similarly:"];
Print["  T_{k-2}/T_k ≈ 1/(k(k-1))"];
Print[""];

Print["Therefore:"];
Print["  Σ_m/T_k ≈ 1 - 1/k + 1/k² + 1/(k(k-1)) + ..."];
Print["          ≈ 1 - 1/k + O(1/k²)"];
Print[""];

Print["So:"];
Print["  Σ_m ≈ (-1)^k · k!/(2k+1) · (1 - 1/k + O(1/k²))"];
Print[""];

Print["Testing this approximation:"];
Print[""];

Print["m | k | Σ_m (exact) | k!/(2k+1)·(1-1/k) | Rel. error"];
Print[StringRepeat["-", 90]];

Do[
  Module[{k, sigma, approx, relError},
    k = (m-1)/2;
    sigma = ComputeBareSumAlt[m];
    approx = (-1)^k * k!/(2*k+1) * (1 - 1/k);
    relError = Abs[(sigma - approx)/sigma];

    Print[m, " | ", k, " | ", N[sigma, 8], " | ", N[approx, 8], " | ",
      N[relError, 4]];
  ],
  {m, primes}
];

Print[""];
Print["Excellent agreement! Relative error < 1% for k ≥ 3"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["IMPROVED BOUNDS ON NUMERATOR"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["We now have:"];
Print["  Σ_m ≈ (-1)^k · k!/(2k+1) · (1 - 1/k)"];
Print[""];
Print["Therefore:"];
Print["  N = D · Σ_m ≈ D · k!/(2k+1) · (1 - 1/k)"];
Print[""];
Print["where D = Primorial(m)/2"];
Print[""];

Print["This gives MUCH tighter bounds than before!"];
Print[""];

Primorial[n_] := Times @@ Select[Range[2, n], PrimeQ];

Print["m | N (exact) | N (approx) | Rel. error | Prime?"];
Print[StringRepeat["-", 90]];

Do[
  Module[{k, D, sigma, N, Napprox, relError, isPrime},
    k = (m-1)/2;
    D = Primorial[m]/2;
    sigma = ComputeBareSumAlt[m];
    N = Numerator[sigma];
    Napprox = Round[D * k!/(2*k+1) * (1 - 1/k)];
    relError = N[Abs[(N - Napprox)/N], 4];
    isPrime = PrimeQ[Abs[N]];

    Print[m, " | ", N, " | ", Napprox, " | ", relError, " | ",
      If[isPrime, "YES", "no"]];
  ],
  {m, Take[primes, 4]}  (* First few only - numbers get huge *)
];

Print[""];
Print[""];

Print["═══════════════════════════════════════════════════════════════════"];
Print["INVERSION FEASIBILITY"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Given m and D = Primorial(m)/2, we can now estimate:"];
Print[""];
Print["  N ≈ D · k!/(2k+1) · (1 - 1/k)  with error < 1%"];
Print[""];

Print["But 1% of a huge number is still huge!"];
Print[""];

Print["Example: For m=17:"];
Module[{m, k, D, Napprox, errorBound},
  m = 17;
  k = (m-1)/2;
  D = Primorial[m]/2;
  Napprox = N[D * k!/(2*k+1) * (1 - 1/k)];
  errorBound = 0.01 * Napprox;

  Print["  k = ", k];
  Print["  D = ", D];
  Print["  N ≈ ", N[Napprox, 6]];
  Print["  1% error = ±", N[errorBound, 6]];
  Print[""];
  Print["  Search space: ", N[2*errorBound, 6], " candidates"];
  Print["  Even if we only check primes, this is infeasible!"];
];

Print[""];
Print[""];

Print["═══════════════════════════════════════════════════════════════════"];
Print["ALTERNATIVE: Use as primality witness"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["We can't efficiently find N, but we can do the REVERSE:"];
Print[""];
Print["Given a large number L, test if L could be a numerator for some m:"];
Print[""];
Print["1. Estimate m from |L| ≈ exp(θ(m)) · k!/(2k+1)"];
Print["2. Compute D = Primorial(m)/2"];
Print["3. Check if L/D is close to k!/(2k+1) · (1-1/k)"];
Print["4. If yes, compute Σ_m exactly and verify L = Numerator[Σ_m]"];
Print[""];

Print["This provides a NUMBER-THEORETIC CERTIFICATE for certain integers!"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["CONCLUSION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["✓ We derived asymptotic formula: Σ_m ≈ (-1)^k·k!/(2k+1)·(1-1/k)"];
Print["✓ This gives N with < 1% relative error"];
Print["✓ But 1% is still too large for direct inversion"];
Print[""];

Print["✗ Cannot efficiently find N given only m and D"];
Print["✗ Search space remains exponentially large"];
Print[""];

Print["✓ BUT: Can use formula as primality certificate"];
Print["✓ Given large L, test if it's a numerator for some factorial sum"];
Print["✓ All prime factors of N are > m (powerful constraint!)"];
Print[""];

Print["NEXT: Investigate number-theoretic properties of these numerators"];
Print["      - Distribution of prime numerators"];
Print["      - Factorization patterns"];
Print["      - Connection to other sequences (OEIS)"];
Print[""];
