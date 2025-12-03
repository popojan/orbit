(* What SHOULD we be measuring? *)

Print["═══════════════════════════════════════════════════════════════"];
Print["BACK TO BASICS: What has arcsine distribution?"];
Print["═══════════════════════════════════════════════════════════════\n"];

(* Chebyshev zeros: x_k = cos(kπ/n) for k = 1, ..., n-1 *)
(* These have arcsine distribution on [-1, 1] *)

n = 100;
chebyZeros = Table[Cos[k Pi/n], {k, 1, n - 1}];

Print["Chebyshev T_", n, " zeros: x_k = cos(kπ/", n, ")"];
Print["These are deterministic, uniformly spaced in angle"];
Print["They have ARCSINE distribution in x"];
Print[""];

(* Spacing of Chebyshev zeros *)
sortedZeros = Sort[chebyZeros];
zeroSpacings = Differences[sortedZeros];
meanZeroSpacing = Mean[zeroSpacings];
normZeroSpacings = zeroSpacings / meanZeroSpacing;

Print["Chebyshev zero spacing statistics:"];
Print["  P(s < 0.2) = ", N[Count[normZeroSpacings, _?(# < 0.2 &)] / Length[normZeroSpacings]]];
Print["  P(s < 0.5) = ", N[Count[normZeroSpacings, _?(# < 0.5 &)] / Length[normZeroSpacings]]];
Print[""];

Print["═══════════════════════════════════════════════════════════════"];
Print["B-values: B(n,k) = (1/n)(1 + β(n)·cos((2k-1)π/n))"];
Print["═══════════════════════════════════════════════════════════════\n"];

beta[m_] := If[OddQ[m], 1/m, 2 Cot[Pi/(2 m)]/(m Pi)];
Bvalue[m_, k_] := (1/m) (1 + beta[m] Cos[(2 k - 1) Pi/m]);

(* B-values for large n *)
bVals = Table[Bvalue[n, k], {k, 1, n}];

Print["For n = ", n, ":"];
Print["  β(n) = ", N[beta[n]]];
Print["  B-values range: [", Min[bVals] // N, ", ", Max[bVals] // N, "]"];
Print["  Mean B-value: ", Mean[bVals] // N, " (should be 1/n = ", 1./n, ")"];
Print[""];

(* Distribution of B-values (not spacing!) *)
Print["B-value DISTRIBUTION (histogram of values, not spacings):"];
Print["  Since B(n,k) = (1/n)(1 + β·cos(...)), values follow arcsine"];
Print[""];

Print["═══════════════════════════════════════════════════════════════"];
Print["KEY QUESTION: What should RMT comparison be about?"];
Print["═══════════════════════════════════════════════════════════════\n"];

Print["Option 1: Spacing of Chebyshev zeros x_k = cos(kπ/n)"];
Print["  → Deterministic, no randomness → no level repulsion expected"];
Print[""];

Print["Option 2: Distribution of B-values (as histogram)"];
Print["  → Arcsine-like for large n"];
Print["  → This is marginal distribution, not spacing"];
Print[""];

Print["Option 3: Eigenvalues of Jacobi matrix for Chebyshev"];
Print["  → These ARE the Chebyshev zeros (deterministic)"];
Print[""];

Print["Option 4: Eigenvalues of RANDOM perturbation of Jacobi matrix"];
Print["  → Would give RMT statistics!"];
Print[""];

(* Let's try option 4 *)
Print["═══════════════════════════════════════════════════════════════"];
Print["RANDOM JACOBI MATRIX (Chebyshev + noise)"];
Print["═══════════════════════════════════════════════════════════════\n"];

(* Jacobi matrix for Chebyshev T_n: tridiagonal with specific entries *)
(* a_k = 0, b_k = 1/2 (except b_1 = 1/√2) *)
jacobiChebyshev[m_] := SparseArray[{
  Band[{1, 2}] -> Table[If[k == 1, 1/Sqrt[2], 1/2], {k, 1, m - 1}],
  Band[{2, 1}] -> Table[If[k == 1, 1/Sqrt[2], 1/2], {k, 1, m - 1}]
}, {m, m}];

(* Add small random perturbation *)
nSize = 50;
eps = 0.1;
nTrials = 100;

allRandSpacings = {};
Do[
  randMatrix = N[jacobiChebyshev[nSize]] + 
               eps * RandomVariate[NormalDistribution[], {nSize, nSize}];
  randMatrix = (randMatrix + Transpose[randMatrix])/2;  (* symmetrize *)
  eigs = Sort[Eigenvalues[randMatrix]];
  spacings = Differences[eigs];
  meanS = Mean[spacings];
  normalized = spacings / meanS;
  allRandSpacings = Join[allRandSpacings, normalized],
  {nTrials}
];

Print["Chebyshev Jacobi + ", eps, " noise (", nTrials, " trials):"];
ps02 = N[Count[allRandSpacings, _?(# < 0.2 &)] / Length[allRandSpacings]];
ps05 = N[Count[allRandSpacings, _?(# < 0.5 &)] / Length[allRandSpacings]];
Print["  P(s < 0.2) = ", ps02];
Print["  P(s < 0.5) = ", ps05];
Print[""];
Print["Compare: GOE P(s<0.2) = 0.031, GUE P(s<0.2) = 0.008"];

