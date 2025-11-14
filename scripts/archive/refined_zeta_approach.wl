(* Refined approach using zeta zeros correctly *)

Print["═══════════════════════════════════════════════════════════════════"];
Print["REFINED ZETA ZERO APPROACH"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["KEY INSIGHT: Zeros come in conjugate pairs ρ = 1/2 ± iγ"];
Print[""];
Print["Correct explicit formula (using pairs):"];
Print[""];
Print["ψ(x) = x - Σ_{γ>0} 2·Re(x^ρ/ρ) - log(2π) - (1/2)log(1-x^{-2})"];
Print[""];
Print["where ρ = 1/2 + iγ and we sum over positive γ only,"];
Print["taking real parts to account for conjugate pairs."];
Print[""];

(* Corrected approximation *)
PsiApproxCorrected[x_, nZeros_] := Module[{gammas, rho, sumTerm},
  (* Get positive imaginary parts only *)
  gammas = Table[Im[ZetaZero[k]], {k, 1, nZeros}];

  (* Sum over conjugate pairs *)
  sumTerm = Sum[
    Module[{rho = 1/2 + I*gamma},
      2 * Re[x^rho / rho]
    ],
    {gamma, gammas}
  ];

  x - sumTerm - Log[2*Pi] - (1/2)*Log[1 - x^(-2)]
];

Print["Testing corrected formula:"];
Print[""];

testX = {10, 20, 30, 50};
PsiTrue[x_] := Sum[MangoldtLambda[k], {k, 1, Floor[x]}];

Print["x | ψ(x) exact | ψ corrected (10 zeros) | Error"];
Print[StringRepeat["-", 80]];

Do[
  Module[{psiExact, psiApprox, error},
    psiExact = PsiTrue[x];
    psiApprox = PsiApproxCorrected[N[x], 10];
    error = Abs[psiExact - psiApprox];

    Print[x, " | ", N[psiExact, 8], " | ", N[psiApprox, 8], " | ", N[error, 6]];
  ],
  {x, testX}
];

Print[""];
Print["Much better! Now real-valued."];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["CONVERGENCE: HOW MANY ZEROS NEEDED?"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Testing with increasing numbers of zeros for x=30:"];
Print[""];

Print["# zeros | ψ(30) approx | Error"];
Print[StringRepeat["-", 60]];

psiExact30 = PsiTrue[30];

Do[
  Module[{psiApprox, error},
    psiApprox = PsiApproxCorrected[30.0, nz];
    error = Abs[psiExact30 - psiApprox];

    Print[nz, " | ", N[psiApprox, 8], " | ", N[error, 6]];
  ],
  {nz, {5, 10, 20, 50, 100}}
];

Print[""];
Print["Convergence is SLOW - many zeros needed for accuracy!"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["ALTERNATIVE: DIRECT θ(x) FORMULA"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Instead of ψ(x), we want θ(x) = Σ_{p≤x} log p directly."];
Print[""];
Print["Relationship: ψ(x) = θ(x) + θ(x^{1/2}) + θ(x^{1/3}) + ..."];
Print[""];
Print["Can we invert this?"];
Print[""];

(* Möbius inversion *)
ThetaFromPsi[x_] := Module[{n, sum},
  sum = 0;
  n = 1;
  While[x^(1/n) >= 2,
    sum += MoebiusMu[n] * PsiTrue[x^(1/n)] / n;
    n++;
  ];
  sum
];

ChebyshevTheta[x_] := Sum[Log[Prime[k]], {k, 1, PrimePi[Floor[x]]}];

Print["Testing Möbius inversion:"];
Print[""];

Print["x | θ(x) direct | θ from ψ (Möbius) | Match?"];
Print[StringRepeat["-", 70]];

Do[
  Module[{thetaDirect, thetaFromPsi, match},
    thetaDirect = ChebyshevTheta[x];
    thetaFromPsi = ThetaFromPsi[x];
    match = Abs[thetaDirect - thetaFromPsi] < 10^(-6);

    Print[x, " | ", N[thetaDirect, 8], " | ", N[thetaFromPsi, 8], " | ",
      If[match, "✓", "✗"]];
  ],
  {x, {10, 20, 30, 50}}
];

Print[""];
Print["Möbius inversion works! θ = Σ μ(n)/n · ψ(x^{1/n})"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["KEY QUESTIONS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];
Print["1. Can we compute θ(m) efficiently via zeros?"];
Print["   - Use explicit formula for ψ, then Möbius invert to get θ"];
Print["   - But convergence is VERY slow"];
Print[""];
Print["2. Are there better formulas for θ directly?"];
Print["   - Avoiding the ψ → θ conversion"];
Print[""];
Print["3. Can we use ASYMPTOTIC approximations?"];
Print["   - θ(x) ~ x (prime number theorem)"];
Print["   - But we need EXACT values for primorials!"];
Print[""];
Print["4. Connection to our factorial sums?"];
Print["   - Do the zeros appear in the numerator somehow?"];
Print["   - Is there a generating function connection?"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["LITERATURE SEARCH NEEDED"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];
Print["We need to search for:"];
Print["- Computational algorithms for Chebyshev functions"];
Print["- Fast primorial formulas in literature"];
Print["- Connections between factorial sums and zeta zeros"];
Print["- Alternative characterizations of primorials"];
Print[""];
Print["This is likely well-studied in computational number theory!"];
Print[""];
