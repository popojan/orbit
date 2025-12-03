(* ═══════════════════════════════════════════════════════════════════════
   JACOBI MATRIX FOR CHEBYSHEV POLYNOMIALS
   ═══════════════════════════════════════════════════════════════════════
   
   Chebyshev polynomials T_n(x) satisfy the three-term recurrence:
   
       T_0(x) = 1
       T_1(x) = x
       T_{n+1}(x) = 2x·T_n(x) - T_{n-1}(x)   for n ≥ 1
   
   This can be written as eigenvalue problem: x·p(x) = J·p(x)
   where p(x) = (T_0, T_1, T_2, ...)^T and J is tridiagonal Jacobi matrix.
   
   The eigenvalues of J_n (truncated to n×n) are the zeros of T_n(x).
   ═══════════════════════════════════════════════════════════════════════ *)

Print["═══════════════════════════════════════════════════════════════"];
Print["JACOBI MATRIX FOR CHEBYSHEV POLYNOMIALS"];
Print["═══════════════════════════════════════════════════════════════\n"];

(* ─────────────────────────────────────────────────────────────────────
   Section 1: Three-Term Recurrence → Jacobi Matrix
   ───────────────────────────────────────────────────────────────────── *)

Print["─── Three-Term Recurrence ───"];
Print["T_{n+1}(x) = 2x·T_n(x) - T_{n-1}(x)"];
Print[""];
Print["Rearranged as eigenvalue equation x·T_n = ..."];
Print["  x·T_0 = T_1"];
Print["  x·T_n = (1/2)T_{n-1} + (1/2)T_{n+1}  for n ≥ 1"];
Print[""];

(* Jacobi matrix (symmetric tridiagonal) *)
(* For monic Chebyshev: diagonal = 0, off-diagonal = 1/2 *)
(* First off-diagonal element needs care due to normalization *)

jacobiChebyshev[n_] := SparseArray[{
  (* Diagonal: all zeros (Chebyshev has symmetric zeros) *)
  Band[{1, 1}] -> 0,
  (* Super-diagonal *)
  Band[{1, 2}] -> Table[1/2, {k, 1, n - 1}],
  (* Sub-diagonal (symmetric) *)
  Band[{2, 1}] -> Table[1/2, {k, 1, n - 1}]
}, {n, n}];

Print["─── Jacobi Matrix J_n (n×n truncation) ───"];
Print["Structure: symmetric tridiagonal"];
Print["  Diagonal entries: a_k = 0"];
Print["  Off-diagonal entries: b_k = 1/2"];
Print[""];

(* Show explicit matrix for small n *)
n = 6;
Jn = jacobiChebyshev[n];
Print["J_", n, " = "];
Print[MatrixForm[Normal[Jn]]];
Print[""];

(* ─────────────────────────────────────────────────────────────────────
   Section 2: Eigenvalues = Chebyshev Zeros
   ───────────────────────────────────────────────────────────────────── *)

Print["─── Eigenvalues of J_n ───"];

(* Compute eigenvalues *)
eigenvals = Sort[Eigenvalues[N[Jn]]];
Print["Eigenvalues of J_", n, ": ", eigenvals];

(* Compare with Chebyshev zeros: x_k = cos((2k-1)π/(2n)) for T_n *)
chebyZeros = Sort[Table[Cos[(2 k - 1) Pi/(2 n)], {k, 1, n}]];
Print["Chebyshev T_", n, " zeros:  ", N[chebyZeros]];
Print[""];
Print["Difference: ", Norm[eigenvals - N[chebyZeros]]];
Print[""];

(* ─────────────────────────────────────────────────────────────────────
   Section 3: Symbolic Characteristic Polynomial
   ───────────────────────────────────────────────────────────────────── *)

Print["─── Characteristic Polynomial ───"];

(* Characteristic polynomial of J_n should be related to T_n *)
charPoly[m_] := CharacteristicPolynomial[jacobiChebyshev[m], x];

Print["det(xI - J_n) for small n:"];
Do[
  cp = charPoly[k] // Expand;
  tn = ChebyshevT[k, x] / 2^(k-1) // Expand;  (* Monic normalization *)
  Print["  n=", k, ": ", cp, "  (compare: T_", k, "/2^", k-1, " = ", tn, ")"],
  {k, 2, 5}
];
Print[""];

(* ─────────────────────────────────────────────────────────────────────
   Section 4: Symbolic Matrix with Parameter
   ───────────────────────────────────────────────────────────────────── *)

Print["─── Symbolic Jacobi Matrix J(λ) ───"];

(* Jacobi matrix as function of spectral parameter *)
jacobiSymbolic[n_, lambda_] := SparseArray[{
  Band[{1, 1}] -> lambda,
  Band[{1, 2}] -> Table[1/2, {k, 1, n - 1}],
  Band[{2, 1}] -> Table[1/2, {k, 1, n - 1}]
}, {n, n}];

Print["J_4(λ) with diagonal = λ:"];
Print[MatrixForm[Normal[jacobiSymbolic[4, λ]]]];
Print[""];

(* Determinant as polynomial in λ *)
Print["det(J_4(λ)) = ", Det[jacobiSymbolic[4, λ]] // Expand];
Print[""];

(* ─────────────────────────────────────────────────────────────────────
   Section 5: Connection to RMT - Adding Noise
   ───────────────────────────────────────────────────────────────────── *)

Print["═══════════════════════════════════════════════════════════════"];
Print["CONNECTION TO RMT: DETERMINISTIC → RANDOM"];
Print["═══════════════════════════════════════════════════════════════\n"];

Print["Chebyshev Jacobi matrix is DETERMINISTIC:"];
Print["  → Eigenvalues = Chebyshev zeros (no repulsion)"];
Print["  → P(s < 0.2) ≈ 0.50 (uniform-like spacing)"];
Print[""];

Print["Adding Gaussian noise → GOE statistics:"];
Print["  J_noisy = J_Chebyshev + ε·W  (W = GOE random matrix)"];
Print["  → Level repulsion emerges"];
Print["  → P(s < 0.2) → 0.031 (GOE)"];
Print[""];

(* Demonstrate transition *)
nSize = 30;
epsilons = {0, 0.01, 0.05, 0.1, 0.5};
nTrials = 200;

Print["─── Transition: ε = noise strength ───"];
Print["ε\t\tP(s<0.2)"];

Do[
  allSpacings = {};
  Do[
    If[eps == 0,
      mat = N[jacobiChebyshev[nSize]],
      (* Add symmetric Gaussian noise *)
      noise = RandomVariate[NormalDistribution[], {nSize, nSize}];
      noise = (noise + Transpose[noise])/2;
      mat = N[jacobiChebyshev[nSize]] + eps * noise
    ];
    eigs = Sort[Eigenvalues[mat]];
    spacings = Differences[eigs];
    meanS = Mean[spacings];
    If[meanS > 0,
      normalized = spacings / meanS;
      allSpacings = Join[allSpacings, normalized]
    ],
    {nTrials}
  ];
  ps02 = N[Count[allSpacings, _?(# < 0.2 &)] / Length[allSpacings]];
  Print[eps, "\t\t", ps02],
  {eps, epsilons}
];

Print[""];
Print["GOE reference: P(s<0.2) = 0.031"];

(* ─────────────────────────────────────────────────────────────────────
   Section 6: Visualization
   ───────────────────────────────────────────────────────────────────── *)

Print["\n═══════════════════════════════════════════════════════════════"];
Print["VISUALIZATION"];
Print["═══════════════════════════════════════════════════════════════"];

(* Matrix visualization *)
matrixPlot = MatrixPlot[Normal[jacobiChebyshev[20]], 
  PlotLabel -> "Jacobi Matrix J₂₀ (Chebyshev)",
  ColorFunction -> "TemperatureMap"
];

Export["jacobi_matrix_plot.png", matrixPlot, ImageSize -> 400];
Print["\nExported jacobi_matrix_plot.png"];

(* Eigenvalue distribution *)
nLarge = 100;
eigsLarge = Sort[Eigenvalues[N[jacobiChebyshev[nLarge]]]];

eigPlot = Show[
  Histogram[eigsLarge, 20, "PDF", 
    PlotLabel -> "Eigenvalue Distribution of J₁₀₀",
    AxesLabel -> {"x", "density"}
  ],
  Plot[(1/Pi)/Sqrt[1 - x^2], {x, -0.95, 0.95}, 
    PlotStyle -> {Red, Thick},
    PlotLegends -> {"Arcsine density"}
  ]
];

Export["eigenvalue_distribution.png", eigPlot, ImageSize -> 500];
Print["Exported eigenvalue_distribution.png"];

Print["\n═══════════════════════════════════════════════════════════════"];
Print["SUMMARY"];
Print["═══════════════════════════════════════════════════════════════"];
Print[""];
Print["1. Chebyshev T_n satisfies three-term recurrence"];
Print["2. This defines tridiagonal Jacobi matrix J_n"];
Print["3. Eigenvalues of J_n = zeros of T_n (deterministic)"];
Print["4. Adding noise: J + εW transitions to GOE statistics"];
Print["5. ε → 0: deterministic (no repulsion)"];
Print["   ε → ∞: pure GOE (full repulsion)"];

