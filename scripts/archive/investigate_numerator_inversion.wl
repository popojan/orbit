(* Investigate inverting the primorial formula to learn about large prime numerators *)

Print["═══════════════════════════════════════════════════════════════════"];
Print["NUMERATOR INVERSION: FROM PRIMORIAL TO LARGE PRIMES"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["IDEA: We know Denominator easily (from primorial)."];
Print["      We know N ≡ (-1)^((m+1)/2) · k! (mod m)."];
Print["      Can we determine N or its prime factors without computing sum?"];
Print[""];

(* Compute both alternating and non-alternating for comparison *)
ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

ComputeBareSumNonAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[i! / (2i+1), {i, 1, k}]
];

Primorial[n_] := Times @@ Select[Range[2, n], PrimeQ];

Print["═══════════════════════════════════════════════════════════════════"];
Print["GATHER DATA: Numerators and their properties"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

primes = {5, 7, 11, 13, 17, 19, 23, 29, 31};

Print["For ALTERNATING sum:"];
Print[""];
Print["m | N (alt) | N mod m | Prime? | Factorization | log₁₀(N)"];
Print[StringRepeat["-", 100]];

dataAlt = Table[
  Module[{sigma, N, Nmod, k, predicted, isPrime, factors, logN},
    sigma = ComputeBareSumAlt[m];
    N = Numerator[sigma];
    k = (m-1)/2;
    Nmod = Mod[N, m];
    predicted = Mod[(-1)^((m+1)/2) * k!, m];
    isPrime = PrimeQ[N];
    factors = If[isPrime, {N}, FactorInteger[N][[All, 1]]];
    logN = N[Log[10, N], 4];

    Print[m, " | ", N, " | ", Nmod, " (expect ", predicted, ") | ",
      If[isPrime, "YES", "no"], " | ",
      If[isPrime, "prime", ToString[Length[factors]] <> " factors"], " | ", logN];

    {m, N, Nmod, isPrime, factors, logN}
  ],
  {m, primes}
];

Print[""];
Print[""];

Print["For NON-ALTERNATING sum:"];
Print[""];
Print["m | N (non-alt) | Prime? | Factorization summary | log₁₀(N)"];
Print[StringRepeat["-", 100]];

dataNonAlt = Table[
  Module[{sigma, N, isPrime, factors, logN},
    sigma = ComputeBareSumNonAlt[m];
    N = Numerator[sigma];
    isPrime = PrimeQ[N];
    factors = If[isPrime, {N}, FactorInteger[N][[All, 1]]];
    logN = N[Log[10, N], 4];

    Print[m, " | ", N, " | ",
      If[isPrime, "YES", "no"], " | ",
      If[isPrime, "prime", ToString[Length[factors]] <> " factors"], " | ", logN];

    {m, N, isPrime, factors, logN}
  ],
  {m, primes}
];

Print[""];
Print[""];

Print["═══════════════════════════════════════════════════════════════════"];
Print["OBSERVATIONS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

altPrimes = Count[dataAlt, {_, _, _, True, _, _}];
nonAltPrimes = Count[dataNonAlt, {_, _, True, _, _}];

Print["Alternating: ", altPrimes, "/", Length[primes], " numerators are prime"];
Print["Non-alternating: ", nonAltPrimes, "/", Length[primes], " numerators are prime"];
Print[""];

Print["Non-alternating numerators grow FASTER (no cancellation from alternating signs)"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["CONSTRAINTS WE HAVE ON NUMERATOR N"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Given prime m, we know:"];
Print[""];
Print["1. EXACT VALUE: N / D = Σ_m  where D = Primorial(m)/2"];
Print["   → N = D · Σ_m"];
Print["   → But computing Σ_m is the hard part!"];
Print[""];

Print["2. MODULAR CONSTRAINT: N ≡ (-1)^((m+1)/2) · k! (mod m)"];
Print["   → Reduces N modulo m, but N >> m typically"];
Print["   → Many integers satisfy this congruence"];
Print[""];

Print["3. ROUGH MAGNITUDE: N ≈ D · Σ_m ≈ exp(θ(m)) · (polynomial in m)"];
Print["   → Σ_m has terms up to k! ≈ ((m-1)/2)!"];
Print["   → Growth is super-exponential in m"];
Print[""];

Print["4. GCD CONSTRAINT: gcd(N, D) = 1  (N/D is reduced)"];
Print["   → N is coprime to all primes ≤ m"];
Print["   → All prime factors of N are > m"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["THE KEY CONSTRAINT: All prime factors of N are > m"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["This is POWERFUL! Let's verify:"];
Print[""];

Print["m | N | Smallest prime factor | Largest prime factor | All > m?"];
Print[StringRepeat["-", 90]];

Do[
  Module[{N, factors, minFactor, maxFactor, allLarge},
    N = dataAlt[[i, 2]];
    factors = dataAlt[[i, 5]];
    minFactor = Min[factors];
    maxFactor = Max[factors];
    allLarge = minFactor > dataAlt[[i, 1]];

    Print[dataAlt[[i, 1]], " | ", N, " | ", minFactor, " | ", maxFactor, " | ",
      If[allLarge, "✓", "✗"]];
  ],
  {i, Length[dataAlt]}
];

Print[""];
Print[""];

Print["═══════════════════════════════════════════════════════════════════"];
Print["INVERSION QUESTION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Given:"];
Print["  - m (prime)"];
Print["  - D = Primorial(m)/2 (easy to compute)"];
Print["  - N ≡ c (mod m) where c = (-1)^((m+1)/2) · k! mod m"];
Print["  - gcd(N, D) = 1"];
Print["  - Rough bound: N ≈ D · O(m^?)  [need to estimate Σ_m]"];
Print[""];

Print["Can we find N or test primality of N without computing full sum?"];
Print[""];

Print["OBSTACLE: The solution space is HUGE"];
Print["  - Integers satisfying N ≡ c (mod m) form arithmetic progression"];
Print["  - Even with coprimality constraint, many candidates"];
Print["  - Need much tighter bounds on N"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["BOUND ESTIMATION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Can we bound |Σ_m| without computing it?"];
Print[""];

Print["Σ_m = Σ_{i=1}^k (-1)^i · i! / (2i+1)"];
Print[""];
Print["Rough analysis:"];
Print["  - Terms alternate in sign"];
Print["  - Last term dominates: k! / (2k+1) where k = (m-1)/2"];
Print["  - Earlier terms partially cancel"];
Print[""];

Print["Upper bound (triangle inequality):"];
Print["  |Σ_m| ≤ Σ_{i=1}^k i!/(2i+1) ≤ Σ_{i=1}^k i! ≈ k! · (1 + 1/k + 1/k(k-1) + ...)"];
Print["  |Σ_m| < 2·k!  (very loose)"];
Print[""];

Print["Lower bound (last term dominates):"];
Print["  |Σ_m| ≥ |last term| - |rest| ≈ k!/(2k+1) - (k-1)! ≈ k!/(2k+1) - k!/k"];
Print["  |Σ_m| > k!/(4k) for large k  (very rough)"];
Print[""];

Print["Testing these bounds:"];
Print[""];

Print["m | |Σ_m| actual | k!/(4k) | 2·k! | Within bounds?"];
Print[StringRepeat["-", 80]];

Do[
  Module[{m, k, sigma, sigmaAbs, lowerBound, upperBound, within},
    m = primes[[i]];
    k = (m-1)/2;
    sigma = ComputeBareSumAlt[m];
    sigmaAbs = Abs[sigma];
    lowerBound = N[k!/(4*k)];
    upperBound = N[2*k!];
    within = lowerBound < sigmaAbs < upperBound;

    Print[m, " | ", N[sigmaAbs, 6], " | ", N[lowerBound, 6], " | ",
      N[upperBound, 6], " | ", If[within, "✓", "✗"]];
  ],
  {i, Min[5, Length[primes]]}  (* Just first few - factorials get huge *)
];

Print[""];
Print["Bounds are very loose! Still leaves huge search space for N."];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["CONCLUSION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["CHALLENGE: Inversion seems difficult because:"];
Print[""];
Print["1. Modular constraint N ≡ c (mod m) has infinitely many solutions"];
Print["2. Coprimality constraint gcd(N, D) = 1 still leaves many candidates"];
Print["3. Bounds on |Σ_m| are too loose (exponential range)"];
Print["4. N grows super-exponentially, making search infeasible"];
Print[""];

Print["HOWEVER..."];
Print[""];

Print["POSSIBLE APPROACH: Asymptotic expansion of Σ_m"];
Print[""];
Print["If we could find asymptotic formula:"];
Print["  Σ_m ≈ k!/(2k+1) · (1 + a₁/k + a₂/k² + ...)"];
Print[""];
Print["Then:"];
Print["  N ≈ D · k!/(2k+1) · (1 + O(1/k))"];
Print[""];
Print["This would give much tighter bounds!"];
Print[""];

Print["NEXT STEP: Derive asymptotic expansion of Σ_m"];
Print[""];
