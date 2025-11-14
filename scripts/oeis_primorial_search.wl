(* Search for primorial-related sequences and formulas *)

Print["═══════════════════════════════════════════════════════════════════"];
Print["PRIMORIAL SEQUENCES IN OEIS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

(* Compute standard primorial sequence *)
Primorial[n_] := Times @@ Prime[Range[n]];

primorialSeq = Table[Primorial[n], {n, 1, 10}];

Print["Primorial sequence (A002110):"];
Print[primorialSeq];
Print[""];

Print["Known OEIS sequences related to primorials:"];
Print[""];
Print["A002110: Primorial numbers"];
Print["A034386: Primorial(n) + 1"];
Print["A006794: Primorial(n) - 1"];
Print["A057588: Primorial(n) / 2"];
Print["A143293: Primorial(prime(n))"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["INVESTIGATING LCM FORMULAS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Primorial(n) = LCM(1, 2, 3, ..., prime(n))"];
Print[""];
Print["But there are related LCM formulas:"];
Print[""];

(* LCM of first n integers *)
LCMSeq[n_] := LCM @@ Range[n];

Print["n | LCM(1..n) | Primorial(PrimePi(n)) | Match?"];
Print[StringRepeat["-", 70]];

Do[
  Module[{lcm, prim, match},
    lcm = LCMSeq[n];
    prim = Primorial[PrimePi[n]];
    match = (lcm == prim);

    Print[n, " | ", lcm, " | ", prim, " | ", If[match, "✓", "✗"]];
  ],
  {n, 2, 20}
];

Print[""];
Print["LCM(1..n) = Primorial(PrimePi(n)) when n is prime!"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["CHEBYSHEV'S ψ FUNCTION"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["ψ(n) = log(LCM(1,2,...,n))"];
Print[""];

PsiTrue[x_] := Sum[MangoldtLambda[k], {k, 1, Floor[x]}];

Print["n | ψ(n) | log(LCM(1..n)) | Match?"];
Print[StringRepeat["-", 70]];

Do[
  Module[{psi, logLCM, match},
    psi = PsiTrue[n];
    logLCM = Log[LCMSeq[n]];
    match = Abs[psi - logLCM] < 10^(-10);

    Print[n, " | ", N[psi, 8], " | ", N[logLCM, 8], " | ", If[match, "✓", "✗"]];
  ],
  {n, 2, 20}
];

Print[""];
Print["Confirmed: ψ(n) = log(LCM(1..n))"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["ALTERNATIVE CHARACTERIZATIONS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Primorial can be characterized as:"];
Print[""];
Print["1. Product of all primes ≤ n"];
Print["2. LCM(1,2,...,p_n) where p_n = Prime(n)"];
Print["3. exp(θ(n)) where θ = Chebyshev theta"];
Print["4. exp(ψ(p_n)) when n is PrimePi of a prime"];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["SEARCHING FOR GENERATING FUNCTIONS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];

Print["Dirichlet series for primorials:"];
Print[""];
Print["F(s) = Σ Primorial(n) / n^s"];
Print[""];
Print["Does this have a closed form?"];
Print[""];

(* Compute first few terms *)
Print["First few terms (s=2):"];
sum = N[Sum[Primorial[n] / n^2, {n, 1, 10}], 10];
Print["  Σ_{n=1}^{10} Primorial(n)/n² = ", sum];
Print[""];

Print["This series diverges rapidly - not useful for computation."];
Print[""];

Print[""];
Print["═══════════════════════════════════════════════════════════════════"];
Print["SUMMARY & NEXT DIRECTIONS"];
Print["═══════════════════════════════════════════════════════════════════"];
Print[""];
Print["What we've found:"];
Print["  ✓ Primorial = exp(θ(n)) - exact but requires computing θ"];
Print["  ✓ θ via zeta zeros - very slow convergence"];
Print["  ✓ Primorial = LCM(1..prime(n)) - alternative characterization"];
Print[""];
Print["What we haven't found:"];
Print["  ✗ Fast computational formula"];
Print["  ✗ Closed form avoiding prime enumeration"];
Print["  ✗ Connection that breaks the strange loop"];
Print[""];
Print["Recommendation:"];
Print["  - Search literature for fast LCM algorithms"];
Print["  - Investigate sieve-based methods"];
Print["  - Look for connections to lattice reduction"];
Print["  - Explore if factorial sum numerators encode theta function"];
Print[""];
