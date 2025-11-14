(* Trace how primes cancel via numerator divisibility *)

Print["==============================================================================="];
Print["CORRECT ANALYSIS: Rational Mod Definition"];
Print["==============================================================================="];
Print[""];
Print["For Σ_m mod 1/(m-1)!:"];
Print["  R_m = Σ_m - floor(Σ_m · (m-1)!) · (1/(m-1)!)"];
Print["      = (Σ_m · (m-1)! - Q) / (m-1)!"];
Print[""];
Print["where Q = floor(Σ_m · (m-1)!)"];
Print[""];
Print["After reducing to lowest terms:"];
Print["  den(R_m) = (m-1)! / gcd(numerator, (m-1)!)"];
Print[""];
Print["For prime p to VANISH from den(R_m):"];
Print["  Need: ν_p(numerator) ≥ ν_p((m-1)!)"];
Print[""];
Print["==============================================================================="];
Print[""];

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

TraceNumeratorCancellation[m_, p_] := Module[{k, sigma, numSigma, denSigma,
  mFact, product, Q, numerator, vpNum, vpMFact, remainder, denRem, vpDenRem,
  gcdVal, vpGCD},

  k = Floor[(m-1)/2];
  sigma = ComputeBareSumAlt[m];
  numSigma = Numerator[sigma];
  denSigma = Denominator[sigma];
  mFact = (m-1)!;

  (* Compute Σ_m · (m-1)! *)
  product = sigma * mFact;
  Q = Floor[product];

  (* Numerator of remainder (before reduction) *)
  numerator = numSigma * (mFact / denSigma) - Q;

  (* p-adic valuations *)
  vpNum = If[numerator != 0 && Mod[numerator, p] == 0,
    SelectFirst[FactorInteger[numerator], #[[1]] == p &, {p, 0}][[2]],
    0
  ];
  vpMFact = Sum[Floor[(m-1)/p^j], {j, 1, Floor[Log[p, m-1] + 1]}];

  (* GCD *)
  gcdVal = GCD[numerator, mFact];
  vpGCD = If[Mod[gcdVal, p] == 0,
    SelectFirst[FactorInteger[gcdVal], #[[1]] == p &, {p, 0}][[2]],
    0
  ];

  (* Final remainder *)
  remainder = Mod[sigma, 1/mFact];
  denRem = Denominator[remainder];
  vpDenRem = If[Mod[denRem, p] == 0,
    SelectFirst[FactorInteger[denRem], #[[1]] == p &, {p, 0}][[2]],
    0
  ];

  Print["═══════════════════════════════════════════════════════════════════"];
  Print["m = ", m, ", p = ", p, ", k = ", k];
  Print["═══════════════════════════════════════════════════════════════════"];
  Print[""];
  Print["Step 1: Compute Σ_m"];
  Print["  Σ_", m, " = ", numSigma, "/", denSigma, " = ", N[sigma]];
  Print[""];
  Print["Step 2: Multiply by (m-1)! = ", mFact];
  Print["  Σ_m · (m-1)! = ", product, " = ", N[product]];
  Print["  Q = floor(Σ_m · (m-1)!) = ", Q];
  Print[""];
  Print["Step 3: Compute numerator of remainder"];
  Print["  numerator = Σ_m · (m-1)! - Q"];
  Print["            = ", numSigma, " · ", mFact/denSigma, " - ", Q];
  Print["            = ", numerator];
  Print[""];
  Print["Step 4: p-adic valuation analysis"];
  Print["  ν_p(numerator) = ", vpNum];
  Print["  ν_p((m-1)!)    = ", vpMFact];
  Print["  ν_p(gcd)       = ", vpGCD, " = min(", vpNum, ", ", vpMFact, ")"];
  Print[""];
  Print["Step 5: Reduced denominator"];
  Print["  den(R_m) = (m-1)! / gcd = ", denRem];
  Print["  ν_p(den(R_m)) = ν_p((m-1)!) - ν_p(gcd)"];
  Print["               = ", vpMFact, " - ", vpGCD];
  Print["               = ", vpDenRem];
  Print[""];
  Print["CONCLUSION:"];
  If[vpNum >= vpMFact,
    (
      Print["  ✓ Prime p CANCELS: ν_p(numerator) = ", vpNum, " ≥ ν_p((m-1)!) = ", vpMFact];
      Print["    → p divides numerator with AT LEAST the same power as (m-1)!"];
      Print["    → p cancels completely from denominator!"]
    ),
    (
      Print["  ✗ Prime p SURVIVES: ν_p(numerator) = ", vpNum, " < ν_p((m-1)!) = ", vpMFact];
      Print["    → p appears in den(R_m) with power ", vpMFact - vpNum]
    )
  ];
  Print[""];
  Print[""];
];

(* Test all cases *)
Print["TESTING: Which primes cancel and why?"];
Print[""];

TraceNumeratorCancellation[5, 3];  (* Should cancel *)
TraceNumeratorCancellation[5, 5];  (* Should survive *)
TraceNumeratorCancellation[29, 17]; (* Should cancel *)
TraceNumeratorCancellation[29, 19]; (* Should survive *)
TraceNumeratorCancellation[29, 23]; (* Should survive *)

Print["==============================================================================="];
Print["FINAL QUESTION: Why does ν_p(numerator) vary for different primes?"];
Print["==============================================================================="];
Print[""];
Print["This depends on the SPECIFIC STRUCTURE of the alternating sum!");
Print["Need to analyze: numerator = Σ_m · (m-1)! - floor(Σ_m · (m-1)!)");
Print[""];
Print["Key insight: This is related to the fractional part of Σ_m · (m-1)!");
Print["  FractionalPart[Σ_m · (m-1)!] = Σ_m · (m-1)! - Q");
Print["");
Print["==============================================================================="];
