(* Trace the modular reduction step-by-step for m=5 and m=29 *)

Print["==============================================================================="];
Print["TRACING MODULAR REDUCTION: WHERE DO PRIMES VANISH?"];
Print["==============================================================================="];
Print[""];

ComputeBareSumAlt[m_Integer] := Module[{k},
  k = Floor[(m-1)/2];
  Sum[(-1)^i * i! / (2i+1), {i, 1, k}]
];

(* Detailed modular reduction analysis *)
TraceModularReduction[m_, p_] := Module[{k, sigma, numSigma, denSigma, modulus,
  vpNumSigma, vpDenSigma, vpModulus, remainder, numRem, denRem, vpDenRem,
  lcmDenMod, vpLCM, reduction},

  k = Floor[(m-1)/2];
  sigma = ComputeBareSumAlt[m];
  numSigma = Numerator[sigma];
  denSigma = Denominator[sigma];
  modulus = 1/((m-1)!);

  (* Compute p-adic valuations *)
  vpNumSigma = If[Mod[numSigma, p] == 0,
    SelectFirst[FactorInteger[numSigma], #[[1]] == p &, {p, 0}][[2]],
    0
  ];
  vpDenSigma = If[Mod[denSigma, p] == 0,
    SelectFirst[FactorInteger[denSigma], #[[1]] == p &, {p, 0}][[2]],
    0
  ];
  vpModulus = Sum[Floor[(m-1)/p^j], {j, 1, Floor[Log[p, m-1] + 1]}];

  (* LCM of denominators *)
  lcmDenMod = LCM[denSigma, (m-1)!];
  vpLCM = If[Mod[lcmDenMod, p] == 0,
    SelectFirst[FactorInteger[lcmDenMod], #[[1]] == p &, {p, 0}][[2]],
    0
  ];

  (* Remainder *)
  remainder = Mod[sigma, modulus];
  numRem = Numerator[remainder];
  denRem = Denominator[remainder];
  vpDenRem = If[Mod[denRem, p] == 0,
    SelectFirst[FactorInteger[denRem], #[[1]] == p &, {p, 0}][[2]],
    0
  ];

  (* Compute reduction factor *)
  reduction = denSigma / GCD[denSigma, (m-1)!];

  Print["m = ", m, ", p = ", p, ", k = ", k];
  Print[StringRepeat["-", 80]];
  Print["Σ_m = ", numSigma, "/", denSigma];
  Print["  ν_p(num(Σ)) = ", vpNumSigma];
  Print["  ν_p(den(Σ)) = ", vpDenSigma];
  Print[""];
  Print["Modulus = 1/(m-1)! where (m-1)! = ", (m-1)!];
  Print["  ν_p((m-1)!) = ", vpModulus];
  Print[""];
  Print["LCM(den(Σ), (m-1)!) = ", lcmDenMod];
  Print["  ν_p(LCM) = ", vpLCM];
  Print["  ν_p(LCM) = max(ν_p(den(Σ)), ν_p((m-1)!)) = max(", vpDenSigma, ", ", vpModulus, ") = ", Max[vpDenSigma, vpModulus]];
  Print[""];
  Print["Remainder R_m = ", numRem, "/", denRem];
  Print["  ν_p(den(R)) = ", vpDenRem];
  Print[""];
  Print["KEY QUESTION: Why did ν_p change from ", vpDenSigma, " to ", vpDenRem, "?"];
  Print[""];

  (* Check if numerator of expanded form has special property *)
  expandedNum = numSigma * ((m-1)! / denSigma);
  If[IntegerQ[expandedNum],
    vpExpandedNum = If[Mod[expandedNum, p] == 0,
      SelectFirst[FactorInteger[expandedNum], #[[1]] == p &, {p, 0}][[2]],
      0
    ];
    Print["Expanded numerator: N_Σ · ((m-1)!/den(Σ)) = ", expandedNum];
    Print["  ν_p(expanded num) = ", vpExpandedNum];
    Print[""];
  ];

  Print["ANALYSIS:"];
  If[vpDenSigma > 0 && vpDenRem == 0,
    Print["  ✓ Prime p CANCELLED during modular reduction"];
    Print["  Before: ν_p(den(Σ)) = ", vpDenSigma];
    Print["  After:  ν_p(den(R)) = ", vpDenRem];

    (* Where did it go? *)
    If[vpNumSigma > 0,
      Print["  → Cancellation with numerator? ν_p(num(Σ)) = ", vpNumSigma];
    ];
    If[vpModulus > vpDenSigma,
      Print["  → Absorbed into (m-1)! ? ν_p((m-1)!) = ", vpModulus, " > ", vpDenSigma];
    ];
  ,
    Print["  Prime p survived (or wasn't there to begin with)"];
  ];

  Print[""];
  Print[""];
];

(* Test cases *)
Print["CASE 1: m=5, p=3 (prime that CANCELS)"];
Print[StringRepeat["=", 80]];
TraceModularReduction[5, 3];

Print["CASE 2: m=5, p=5 (prime that SURVIVES)"];
Print[StringRepeat["=", 80]];
TraceModularReduction[5, 5];

Print["CASE 3: m=29, p=17 (prime that CANCELS)"];
Print[StringRepeat["=", 80]];
TraceModularReduction[29, 17];

Print["CASE 4: m=29, p=19 (prime that SURVIVES)"];
Print[StringRepeat["=", 80]];
TraceModularReduction[29, 19];

Print["CASE 5: m=29, p=23 (prime that SURVIVES)"];
Print[StringRepeat["=", 80]];
TraceModularReduction[29, 23];

(* Summary comparison *)
Print["==============================================================================="];
Print["SUMMARY: What distinguishes cancelling primes from surviving primes?"];
Print["==============================================================================="];
Print[""];
Print["m=5:  p=3 cancels  (i=1, 2i+1=3)"];
Print["      p=5 survives (i=2, 2i+1=5, and 5=m)"];
Print[""];
Print["m=29: p=17 cancels  (i=8, 2i+1=17)"];
Print["      p=19 survives (i=9, 2i+1=19)"];
Print["      p=23 survives (i=11, 2i+1=23)"];
Print[""];
Print["Hypothesis to test:"];
Print["  - Does it depend on i < some threshold?"];
Print["  - Does it depend on 2i+1 vs 2k+1?"];
Print["  - Does it depend on ν_p(numerator)?"];
Print[""];
Print["Let me check the specific indices:"];
Print["  m=5, k=2:  p=3 at i=1, p=5 at i=2 (i=k)"];
Print["  m=29, k=14: p=17 at i=8, p=19 at i=9, p=23 at i=11"];
Print[""];
Print["PATTERN CHECK: Does p appear at 2i+1 where i < k/2?"];
Print["  m=5, k=2, k/2=1:  p=3 at i=1 (i ≤ k/2) → CANCELS ✓"];
Print["                    p=5 at i=2 (i > k/2) → SURVIVES ✓"];
Print["  m=29, k=14, k/2=7: p=17 at i=8 (i > k/2) → CANCELS ✗"];
Print[""];
Print["That doesn't work. Try another pattern..."];
Print[""];
Print["==============================================================================="];
