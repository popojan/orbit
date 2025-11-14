(* Exploring Primorials via Chebyshev functions and Riemann zeta zeros *)

Print["═══════════════════════════════════════════════════════════════════"];
Print["CHEBYSHEV FUNCTIONS & PRIMORIALS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Chebyshev theta function: θ(x) = Σ_{p≤x} log p"];
Print["Connection to primorial: Primorial(x) = exp(θ(x))"];
Print[""];

(* Compute Chebyshev theta *)
ChebyshevTheta[x_] := Sum[Log[Prime[k]], {k, 1, PrimePi[x]}];

(* Standard primorial *)
StandardPrimorial[m_] := Times @@ Prime @ Range @ PrimePi[m];

Print["Verification:"];
Print[""];

testVals = {5, 7, 11, 13, 17, 19, 23};

Print["m | θ(m) | exp(θ(m)) | Primorial(m) | Match?"];
Print[StringRepeat["-", 80]];

Do[
  Module[{theta, expTheta, prim, match},
    theta = ChebyshevTheta[m];
    expTheta = Exp[theta];
    prim = StandardPrimorial[m];
    match = (expTheta == prim);

    Print[m, " | ", N[theta, 6], " | ", N[expTheta, 6], " | ", prim, " | ",
      If[match, "✓", "✗"]];
  ],
  {m, testVals}
];

Print[""];
Print["Confirmed: Primorial(m) = exp(θ(m))"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["EXPLICIT FORMULA VIA ZETA ZEROS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["ψ(x) = x - Σ_ρ (x^ρ/ρ) - log(2π) - (1/2)log(1-x^{-2})"];
Print[""];
Print["where ρ = 1/2 + i·γ are non-trivial zeros of ζ(s)"];
Print[""];

Print["Relationship: θ(x) ≈ ψ(x) for large x (differ by prime powers)"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["COMPUTING WITH RIEMANN ZEROS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["First non-trivial zeros of ζ(s) (imaginary parts):"];
Print[""];

(* Mathematica has ZetaZero function *)
numZeros = 10;
zeros = Table[ZetaZero[k], {k, 1, numZeros}];

Print["ρ_k = 1/2 + i·γ_k where γ_k are:"];
Print[""];

Do[
  gamma = Im[zeros[[k]]];
  Print["  γ_", k, " = ", N[gamma, 10]];
,{k, 1, numZeros}];

Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["APPROXIMATING ψ(x) WITH FINITE ZEROS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

(* Approximate ψ using explicit formula with finite zeros *)
PsiApprox[x_, nZeros_] := Module[{rhos, sumTerm},
  rhos = Table[ZetaZero[k], {k, 1, nZeros}];
  sumTerm = Sum[x^rho / rho, {rho, rhos}];
  x - sumTerm - Log[2*Pi] - (1/2)*Log[1 - x^(-2)]
];

(* True ψ function *)
PsiTrue[x_] := Sum[MangoldtLambda[k], {k, 1, Floor[x]}];

Print["Comparing approximation with different numbers of zeros:"];
Print[""];

testX = {10, 20, 30, 50};

Print["x | ψ(x) exact | ψ approx (5 zeros) | ψ approx (10 zeros) | Error (10)"];
Print[StringRepeat["-", 100]];

Do[
  Module[{psiExact, psiApprox5, psiApprox10, error10},
    psiExact = PsiTrue[x];
    psiApprox5 = PsiApprox[x, 5];
    psiApprox10 = PsiApprox[x, 10];
    error10 = Abs[psiExact - psiApprox10];

    Print[x, " | ", N[psiExact, 6], " | ", N[psiApprox5, 6], " | ",
      N[psiApprox10, 6], " | ", N[error10, 6]];
  ],
  {x, testX}
];

Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["PRIMORIAL VIA ZETA ZEROS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Strategy: Primorial(m) ≈ exp(ψ(m)) ≈ exp(explicit formula with zeros)"];
Print[""];

Print["m | Primorial(m) | exp(ψ(m) from 10 zeros) | Ratio"];
Print[StringRepeat["-", 80]];

Do[
  Module[{prim, psiApprox, expPsi, ratio},
    prim = StandardPrimorial[m];
    psiApprox = PsiApprox[N[m], 10];
    expPsi = Exp[psiApprox];
    ratio = N[expPsi / prim];

    Print[m, " | ", prim, " | ", N[expPsi, 10], " | ", ratio];
  ],
  {m, {5, 7, 11, 13}}
];

Print[""];
Print["The approximation is poor with only 10 zeros!");
Print["More zeros needed for accurate computation.");
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["KEY QUESTIONS FOR INVESTIGATION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];
Print["1. Can we compute ψ(m) efficiently using zeros?"];
Print["   - How many zeros needed for accuracy?"];
Print["   - Is there a truncation formula?"];
Print[""];
Print["2. Can we invert: given ψ(m), find Primorial(m)?"];
Print["   - Primorial(m) = exp(θ(m)) where θ(m) ≈ ψ(m)"];
Print[""];
Print["3. Is there a direct formula for θ(x) via zeros?"];
Print["   - θ(x) vs ψ(x) differ by prime power contributions"];
Print[""];
Print["4. Can we use SYMMETRIES of zeta zeros?"];
Print["   - Functional equation of ζ(s)"];
Print["   - Zero-free regions"];
Print[""];
Print["5. Connection to our factorial sums?"];
Print["   - Do zeros appear in the numerator structure?"];
Print["   - Is there a bridge formula?"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["NEXT STEPS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];
Print["A. Study the explicit formula more carefully"];
Print["B. Investigate error bounds (how many zeros needed?)"];
Print["C. Look for truncation/approximation schemes"];
Print["D. Search for θ(x) direct formula (not via ψ)"];
Print["E. Explore combinatorial interpretations of zero sums"];
Print[""];
